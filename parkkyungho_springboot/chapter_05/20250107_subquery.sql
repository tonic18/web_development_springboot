-- UNION
-- 1. 컬럼 목록이 같은 데이터를 위아래로 결합
-- 데이터를 위 아래로 수직 결합해주는 기능 -> 컬럼의 형식과 개수가 같은 두 데이터 결과 집합을
-- 하나로 결합.

-- JOIN의 경우에는 여러 가지 조건을 미리 충족시켜줘야만 함 -> ON

(select * from users) union (select * from users);

-- 이상의 쿼리의 문제점은 결합 기능을 지닌  union의 결과값이 select * from users;와ㅣ
-- 동일하다는 점.

-- 해당 이유는 : union은 결합하는 두 결과 집합에 대한 '중복 제거 기능' 이 포함돼 있습니다.

-- 중복을 제거하지 않고 출력하는 명령어 : union all

(select * from users) union all (select * from users)
order by id;

-- union은 중복 제거 가능 / union all은 중복 포함 출력

-- 참고 union all 사용 시 select에서 컬럼 선별 예시
(select id, phone, city, country			-- 일부 컬럼만 지정해서 출력
	from users)
union all
(select id, phone, city, country			-- 기준이 되는 첫번째 select절에서  선택하는
	from users)								-- 컬럼의 종류 및 개수가 완벽히 일치해야  합니다
	order by id;

-- 실무에서는 union all 이 더 권장됨. union의 경우 중복 제거가 있는데, 대량의 데이터를 대상으로
-- 중복 제거할 때 컴퓨터에 무리한  연산 부하를 줄 가능성이 있기 때문에
-- 일단 union all을 통해서 최종 결과 형태 확인  후에 -> union을 적용하는 식으로
-- 프로세스가 짜여있는 편

-- users에서 country가 korea인 회원 정보만 추출하고(1번 추출),
-- mexico인 회원 정보만 추출해서(2번 추출) 결합해보자
-- (단, 컬럼은 id, phone, city, country만 출력하고, 최종 결과 집합은 country 기준 알파벳 순)
select id, phone, city, country from users where country in ("korea", "mexico");

(select id, phone, city, country from users where country = "korea")
union all
(select id, phone, city, country from users where country = "mexico")
order by country;

-- 연습문제
-- 1. orders에서 order_date가 2015년 10월 건과 2015년 12월인 건을 select로 각각 추출하고,
-- 두 결과 집합을 union all을 사용해 하나로 결합하세요(단, 최종 결과는 최신순으로 정렬)

-- 1번쿼리
(select *
	from orders
	where substr(order_date, 1, 7) = "2015-10")
union all
(select *
	from orders
	where substr(order_date, 1, 7) = "2015-12")
order by order_date desc;

-- 2번쿼리
(select * from orders
	where order_date >= "2015-10-01" and order_date < "2015-11-01")
union all
(select * from orders
	where order_date >= "2015-12-01" and order_date < "2016-01-01")
order by order_date desc;


-- sql상에서의 문자열 비교 방식
-- 문자열을 왼쪽에서 오른쪽으로 한 문자씩 비교
-- ascii / 유니코드 값을 기준으로 비교
-- 왼쪽부터 읽어오다가 다른 문자가 발견되는 순간에 그 값에 따라 크고 작음을 판별

-- "2015-10-01" vs "2015-11-01" 의 경우,
-- "2" == "2" / "0" == "0" / "1" == "1" / "5" == "5" / "-" == "-" / "1" == "1" 까지 동일
-- 그 다음 순간에 "0" != "1"이 다른 시점에 들어갔을 때 크기 비교가 이루어집니다.

-- yyyy-mm-dd 형식으로 지정돼있다면, 문자열 비교 결과와 실제 날짜 비교 결과가 동일하게 작용함.
-- 그래서 mm-dd-yyyy 형태로 돼있다면 오류가 발생할 가능성이 있습니다



