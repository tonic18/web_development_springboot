-- users에서 country 별 회원 수 구하기 쿼리
select country, count(distinct id) as uniqueUserCnt
	from users
	group by country;
-- ------> 뒤에 나오는 컬럼명을 기준으로 그룹화해서
-- country를 표시하고, count() 적용한 컬럼도 표시해서 조해해줘

select * from users;

-- users에서 country가 korea인 회원 중에서 마케팅 수신에 동의한 회원 수를 구해 출력할 것
-- 표시 컬럼 country, uniqueUserCnt
select count(distinct id) as uniqueUserCnt from users
	where is_marketing_agree = 1
	and country = "korea";

-- users에서 country별로 마케팅 수신 동의한 회원 수와 동의하지 않은 회원 수를 구해 출력
select country, is_marketing_agree, count(distinct id) as uniqueUserCnt 
	from users
	group by country, is_marketing_agree
	order by country, uniqueUserCnt desc;
--		국가별로는 오름차순, uniqueUserCnt 기준으로 내림차순
--	select절 - from 테이블명 - group by절 - order by절 : 순서
group by에 두 개 이상의 기준 컬럼을 추가하면 데이터가 여러 그룹으로 나뉨
아르헨티나를 기준으로 했을 때 마케팅 수신 동의 여부가 0인 회원 수와 마케팅 수신 여부가 1인
회원수를 기준으로 나뉘어져 있음을 알 수 있음

예를 들어서 위의 쿼리문의 경우, country를 기준으로 먼저 그룹화가 이루어지고ㅓ,
그 후에 is_marketing_agree를 기준으로 그룹화 됐다.

그래서 group by에 여러 기준을 설정하면, 컬럼 순서에 따라 결과가 달라짐
따라서 '중요한 기준을 앞에 배치'해서 시각화와 그룹화에 우선순위를 결정할 필요가 있음

-- group by 정리
-- 1) 주어진 컬럼을 기준으로 데이터를 그룹화하여 '집계함수'와 함께 사용
-- 2) group by 뒤에는 그룹화할 컬럼명을 입력. 그룹화한 컬럼에 집계 함수  적용하여 그룹별 계산을 수행
-- 3) 형식 : group by 컬럼명1, 컬럼명2
-- 4) group by에서 두 개 이상의 기준 컬럼을 조건으로 추가하여 여러 그룹으로
	-- 분할 가능한데, 컬럼 순서에 따라 결과에 영향을 미치므로 우선순위를 생각할 필요 있음

-- users에서 국가(country) 내 도시(city)별 회원수를 구하여 출력.
-- 단, 국가명은 알파벳 순서대로 정렬, 같은 국가 내에서는 회원 수 기준으로 내림 차순 정렬
-- 표시컬럼 country, city, uniqueUserCnt
select country, city, count(distinct id) as uniqueUserCnt
	from users
	group by country, city
	order by country, uniqueUserCnt desc;

-- substr(컬럼명, 시작값, 글자개수)
-- users에서 월별(e.g. 2013-10) 가입 회원 수를 출력할 것
-- 가입일시 컬럼 활용하고, 최신순으로 정렬할 것
select substr(created_at, 1, 7) as 월, count(distinct id) as 사람수
	from users
	group by substr(created_at, 1, 7)
	order by 월 desc;

-- 1. orderdeatils에서 order_id 별 주문 수량 quantity의 총합을 출력할 것
	-- 주문 수량의 총합이 내림차순으로 정렬되도록 할 것(함수는 어제 수업에서 한 것 확인)
select order_id, sum(quantity) as sumQuantity 
	from orderdetails
	group by order_id
	order by sumQuantity desc;
-- 2. orders에서 staff_id 별, user_id 별로 주문 건수(count(*))를 출력할 것
	-- 단, staff_id 기준 오름차순하고 주문 건수 별 기준 내림차순
select staff_id, user_id, count(*) 
	from orders
	group by staff_id, user_id
	order by staff_id, count(*) desc; 
-- 3. orders에서 월별로 주문한 회원 수 출력할 것(order_date 컬럼 이용, 최신순으로 정렬)
select * from orders;
select substr(order_date, 1, 7), count(distinct user_id) 
	from orders
	group by substr(order_date, 1, 7)
	order by substr(order_date, 1, 7) desc;
	
-- having
-- group by를 이용해서 데이터를 그룹화하고, 해당 그룹별로 집계 연산을 수행하여,
-- 국가별 회원 수를 도출해낼 수 있었습니다(count())
-- 예를 들어서, 회원수가 n명 이상인 국가의 회원 수만 보는 등의 조건을 걸려면 어떡해야 할까

-- where절을 이용하는 방법이 있긴 하지만 추가적인 개념에 대해서 학습할 예정
-- 언제나 where을 쓰는 것이 용이하지 않다는 점 부터 짚고 넘어가서 having 학습 할 예정

-- users에서 country 가 korea, usa, france인 회원 숫자를 도출할 것
select country, count(distinct id)
	from users
	where country in ("korea","usa","france")
	group by country;

where을 통해서 원하는 국가만 먼저 필터링하고, group by를 했음
여기서 필터링 조건은 country 컬럼의 데이터 값에 해당함

