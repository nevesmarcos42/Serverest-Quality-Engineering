package serverest;

import com.intuit.karate.junit5.Karate;

public class TestRunner {
    
    @Karate.Test
    Karate testAll() {
        return Karate.run("classpath:features").relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testUsuarios() {
        return Karate.run("classpath:features/usuarios.feature").relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testLogin() {
        return Karate.run("classpath:features/login.feature").relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testProdutos() {
        return Karate.run("classpath:features/produtos.feature").relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testCarrinhos() {
        return Karate.run("classpath:features/carrinhos.feature").relativeTo(getClass());
    }
}
