package me.parkkyungho.springbootdeveloper;
/*
    1. 서버 껐다 킴
    2. 그런데 안되면 ctrl + s 로 세이브
    3. 인텔리제이 껐다 킴
    4. 서버 재실행
    5. 그러면 완료될 가능성 多
 */
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {
    @GetMapping("/test")
    public String test(){
        return "Hello World!";
    }
}
