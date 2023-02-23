sk하이닉스 주가 분석 프로젝트입니다.
- data_combine.r: 사용할 데이터 합치는 코드입니다.
- missforest.r: 학습 데이터셋에 대하여 missforest하는 코드입니다.
- year_modeling.r: 년도로 구분한 데이터 모델링하는 코드입니다.
- 17_18_19데이터합쳐서모델링.r: 3개년 데이터을 결합하여 모델링한 코드입니다.
- data_sampling.R : Unbalanced 데이터셋임을 고려해 Resampling 하는 코드입니다. (피피티에는 관련 사항 없습니다)
- imputation_real : 다양한 impuatataion method를 실험한 코드입니다.
- pca.R : PCA 클러스터링 시각화 하는 코드입니다.
- random_forest.R : 랜덤 포레스트를 진행한 코드입니다. 다른 코드와 내용이 중복될 수 있습니다.
- kmeans_clustering : kmeans 클러스터링 코드입니다. (피피티에는 관련 사항 없습니다)
- fill_empty_value.py: 결측치 직전과 직후값으로 결측치를 채우는 코드입니다.
- pmpredict_keras.py: Keras를 활용해 Multi-output 모델을 생성하는 코드입니다.
- pm25predict_keras.py: Keras를 활용해 Single-output 모델을 생성하는 코드입니다.
-corrplot_air_china&seoul.r: 서울/중국 6개 도시의 데이터를 불러와 결측치 제거 후 상관계수 분석 및 Corrplot을 그리는 코드입니다.

[데이터]
- train.csv: 2017, 2018년 4개 데이터를 합친 결측치 있는 data입니다.
- test.csv:  2019년 4개 데이터를 합친 결측치 있는 data입니다.
- train_result.csv: 2017, 2108년 데이터를 결합하여 모델링에 사용하는 data입니다.
- test_result.csv: 2019년 데이터를 결합하여 모델링에 사용하는 data입니다.
- train_real_result.csv: 3개년 데이터를 결합하여 모델링에 사용하는 train data입니다.
- test_real_result.csv: 3개년 데이터를 결합하여 모델링에 사용하는 test data입니다.
- PMModel_fitting_result.xlsx: PM10, PM25 Single task 모델과 PM10+PM25 Multi-task 모델 비교를 위해 MSE, MAPE를 분석하여 정리한 sheet입니다.