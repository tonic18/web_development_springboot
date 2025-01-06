-- 1. join
-- 2. union
-- 3. subquery
-- 
-- 1-1. sql에서 join은 여러 테이블에서 데이터를 가져와 결합하는 기능을 합니다
-- RDBS에서는 데이터의 중복을 피하고 쉽게 관리하기 위해 데이터를 여러 곳에 나우어 보관합니다
-- 	EX) 어떤 주문을 담당한 직원을 확인하고 싶은데, 주문 아이디 orders 테이블에 있고,
-- 		직원 이름은 staff 테이블에 있으면 어떻게 쿼리를 입력해야 하는지 고민해보도록 합니다
-- 		
-- 	이상에서 이루어지는 데이터 분산을 '데이터 정규화(data normalization)'이라고 하며
-- 	데이터베이스에서 중복을 최소화하고 데이터의 일관성을 유지하기 위함
-- 	
-- 	1) join
-- 		지금까지는 테이블 하나의 데이터를 필터링 등 다루는 연습을 했습니다
-- 		이제는 둘 이상의 테이블을 함께 다루면서 해당 키워드를 통해 합쳐서 보는 연습을 합니다
-- 		
-- 		실습 데이터를 기준으로,
-- 		EX) 국가별로 주문 건수를 알아보고 싶다면 -> users와 orders가 필요함
-- 		즉, 하나의 테이블만으로는 원하는 정보 출력이 불가능합니다
-- 		
-- 		일반적으로 JOIN의 개념은 중학교 1학년 때 배우는 집합 개념을 떠올리시면 좀 쉽습니다
-- 		두 개의 데이터 집합을 하나로 결합하는 기능을 지님
-- 		즉, 기본적으로는 '서로 다른 두 테이블 간의 공통 부분인 키를 활용'하여 테이블을 합친다

--	users와 orders를 하나로 결합하여 출력합니다.(단 주문 정보가 있는 회원 정보만 출력) 		

select *
	from users u inner join orders o on u.id = o.user_id
	;

-- 이상의 sql문에 대한 해석
-- 기존에 from 다음에는 테이블 명 하나만 작성되었지만, 이제는 join연산을 위한
-- 추가 문법이 적용됐음
-- 회원 정보와 주문 정보를 하나로 결합하기 위해 users와 orders를 inner join(추후설명)
-- 으로 묶고, '후속조건'으로 "주문정보가 있는 회원의 정보만 출력하기 위해" u.id = o.user_id를 적용함

-- 여기서 여러분들에게 연습문제시에만 설명했던 부분을 명확하게 하고 넘어가야 합니다

-- users PK인 id는 회원id에 해당함
-- orders에 PK인 id는 주문 id에 해당하고, 2번째 컬럼인 user_id는
-- orders에서는 Pk는 아니지만 join을 수행할 때 users와 합치는 조건이 됩니다


-- 여러 테이블을 하나의 from에서 다룰 때에는 별칭을 사용 가능(alias와는 다름 -> 컬럼명을 지정)
-- from users u 로 작성했을 때 이후에는 u만 썼을 경우 users 테이블을 의미하게 됨
-- 그래서 이후에 from 절에서 다수의 테이블명을 기입하게 될 경우에 별칭을 통해서 정리하여
-- sql문을 효율적으로 사용할 수 있게 됨

-- 이상의 문제에서의 조건은 '주문 정보가 있는 회원의 정보만 출력'하는 것이므로, orders 내에
-- user_id가 일부 기준이 되어야 함

-- 왜냐하면 users 내에 있는 id는 1부터 있기 때문
-- users 테이블에는 회원 id가 id 컬럼에 기록돼있고, orders 테이블에는 회원 id가 user_id로
-- 공통된 부분을 지정하는 컬럼이 존재하므로 둘을 연결시킬 수 있는데, 이때 사용하는 전치사가
-- 'ON'

