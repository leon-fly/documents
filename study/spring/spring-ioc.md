---
date: "2018-01-01"
draft: false
lastmod: "2018-01-01"
publishdate: "2018-01-01"
tags:
- spring
title: spring-ioc 加载分析
---

# spring ioc 加载分析总结

## spring中与IOC相关的核心类梳理

### BeanFactory
spring bean工厂的超级接口，用于生成bean。从源码可以知道这个类大致包含了跟bean相关的方法，如获取bean，判断是否包含bean，bean是否单例，获取bean类型等，详细文档：[BeanFactory](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/beans/factory/BeanFactory.html) .

### BeanDefinition

spring用来描述一个bean实例的接口,如属性值、构造方法、已经更多具体实现的信息。其意图在于允许 [`BeanFactoryPostProcessor`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/beans/factory/config/BeanFactoryPostProcessor.html)提供一个自省或修改属性值几其他bean元数据。详细文档：[BeanDefinition](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/beans/factory/config/BeanDefinition.html)

* RootBeanDefinition 
* ChildBeanDefinition
* GenericBeanDefinition 
    * 就像任何BeanDefinition,允许指定一个类以及可选的构造参数值和属性值。另外可以通过parentName属性灵活的配置作为一个父BeanDefinition的派生。
    * 通常可以使用它来注册用户可见的BeanDefinition（PostProcessor可能对其进行操作，甚至可能重新配置其父类明），在父子关系可以预定的情况下可以使用RootBeanDefinition和ChildBeanDefinition。

### BeanDefinitionRegistry

spring用来持有BeanDefinition的注册器，通常被BeanFactory实现，内部与AbstractBeanDefinition协同工作。内部提供了对BeanDefinition的管理维护方法。详细文档：[BeanDefinitionRegistry](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/beans/factory/support/BeanDefinitionRegistry.html)

### SingletonBeanRegistry
1. 为共享的bean实例定义注册器的接口。暴露了单例bean的管理、查看及获取方法。
2. 为了以一种统一的方式暴露单例管理组件可以被BeanFactory实现

#### DefaultSingletonBeanRegistry


## 注解方式单例Bean的关键加载过程

从代码看整个加载直接类都bean加载过程
```
public class App {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext("com.leon.demo");
        GenericService genericService = context.getBean(GenericService.class);
        genericService.sayHello("how are you ~");
    }
}
```
从new AnnotationConfigApplicationContext("com.leon.demo")开始进入代码分析，整个单例bean加载过程主要分为两个过程：
1. 扫描指定包下注解spring bean类BeanDefinition，并用BeanDefinitionHolder包装，最终注册到BeanDefinitionRegistry上。
2. 通过遍历BeanDefinitionRegistry上的类分别对类进实例化，实例化过程分为类实例化及属性填充。

创建实例并填充属性

```
AbstractAutowireCapableBeanFactory.doCreateBean() 
            -> createBeanInstance()   使用合适的策略（工厂方法、构造器、简单实例）创建实例
            -> populateBean()   属性填充
```


* 关键类及方法：
DefaultListableBeanFactory
* 循环引用spring内部处理方案：
AbstractAutowireCapableBeanFactory三级缓存在单例对象实例化未填充属性值前提前暴露引用



###  单例bean获取



```

protected Object getSingleton(String beanName, boolean allowEarlyReference) {
		//单例bean实例缓存获取
		Object singletonObject = this.singletonObjects.get(beanName);
		if (singletonObject == null && isSingletonCurrentlyInCreation(beanName)) {
			synchronized (this.singletonObjects) {
				//从earlySingletonObjects中获取
				singletonObject = this.earlySingletonObjects.get(beanName);
				if (singletonObject == null && allowEarlyReference) {
					//从singletonFactories获取
					ObjectFactory<?> singletonFactory = this.singletonFactories.get(beanName);
					if (singletonFactory != null) {
						singletonObject = singletonFactory.getObject();
						this.earlySingletonObjects.put(beanName, singletonObject);
						this.singletonFactories.remove(beanName);
					}
				}
			}
		}
		return (singletonObject != NULL_OBJECT ? singletonObject : null);
	}
```

* 三个关键对象
  * 单例bean实例缓存 Map<String, Object> singletonObjects，用于缓存单例bean实例
  * 单例工厂缓存Map<String, ObjectFactory<?>> singletonFactories，用于存储单例的工厂 
  * 较早创建的bean实例缓存Map<String, Object> earlySingletonObjects，用于存储早期创建的单例bean，这个阶段可能bean还没有完成完整的实例化，属性还未填充，只是先将引用暴露出来
