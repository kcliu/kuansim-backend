should = (require \chai).should!
test_conString = (require \./testlib).get_dbcnn!

expect = (require \chai).expect
var pgrest, plx, conString
describe 'pgrest', -> ``it``
  .. 'loaded successfully.', (done) ->
    # Load home page
    conString := test_conString
    pgrest := require \..
    pgrest.should.be.ok
    _plx <- pgrest.new conString, {}
    plx := _plx
    done!
  .. 'test data', (done) ->
    res <- plx.query """
    DROP TABLE IF EXISTS pgrest_test;
    CREATE TABLE pgrest_test (
        field text not null primary key,
        value text[] not null,
        last_update timestamp
    );
    INSERT INTO pgrest_test (field, value, last_update) values('pgrest_version', '{0.0.1}', NOW());
    """
    done!
  .. 'insert objects', (done) ->
    [pgrest_insert:res] <- plx.query """select pgrest_insert($1)""", [collection: \pgrest_test, $: [
      * field: \zz, value: <[z1]>
      * field: \z3, value: <[z2 z3]>
    ] ]
    expect res .to.deep.equal [1,1]
    [pgrest_select:res] <- plx.query """select pgrest_select($1)""", [collection: \pgrest_test]
    expect res.paging.count .to.equal 3
    content = {[field, value] for {field,value} in res.entries}
    expect content.z3 .to.deep.equal <[z2 z3]>
    done!
  .. 'insert array', (done) ->
    [pgrest_insert:res] <- plx.query """select pgrest_insert($1)""", [collection: \pgrest_test, $: [
      <[field value]>
      [\z4, <[val1 val2]>]
      [\z5, <[val3 val5]>]
    ] ]
    expect res .to.deep.equal [1,1]
    [pgrest_select:res] <- plx.query """select pgrest_select($1)""", [collection: \pgrest_test]
    expect res.paging.count .to.equal 5
    done!