-- join 적용 후 결과를 보기 좋게 정렬하도록 sql 문 수정
-- 회원 id를 기준으로 오름차순하는 조건
-- order by에서도 테이블 별칭으로 정렬할 컬럼을 지정 가능

select *
	from users u inner join orders o on u.id = o.user_id
	order by u.id
	;

-- form에서 join이 정렬된 후에 단일 테이블에 명령을 내리는 것처럼 쿼리를 작성 가능
-- -> 이미 join을 통해 하나의 테이블로 구성된 것처럼 간주되기 때문

-- 복수의 테이블이 하나로 결합되기 위해서는 두 테이블 간에 공통된 부분이 존재해야 합니다
-- rdbs에서는 이 부분을 키(key)라고 합니다
-- 키 값은 테이블에 반드시 1개 이상 존재하도록 설계되어 있고(설계해야함)
-- 테이블에서 개별 행을 유일하게 구분 짓습니다. 따라서 키 값은 컬럼 내에서 중복되지 않으며
-- 개별 행을 구분해야 하므로 null 값을 가질 수 없습니다
-- (nullabe = false로 Entity 클래스에서 지정했음)

-- cf) 키 값은 테이블 내에서 고유한 값을 가지므로 한 테이블에서 개수를 계산할 때 중복되진 않는다
-- 하지만 여러 테이블을 조인하면 '키 값도 중복될 수 있다' 예를 들어 회원 아이디가 7인 사람이
-- 세 번 주문했다면 회원 정보(users)와 주문 정보(orders)를 결합한 결과에는 u.id =7인
-- 행에 3개 있을 것이다. 이 경우 '한 번이라도 주문한 회원 수'를 중복 없이 구하려면 회원
-- id를 중복 제거한 뒤에 회원 수를 count할 필요가 있다


-- KEY의 구분
-- 1. 기본 키(Primary Key) : 하나의 테이블에서 가지는 고유한 값
-- 2. 외래 키(Foreign Key) : 다른 테이블에서 가지는 기존 테이블의 값

-- FK는 테이블의 고유한 키 값인 PK를 참조한다.(orders에서 o.id가 FK에 해당,
-- users의 u.id가 PK에 해당해서 FK가 PK를 참조해서 조건을 합치시켜 JOIN함)

-- 예를 들어 PK값이 A, B, C만 있다면 PK값도 이 값만 가질 수 있고, 또한 중복되지 않는다는
-- 특징을 지니고 있음.
-- 하지만 FK의 경우에는 참조하고 있는 관계에 따라 참조 대상인 PK값이 여러 번 나타날 수 있습니다.
-- users 테이블에서는 id = 7인 값이 하나만 존재하지만
-- orders 테이블에서는 user_id가 PK가 아니기 때문에 3건 존재함
-- 이를 JOIN 시켰을 때 u.id로 ORDER BY 하더라도 합친 테이블 상에서 제 1컬럼(즉 PK 컬럼)에
-- 동일 id가 여러 번 출력될 수 있습니다


-- JOIN의 종류 
-- 1. INNER JOIN
--  : 두 테이블의 키 값이 일치하는 행의 정보만 가져옵니다.	-> 집합에서 교집합에 해당
-- users와 orders를 하나로 결합하여 출력합니다.(단 주문 정보가 있ㅇ는 회원의 정보만 출력)
-- 이상의 문제에서 INNER JOIN을 도출할 수 있는 근거는'(단 주문 정보가 있ㅇ는 회원의 정보만 출력)'
-- 이 부분에 해당함.

-- 2. LEFT JOIN
-- users와 orders를 하나로 결합해 출력합니다(단, 주문 정보가 없는 회원의 정보도 모두 출력)

select *
	from users u left join orders o on u.id = o.user_id;

-- INNER JOIN의 경우 두 테이블 간의 키 값 조건이 일치하는 행만 결과값으로 가져왔습니다(교집합만)
-- LEFT JOIN은 INNER JOIN의 결과값인 교집합 뿐만 아니라 JOIN 명령문의 왼쪽에 위치한 테이블의
-- 모든 결과값을 가져옵니다

