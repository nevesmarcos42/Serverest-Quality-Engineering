package serverest;

import com.intuit.karate.junit5.Karate;

/**
 * Test runner for executing all Karate API tests.
 * Generates consolidated HTML reports in target/karate-reports/.
 */
public class TestRunner {
    
    @Karate.Test
    Karate testAll() {
        return Karate.run().relativeTo(getClass());
    }
}
