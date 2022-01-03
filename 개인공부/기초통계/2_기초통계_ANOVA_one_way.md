## 1. One-way ANOVA를 사용할 때?



![image-20220103233412790](../../images/2_기초통계_ANOVA_one_way/image-20220103233412790.png)

​	세 대학의 평균 키의 차이를 비교할 때 각 그룹간의 t-test를 하는 Multiple t-test를 사용하면 1종 오류(유의하지 않을 때 유의하다 판단)에 해당하고 만다. 3번 t-test를 적용할 때 각각에 적용되는 0.05의 p-value가 영향을 미쳐 약 0.15가 적용되는 1종오류가 발생하게 되는 것.



![image-20220103232952551](../../images/2_기초통계_ANOVA_one_way/image-20220103232952551.png)

​	이 떄 사용하는 통계법이 One-way ANOVA(Analysis of Variance)이다. 여기서 One-way는 독립변수가 하나라는 의미.



**변수**

- 독립변수(Indipendent variable) : 
  논리적인 관계에서의 독립을 의미. 다른말로 결과에 대한 예측변수(predictor variable), 설명변수(explanatory variable)라고 한다. 인과관계에 대해 조사,연구하게 되는데 이 인과관계의 원인에 해당하는게 독립변수이다.
- 종속변수(Dependent variable) : 
  논리적인 인과관계에 있어 종속을 의미. 다른말로 반응변수(response variable), 결과변수(outcome variable)라고 한다.결과에
- 통제변수(Control variavle) : 
  기본적으로는 독립변수와 동일하나 연구, 조사의 주 관심사에 벗어난 변수이다. 통제변수를 감안하지 않을 경우 모델의 중요변수가 누락됐다는 Model Misspecification이 발생한다.



## 2. ANOVA와 변수

- 