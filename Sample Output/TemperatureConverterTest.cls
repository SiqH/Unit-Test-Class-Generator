@isTest 
private class TemperatureConverterTest {
        

            @isTest
            static void testWarmTemp() {
                System.assertEquals(21.11, TemperatureConverter.FahrenheitToCelsius(70));
            }
        

            @isTest
            static void testFreezingPoint() {
                System.assertEquals(0, TemperatureConverter.FahrenheitToCelsius(32));
            }
        

            @isTest
            static void testNegativeTemp() {
                System.assertEquals(-23.33, TemperatureConverter.FahrenheitToCelsius(-10));
            }
        

            @isTest
            static void testBoilingTemp() {
                System.assertEquals(100.56, TemperatureConverter.FahrenheitToCelsius(213));
            } 
}