-- 2. users에서 usa에 거주 중이면서 마케팅 수신에 동의(1)한 회원 정보와 france에 거주 중이면서
-- 마케팅 수신에 동의하지 않은(0) 회원 정보를 select로 각각 추출하고, 두 결과 집합을 union all을
-- 사용해 하나로 결합하라(단, 최종 결과는 id, phone, country, city, is_marketing_agree
-- 컬럼 추출하고, 거주 국가 기준으로 알파벳 역순으로 추출해라)


(select id, phone, country, city, is_marketing_agree
	from users
	where country = "usa" and is_marketing_agree = 1)
union all
(select id, phone, country, city, is_marketing_agree
	from users
	where country = "france" and is_marketing_agree = 0)
order by country desc;

-- 3. 이건  풀지마세요 문제만 적어놓고 같이  풂
-- union을 활용하여 orderdetails와 products를 full outer join 조건으로 결합하여 출력
-- -> 굳이 이런 형식으로 시험 문제 및 실무에까지 이용하는 경우는 거의 없습니다
(select * from orderdetails o left join products p on o.product_id = p.id)
union
(select * from orderdetails o right join products p on o.product_id = p.id);

-- 서브쿼리
-- sql 쿼리 결과를 테이블처럼 사용하는, 쿼리 속의 쿼리
-- 서브 쿼리는 작성한 쿼리를 소괄호로 감싸서 사용하는데, 실제로 테이블은 아니지만
-- 테이블처럼 사용이 가능함

-- products에서 name(제품명)과 price(정상가격)을 모두 불러오고, '평균 정상 가격을
-- 새로운 컬럼'으로 각 행마다 출력해보세요.

select name, price, (select avg(price) from products) from products;
-- select avg(price) from products;를 하는 경우 전체 price / 행의 개수로 나눈 데이터가
-- 단 하나이므로 select name, price, avg(price) from products;로 작성하면
-- 1행짜리만 도출됨

-- 이를 막기위해 서브쿼리를 적용

-- products 테이블의 name / price를 불러오는 것은 기본적인 select 절입니다.
-- 그런데 select 절에는 단일값을 반환하는 서브 쿼리가 올 수 있습니다.

-- 스칼라(Scalar) 서브 쿼리 : 쿼리의 결과가 단일 값을 반환하는 서브 쿼리

select name, price, 38.5455 as avgPrc from products;

-- 특정한 단일 결과값을 각  행에 적용을 하고 싶다면 이상과 같은 하드코딩이 가능
-- 하지만 정확한 값을 얻기 위해서 사전에 쿼리문으로
-- select avg(price) from products; 가 요구된다는 점에서 효율적이지는 않고,
-- 실무 상황에서 실제로 전제 쿼리문을 실행시킨 이후에 확인해야 해서
-- 서브 쿼리를 작성하는 편이 권장됨

-- 스칼라 서브 쿼리를 작성할 때 '단일 값'이 반환되도록 작성해야 한다는 점에 유의하세요
-- 만약 2개 이상의 집계 값을 기존 테이블에 추가하여 출력하고 싶다면 스칼라 서브 쿼리를 따로
-- 나누어서 작성해야 함

-- users에서 city별 회원 수를 카운트하고, 회원 수가 3명 이상인 도시 명과 회원 수를 출력해보자
-- 회원 수를 기준으로 내림차순
select city, count(distinct id) from users group by city;		-- > 도시 별로
																-- id 수를 계산함

-- 1번 쿼리
select city, count(distinct id)
	from users
	group by city
	having count(distinct id) >= 3
	order by count(distinct id) desc;

-- 2번 쿼리
-- select *
-- 	from 
-- 	(
-- 		select city, count(distinct id) as cntUser
-- 		from users u
-- 		group by city
-- 	) a
-- 	where cntUser >= 3
-- 	order by cntUser desc;


-- 여기서는 서브쿼리를 작성하는데 있어서 스칼라 서브 쿼리 형태로 작성하는 것이 중요하다
-- 해당 문제에서는 검증 결과 서브 쿼리 자체가 필요하지는 않음
-- a 이 부분도 비표준 sql이라서 일단은 적어둠