* 对象获取关键逻辑
  * 依次从singletonObjects -> earlySingletonObjects -> singletonFactories获取



### 单例bean的创建

当通过三级缓存获取bean为空说明暂未创建，进入bean的创建过程。关注AbstractAutowireCapableBeanFactory的doCreateBean方法

```
protected Object doCreateBean(final String beanName, final RootBeanDefinition mbd, final Object[] args)
			throws BeanCreationException {

		// Instantiate the bean.
		BeanWrapper instanceWrapper = null;
		if (mbd.isSingleton()) {
			instanceWrapper = this.factoryBeanInstanceCache.remove(beanName);
		}
		if (instanceWrapper == null) {
			//这里会实例化一个bean
			instanceWrapper = createBeanInstance(beanName, mbd, args);
		}
		final Object bean = (instanceWrapper != null ? instanceWrapper.getWrappedInstance() : null);
		Class<?> beanType = (instanceWrapper != null ? instanceWrapper.getWrappedClass() : null);
		mbd.resolvedTargetType = beanType;

		// Allow post-processors to modify the merged bean definition.
		synchronized (mbd.postProcessingLock) {
			if (!mbd.postProcessed) {
				try {
					applyMergedBeanDefinitionPostProcessors(mbd, beanType, beanName);
				}
				catch (Throwable ex) {
					throw new BeanCreationException(mbd.getResourceDescription(), beanName,
							"Post-processing of merged bean definition failed", ex);
				}
				mbd.postProcessed = true;
			}
		}

		// Eagerly cache singletons to be able to resolve circular references
		// even when triggered by lifecycle interfaces like BeanFactoryAware.
		boolean earlySingletonExposure = (mbd.isSingleton() && this.allowCircularReferences &&
				isSingletonCurrentlyInCreation(beanName));
		if (earlySingletonExposure) {
			if (logger.isDebugEnabled()) {
				logger.debug("Eagerly caching bean '" + beanName +
						"' to allow for resolving potential circular references");
			}
			
			//如果需要提前暴露bean的引用，就将该引用加入到一级缓存singletonFactories中
			addSingletonFactory(beanName, new ObjectFactory<Object>() {
				@Override
				public Object getObject() throws BeansException {
					return getEarlyBeanReference(beanName, mbd, bean);
				}
			});
		}

		// Initialize the bean instance.
		Object exposedObject = bean;
		try {
			populateBean(beanName, mbd, instanceWrapper);
			if (exposedObject != null) {
				exposedObject = initializeBean(beanName, exposedObject, mbd);
			}
		}
		catch (Throwable ex) {
			if (ex instanceof BeanCreationException && beanName.equals(((BeanCreationException) ex).getBeanName())) {
				throw (BeanCreationException) ex;
			}
			else {
				throw new BeanCreationException(
						mbd.getResourceDescription(), beanName, "Initialization of bean failed", ex);
			}
		}

		if (earlySingletonExposure) {
			Object earlySingletonReference = getSingleton(beanName, false);
			if (earlySingletonReference != null) {
				if (exposedObject == bean) {
					exposedObject = earlySingletonReference;
				}
				else if (!this.allowRawInjectionDespiteWrapping && hasDependentBean(beanName)) {
					String[] dependentBeans = getDependentBeans(beanName);
					Set<String> actualDependentBeans = new LinkedHashSet<String>(dependentBeans.length);
					for (String dependentBean : dependentBeans) {
						if (!removeSingletonIfCreatedForTypeCheckOnly(dependentBean)) {
							actualDependentBeans.add(dependentBean);
						}
					}
					if (!actualDependentBeans.isEmpty()) {
						throw new BeanCurrentlyInCreationException(beanName,
								"Bean with name '" + beanName + "' has been injected into other beans [" +
								StringUtils.collectionToCommaDelimitedString(actualDependentBeans) +
								"] in its raw version as part of a circular reference, but has eventually been " +
								"wrapped. This means that said other beans do not use the final version of the " +
								"bean. This is often the result of over-eager type matching - consider using " +
								"'getBeanNamesOfType' with the 'allowEagerInit' flag turned off, for example.");
					}
				}
			}
		}

		// Register bean as disposable.
		try {
			registerDisposableBeanIfNecessary(beanName, bean, mbd);
		}
		catch (BeanDefinitionValidationException ex) {
			throw new BeanCreationException(
					mbd.getResourceDescription(), beanName, "Invalid destruction signature", ex);
		}

		return exposedObject;
	}
```





## Bean的生命周期



## Bean的依赖关系及注入过程




https://blog.csdn.net/u010853261/article/details/77940767