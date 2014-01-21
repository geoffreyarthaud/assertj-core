#!/bin/bash

export SED_OPTIONS=-i
export FILES_PATTERN=*Test.java
# export FILES_PATTERN=Test.java
# echo "SED_OPTIONS = $SED_OPTIONS"

echo ''
echo "Converting JUnit assertions to AssertJ assertions on files matching pattern : $FILES_PATTERN"
echo ''
echo ' 1 - Replacing : assertEquals(0, myList.size()) ................. by : assertThat(myList).isEmpty()'
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertEquals(\(\".*\"\),[[:blank:]]*0,[[:blank:]]*\(.*\).size())/assertThat(\2).as(\1).isEmpty()/g' '{}' \;
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertEquals([[:blank:]]*0,[[:blank:]]*\(.*\).size())/assertThat(\1).isEmpty()/g' '{}' \;

echo ' 2 - Replacing : assertEquals(expectedSize, myList.size()) ...... by : assertThat(myList).hasSize(expectedSize)'
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertEquals(\(\".*\"\),[[:blank:]]*\([[:digit:]]*\),[[:blank:]]*\(.*\).size())/assertThat(\3).as(\1).hasSize(\2)/g' '{}' \;
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertEquals([[:blank:]]*\([[:digit:]]*\),[[:blank:]]*\(.*\).size())/assertThat(\2).hasSize(\1)/g' '{}' \;

echo ' 3 - Replacing : assertEquals(expectedDouble, actual, delta) .... by : assertThat(actual).isEqualTo(expectedDouble, offset(delta))'
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertEquals(\(\".*\"\),[[:blank:]]*\(.*\),[[:blank:]]*\(.*\),[[:blank:]]*\(.*\))/assertThat(\3).as(\1).isEqualTo(\2, offset(\4))/g' '{}' \;
# must be done before assertEquals("description", expected, actual) -> assertThat(actual).as("description").isEqualTo(expected) 
# will only replace triplet without double quote to avoid matching : assertEquals("description", expected, actual)
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertEquals([[:blank:]]*\([^"]*\),[[:blank:]]*\([^"]*\),[[:blank:]]*\([^"]*\))/assertThat(\2).isEqualTo(\1, offset(\3))/g' '{}' \;

echo ' 4 - Replacing : assertEquals(expected, actual) ................. by : assertThat(actual).isEqualTo(expected)'
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertEquals(\(\".*\"\),[[:blank:]]*\(.*\),[[:blank:]]*\(.*\))/assertThat(\3).as(\1).isEqualTo(\2)/g' '{}' \;
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertEquals([[:blank:]]*\(.*\),[[:blank:]]*\(.*\))/assertThat(\2).isEqualTo(\1)/g' '{}' \;

echo ' 5 - Replacing : assertArrayEquals(expectedArray, actual) ....... by : assertThat(actual).isEqualTo(expectedArray)'
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertArrayEquals(\(\".*\"\),[[:blank:]]*\(.*\),[[:blank:]]*\(.*\))/assertThat(\3).as(\1).isEqualTo(\2)/g' '{}' \;
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertArrayEquals([[:blank:]]*\(.*\),[[:blank:]]*\(.*\))/assertThat(\2).isEqualTo(\1)/g' '{}' \;

echo ' 6 - Replacing : assertNull(actual) ............................. by : assertThat(actual).isNull()'
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertNull(\(\".*\"\),[[:blank:]]*\(.*\))/assertThat(\2).as(\1).isNull()/g' '{}' \;
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertNull([[:blank:]]*\(.*\))/assertThat(\1).isNull()/g' '{}' \;

echo ' 7 - Replacing : assertNotNull(actual) .......................... by : assertThat(actual).isNotNull()'
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertNotNull(\(\".*\"\),[[:blank:]]*\(.*\))/assertThat(\2).as(\1).isNotNull()/g' '{}' \;
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertNotNull([[:blank:]]*\(.*\))/assertThat(\1).isNotNull()/g' '{}' \;

echo ' 8 - Replacing : assertTrue(logicalCondition) ................... by : assertThat(logicalCondition).isTrue()'
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertTrue(\(\".*\"\),[[:blank:]]*\(.*\))/assertThat(\2).as(\1).isTrue()/g' '{}' \;
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertTrue([[:blank:]]*\(.*\))/assertThat(\1).isTrue()/g' '{}' \;

echo ' 9 - Replacing : assertFalse(logicalCondition) .................. by : assertThat(logicalCondition).isFalse()'
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertFalse(\(\".*\"\),[[:blank:]]*\(.*\))/assertThat(\2).as(\1).isFalse()/g' '{}' \;
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertFalse([[:blank:]]*\(.*\))/assertThat(\1).isFalse()/g' '{}' \;

echo '10 - Replacing : assertSame(expected, actual) ................... by : assertThat(actual).isSameAs(expected)'
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertSame(\(\".*\"\),[[:blank:]]*\(.*\),[[:blank:]]*\(.*\))/assertThat(\3).as(\1).isSameAs(\2)/g' '{}' \;
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertSame([[:blank:]]*\(.*\),[[:blank:]]*\(.*\))/assertThat(\2).isSameAs(\1)/g' '{}' \;

echo '11 - Replacing : assertNotSame(expected, actual) ................ by : assertThat(actual).isNotSameAs(expected)'
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertNotSame(\(\".*\"\),[[:blank:]]*\(.*\),[[:blank:]]*\(.*\))/assertThat(\3).as(\1).isNotSameAs(\2)/g' '{}' \;
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/assertNotSame([[:blank:]]*\(.*\),[[:blank:]]*\(.*\))/assertThat(\2).isNotSameAs(\1)/g' '{}' \;

echo ''
echo '12 - Replacing JUnit static import by AssertJ ones, at this point you will probably need to :'
echo '12 --- optimize imports with your IDE to remove unused imports'
echo '12 --- add "import static org.assertj.core.api.Assertions.offset;" if you were using JUnit number assertions with delta'
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/import static org.junit.Assert.assertEquals;/import static org.assertj.core.api.Assertions.assertThat;/g' '{}' \;
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/import static org.junit.Assert.fail;/import static org.assertj.core.api.Assertions.fail;/g' '{}' \;
find . -name "$FILES_PATTERN" -exec sed $SED_OPTIONS 's/import static org.junit.Assert.\*;/import static org.assertj.core.api.Assertions.*;/g' '{}' \;
echo ''