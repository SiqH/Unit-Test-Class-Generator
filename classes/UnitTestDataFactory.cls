public class UnitTestDataFactory{
    public ApexClass apexClassRecord {get; set;}
    public ApexTrigger apexTriggerClassRecord {get; set;}
    public List<String> methods = new List<String>();
    ClassDetails classDetailsWrapperInstance = new ClassDetails();
    
    public Map<String, Object> results = new Map<String, Object>();
    public class UnitTestDataFactoryException extends Exception {}

    public UnitTestDataFactory() {}

    public ClassDetails getClassDetailsWrapperInstance() {
        // System.debug('apexClassRecord -->' + apexClassRecord);
        // System.debug('apexTriggerClassRecord -->' + apexTriggerClassRecord);
        List<Object> parsedValues = new List<Object>();
        Map<String, Object> innerValues = new Map<String, Object>();
        
           results = ApexTestClassGenUtil.results;
            if (results.keySet().contains('type') && results.get('type') == 'ApexClass') {

                new ApexClassSymbolTable(apexClassRecord.Name);
                ClassDefinitionWrapper classDefinitionWrapperInstance = null;

                for (String value : results.keySet()) {
                    
                    if (value != 'type') {                    
                        if (
                            ApexClassSymbolTable.methodDetailsMap.keyset().contains(value) ||
                            ApexClassSymbolTable.constructorDetailsMap.keyset().contains(value)
                        ) {
                            Set<String> modifiers = new Set<String> (ApexClassSymbolTable.methodDetailsMap.get(value).modifiers);
                            classDetailsWrapperInstance.isStaticMethod = modifiers.contains('static') ? true : false;
                        } else {
                            throw new UnitTestDataFactoryException('Method name does not exist in mentioned class' + ApexClassSymbolTable.methodDetailsMap);
                        }
                        classDetailsWrapperInstance.methodName = value;
                        classDetailsWrapperInstance.classDefinitionWrapperList = new List<ClassDefinitionWrapper>(); 

                        if (value != 'type' && value != 'primaryobject') {
                            parsedValues = (List<Object>) results.get(value);
                            for (Object value1 : parsedValues) {
                                innerValues = (Map<String, Object>) value1;
                                classDefinitionWrapperInstance = new ClassDefinitionWrapper();

                                for (String s : innerValues.keySet()) {
                                    if (s == 'testmethodname') {
                                        classDefinitionWrapperInstance.testMethodName = String.valueOf(innerValues.get(s));
                                    }
                                    if (s == 'input') {
                                        classDefinitionWrapperInstance.input = String.valueOf(innerValues.get(s));
                                    }
                                    if (s == 'output') {
                                        classDefinitionWrapperInstance.output = String.valueOf(innerValues.get(s));
                                    }
                                } // end of inner for
                                classDetailsWrapperInstance.classDefinitionWrapperList.add(classDefinitionWrapperInstance);
                            } // end of outer for
                        }
                    }
                } // end of outer for
            } // end of outer if

            if (results.keySet().contains('type') && results.get('type') == 'trigger') {
                TriggerWrapper triggerWrapperInstance = null;
                
                for (String value : results.keySet()) {
                    classDetailsWrapperInstance.triggerWrapperList = new List<TriggerWrapper>();

                    if (value == 'primaryobject') {
                        classDetailsWrapperInstance.primaryobject = String.valueOf(results.get(value));
                    }
                    if (value != 'type' && value != 'primaryobject') {
                        parsedValues = (List<Object>) results.get(value);
                        for (Object value1 : parsedValues) {
                            innerValues = (Map<String, Object>) value1;
                            triggerWrapperInstance = new TriggerWrapper();

                            for (String s : innerValues.keySet()) {
                                if (s == 'relatedObject') {
                                    triggerWrapperInstance.relatedObject = (List<Object>) innerValues.get(s);
                                }
                                if (s == 'additionalObject') {
                                    triggerWrapperInstance.additionalObject = (List<Object>) innerValues.get(s);
                                }
                                if (s == 'action') {
                                    String actionValue = String.valueOf(innerValues.get(s));
                                    triggerWrapperInstance.action = actionValue ;
                                    if(actionValue=='delete'){
                                        triggerWrapperInstance.actionResults = 'Delete';
                                    }
                                    else {
                                        triggerWrapperInstance.actionResults = 'Save';
                                    }
                                }
                                if (s == 'testmethod') {
                                    triggerWrapperInstance.testmethodname = String.valueOf(innerValues.get(s));
                                }
                                if (s == 'noofprimobjs') {
                                    triggerWrapperInstance.numberOfPrimaryRecord = Integer.valueOf(innerValues.get(s));
                                }
                                if (s == 'noofreltdobjs') {
                                    triggerWrapperInstance.numberOfRelatedRecord = Integer.valueOf(innerValues.get(s));
                                }
                                if (s == 'assertfor') {
                                    triggerWrapperInstance.assertfor = String.valueOf(innerValues.get(s));
                                }
                                if (s == 'relatedObjectInput') {
                                    triggerWrapperInstance.relatedObjectInput = (List<Object>) innerValues.get(s);
                                }
                                if (s == 'fieldsToUpdate') {
                                    List<Object> objList = (List<Object>) innerValues.get(s);
                                    triggerWrapperInstance.fieldsToUpdateInput = new List<FieldNameValue>();
									
                                    for (Object o : objList) {
										Map<String, Object> objMap = (Map<String, Object>) o;
										FieldNameValue val = null;
										val = new FieldNameValue();
										for (String oMap : objMap.keySet()) {
											if (oMap == 'fieldName') {
												val.fieldName = String.valueof(objMap.get(oMap));
											}
											if (oMap == 'fieldValue') {
												val.fieldValue = objMap.get(oMap);
											}
										}										
										triggerWrapperInstance.fieldsToUpdateInput.add(val);
									}
        
                                }                                
                                //fieldToUpdate
                            } // inner for loop
                            classDetailsWrapperInstance.triggerWrapperList.add(triggerWrapperInstance);
                        } // outer for loop
                    } // end of if
                } // end of for
            } // end of if

            return classDetailsWrapperInstance;
    }

    public Map<String, List<String>> getTestdata() {
        Set<String> dependentObjectSet = new Set<String>();
        Map<String, List<String>> testDataMap = new Map<String, List<String>>();
        testDataMap.put(
            classDetailsWrapperInstance.primaryObject,
            getFieldToCreateData(classDetailsWrapperInstance.primaryObject, null)
        );

        for (TriggerWrapper wrapper : classDetailsWrapperInstance.triggerWrapperList) {
            if (!testDataMap.keySet().contains(String.valueOf(wrapper.relatedObject[0]))) {
                testDataMap.put(
                    String.valueOf(wrapper.relatedObject[0]),
                    getFieldToCreateData(String.valueOf(wrapper.relatedObject[0]), wrapper.relatedObjectInput)
                );
            }
        }
        return testDataMap;
    }

    private List<String> getFieldToCreateData(String objectName, List<Object> relatedFields) {
        Map<String, Schema.DescribeFieldResult> requiredFieldMap = fetchRequiredFields(objectName);
        Map<String, Schema.DescribeFieldResult> dependentFieldMap = fetchDependentFormulaFields(objectName);
        Map<String, Schema.DescribeFieldResult> relatedFieldMap = null;
        if (relatedFields != null) {
            relatedFieldMap = fetchRelatedObjectField(objectName, relatedFields);
        }

        if (dependentFieldMap != null && dependentFieldMap.size() > 0) {
            for (String s : dependentFieldMap.keySet()) {
                if (!requiredFieldMap.keySet().contains(s)) {
                    requiredFieldMap.put(s, dependentFieldMap.get(s));
                }
            }
        }

        if (relatedFieldMap != null && relatedFieldMap.size() > 0) {
            for (String s : relatedFieldMap.keySet()) {
                if (!requiredFieldMap.keySet().contains(s)) {
                    requiredFieldMap.put(s, relatedFieldMap.get(s));
                }
            }
        }
        List<String> testDataList = createTestData(requiredFieldMap);
        return testDataList;
    }

    private Map<String, Schema.DescribeFieldResult> fetchRequiredFields(String objectName) {
        Set<String> requiredFieldSet = new Set<String>();
        Map<String, Schema.DescribeFieldResult> requiredFieldMap = new Map<String, Schema.DescribeFieldResult>();
        Map<String, Schema.SObjectField> objectFields =
            Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        
		for (String s : objectFields.keySet()) {
            Schema.DescribeFieldResult descResField = objectFields.get(s).getDescribe(); 

            if (descResField.isCreateable() && descResField.isUpdateable()) {
                // Required fields
                if (
                    !descResField.isNillable() &&
                    descResField.isCreateable() &&
                    !descResField.isDefaultedOnCreate()
                ) {
                    requiredFieldSet.add(descResField.getName());
                    requiredFieldMap.put(descResField.getName(), descResField);
                }
            }
        }
        return requiredFieldMap;
    }

    private Map<String, Schema.DescribeFieldResult> fetchDependentFormulaFields(String objectName) {
        Set<String> dependentFieldSet = new Set<String>();
        Map<String, Schema.DescribeFieldResult> formulaFieldMap = new Map<String, Schema.DescribeFieldResult>();
        Map<String, Schema.SObjectField> objectFields =
            Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
			
        for (String s : objectFields.keySet()) {
            Schema.DescribeFieldResult descResField = objectFields.get(s).getDescribe(); 
            
			if (descResField.isCreateable() && descResField.isUpdateable()) {

                // Formula fields
                if (descResField.isCalculated()) {
                    formulaFieldMap.put(descResField.getName(), descResField);
                }
            }
        }

        for (String s : objectFields.keySet()) {
            if (formulaFieldMap.get(s) != null && formulaFieldMap.keySet().contains(s)) {
                dependentFieldSet.add(s);
                formulaFieldMap.remove(s);
            }
        }
        return formulaFieldMap;
    }

    private Map<String, Schema.DescribeFieldResult> fetchRelatedObjectField(String objectName, List<Object> relatedFields) {
        Map<String, Schema.DescribeFieldResult> relatedFieldMap = new Map<String, Schema.DescribeFieldResult>();
        Map<String, Schema.SObjectField> objectFields =
            Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        for (Object s : relatedFields) {
            Schema.DescribeFieldResult descResField = objectFields.get(String.valueOf(s)).getDescribe(); 
            if (descResField.isCreateable() && descResField.isUpdateable()) {

                // Related fields
                if (descResField.getType() == Schema.DisplayType.Reference) {
                    relatedFieldMap.put(descResField.getName(), descResField);
                }
            }
        }
        return relatedFieldMap;
    }

    private List<String> createTestData(Map<String, Schema.DescribeFieldResult> requiredFieldMap) {
        List<String> testDataList = new List<String>();
        for (String s : requiredFieldMap.keySet()) {
            if (
                requiredFieldMap.get(s).getType() == Schema.DisplayType.Currency ||
                requiredFieldMap.get(s).getType() == Schema.DisplayType.Integer ||
                requiredFieldMap.get(s).getType() == Schema.DisplayType.Double ||
                requiredFieldMap.get(s).getType() == Schema.DisplayType.Percent
            ) {
                testDataList.add(s + ' = ' + 1);
            }
            if (
                requiredFieldMap.get(s).getType() == Schema.DisplayType.String ||
                requiredFieldMap.get(s).getType() == Schema.DisplayType.Picklist ||
                requiredFieldMap.get(s).getType() == Schema.DisplayType.Id ||
                requiredFieldMap.get(s).getType() == Schema.DisplayType.TextArea
            ) {
                testDataList.add(s + ' = ' + '\'TestData\'');
            }
            if (requiredFieldMap.get(s).getType() == Schema.DisplayType.Boolean) {
                testDataList.add(s + ' = ' + true);
            }
            if (requiredFieldMap.get(s).getType() == Schema.DisplayType.DateTime) {
                testDataList.add(s + ' = DateTime.valueOf(\'' + System.now() + '\')');
            }
            if (requiredFieldMap.get(s).getType() == Schema.DisplayType.Date) {
                testDataList.add(s + ' = Date.valueOf(\'' + Date.valueOf(System.now()) + '\')');
            }
            if (requiredFieldMap.get(s).getType() == Schema.DisplayType.Reference) {
                testDataList.add(s + ' = ' + requiredFieldMap.get(s).getRelationshipName() + 'Obj.Id');
            }
        }
        System.debug('testDataList -->' + testDataList);
        return testDataList;
    }

    public class ClassDetails {
        public String methodName {get; set;}
        public Boolean isStaticMethod {get; set;}
        public String apexClasstype {get; set;}
        public String primaryObject {get; set;}
        public List<ClassDefinitionWrapper> classDefinitionWrapperList {get; set;}
        public List<TriggerWrapper> triggerWrapperList {get; set;}
    }

    public class ClassDefinitionWrapper {
        public String testMethodName {get; set;}
        public Object input {get; set;}
        public Object output {get; set;}
    }

    public class TriggerWrapper {
        public List<Object> relatedObject {get; set;}
        public List<Object> additionalObject {get; set;}
        public String action {get; set;} // on same object there can be multiple actions, make list
        public String actionResults {get; set;} // to save correct database results 
        
        public String testmethodname {get; set;}
        public Integer numberOfPrimaryRecord {get; set;}
        public Integer numberOfRelatedRecord {get; set;}
        public List<Object> relatedObjectInput {get; set;}
        public List<Object> primaryObjectInput {get; set;}
        public String assertfor {get; set;}		
		public List<FieldNameValue> fieldsToUpdateInput {get; set;}        
    }
	
    public class FieldNameValue {
        String fieldName {get; set;}
        Object fieldValue {get; set;}
    }
}