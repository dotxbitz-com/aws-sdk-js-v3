# language: en
@s3 @objects
Feature: Working with Objects in S3

  As a user of S3 I need to be able to work with objects in a bucket.

  Background:
    Given I create a shared bucket

  @crud
  Scenario: CRUD objects
    When I put "world" to the key "hello"
    Then the object "hello" should exist
    Then I get the object "hello"
    And the object "hello" should contain "world"
    When I put "new world" to the key "hello"
    Then the object "hello" should exist
    Then I get the object "hello"
    Then the object "hello" should contain "new world"
    Then I delete the object "hello"
    Then the object "hello" should not exist

  @content-length
  Scenario: Content length
    When I put "foo" to the key "contentlength" with ContentLength 3
    Then the object "contentlength" should exist
    Then I get the object "contentlength"
    And the object "contentlength" should contain "foo"

  @multi-byte
  Scenario: Putting a multi-byte string to an object
    When I put "åß∂ƒ©" to the key "multi"
    Then the object "multi" should exist
    Then I get the object "multi"
    Then the object "multi" should contain "åß∂ƒ©"
    And the HTTP response should have a content length of 11

  @copy
  Scenario: Copying an object
    Given I put "world" to the key "hello"
    When I copy the object "hello" to "byebye"
    Then the object "byebye" should exist
    Then I get the object "byebye"
    Then the object "byebye" should contain "world"
    Then I delete the object "byebye"

  # Blocked on the support for makeUnauthenticatedRequest https://github.com/aws/aws-sdk-js-v3/issues/984
  # @unauthenticated
  # Scenario: Unauthenticated requests
  #   When I put "world" to the public key "hello"
  #   And I make an unauthenticated request to read object "hello"
  #   Then the object "hello" should contain "world"

  @blank
  Scenario: Putting nothing to an object
    When I put "" to the key "blank"
    Then the object "blank" should exist
    Then I get the object "blank"
    Then the object "blank" should contain ""
    And the HTTP response should have a content length of 0

  @buffer
  Scenario: Putting and getting an empty buffer
    When I put an empty buffer to the key "emptybuffer"
    Then the object "emptybuffer" should exist
    Then I get the object "emptybuffer"
    And the HTTP response should have a content length of 0

  @buffer
  Scenario: Putting and getting a small buffer
    When I put a small buffer to the key "smallbuffer"
    Then the object "smallbuffer" should exist
    Then I get the object "smallbuffer"
    And the HTTP response should have a content length of 1048576

  @buffer
  Scenario: Putting and getting a large buffer
    When I put a large buffer to the key "largebuffer"
    Then the object "largebuffer" should exist
    Then I get the object "largebuffer"
    And the HTTP response should have a content length of 20971520

  @file
  Scenario: Putting and getting an empty file
    When I put an empty file to the key "emptyfile"
    Then the object "emptyfile" should exist
    Then I get the object "emptyfile"
    And the HTTP response should have a content length of 0

  @file
  Scenario: Putting and getting a small file
    When I put a small file to the key "smallfile"
    Then the object "smallfile" should exist
    Then I get the object "smallfile"
    And the HTTP response should have a content length of 1048576

  @file
  Scenario: Putting and getting a large file
    When I put a large file to the key "largefile"
    Then the object "largefile" should exist
    Then I get the object "largefile"
    And the HTTP response should have a content length of 20971520

  @checksum
  Scenario: Verifying data integrity
    Given I generate the MD5 checksum of "SOME SAMPLE DATA"
    And I put "SOME SAMPLE DATA" to the key "checksummed_data"
    Then the object "checksummed_data" should exist
    When I get the object "checksummed_data"
    Then the object "checksummed_data" should contain "SOME SAMPLE DATA"
    Then the HTTP response should have a content length of 16
    And the MD5 checksum of the response data should equal the generated checksum

  @presigned
  Scenario: Putting to a pre-signed URL
    Given I get a pre-signed URL to PUT the key "presigned" with data ""
    And I access the URL via HTTP PUT with data "PRESIGNED BODY CONTENTS"
    Then I get a pre-signed URL to GET the key "presigned"
    And I access the URL via HTTP GET
    Then the HTTP response should equal "PRESIGNED BODY CONTENTS"

  @presigned @checksum
  Scenario: Pre-signed URLs with checksum
    Given I get a pre-signed URL to PUT the key "hello" with data "CHECKSUMMED"
    And I access the URL via HTTP PUT with data "NOT CHECKSUMMED"
    Then the HTTP response should contain "SignatureDoesNotMatch"

  # Blocked on parity https://github.com/aws/aws-sdk-js-v3/issues/1001
  # @presigned_post
  # Scenario: POSTing an object with a presigned form
  #   Given I create a presigned form to POST the key "presignedPost" with the data "PRESIGNED POST CONTENTS"
  #   And I POST the form
  #   Then the object "presignedPost" should exist
  #   When I get the object "presignedPost"
  #   Then the object "presignedPost" should contain "PRESIGNED POST CONTENTS"
  #   Then the HTTP response should have a content length of 23

  @proxy
  Scenario: Proxy support
    When I put "world" to the key "proxy_object"
    Then the object "proxy_object" should exist
    Then I get the object "proxy_object"
    And the object "proxy_object" should contain "world"

    When I delete the object "proxy_object"
    Then the object "proxy_object" should not exist

    And I teardown the local proxy server

  @error
  Scenario: Error handling
    Given I put "data" to the key ""
    Then the error code should be "NoKeyProvided"
    And the status code should be 404