-- orders 와 staff 를 활용해 last_name이 kyle이나 scott인 직원의 담당 주문을 출력하려면?
-- (단, 서브쿼리 형태를 활용하자)

select *
	from orders o left join staff s on o.staff_id = s.user_id
	where s.last_name = "Kyle" or s.last_name = "Scott";
	
	-- where s.last_name = "Kyle" or s.last_name = "Scott";

select id from staff where last_name in ("Kyle", "Scott");		-- 조건절에 쓰일 경우에 스칼라 서브 쿼리가 아니었다는 점에 주목

-- 이상의 코드는 staff 테이블에서 id 값이 3, 5 를 도출해냈습니다
-- 해당 결과를 가지고 orders 테이블에 적용하는 형태로 작성합니다


select *
	from orders
	where staff_id in (
		select id
			from staff
			where last_name in ("Kyle", "Scott")
	)
	order by staff_id;
	
-- where 절 내에서 필터링 조건 지정을 위해 중첩된 서브 쿼리를 작성 가능
-- where 에서 in 연산자와 함께 서브 쿼리를 활용할 경우 :
-- 컬럼 개수와 필터링 적용 대상 컬럼의 개수가 '일치'해야만 합니다

-- 이상의 코드에서 서브쿼리의 결과 도출되는 컬럼의 숫자 = 1 (staff 테이블의 id) / 행 = 2

select *
	from orders
	where (staff_id, user_id) in (		-- 필터링 대상 컬럼 개수 = 2
		select id, user_id				-- 서브쿼리 컬럼 개수 = 2
			from staff
			where last_name in ("Kyle", "Scott")
	)
	order by staff_id;

-- 결과값으로 직원 정보 테이블에 존재하는 id, user_id와 동일한 값이 orders 테이블의
-- staff_id, user_id 컬럼에 있을 경우 반환하여 출력합니다
-- 이상의 쿼리문의 해석 -> 직원 자신이 자기 쇼핑몰에서 주문한 이력이 반환된 것

-- products에서 discount_price가 가장 비싼 제품 정보 출력
-- (단, products의 전체 컬럼이 다 출력되어야 합니다)
select max(discount_price) from products;

select *
	from products
	where discount_price in (
		select max(discount_price) from products
	);


-- orders에서 주문 월(order_date 컬럼 이용) 이 2015년 7월인 주문 정보를,
-- 주문 상세 정보 테이블 orderdeatils에서 quantity가 50 이상인 정보를 각각 서브 쿼리로 작성하고,
-- inner join하여 출력해봅시다.

select *
	from orders o inner join orderdetails od on o.id = od.order_id
	where order_id in (
		select o.order_date from orders where o.order_date like "%2015-07%"
	);

-- 1)
select *
	from orders
	where order_date >= "2015-07-01"
		and order_date < "2015-08-01";
-- 2)
select *
	from orderdetails
	where quantity >= 50;

-- 1)과 2)의 inner join 구문 -> from 절에서 이루어집니다
select *
	from(select *
		from orders
		where order_date >= "2015-07-01"
			and order_date < "2015-08-01") o		-- 1)의 결과가 테이블이었기 때문에 별칭 o를 표기
	inner join
	(select *
		from orderdetails
		where quantity >= 50) od
	on o.id = od.order_id;

-- 서브 쿼리를 작성하기 위한 방안 중에 하나는 서브 쿼리에 들어가게 될 쿼리문을 작성한 결과값을 확인
-- 이후 해당 쿼리가 스칼라냐 아니냐에 따라서 그 위치 역시 어느 정도 통제 가능
-- ex) scalar인 경우에는 select절에 들어가는 것처럼
-- 이상의 경우에는 결과값이 테이블 형태로 나왔기 때문에 이를 기준으로 inner join 했습니다

-- 서브 쿼리 정리하기
-- 쿼리 결과값을 메인 쿼리에서 값이나 조건으로 사용하고 싶을 때 사용

