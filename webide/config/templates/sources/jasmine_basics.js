#desc - create new 'describe' function, group of tests
describe('$TESTNAME$', function () {
    $END$
});

#it - create new 'it' function, implementation one test
it('$STATE$', function (done) {
    $END$
    done();
});
