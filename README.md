# RudifaUtilPkg &nbsp; &nbsp;

![XCtests](https://github.com/rudifa/RudifaUtilPkg/workflows/build_and_test/badge.svg)
![XCtests](https://github.com/rudifa/RudifaUtilPkg/workflows/build_jazzy_docs/badge.svg)

[RudifaUtilPkg](https://rudifa.github.io/RudifaUtilPkg/) contains swift extensions and utility methods.


## Highlights

### FileBackedDictionary


 `struct FileBackedDictionary`  encapsulates a `[String:T]` dictionary whose values are automatically persisted, each in its own file.

 `FileBackedDictionary` exposes methods and properties similar to those of the Swift Dictionary.

 At its initialization (typically at the application start), an instance of `FileBackedDictionary` recovers the keys and values from the file storage (if any have been stored in previous application runs).

### Usage examples ###

 Create a `FileBackedDictionary` instance, with a directory named `MyResources` and `struct Resource` as type of the values to store.

```
        let directoryName = "MyResources"
        var fbDict = FileBackedDictionary<Resource>(directoryName: directoryName)
```

 Add `Resource` instances

```
        fbDict["apples"] = Resource(name: "apples", value: 1, quantity: 1)
        fbDict["oranges"] = Resource(name: "oranges", value: 2, quantity: 2)
        fbDict["mangos"] = Resource(name: "mangos", value: 3, quantity: 3)
```

 Look up the resource info

```
        let count = fbDict.count			// 3
        let keys = fbDict.keys			// ["apples", "oranges", "mangos"])
        let values = fbDict.values 		// [...]
        let myOranges = fbDict["oranges"]
```

 Remove resources

```
        fbDict["oranges"] = nil
        fbDict.removeAll()
```