-- select / from / where 등 사용 위치에 따라 불리는 이름이 다르다

-- 정리 1. select 절에서의 사용
-- 형태
-- select ..., ([서브쿼리]) as [컬럼명]
-- ... 이하 생략

-- select에서는 '단일 집계 값'을 신규 컬럼으로 추가하기 위해 서브 쿼리를 사용
-- 여러 개의 컬럼을 추가하고 싶을 때는 서브 쿼리를 여러 개 작성하면 됩ㄴ디ㅏ
-- 특징 : select의 서브 쿼리는 메인 쿼리의 from에서 사용된 테이블이 아닌 테이블도 사용이 가능하기
-- 때문에 불필요한 조인 수행을 줄일 수 있다는 장점이 있다

-- 정리 2. from 에서 사용
-- 형태 : 
-- select ...
-- from ([서브쿼리]) a
-- ...

-- from에서 사용되는 서브 쿼리 : '인라인 뷰', 마치 테이블처럼 서브 쿼리의 결과값을 사용 가능
-- 또한 from에서 2개 이상의 서브 쿼리를 활용하여 join 연산 가능
-- 이 때 조인 연산을 위해 별칭 생성 가능한데 서브 쿼리가 끝나는 괄호 뒤에 공백을 한 칸 주고
-- 원하는 별칭을 쓰면 된다(orders o / orderdeails od와 같은 방식)

-- 특징 : 
-- from에서 서브 쿼리를 적절히 활용하면 적은 연산으로 같은 결과를 도출 가능. 단, rdbs 기준
-- 테이블 검색을 빠르게 할 수 있는 인덱스* 개념이 있는데 서브 쿼리를 활용하면 인덱스를 사용하지 못하는
-- 경우가 있으므로 주의해야 함

-- 인덱스(index) : 테이블의 검색 속도를 높이는 기능으로, 컬럼 값을 정렬하여 검색 시 더욱 빠르게
-- 찾아내도록 하는 자료구조

-- 정리 3. where에서의 사용
-- 형태 :
-- select...
-- where [컬럼명] [조건 연산자] ([서브 쿼리])
-- ...

-- where 에서 필터링을 위한 조건 값을 설정하는데 서브 쿼리 사용 가능
-- 위의 에시에서는 in 연산자를 사용했지만, 다른 비교 연산자도 사용 가능.

-- 특징 : in 연산자의 경우에 다중 컬럼 비교를 할 때는 서브 쿼리에서 추출하는 컬럼의 개수와
-- where에 작성하는 필터링 대상 컬럼 개수가 일치 해야 함	-> 이 때 필터링 대상 컬럼이 2개 이상이면
-- ()로 묶어서 작성해야 합니다.

-- 1. 데이터 그룹화하기(GROUP BY + 집계함수)
-- 2. 데이터 결과 집합 결합하기(JOIN + 서브쿼리)
-- 3. 테이블 결합 후 그룹화하기(JOIN + GROUP BY)
-- 4. 서브 쿼리로 필터링(WHERE절 + 서브쿼리)
-- 5. 같은 행동 반복 대상 추출(LEFT JOIN)

-- 1. users에서 created_at 컬럼 활용하여 연도별 가입 회원 수를 추출

select substr(created_at, 1, 4), count(distinct id)
	from users
	where created_at is not null
	group by substr(created_at, 1, 4);

-- 2. users에서 country, city, is_auth 컬럼을 활용, 국가별, 도시별로 본인 인증한 회원 수를
-- 추출하라.

select country, city, count(distinct id)			-- is_auth가 1이면 본인인증한거니까 is_auth들의 합이 10인건
	from users										-- 본인인증한 회원 숫자가 10이라는 뜻이라서
	where is_auth = 1
	group by country, city;

select country, city, sum(is_auth)					-- is_auth가 1이면 본인인증한거니까 is_auth들의 합이 10인건
	from users										-- 본인인증한 회원 숫자가 10이라는 뜻이라서
	where is_auth = 1
	group by country, city
	order by sum(is_auth)	 desc;