From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: librdmacm 1.0.12 release notes for OFED 1.5.2
Date: Tue, 8 Jun 2010 11:58:43 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F5DE5D5@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_CF9C39F99A89134C9CF9C4CCB68B8DDF255F5DE5D5orsmsx501amrc_"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--_002_CF9C39F99A89134C9CF9C4CCB68B8DDF255F5DE5D5orsmsx501amrc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Here is the first cut at release notes -- attached and inline -- for the OF=
ED 1.5.2 release of the librdmacm.

- Sean

---

librdmacm release notes
-----------------------
Several enhancements were added to librdmacm release 1.0.12 that
are intended to simplify using RDMA devices and address scalability issues.
These changes were in response to long standing requests to make
connection establishment 'more like sockets'.  For full details,
users should refer to the appropriate man pages.  Major changes include:


* Support synchronous operation for library calls.  Users can control
  whether an rdma_cm_id operates asynchronously or synchronously based on
  the rdma_event_channel parameter.  Use of synchronous operations
  reduces the amount of application code required to use the librdmacm
  by eliminating the need for event processing code.

  An rdma_cm_id will be marked for synchronous operation if the
  rdma_event_channel parameter is NULL for rdma_create_id or
  rdma_migrate_id.  Users can toggle between synchronous and
  asynchronous operation through the rdma_migrate_id call.

  Calls that operate synchronously include rdma_resolve_addr,
  rdma_resolve_route, rdma_connect, rdma_accept, and rdma_get_request.
  Synchronous event data is returned to the user through the
  rdma_cm_id.


* The addition of a new API: rdma_getaddrinfo.  This call is modeled
  after getaddrinfo, but for RDMA devices and connections.  It has the
  following notable deviations from getaddrinfo:

  A source address is returned as part of the call to allow the
  user to allocate necessary local HW resources for connections.

  Optional routing information may be returned to support
  Infiniband fabrics.  IB routing information includes necessary
  path record data.  rdma_getaddrinfo will obtain this information
  if IB ACM support (see below) is enabled.  The use of IB ACM
  is not required for rdma_getaddrinfo.

  rdma_getaddrinfo provides future extensions to support
  more complex address and route resolution mechanisms, such as
  multiple path support and failover.


* Support for a new APIs: rdma_get_request, rdma_create_ep, and
  rdma_destroy_ep.  rdma_get_request simplifies the passive side
  implementation by adding synchronous support for accepting new
  connections.  rdma_create_ep combines the functionality of
  rdma_create_id, rdma_create_qp, rdma_resolve_addr, and rdma_resolve_route
  in a single API that uses the output of rdma_getaddrinfo as its input.

 =20
* Support for optional parameters.  To simplify support for casual RDMA
  developers and researchers, the librdmacm can allocate protection
  domains, completion queues, and queue pairs on a user's behalf.
  This simplifies the amount of information that a developer
  must learn in order to use RDMA, plus allows the user to take
  advantage of higher-level completion processing abstractions.

  In addition to optional parameters, a user can also specify that the
  librdmacm should automatically select usable values for RDMA read
  operations.


* Add support for IB ACM.  IB ACM (InfiniBand Assistant for Communication
  Management) defines a socket based protocol to an IB address and route
  resolution service.  One implementation of that service is provided
  separately by the ibacm package, but anyone can implement the service
  provided that they adhere to the IB ACM socket protocol.  IB ACM is an
  experimental service targeted at increasing the scalability of applicatio=
ns
  running on a large cluster.
 =20
  Use of IB ACM is not required and is controlled through the build option
  '--with-ib_acm'.  If the librdmacm fails to contact the IB ACM service, i=
t
  reverts to using kernel services to resolve address and routing data.


* Add RDMA helper routines.  The librdmacm provide a set of simpler verbs
  calls for posting work requests, registering memory, and checking for
  completions.  These calls are wrappers around libibverbs routines.




--_002_CF9C39F99A89134C9CF9C4CCB68B8DDF255F5DE5D5orsmsx501amrc_
Content-Type: application/octet-stream; name="rel-notes"
Content-Description: rel-notes
Content-Disposition: attachment; filename="rel-notes"; size=3836;
	creation-date="Tue, 08 Jun 2010 11:46:16 GMT";
	modification-date="Tue, 08 Jun 2010 10:39:23 GMT"