-- 이상의 예시에서는 users 테이블이 왼쪽에 있으므로, users 테이블의 모든 결과값을 가져오는데,
-- orders 테이블에 대응하는 값이 없는 경우 null 값으로 출력됩니다

-- 즉, 두 테이블의 교집합과 교집합에 속하지 않는 왼쪽 차집합을 불러옵니다
-- 왼쪽 테이블의 값을 전부 불러오기 때문에 LEFT JOIN / LEFT OUTER JOIN 이라고 합니다

-- LEFT JOIN 과 INNER JOUN은 함께 실무에서 자주 쓰임. 데이터를 결합하는 경우 대부분
-- 한쪽 데이터의 값을 보존해야 할 때가 많은데, 이번 예시에서도 그렇습니다. 주문 정보가 없는
-- 회원의 정보까지 출력항려면 LEFT JOIN을 활용합니다(블로그 글을 남긴 users와)
-- (한번도 남기지 않는 user를 구분할 때)

-- '결합 후에' 컬럼 값에 접근할 때는 [테이블 별칭].[컬럼명]으로 내부 컬럼에 접근합니다
-- 두 테입르에 동일한 컬럼이 있을 때(대부분의 경우 PK 역할을 하는 id들은 다 있으니까)
-- 어떤 것을 지정했는지 명확히 하기 위해서 입니다
-- 이를 활용해서 SELECT에서도 * 대신에 표시할 컬럼을 지정할 수 있는데,
-- u.id, u.username, o.order_date처럼 컬럼이 속한 테이블 별칭을 . 앞에 명시해주면 됩니다.

-- 예시
select u.id, u.username, u.country, o.id, o.user_id, o.order_date
from users u left join orders o on u.id = o.user_id		-- select의 별칭을 여기서 지정
order by u.id;

-- users와 orders를 하나로 결합해 출력해 봅시다 (단, 주문 정보가 없는 회원의 정보만 출력합니다)
select *
from users u left join orders o on u.id = o.user_id
where o.id is null		-- o.id / o.user_id / o.staff_id, o.order_date
order by u.id;

-- users 와 orders를 하나로 결합하고, 추가로 orderdetails에 있는 데이터도 출력해보자.(단,
-- 주문 정보가 없는 회원의 주문 정보도 모두 출력하고, 다음 컬럼을 출력하자. u.id, u.username,
-- u.phone, o.user_id, o.id, od.order_id, od.product_id)	-> JOIN이 두번 일어납니다.

-- FROM 내에서는 JOIN을 중첩해서 횟수 제한 없이 사용 가능합니다.
-- 첫번째 JOIN의 ON절 뒤에, 두번째 JOIN 절을 작성하면됨

select u.id, u.username, u.phone, o.user_id, o.id, od.order_id, od.product_id
from users u left join orders o on u.id = o.user_id
left join orderdetails od on o.id = od.order_id	-- select의 별칭을 여기서 지정
order by u.id;

-- users와 orders를 하나로 결합하여 출력해보자(단, 회원 정보가 없는 주문 정보도 출력)

select *
	from users u right join orders o on u.id = o.user_id;

-- RIGHT JOIN 은 기본적으로 LEFT JOIN과 기능은 동일함. LEFT JOIN에서는 왼쪽에 위치한
-- 테이블의 모든 값을 가져왔음(즉, JOIN 했을 때를 기준으로 u.id는 있지만 o.user_id가 없는 경우도
-- 출력된다는 것을 의미)
-- RIGHT JOIN의 경우는 오른쪽 테이블에 위치한 값을 전부 가지고 온다는 것을 의미합니다
-- 즉 여기에서의 예제 쿼리의 결과값은 INNER JOIN과 동일하게 됩니다

-- 이는 두 테이블 간의 '포함 관계'에서 비롯됩니다
-- users 테이블에 id가 없는 회원의 정보는 orders 테이블에 존재할 수 없음
-- 따라서 orders 테이블의 user_id 컬럼은 모두 users 테이블의 id 컬럼에 있는 값에 해당함
-- 결합으로 봤을 때 orders는 users 테이블에 종속돼 있으므로 null 값이 출력될 수 없음

