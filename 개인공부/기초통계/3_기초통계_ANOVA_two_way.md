## 1. Two-way ANOVA란

- 독립변수가 2개 $+\alpha$인 ANOVA를 Two-way ANOVA라 한다. 즉 이 경우 Main effect(주효과)가 2개인데 Main effect라 함은 각 독립변수에 따른 종속변수의 변화를 의미한다. 
- $\alpha$는 interaction(상호작용, 교호작용)으로 한 독립변수의 main effect가 다른 독립변수의 level에 따라 linear relationship이 non-linear하게 변하는 경우를 말한다.
- Two-way ANOVA에서는 각 변수에 대한 F-value, 그리고 interaction에 대한 F-value까지 총 3개의 F-value가 필요하게 된다.

### 1.1 Interaction (상호작용, 교호작용)

​	Interaction이란 한 독립변수의 종속변수에 대한 영향관계가 다른 독립변수의 level(group)에 따라 변할 경우 이를 interaction effect가 있다고 한다. 이러한 두 변수를 이용해 다양한 결과를 예측할 수 있게되어 종속변수의 변화에 대한 원인을 판단할 수 있는 중요한 도구로 사용할 수 있다.

**예시>**

<img src="../../images/3_기초통계_ANOVA_two_way/image-20220104214438284.png" alt="image-20220104214438284" style="zoom:67%;" />

- 각 통계기법에서는 종속변수와 독립변수를 선형관계로 가정함. 
- 독립변수 X1과 X2의 종류에 따른 종속변수의 평균값을 위 표와 나타냈을 때, X2의 레벨에 따른 X1에서의 종속변수와 관계는 동일하게 선형으로 나타난다. X1, X2의 main effect는 존재하지만 Interaction effect는 없다. 

![image-20220104215249703](../../images/3_기초통계_ANOVA_two_way/image-20220104215249703.png)

- 각 경우들은 level에 따른 평균의 차이로 main effect의 유무를 판별한다.
- 1의 경우에는 X1, X2의 main effect가 없으며 Interaction effect도 없다.
- 2의 경우X1의 main effect는 유의하며 X2의 main effect는 없고 Interaction effect도 없다.
- 3의 경우 X1의 main effect는 없고 X2의 main effect는 있으며 Interaction effect는 없다

<img src="../../images/3_기초통계_ANOVA_two_way/image-20220104215717899.png" alt="image-20220104215717899" style="zoom: 80%;" />

- 마지막 이 경우에는 X1의 level1과 level2의 평균이 동일, X2의 level1과 2의 평균이 동일한 것으로 양측의 main effect는 없다.
- 하지만 X1에서 각 그룹의 평균값에 따른 선을 그어보면 수평선이 그려지는데, X2의 level1에 의해 양의 상관관계가, level2에 의해 음의 상관관계가 나타난다. 반대로 X2에서는 main effect가 없지만 X1의 level에 따라 main effect가 보여 Interaction effect가 있는 것으로 볼 수 있다. 

<img src="../../images/3_기초통계_ANOVA_two_way/image-20220104221102609.png" alt="image-20220104221102609"  />

- 이 경우에서는 X1의 main effect는 존재, X2의 main effect는 없다. 그리고 X1의 level에 따라 X1의 level1에서는 X2의 level2가 level1보다 더 높고 반대로 X1의 level2에서는 X2의 level1이 level2보다 더 큰 걸 보이며 Interaction effect가 있는 것으로 보인다.



## 2. Two-way ANOVA의 계산

$$
F-value_{main\ effect1} = \frac{BetweenVariacne_{main\ effect1}}{WithinVariance}= \frac{\frac{SS_{main\ effect1}}{df_1of main\ effect1}}{\frac{SS_{within}}{df_2of\ within\ variance}}\\
F-value_{main\ effect2} = \frac{BetweenVariacne_{main\ effect2}}{WithinVariance}= \frac{\frac{SS_{main\ effect2}}{df_1of main\ effect2}}{\frac{SS_{within}}{df_2of\ within\ variance}}\\
F-value_{interaction\ effect} = \frac{BetweenVariacne_{interaction\ effect}}{WithinVariance}= \frac{\frac{SS_{interaction\ effect}}{df_1of interaction\ effect}}{\frac{SS_{within}}{df_2of\ within\ variance}}\\
$$