Content-Transfer-Encoding: base64

bGlicmRtYWNtIHJlbGVhc2Ugbm90ZXMKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KClNldmVyYWwg
ZW5oYW5jZW1lbnRzIHdlcmUgYWRkZWQgdG8gbGlicmRtYWNtIHJlbGVhc2UgMS4wLjEyIHRoYXQK
YXJlIGludGVuZGVkIHRvIHNpbXBsaWZ5IHVzaW5nIFJETUEgZGV2aWNlcyBhbmQgYWRkcmVzcyBz
Y2FsYWJpbGl0eSBpc3N1ZXMuClRoZXNlIGNoYW5nZXMgd2VyZSBpbiByZXNwb25zZSB0byBsb25n
IHN0YW5kaW5nIHJlcXVlc3RzIHRvIG1ha2UKY29ubmVjdGlvbiBlc3RhYmxpc2htZW50ICdtb3Jl
IGxpa2Ugc29ja2V0cycuICBGb3IgZnVsbCBkZXRhaWxzLAp1c2VycyBzaG91bGQgcmVmZXIgdG8g
dGhlIGFwcHJvcHJpYXRlIG1hbiBwYWdlcy4gIE1ham9yIGNoYW5nZXMgaW5jbHVkZToKCgoqIFN1
cHBvcnQgc3luY2hyb25vdXMgb3BlcmF0aW9uIGZvciBsaWJyYXJ5IGNhbGxzLiAgVXNlcnMgY2Fu
IGNvbnRyb2wKICB3aGV0aGVyIGFuIHJkbWFfY21faWQgb3BlcmF0ZXMgYXN5bmNocm9ub3VzbHkg
b3Igc3luY2hyb25vdXNseSBiYXNlZCBvbgogIHRoZSByZG1hX2V2ZW50X2NoYW5uZWwgcGFyYW1l
dGVyLiAgVXNlIG9mIHN5bmNocm9ub3VzIG9wZXJhdGlvbnMKICByZWR1Y2VzIHRoZSBhbW91bnQg
b2YgYXBwbGljYXRpb24gY29kZSByZXF1aXJlZCB0byB1c2UgdGhlIGxpYnJkbWFjbQogIGJ5IGVs
aW1pbmF0aW5nIHRoZSBuZWVkIGZvciBldmVudCBwcm9jZXNzaW5nIGNvZGUuCgogIEFuIHJkbWFf
Y21faWQgd2lsbCBiZSBtYXJrZWQgZm9yIHN5bmNocm9ub3VzIG9wZXJhdGlvbiBpZiB0aGUKICBy
ZG1hX2V2ZW50X2NoYW5uZWwgcGFyYW1ldGVyIGlzIE5VTEwgZm9yIHJkbWFfY3JlYXRlX2lkIG9y
CiAgcmRtYV9taWdyYXRlX2lkLiAgVXNlcnMgY2FuIHRvZ2dsZSBiZXR3ZWVuIHN5bmNocm9ub3Vz
IGFuZAogIGFzeW5jaHJvbm91cyBvcGVyYXRpb24gdGhyb3VnaCB0aGUgcmRtYV9taWdyYXRlX2lk
IGNhbGwuCgogIENhbGxzIHRoYXQgb3BlcmF0ZSBzeW5jaHJvbm91c2x5IGluY2x1ZGUgcmRtYV9y
ZXNvbHZlX2FkZHIsCiAgcmRtYV9yZXNvbHZlX3JvdXRlLCByZG1hX2Nvbm5lY3QsIHJkbWFfYWNj
ZXB0LCBhbmQgcmRtYV9nZXRfcmVxdWVzdC4KICBTeW5jaHJvbm91cyBldmVudCBkYXRhIGlzIHJl
dHVybmVkIHRvIHRoZSB1c2VyIHRocm91Z2ggdGhlCiAgcmRtYV9jbV9pZC4KCgoqIFRoZSBhZGRp
dGlvbiBvZiBhIG5ldyBBUEk6IHJkbWFfZ2V0YWRkcmluZm8uICBUaGlzIGNhbGwgaXMgbW9kZWxl
ZAogIGFmdGVyIGdldGFkZHJpbmZvLCBidXQgZm9yIFJETUEgZGV2aWNlcyBhbmQgY29ubmVjdGlv
bnMuICBJdCBoYXMgdGhlCiAgZm9sbG93aW5nIG5vdGFibGUgZGV2aWF0aW9ucyBmcm9tIGdldGFk
ZHJpbmZvOgoKICBBIHNvdXJjZSBhZGRyZXNzIGlzIHJldHVybmVkIGFzIHBhcnQgb2YgdGhlIGNh
bGwgdG8gYWxsb3cgdGhlCiAgdXNlciB0byBhbGxvY2F0ZSBuZWNlc3NhcnkgbG9jYWwgSFcgcmVz
b3VyY2VzIGZvciBjb25uZWN0aW9ucy4KCiAgT3B0aW9uYWwgcm91dGluZyBpbmZvcm1hdGlvbiBt
YXkgYmUgcmV0dXJuZWQgdG8gc3VwcG9ydAogIEluZmluaWJhbmQgZmFicmljcy4gIElCIHJvdXRp
bmcgaW5mb3JtYXRpb24gaW5jbHVkZXMgbmVjZXNzYXJ5CiAgcGF0aCByZWNvcmQgZGF0YS4gIHJk
bWFfZ2V0YWRkcmluZm8gd2lsbCBvYnRhaW4gdGhpcyBpbmZvcm1hdGlvbgogIGlmIElCIEFDTSBz
dXBwb3J0IChzZWUgYmVsb3cpIGlzIGVuYWJsZWQuICBUaGUgdXNlIG9mIElCIEFDTQogIGlzIG5v
dCByZXF1aXJlZCBmb3IgcmRtYV9nZXRhZGRyaW5mby4KCiAgcmRtYV9nZXRhZGRyaW5mbyBwcm92
aWRlcyBmdXR1cmUgZXh0ZW5zaW9ucyB0byBzdXBwb3J0CiAgbW9yZSBjb21wbGV4IGFkZHJlc3Mg
YW5kIHJvdXRlIHJlc29sdXRpb24gbWVjaGFuaXNtcywgc3VjaCBhcwogIG11bHRpcGxlIHBhdGgg
c3VwcG9ydCBhbmQgZmFpbG92ZXIuCgoKKiBTdXBwb3J0IGZvciBhIG5ldyBBUElzOiByZG1hX2dl
dF9yZXF1ZXN0LCByZG1hX2NyZWF0ZV9lcCwgYW5kCiAgcmRtYV9kZXN0cm95X2VwLiAgcmRtYV9n
ZXRfcmVxdWVzdCBzaW1wbGlmaWVzIHRoZSBwYXNzaXZlIHNpZGUKICBpbXBsZW1lbnRhdGlvbiBi
eSBhZGRpbmcgc3luY2hyb25vdXMgc3VwcG9ydCBmb3IgYWNjZXB0aW5nIG5ldwogIGNvbm5lY3Rp
b25zLiAgcmRtYV9jcmVhdGVfZXAgY29tYmluZXMgdGhlIGZ1bmN0aW9uYWxpdHkgb2YKICByZG1h
X2NyZWF0ZV9pZCwgcmRtYV9jcmVhdGVfcXAsIHJkbWFfcmVzb2x2ZV9hZGRyLCBhbmQgcmRtYV9y
ZXNvbHZlX3JvdXRlCiAgaW4gYSBzaW5nbGUgQVBJIHRoYXQgdXNlcyB0aGUgb3V0cHV0IG9mIHJk
bWFfZ2V0YWRkcmluZm8gYXMgaXRzIGlucHV0LgoKICAKKiBTdXBwb3J0IGZvciBvcHRpb25hbCBw
YXJhbWV0ZXJzLiAgVG8gc2ltcGxpZnkgc3VwcG9ydCBmb3IgY2FzdWFsIFJETUEKICBkZXZlbG9w
ZXJzIGFuZCByZXNlYXJjaGVycywgdGhlIGxpYnJkbWFjbSBjYW4gYWxsb2NhdGUgcHJvdGVjdGlv
bgogIGRvbWFpbnMsIGNvbXBsZXRpb24gcXVldWVzLCBhbmQgcXVldWUgcGFpcnMgb24gYSB1c2Vy
J3MgYmVoYWxmLgogIFRoaXMgc2ltcGxpZmllcyB0aGUgYW1vdW50IG9mIGluZm9ybWF0aW9uIHRo
YXQgYSBkZXZlbG9wZXIKICBtdXN0IGxlYXJuIGluIG9yZGVyIHRvIHVzZSBSRE1BLCBwbHVzIGFs
bG93cyB0aGUgdXNlciB0byB0YWtlCiAgYWR2YW50YWdlIG9mIGhpZ2hlci1sZXZlbCBjb21wbGV0
aW9uIHByb2Nlc3NpbmcgYWJzdHJhY3Rpb25zLgoKICBJbiBhZGRpdGlvbiB0byBvcHRpb25hbCBw
YXJhbWV0ZXJzLCBhIHVzZXIgY2FuIGFsc28gc3BlY2lmeSB0aGF0IHRoZQogIGxpYnJkbWFjbSBz
aG91bGQgYXV0b21hdGljYWxseSBzZWxlY3QgdXNhYmxlIHZhbHVlcyBmb3IgUkRNQSByZWFkCiAg
b3BlcmF0aW9ucy4KCgoqIEFkZCBzdXBwb3J0IGZvciBJQiBBQ00uICBJQiBBQ00gKEluZmluaUJh
bmQgQXNzaXN0YW50IGZvciBDb21tdW5pY2F0aW9uCiAgTWFuYWdlbWVudCkgZGVmaW5lcyBhIHNv
Y2tldCBiYXNlZCBwcm90b2NvbCB0byBhbiBJQiBhZGRyZXNzIGFuZCByb3V0ZQogIHJlc29sdXRp
b24gc2VydmljZS4gIE9uZSBpbXBsZW1lbnRhdGlvbiBvZiB0aGF0IHNlcnZpY2UgaXMgcHJvdmlk
ZWQKICBzZXBhcmF0ZWx5IGJ5IHRoZSBpYmFjbSBwYWNrYWdlLCBidXQgYW55b25lIGNhbiBpbXBs
ZW1lbnQgdGhlIHNlcnZpY2UKICBwcm92aWRlZCB0aGF0IHRoZXkgYWRoZXJlIHRvIHRoZSBJQiBB
Q00gc29ja2V0IHByb3RvY29sLiAgSUIgQUNNIGlzIGFuCiAgZXhwZXJpbWVudGFsIHNlcnZpY2Ug
dGFyZ2V0ZWQgYXQgaW5jcmVhc2luZyB0aGUgc2NhbGFiaWxpdHkgb2YgYXBwbGljYXRpb25zCiAg
cnVubmluZyBvbiBhIGxhcmdlIGNsdXN0ZXIuCiAgCiAgVXNlIG9mIElCIEFDTSBpcyBub3QgcmVx
dWlyZWQgYW5kIGlzIGNvbnRyb2xsZWQgdGhyb3VnaCB0aGUgYnVpbGQgb3B0aW9uCiAgJy0td2l0
aC1pYl9hY20nLiAgSWYgdGhlIGxpYnJkbWFjbSBmYWlscyB0byBjb250YWN0IHRoZSBJQiBBQ00g
c2VydmljZSwgaXQKICByZXZlcnRzIHRvIHVzaW5nIGtlcm5lbCBzZXJ2aWNlcyB0byByZXNvbHZl
IGFkZHJlc3MgYW5kIHJvdXRpbmcgZGF0YS4KCgoqIEFkZCBSRE1BIGhlbHBlciByb3V0aW5lcy4g
IFRoZSBsaWJyZG1hY20gcHJvdmlkZSBhIHNldCBvZiBzaW1wbGVyIHZlcmJzCiAgY2FsbHMgZm9y
IHBvc3Rpbmcgd29yayByZXF1ZXN0cywgcmVnaXN0ZXJpbmcgbWVtb3J5LCBhbmQgY2hlY2tpbmcg
Zm9yCiAgY29tcGxldGlvbnMuICBUaGVzZSBjYWxscyBhcmUgd3JhcHBlcnMgYXJvdW5kIGxpYmli
dmVyYnMgcm91dGluZXMuCgo=

--_002_CF9C39F99A89134C9CF9C4CCB68B8DDF255F5DE5D5orsmsx501amrc_--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