-- 이상을 이유로,
-- 많은 기업에서는 RIGHT JOUN 대신에 LEFT JOIN을 사용하도록 권장함

-- users와 orders의 '모든 가능한 행 조합'을 만들어 내는 쿼리를 작성합니다
select *
	from users u cross join orders o	-- 모든 가능한 행 조합에서 -> cross join을 유추
	order by u.id;

-- cross join - 두 테이블 간의 집합을 조합해 만들 수 있는 모든 경우의 수를 생성하는 방식으로,
	-- 카테시안 제곱(Cartesian Product)을 의미함
-- u.id를 기준으로 정렬했습니다(얼마나 많은 조합이 나오는지 시각적으로 보여드릴 수 있도록 추가함)

-- u.id와 o.user_id를 연결하는 등의 조건 없이 두 테이블의 모든 행을 합쳐서 만들 수 있는 모든
-- 경우의 수를 생성한 것입니다

-- 즉, 10 행의 테이블과 20행의 테이블을 cross join하면, 200행이 됩니다.
-- 해당 경우 cross join은 모든 경우의 수를 구하므로 on 조건을 굳이 설정하지 않습니다

-- join 명령어는 근본적으로 두 테이블의 행을 서로 조합하는 과정에 해당하는데, on 조건을 활용하면
-- 전체 경우의 수에서 어떤 행만 가져올 수 있을지 정할 수 있습니다

-- 실제 환경에서는 cross join을 제한하는 편입니다. 컴퓨터에 많은 연산을 요구하는데,
-- 실질적으로는 null 값만 출력되는 경우의 수가 많아 쓸모가 없기 때문

-- 연습문제
-- 1. users와 staff를 참고하여 회원 중 직원인 사람의 회원 id, 이메일, 거주도시, 거주국가, 성, 이름을 한 화면에 출력

select u.id, u.username, u.city, u.country, s.first_name, s.last_name
	from users u inner join staff s on u.id = s.user_id;

-- 2. staff와 orders를 참고하여 직원 아이디가 3번, 5번인 직원의 담당 주문을 출력하세요
-- 단, 직원아이디, 직원 성, 주문 아이디, 주문일자만 출력하세요

select s.id, s.last_name, o.id, o.order_date
	from staff s left join orders o on s.id = o.staff_id 
--	where s.id = 3 or s.id = 5;
	where s.id in(3, 5);

-- 3. users와 orders를 참고하여 회원 국가별 주문 건수를 내림차순으로 출력하세요

select u.country, count(distinct o.id)
	from users u left join orders o on u.id = o.user_id
	group by u.country					-- 국가별로 확인한다고 했기 때문에
	order by count(distinct o.id) desc;


-- 4. orders와 orderdetails, products를 참고하여 회원 아이디별 주문 금액의 총합을 정상 가격과
-- 할인 가격 기준으로 각각 구하세요(단, 정상 가격 주문 금액의 총합 기준으로 내림차순으로 정렬하세요)

-- select o.user_id, p.price, p.discount_price, sum(p.price)
select o.user_id
	, sum(p.price * od.quantity) as sumPrice
	, sum(p.discount_price * od.quantity) as sumDiscountPrice
	from orders o
	left join orderdetails od
	on o.id = od.order_id
	inner join
	products p
	on od.product_id = p.id
	group by o.user_id 				-- 회원 아이디 별로 정렬하라고 했기 때문에
	order by sum(price * quantity) desc;

-- JOIN 총 정리
-- JOIN : 두 테이블을 하나로 결합할 때 사용(정규화를 통해서 DB 관리를 효율화했기 때문에 하나로 합치게 될 때 사용되는 명령어).

-- 정리 1. 기본 형식
-- FROM [테이블명1] a(별칭) [INNER/LEFT/RIGHT/CROSS JOIN] [테이블명2] b(별칭)
-- ON [JOIN 조건]			-> 선호되는 조건 방식 PK = FK

