# $q promise
var deferred = $q.defer();
Resource.query({})
  .$promise
  .then(function (results) {
    if (true) {
      deferred.resolve(results);
    } else {
      deferred.reject('reason');
    }
  });
return deferred.promise;

