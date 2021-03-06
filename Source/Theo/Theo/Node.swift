//
//  Node.swift
//  Theo
//
//  Created by Cory D. Wiles on 9/19/14.
//  Copyright (c) 2014 Theo. All rights reserved.
//

import Foundation

let TheoNodeExtensions:                 String = "extensions"
let TheoNodePagedTraverse:              String = "paged_traverse"
let TheoNodeLabels:                     String = "labels"
let TheoNodeOutGoingRelationships:      String = "outgoing_relationships"
let TheoNodeTraverse:                   String = "traverse"
let TheoNodeAllTypedRelationships:      String = "all_typed_relationships"
let TheoNodeProperty:                   String = "property"
let TheoNodeAllRelationships:           String = "all_relationships"
let TheoNodeSelf:                       String = "self"
let TheoNodeOutGoingTypedRelationships: String = "outgoing_typed_relationships"
let TheoNodeProperties:                 String = "properties"
let TheoNodeIncomingRelationships:      String = "incoming_relationships"
let TheoNodeIncomingTypedRelationships: String = "incoming_typed_relationships"
let TheoNodeCreateRelationship:         String = "create_relationship"
let TheoNodeData:                       String = "data"
let TheoNodeMetaData:                   String = "metadata"

open struct NodeMeta: CustomStringConvertible {
    
    let extensions:                   [String: AnyObject]
    let page_traverse:                String
    let labels:                       String
    let outgoing_relationships:       String
    let traverse:                     String
    let all_typed_relationships:      String
    let property:                     String
    let all_relationships:            String
    let node_self:                    String
    let outgoing_typed_relationships: String
    let properties:                   String
    let incoming_relationships:       String
    let incoming_typed_relationships: String
    let create_relationship:          String
    let data:                         [String: AnyObject]
    let metadata:                     [String: AnyObject]

    open func nodeID() -> String {

        let pathComponents: Array<String> = self.node_self.components(separatedBy: "/")

        return pathComponents.last!
    }
    
    open init(dictionary: Dictionary<String, AnyObject>!) {
        
        self.extensions                     = dictionary[TheoNodeExtensions]                    as! Dictionary
        self.page_traverse                  = dictionary[TheoNodePagedTraverse]                 as! String
        self.labels                         = dictionary[TheoNodeLabels]                        as! String
        self.outgoing_relationships         = dictionary[TheoNodeOutGoingRelationships]         as! String
        self.traverse                       = dictionary[TheoNodeTraverse]                      as! String
        self.all_relationships              = dictionary[TheoNodeAllRelationships]              as! String
        self.all_typed_relationships        = dictionary[TheoNodeAllTypedRelationships]         as! String
        self.property                       = dictionary[TheoNodeProperty]                      as! String
        self.node_self                      = dictionary[TheoNodeSelf]                          as! String
        self.outgoing_typed_relationships   = dictionary[TheoNodeOutGoingTypedRelationships]    as! String
        self.properties                     = dictionary[TheoNodeProperties]                    as! String
        self.incoming_relationships         = dictionary[TheoNodeIncomingRelationships]         as! String
        self.incoming_typed_relationships   = dictionary[TheoNodeIncomingTypedRelationships]    as! String
        self.create_relationship            = dictionary[TheoNodeCreateRelationship]            as! String
        self.data                           = dictionary[TheoNodeData]                          as! Dictionary
        self.metadata                       = dictionary[TheoNodeMetaData]                      as! Dictionary
    }
    
    open var description: String {
        return "Extensions: \(self.extensions), page_traverse \(self.page_traverse), labels \(self.labels), outgoing_relationships \(self.outgoing_relationships), traverse \(self.traverse), all_typed_relationships \(self.all_typed_relationships), all_typed_relationships \(self.all_typed_relationships), property \(self.property), all_relationships \(self.all_relationships), self \(self.node_self), outgoing_typed_relationships \(self.outgoing_typed_relationships), properties \(self.properties), incoming_relationships \(self.incoming_relationships), incoming_typed_relationships \(self.incoming_typed_relationships), create_relationship \(self.create_relationship), data \(self.data), metadata \(self.metadata), nodeID \(self.nodeID())"
    }
}

open class Node {

    // MARK: Private Setters and open Getters

    fileprivate (set) var nodeData: [String:AnyObject] = [String:AnyObject]()
    fileprivate (set) var labels: [String] = [String]()

    // MARK: open Properties
    
    open var meta: NodeMeta? = nil {

        didSet {
        
            if let metaForNode = self.meta {
                self.nodeData = metaForNode.data
            }
        }
    }
    
    // MARK: Constructors
    
    /// Designated Initializer
    ///
    /// - parameter Dictionary<String,AnyObject>?: data
    /// - returns: Node
    open required init(data: Dictionary<String,AnyObject>?) {
        
        if let dictionaryData: [String:AnyObject] = data {

            self.meta = NodeMeta(dictionary: dictionaryData)
            
            if let metaForNode = self.meta {
                self.nodeData = metaForNode.data
            }
        }
    }
    
    /// Convenience initializer
    ///
    /// calls init(data:) with the param value as nil
    ///
    /// - returns: Node
    open convenience init() {
        self.init(data: nil)
    }
    
    /// Gets a specified property for the Node
    ///
    /// - parameter String: propertyName
    /// - returns: AnyObject?
    open func getProp(_ propertyName: String) -> AnyObject? {

        if let object: AnyObject = self.nodeData[propertyName] {
            return object
        }
        
        return nil
    }
    
    /// Sets the property for the relationship
    ///
    /// - parameter String: propertyName
    /// - parameter String: propertyValue
    /// - returns: Void
    open func setProp(_ propertyName: String, propertyValue: AnyObject) -> Void {
        
        let objectValue: AnyObject = propertyValue
        
        self.nodeData[propertyName] = objectValue
    }
    
    /// Adds label to array of labels for the node
    ///
    /// - parameter String: label
    /// - returns: Void
    open func addLabel(_ label: String) -> Void {
        self.labels.append(label)
    }
    
    /// Adds labels to existing array of labels for the node
    ///
    /// - parameter Array<String>: labels
    /// - returns: Void
    open func addLabels(_ labels: Array<String>) -> Void {

        let newLabels = Array([self.labels, labels].joined())
        self.labels = newLabels
    }
    
    /// Returns whether or not the nodeData is empty
    ///
    /// This is done by checking for empty keys array
    ///
    /// - returns: Bool
    open func isEmpty() -> Bool {
        return self.nodeData.keys.isEmpty
    }

    /// Returns whether the current node has labels
    ///
    /// - returns: Bool
    open func hasLabels() -> Bool {
        return self.labels.isEmpty
    }
}

// MARK: - Printable

extension Node: CustomStringConvertible {
    
    open var description: String {
        
        var returnString: String = ""
            
        for (key, value) in self.nodeData {
            returnString += "\(key): \(value) "
        }
        
        if let meta: NodeMeta = self.meta {
            returnString += meta.description
        }
            
        return returnString
    }
}


