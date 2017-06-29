% title = "History of records in the Registration Data Access Protocol"
% abbrev = "History in RDAP"
% category = "std"
% docName = "draft-apnic-historical-rdap"
% ipr = "trust200902"
% area = "Applications"
% workgroup = ""
% keyword = ["RDAP", "history"]
%
% date = 2017-06-28T00:00:00Z
%
% [[author]]
% initials = "B."
% surname = "Ellacott"
% fullname = "Byron Ellacott"
% organization = "APNIC Pty Ltd"
%  [author.address]
%  email = "bje@apnic.net"
% [[author]]
% initials = "T."
% surname = "Harrison"
% fullname = "Tom Harrison"
% organization = "APNIC Pty Ltd"
%  [author.address]
%  email = "tomh@apnic.net"
% [pi]
% toc="yes"
% symrefs="yes"
% sortrefs="yes"
% compact="yes"
% subcompact="no"

.# Abstract

The Registration Data Access Protocol (RDAP) provides current registration
information.  This document describes an RDAP query and response extension that
allows retrieving historical registration records.

{mainmatter}

# Introduction

The Registration Data Access Protocol (RDAP) offers simple search and responses
as defined in [@!RFC7482] and [@!RFC7483] respectively.  Both the search and
response documents implicitly describe current registration information.  This
document provides an extension to RDAP allowing the discovery of historical
registration information.

## Terminology

The keywords **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHALL NOT**,
**SHOULD**, **SHOULD NOT**, **RECOMMENDED**, **MAY**, and **OPTIONAL**, when
they appear in this document, are to be interpreted as described in [@?RFC2119].

# JSON Responses

The JSON responses described in [@!RFC7483] are extended with one additional
object class, the History object class, described below.

## The History Object Class

The history object class represents a container in which individual
registration records will be listed, together comprising a history of
registration.  The registration records are represented in the form given
in [@!RFC7483], without change.

The rdapConformance structure **MUST** include the string "history\_0" to
indicate to clients that this object class conforms to this definition.

The history object class can contain the following members:

  * rdapConformance -- see section 4.1 of [@!RFC7483]
  * objectClassName -- the string "history"
  * notices -- see section 4.3 of [@!RFC7483]
  * records -- an array of record objects, defined in the next subsection

## The Record Data Structure

The record data structure describes one historical registration record.  It is
an object describing the date range during which this record was current, and
the record's content.  The content of a historical record is a JSON response
element as defined in [@!RFC7483].  In this way, history is defined for all
RDAP object classes, and may be extended to apply to non-standard or new RDAP
object classes without requiring a revision to the history specification.

The date range of the historical registration record consists of an element
indicating the first moment at which the contained record was current, in
the "applicableFrom" element, and an element indicating the first moment at
which the contained record was no longer current, in the "applicableUntil"
element.   The date range is half-open, including the "applicableFrom" date
but excluding the "applicableUntil" date.

An example of the record data structure:

```
{
    "applicableFrom": "2008-09-04T06:51:49Z",
    "applicableUntil": "2008-09-04T07:27:55Z",
    "content": {
        "objectClassName": "ip network",
        ...
    }
}
```

All of the records in one history object **SHOULD** contain versions of the same
object.

# RDAP Historical Path Segment Specification

Path segments for querying registration data are defined in [@!RFC7482] for five
resource types (ip, autnum, domain, nameserver, and entity).  In addition to
these segments, this document defines one additional path segment, 'history',
for querying the historical data of any of the five resource types, where
supported by the server.

The history access specified in this document does not support searches.

## IP Network History Path Segment Specification

Syntax: `history/ip/<IP address>` or `history/ip/<CIDR prefix>/<CIDR length>`

Queries for the history of IP networks follow the same form as for the current
registration of IP networks.  However, while the current registration query will
select the "most-specific" or smallest IP network that completely encompasses
the query network, an historical query selects all networks intersecting the
query range.

A server **MAY** choose to limit the number of networks selected by a query, by
limiting the size of sub-networks, or the total number, or some other means.

## Autonomous System History Path Segment Specification

Syntax: `history/autnum/<autonomous system number>`

Queries for the history of an autonomous system number follow the same form as
for the current registration of autonomous system numbers.

## Domain History Path Segment Specification

Syntax: `history/domain/<domain name>`

Queries for the history of a domain registration.  As with [@!RFC7482] the
domain is fully qualified, and **SHOULD NOT** be represented as a mixture of
A-labels and U-labels.

## Nameserver History Path Segment Specification

Syntax: `history/nameserver/<nameserver name>`

Queries for the history of a nameserver.  As with [@!RFC7482] the name is
a fully qualified host name represented in either A-label or U-label format.

## Entity History Path Segment Specification

Syntax: `history/entity/<handle>`

Queries for the history of an entity.  The syntax of the handle is specific to
the registration provider.

# Query Processing

The processing of queries proceeds as in [@!RFC7482] and [@!RFC7480].
Associated records, as documented in section 4.2 of [@!RFC7482], contribute to
the history of a registration record, and so any change to the record or any
of its associated records **SHOULD** be included in the response to a history query.

A server **MAY** choose to limit the responses given to a history query.  For
example, the date range of returned records may be restricted, or the number of
distinct records may be limited.  A server **MAY** choose to abridge history, such
as eliding a short-lived record state.  If a server limites responses in this
way, it **SHOULD** indicate to the user that it has done so, either through the
'help' path segment documented in [@!RFC7482], or in (TODO: history object note).

# Internationalization Considerations

Character encoding considerations are described in section 6.1 of [@!RFC7482].

# IANA Considerations

The IANA is requested to add this document to the IANA RDAP Extensions Registry.

TO BE REMOVED: This registration should take place at
https://www.iana.org/assignments/rdap-extensions/rdap-extensions.xhtml

Extension identifier: history\_0

Registry operator: Asia Pacific Network Information Center

Published specification: TBD

Person & email address to contact for further information: Byron Ellacott
<bje@apnic.net>

Intended usage: This extension allows an RDAP operator to provide historical
registration data.

# Security Considerations

Historical records may contain information which was inadvertently entered into
a record, and subsequently amended.  It may contain information which was
removed by request of the information holder.  Additional privacy constraints
may apply to data held for a long period.  Operators of a history-capable RDAP
service **SHOULD** ensure they have understood the privacy implications of this
facility.

A query for historical records may consume more computing resources than a query
for current records.  Implementations **SHOULD** take care to offer operators the
appropriate means to manage the operational cost of a historical service,
limiting query rates or response sizes or both, where appropriate.

# Acknowledgements

Substantial feedback on the initial draft was provided by Andrew Newton of ARIN.

{backmatter}

# An example History response

<{{example.json}}

In this example, the "POTUS" entity has two historical records.  The applicability range of the first record
is left-closed, indicating that the "POTUS" entity had the first record's contents at noon EST on the 20th of
January, 2009, and right-open, indicating that the "POTUS" entity no longer had the first record's contents at noon
EST on the 20th of Janauary, 2017.  The absence of a gap between the "applicableUntil" date of the first record and
the "applicableFrom" date of the second record indicates that the record was updated, while a gap may indicate that
the record was removed, then a similar record with the same key was subsequently added.  The second record has no
"applicableUntil" element, which indicates that, as of the time that this RDAP History response was prepared, the
second record was still in effect.

This example also suggests that this response elides a number of previous versions of this record.  A registry's
local policy will determine what historical registration information is available, and may vary based on the
identity of the entity retrieving the information.