- Two-way ANOVA의 계산을 위헤서는 2개의 main effect, 그리고 interaction effect에 대한 between variance와 within variance 4가지가 필요하다
- 통계적 가설은 effect의 개수에 따라 아래와 같은 3개의 식이 필요하다. 두 main effect의 통계적 가설은 One-way ANOVA와 같이 각 그룹의 평균에 대한 가설이며 interaction에 관해서는 존재여부에 대한 가설을 세운다.
- 각 통계적 가설에 대해 유의하다는 판별이 되면, main effect에 대해서는 사후검정을 실행한다. 하지만 interaction은 과정이 매우 복잡하여 그래프로 나타내는 방법이 더욱 편리하다.

$$
H_{01} : \mu_{11} = \mu_{11} = \cdots = \mu_{1k} \\
H_{a1} : \mu_{1i} \not= \mu_{1j} \ for \ some \ i,j\\ 
\\
H_{02} : \mu_{21} = \mu_{21} = \cdots = \mu_{2k} \\
H_{a2} : \mu_{2i} \not= \mu_{2j} \ for \ some \ i,j\\ 
\\
H_{03} : The\ \ interaction\ \ effect\ \ does\ \ not\ \ exist\\
H_{a3} : The\ \ interaction\ \ effect\ \ exists\\
$$



## 3. 실습 : JAMOVI 

**예시>**

​	어떤 ISP(Internet Service Provieder)는 고객의 총 지출금액이 지불방법에 따라 차이가 나는지 알고 싶다. 종속변수는 총 지출금액(Total Charges), 독립변수는 지불방법(Payment Method)과 계약기간(Contract)를 사용한다. 총 지출금액은 Bank Transfer, Credit Card, Electronic Check, Mailed Check 4가지 level이 있다. 계약기간은 Month-to-month, One year, Two year로 세 그룹으로 나뉜다. 이 자료들의 Two-way ANOVA를 시행할 것이다.

- 해당 예시에 대한 데이터는 이전 One-way ANOVA와 같은 자료로 https://www.kaggle.com/blastchar/telco-customer-churn 에서 다운로드해 JAMOVI로 Two-way ANOVA 테스트를 수행했다.

![image-20220108003525001](../../images/3_기초통계_ANOVA_two_way/image-20220108003525001.png)

- F-test는 각 독립변수 Payment Method, Contract에 대해 진행이 되었다. F-value 테스트에서는 각 컬럼과 Interaction 모두 유의하다 볼 수 있다.
- Post  Hoc Test에서는 Payment Method가 One-way ANOVA때의 결과와 유사하며 Contract또한 각 group간의 낮은 p-value로 평균이 다른 그룹으로 생각된다. Interaction도 Post Hoc Test를 할 수 있지만 많은 결과로 인해 해석하기가 힘들어 아래의 표로 나타내어본다.

![image-20220108003938136](../../images/3_기초통계_ANOVA_two_way/image-20220108003938136.png)

- 위의 그래프에서는 Contract와의 Two-way ANOVA에서는 Payment Method의 One-way ANOVA와 다르게 Electronic check의 평균치가 사뭇 다른 그래프의 모습을 볼 수 있었다. Contract 그룹에 따라 Payment Metod의 각 그룹별 Total Charges는 우하향하는 모습을 보이지만 One year, Two year에서는 반등하며 다른 그룹군과의 차이를 보였다.
- 아래의 Payment Method 그룹에 따라 Contrat 그룹들의 Total Charges를 본 그래프에서도 다른 그룹들은 비슷한 추세를 보이지만 Electronic check가 Month-to-month에서는 제일 낮지만 One year 이후로 크게 반등하는걸 볼 수 있다. 













**Skip : RM ANOVA, Contrast test** 

---

**참조**

https://www.youtube.com/channel/UCnN2E8RCEuKi-WLBrd0Nu1A