-- JOIN 명령어는 FROM에서 수행됩니다. 쿼리 진행상 FROM이 가장 먼저 수행되므로
-- 일단 JOIN이 수행된 뒤에 다른 명령어들이 수행됩니다 JOIN 사용 시, 결합할 두 테이블 사이에
-- 원하는 JOIN 명령어를 작성하고, 테이블 별칭을 설정(알리아스가 아님)
-- 또한 두 테이블 사이에 공통된 컬럼 값인 키 값이 존재해야만 JOIN으로 결합할 수 있습니다.
-- 키 값은 여러 개가 있을 수 있어, 어떤 값을 기준으로 할 지 ON에서 명시합니다.
-- 다중 키값을 설정할 때는 ON에서 각 조건을 AND로 연결합니다.
-- FROM [테이블명1] a(별칭) [INNER/LEFT/RIGHT/CROSS JOIN] [테이블명2] b(별칭)
-- ON [JOIN 조건1]
-- [INNER/LEFT/RIGHT/CROSS JOIN] [테이블명3] c(별칭)
-- ON [JOIN 조건2]

-- FROM 내에서 JOIN을 여러 번 중첩 사용 가능. 앞의 JOIN의 ON 절 뒤에 새로운 JOIN 명령어를
-- 작성하면 제 3의 테이블과 결합 가능 -> 순서대로 적용한다는 점이 중요
-- 횟수 제한은 없지만, 테이블 크기에 따라 많은 연산이 필요할 수 있어 사전에 필요한 연산인지
-- 점검할 필요가 있습니다.

-- 정리 3. INNER JOIN
-- FROM [테이블명1] a INNER JOIN [테이블명2] b
-- ON a.key = b.key

-- INNER JOIN은 각 테이블의 키 값이 '일치하는 행만' 가져옵니다. 집합으로 보면 교집합
-- 가장 기본적인 JOIN문으로, 간혹 INNER를 생략하고 JOIN만 쓰기도 합니다(default JOIN 구문)
-- 그런데 실무에서는 웬만하면 가독성을 위해 INNER 명시

-- 정리 4. OUTER JOIN(LEFT/RIGHT)
-- FROM [테이블명1] a LEFT/RIGHT/FULL JOIN [테이블명2] b
-- OUTER JOIN은 LEFT OUTER JOIN, RIGHT OUTER JOIN, FULL OUTER JOIN을 포괄하는 용어
-- OUTER 생략 가능

-- LEFT JOIN : 왼쪽 테이블의 모든 데이터 값을 결과에 포함(보통 자주 쓰임)
-- RIGHT JOIN : 오른쪾 테이블의 모든 데이터 값을 결과에 포함(잘 안씀)
-- FULL OUTER JOIN : 왼쪽과 오른쪽에 있는 테이블의 모든 값을 결과에 포함
-- 		LEFT + RIGHT JOIN의 결과값이 중복없이 결합된 형태
--		DB에 따라서 지원하지 않는 경우도 많음
-- 정리 5. CROSS JOIN
-- FROM [테이블명1] a LEFT/RIGHT/FULL JOIN [테이블명2] b
-- CROSS JOIN은 두 테이블을 결합했을 때 각 테이블의 행으로 만들 수 있는 모든 조합을 결과값으로
-- 도축하는 연산 -> 카테시안 곱이라고 함 -> 쓸 때 주의 필요

-- 주의 사항 :  FULL OUTER JOIN VS. CROSS JOIN
-- FULL OUTER JOIN의 경우 ON 조건에 부합할 때만 결과값을 도출하는 반면에,
-- CROSS JOIN은 모든 경우의 수를 출력하기 때문에 ON 조건을 명시하는 일이 거의 없다

-- 강사 정리 : 실무에서는 INNER JOIN(default), LEFT OUTER JOIN을 기본으로 사용함
-- 			OUTER를 명시하는 회사도 있음