만약에 회원 수가 8명 이상인 국가의 회원수만 필터링하려면 어떡함?

-- select country, count(distinct id)
-- 	from users
-- 	where count(distinct id) >= 8; 
-- 오류 나는 사례

-- users에서 회원수가 8명 이상인 country 별 회원 수 출력(회원 수 기준 내림 차순)
select country, count(distinct id)
	from users
	group by country
	having count(distinct id) >= 8
	order by count(distinct id) desc;

select country, count(distinct id)
	from users
	group by country
	having count(distinct id) >= 8
	order by 2 desc;		-- 두번째 컬럼을 desc 순으로 정리

1. where에서 필터링을 시도할 때 오류가 발생하는 이유 : 
	where은 group by 보다 먼저 실행되기 때문에 그룹화를 진행하기 전에 행을 필터링 함
	하지만 집계 함수로 계산된 값의 경우에는 그룹화 이후에 이루어지기 때문에
	순서상으로 group by 보다 뒤에 있어야 해서 where 절 도입이 불가능 함
	
2. 즉 group by 를 사용한 집계 값을 필터링할 때는 -> having 을 사용

-- orders에서 staff_id 별 주문 건수와 주문 회원 수를 계산하고, 주문건수가 10건 이상이면서
	-- 주문 회원 수가 40명 이하인 데이터만 출력(단, 주문 건수 기준으로 내림차순 정렬할 것)
	-- staff_id, users_id, id(주문건수) 컬럼 이용
select * from orders;
select staff_id, count(distinct id), count(distinct user_id) 
	from orders
	group by staff_id
	having count(distinct id) >= 10 and  count(distinct user_id) <= 40
	order by count(distinct id) desc;

-- having 정리
-- 순서상 group by 뒤쪾에 위치하며, group by와 집계함수로 그룹별로 집계한 값을 필터링할 때 사용
-- where과 동일하게 필터링 기능을 수행하지만, 적용 영역의 차이 때문에 주의할 필요가 있음
-- where은 'from에서 불러온 데이터'를 직접 필터링하는 반면에,
-- having은 'group by가 실행된 이후의 집계 함수 값'을 필터링 함
-- 따라서 having은 group by가 select 문 내에 없다면 사용할 수가 없음

-- select문의 실행 순서
-- select 컬럼명			- 5
-- from 테이블명			- 1
-- where 조건1			- 2
-- group by 컬럼명		- 3
-- having 조건2			- 4
-- order by 컬럼명		- 6
-- 
-- 
-- 1. 컴퓨터는 가장 먼저 from 을 읽어 데이터가 저장도니 위치에 접근하고, 테이블의 존재 유무를 따지고
-- 테이블을 확인하는 작업을 실행하고,
-- 2. where을 실행하여 가져올 데이터의 범위 확인
-- 3. 데이터베이스에서 가져올 범위가 결정된 데이터에 한하여 집계 연산을 적용할 수 있게
-- 	그룹으로 데이터를 나눈다
-- 4. having은 바로 그 다음 실행되면서 이미 group by를 통해 집계 연산 적용이 가능한 상태이기 때문에
-- 	4의 단계에서 집계 연산을 수행함
-- 5. 이후 select를 통해 특정 컬럼, 혹은 집계 함수 적용 컬럼을 조회하여 값을 보여주는데,
-- 6. order by를 통해 특정 컬럼 및 연산 결과를 통한 오름차순 및 내림차순으로 나열함

연습문제
1. orders 에서 회원 별 주문 건수 추출하라(단 주문 건수가 7건 이상인 회원의 정보만 추출
, 주문 건수 기준으로 내림차순 정렬, user_id와 주문 아이디(id)컬럼 활용할 것)

select count(distinct user_id) from orders;
select * from orders;

select user_id, count(distinct id) 
	from orders
	group by user_id
	having count(distinct id) >= 7
	order by count(distinct user_id) desc;

2. users에서 country 별 city 수와 국가별 회원(id) 수를 추출
	단, 도시 수가 5개 이상이고 회원 수가 3명 이상인 정보만 추출하고,
	도시 수, 회원 수 기준으로 모두 내림차순할 것

select country, count(distinct city), count(distinct id)
	from users
	group by country
	having count(distinct city) >= 5 and count(distinct id) >= 3
	order by count(distinct city) desc, count(distinct id) desc;

3. users에서 usa, brazil, argentina, mexico에 거주 중인 회원 수를
	국가별로 추출(단, 회원 수가 5명 이상인 국가만 추출하고, 회원 수 기준으로 내림차순)
	
	select * from users;
	
select country, count(distinct id)
	from users
	group by country
	having country in ("usa", "brazil", "argentina", "mexico", "korea") and count(distinct id) >= 5
	order by count(distinct id) desc;



select country, count(distinct id)
	from users
	where country in ("usa", "brazil", "argentina", "mexico", "korea")
	group by country
	having count(distinct id) >= 5
	order by count(distinct id) desc;

-- sql 실무 상황에서의 group by & having
-- 1. 2025-01-03에 음식 분류별(한식, 중식, 분식, ...) 주문 건수 집계
	select 음식분류, count(distinct 주문아이디) as 주문건수
		from 주문정보
		where 주문시간(월) = "2025-01"
		group by 
		order by 
