From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: ibacm 1.0.0 release notes for OFED 1.5.2
Date: Tue, 8 Jun 2010 13:02:57 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F5DE68A@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_CF9C39F99A89134C9CF9C4CCB68B8DDF255F5DE68Aorsmsx501amrc_"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--_002_CF9C39F99A89134C9CF9C4CCB68B8DDF255F5DE68Aorsmsx501amrc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Here are release notes -- attached and inline -- for IB ACM 1.0.0 for OFED =
1.5.2.

 - Sean
---
Assistant for InfiniBand Communication Management (IB ACM)

Note: The IB ACM should be considered experimental.


Overview
--------
The IB ACM package implements and provides a framework for experimental nam=
e,
address, and route resolution services over InfiniBand.  It is intended to
address connection setup scalability issues running MPI applications on
large clusters.  The IB ACM provides information needed to establish a
connection, but does not implement the CM protocol.

The librdmacm can invoke IB ACM services when built using the --with-ib_acm
option.  The IB ACM services tie in under the rdma_resolve_addr,
rdma_resolve_route, and rdma_getaddrinfo routines.  For maximum benefit,
the rdma_getaddrinfo routine should be used, however existing applications
should still see significant connection scaling benefits using the calls
available in librdmacm 1.0.11 and previous releases.

The IB ACM is focused on being scalable and efficient.  The current
implementation limits network traffic, SA interactions, and centralized
services.  ACM supports multiple resolution protocols in order to handle
different fabric topologies.

This release 1.0.0 is limited in its handling of dynamic changes.

The IB ACM package is comprised of two components: the ib_acm service
and a test/configuration utility - ib_acme.  Both are userspace components
and are available for Linux and Windows.  Additional details are given belo=
w.


Quick Start Guide
-----------------
1. Prerequisites: libibverbs and libibumad must be installed.
   The IB stack should be running with IPoIB configured.
   These steps assume that the user has administrative privileges.
2. Install the IB ACM package
   This installs ib_acm, and ib_acme.
3. Run ib_acme -A -O
   This will generate IB ACM address and options configuration files.
   (acm_addr.cfg and acm_opts.cfg)
4. Run ib_acm and leave running.
   ib_acm will eventually be converted to a service/daemon, but for now
   is a userspace application.  Because ib_acm uses the libibumad
   interfaces, it should be run with administrative privileges.
5. Optionally, run ib_acme -s <source_ip> -d <dest_ip> -v
   This will verify that the ib_acm service is running.
5. Install librdmacm using the build option --with-ib_acm.
   The librdmacm will automatically use the ib_acm service.
   On failures, the librdmacm will fall back to normal resolution.


Details
-------
ib_acme:
The ib_acme program serves a dual role.  It acts as a utility to test
ib_acm operation and help verify if the ib_acm service and selected
protocol is usable for a given cluster configuration.   Additionally,
it automatically generates ib_acm configuration files to assist with
or eliminate manual setup.


acm configuration files:
The ib_acm service relies on two configuration files.

The acm_addr.cfg file contains name and address mappings for each IB
<device, port, pkey> endpoint.  Although the names in the acm_addr.cfg
file can be anything, ib_acme maps the host name and IP addresses to
the IB endpoints.

The acm_opts.cfg file provides a set of configurable options for the
ib_acm service, such as timeout, number of retries, logging level, etc.
ib_acme generates the acm_opts.cfg file using static information.  A
future enhancement would adjust options based on the current system
and cluster size.=20


ib_acm:
The ib_acm service is responsible for resolving names and addresses to
InfiniBand path information and caching such data.  It is currently
implemented as an executable application, but is a conceptual service
or daemon that should execute with administrative privileges.

The ib_acm implements a client interface over TCP sockets, which is
abstracted by the librdmacm library.  One or more back-end protocols are
used by the ib_acm service to satisfy user requests.  Although the
ib_acm supports standard SA path record queries on the back-end, it
provides an experimental multicast resolution protocol in hope of
achieving greater scalability.  The latter is not usable on all fabric
topologies, specifically ones that may not have reversible paths.
Users should use the ib_acme utility to verify that multicast protocol
is usable before running other applications.

Conceptually, the ib_acm service implements an ARP like protocol and either
uses IB multicast records to construct path record data or queries the
SA directly, depending on the selected route protocol.  By default, the
ib_acm services uses and caches SA path record queries.

Specifically, all IB endpoints join a number of multicast groups.
Multicast groups differ based on rates, mtu, sl, etc., and are prioritized.
All participating endpoints must be able to communicate on the lowest
priority multicast group.  The ib_acm assigns one or more names/addresses
to each IB endpoint using the acm_addr.cfg file.  Clients provide source
and destination names or addresses as input to the service, and receive
as output path record data.

The service maps a client's source name/address to a local IB endpoint.
If a client does not provide a source address, then the ib_acm service
will select one based on the destination and local routing tables.  If the
destination name/address is not cached locally, it sends a multicast
request out on the lowest priority multicast group on the local endpoint.
The request carries a list of multicast groups that the sender can use.
The recipient of the request selects the highest priority multicast group
that it can use as well and returns that information directly to the sender=
.
The request data is cached by all endpoints that receive the multicast
request message.  The source endpoint also caches the response and uses
the multicast group that was selected to construct or obtain path record
data, which is returned to the client.

The current implementation of the IB ACM has several additional restriction=
s:
- The ib_acm is limited in its handling of dynamic changes;
  the ib_acm must be stopped and restarted if a cluster is reconfigured.
- Cached data does not timed out and is only updated if a new resolution
  request is received from a different QPN than a cached request.
- Support for IPv6 has not been verified.
- The number of addresses that can be assigned to a single endpoint is
  limited to 4.
- The number of multicast groups that an endpoint can support is limited to=
 2.



--_002_CF9C39F99A89134C9CF9C4CCB68B8DDF255F5DE68Aorsmsx501amrc_
Content-Type: text/plain; name="acm_notes.txt"
Content-Description: acm_notes.txt
Content-Disposition: attachment; filename="acm_notes.txt"; size=6463;
	creation-date="Tue, 08 Jun 2010 12:59:58 GMT";
	modification-date="Tue, 08 Jun 2010 11:55:21 GMT"
Content-Transfer-Encoding: base64

QXNzaXN0YW50IGZvciBJbmZpbmlCYW5kIENvbW11bmljYXRpb24gTWFuYWdlbWVudCAoSUIgQUNN
KQ0KDQpOb3RlOiBUaGUgSUIgQUNNIHNob3VsZCBiZSBjb25zaWRlcmVkIGV4cGVyaW1lbnRhbC4N
Cg0KDQpPdmVydmlldw0KLS0tLS0tLS0NClRoZSBJQiBBQ00gcGFja2FnZSBpbXBsZW1lbnRzIGFu
ZCBwcm92aWRlcyBhIGZyYW1ld29yayBmb3IgZXhwZXJpbWVudGFsIG5hbWUsDQphZGRyZXNzLCBh
bmQgcm91dGUgcmVzb2x1dGlvbiBzZXJ2aWNlcyBvdmVyIEluZmluaUJhbmQuICBJdCBpcyBpbnRl
bmRlZCB0bw0KYWRkcmVzcyBjb25uZWN0aW9uIHNldHVwIHNjYWxhYmlsaXR5IGlzc3VlcyBydW5u
aW5nIE1QSSBhcHBsaWNhdGlvbnMgb24NCmxhcmdlIGNsdXN0ZXJzLiAgVGhlIElCIEFDTSBwcm92
aWRlcyBpbmZvcm1hdGlvbiBuZWVkZWQgdG8gZXN0YWJsaXNoIGENCmNvbm5lY3Rpb24sIGJ1dCBk
b2VzIG5vdCBpbXBsZW1lbnQgdGhlIENNIHByb3RvY29sLg0KDQpUaGUgbGlicmRtYWNtIGNhbiBp
bnZva2UgSUIgQUNNIHNlcnZpY2VzIHdoZW4gYnVpbHQgdXNpbmcgdGhlIC0td2l0aC1pYl9hY20N
Cm9wdGlvbi4gIFRoZSBJQiBBQ00gc2VydmljZXMgdGllIGluIHVuZGVyIHRoZSByZG1hX3Jlc29s
dmVfYWRkciwNCnJkbWFfcmVzb2x2ZV9yb3V0ZSwgYW5kIHJkbWFfZ2V0YWRkcmluZm8gcm91dGlu
ZXMuICBGb3IgbWF4aW11bSBiZW5lZml0LA0KdGhlIHJkbWFfZ2V0YWRkcmluZm8gcm91dGluZSBz
aG91bGQgYmUgdXNlZCwgaG93ZXZlciBleGlzdGluZyBhcHBsaWNhdGlvbnMNCnNob3VsZCBzdGls
bCBzZWUgc2lnbmlmaWNhbnQgY29ubmVjdGlvbiBzY2FsaW5nIGJlbmVmaXRzIHVzaW5nIHRoZSBj
YWxscw0KYXZhaWxhYmxlIGluIGxpYnJkbWFjbSAxLjAuMTEgYW5kIHByZXZpb3VzIHJlbGVhc2Vz
Lg0KDQpUaGUgSUIgQUNNIGlzIGZvY3VzZWQgb24gYmVpbmcgc2NhbGFibGUgYW5kIGVmZmljaWVu
dC4gIFRoZSBjdXJyZW50DQppbXBsZW1lbnRhdGlvbiBsaW1pdHMgbmV0d29yayB0cmFmZmljLCBT
QSBpbnRlcmFjdGlvbnMsIGFuZCBjZW50cmFsaXplZA0Kc2VydmljZXMuICBBQ00gc3VwcG9ydHMg
bXVsdGlwbGUgcmVzb2x1dGlvbiBwcm90b2NvbHMgaW4gb3JkZXIgdG8gaGFuZGxlDQpkaWZmZXJl
bnQgZmFicmljIHRvcG9sb2dpZXMuDQoNClRoaXMgcmVsZWFzZSAxLjAuMCBpcyBsaW1pdGVkIGlu
IGl0cyBoYW5kbGluZyBvZiBkeW5hbWljIGNoYW5nZXMuDQoNClRoZSBJQiBBQ00gcGFja2FnZSBp
cyBjb21wcmlzZWQgb2YgdHdvIGNvbXBvbmVudHM6IHRoZSBpYl9hY20gc2VydmljZQ0KYW5kIGEg
dGVzdC9jb25maWd1cmF0aW9uIHV0aWxpdHkgLSBpYl9hY21lLiAgQm90aCBhcmUgdXNlcnNwYWNl
IGNvbXBvbmVudHMNCmFuZCBhcmUgYXZhaWxhYmxlIGZvciBMaW51eCBhbmQgV2luZG93cy4gIEFk
ZGl0aW9uYWwgZGV0YWlscyBhcmUgZ2l2ZW4gYmVsb3cuDQoNCg0KUXVpY2sgU3RhcnQgR3VpZGUN
Ci0tLS0tLS0tLS0tLS0tLS0tDQoxLiBQcmVyZXF1aXNpdGVzOiBsaWJpYnZlcmJzIGFuZCBsaWJp
YnVtYWQgbXVzdCBiZSBpbnN0YWxsZWQuDQogICBUaGUgSUIgc3RhY2sgc2hvdWxkIGJlIHJ1bm5p
bmcgd2l0aCBJUG9JQiBjb25maWd1cmVkLg0KICAgVGhlc2Ugc3RlcHMgYXNzdW1lIHRoYXQgdGhl
IHVzZXIgaGFzIGFkbWluaXN0cmF0aXZlIHByaXZpbGVnZXMuDQoyLiBJbnN0YWxsIHRoZSBJQiBB
Q00gcGFja2FnZQ0KICAgVGhpcyBpbnN0YWxscyBpYl9hY20sIGFuZCBpYl9hY21lLg0KMy4gUnVu
IGliX2FjbWUgLUEgLU8NCiAgIFRoaXMgd2lsbCBnZW5lcmF0ZSBJQiBBQ00gYWRkcmVzcyBhbmQg
b3B0aW9ucyBjb25maWd1cmF0aW9uIGZpbGVzLg0KICAgKGFjbV9hZGRyLmNmZyBhbmQgYWNtX29w
dHMuY2ZnKQ0KNC4gUnVuIGliX2FjbSBhbmQgbGVhdmUgcnVubmluZy4NCiAgIGliX2FjbSB3aWxs
IGV2ZW50dWFsbHkgYmUgY29udmVydGVkIHRvIGEgc2VydmljZS9kYWVtb24sIGJ1dCBmb3Igbm93
DQogICBpcyBhIHVzZXJzcGFjZSBhcHBsaWNhdGlvbi4gIEJlY2F1c2UgaWJfYWNtIHVzZXMgdGhl
IGxpYmlidW1hZA0KICAgaW50ZXJmYWNlcywgaXQgc2hvdWxkIGJlIHJ1biB3aXRoIGFkbWluaXN0
cmF0aXZlIHByaXZpbGVnZXMuDQo1LiBPcHRpb25hbGx5LCBydW4gaWJfYWNtZSAtcyA8c291cmNl
X2lwPiAtZCA8ZGVzdF9pcD4gLXYNCiAgIFRoaXMgd2lsbCB2ZXJpZnkgdGhhdCB0aGUgaWJfYWNt
IHNlcnZpY2UgaXMgcnVubmluZy4NCjUuIEluc3RhbGwgbGlicmRtYWNtIHVzaW5nIHRoZSBidWls
ZCBvcHRpb24gLS13aXRoLWliX2FjbS4NCiAgIFRoZSBsaWJyZG1hY20gd2lsbCBhdXRvbWF0aWNh
bGx5IHVzZSB0aGUgaWJfYWNtIHNlcnZpY2UuDQogICBPbiBmYWlsdXJlcywgdGhlIGxpYnJkbWFj
bSB3aWxsIGZhbGwgYmFjayB0byBub3JtYWwgcmVzb2x1dGlvbi4NCg0KDQpEZXRhaWxzDQotLS0t
LS0tDQppYl9hY21lOg0KVGhlIGliX2FjbWUgcHJvZ3JhbSBzZXJ2ZXMgYSBkdWFsIHJvbGUuICBJ
dCBhY3RzIGFzIGEgdXRpbGl0eSB0byB0ZXN0DQppYl9hY20gb3BlcmF0aW9uIGFuZCBoZWxwIHZl
cmlmeSBpZiB0aGUgaWJfYWNtIHNlcnZpY2UgYW5kIHNlbGVjdGVkDQpwcm90b2NvbCBpcyB1c2Fi
bGUgZm9yIGEgZ2l2ZW4gY2x1c3RlciBjb25maWd1cmF0aW9uLiAgIEFkZGl0aW9uYWxseSwNCml0
IGF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVzIGliX2FjbSBjb25maWd1cmF0aW9uIGZpbGVzIHRvIGFz
c2lzdCB3aXRoDQpvciBlbGltaW5hdGUgbWFudWFsIHNldHVwLg0KDQoNCmFjbSBjb25maWd1cmF0
aW9uIGZpbGVzOg0KVGhlIGliX2FjbSBzZXJ2aWNlIHJlbGllcyBvbiB0d28gY29uZmlndXJhdGlv
biBmaWxlcy4NCg0KVGhlIGFjbV9hZGRyLmNmZyBmaWxlIGNvbnRhaW5zIG5hbWUgYW5kIGFkZHJl
c3MgbWFwcGluZ3MgZm9yIGVhY2ggSUINCjxkZXZpY2UsIHBvcnQsIHBrZXk+IGVuZHBvaW50LiAg
QWx0aG91Z2ggdGhlIG5hbWVzIGluIHRoZSBhY21fYWRkci5jZmcNCmZpbGUgY2FuIGJlIGFueXRo
aW5nLCBpYl9hY21lIG1hcHMgdGhlIGhvc3QgbmFtZSBhbmQgSVAgYWRkcmVzc2VzIHRvDQp0aGUg
SUIgZW5kcG9pbnRzLg0KDQpUaGUgYWNtX29wdHMuY2ZnIGZpbGUgcHJvdmlkZXMgYSBzZXQgb2Yg
Y29uZmlndXJhYmxlIG9wdGlvbnMgZm9yIHRoZQ0KaWJfYWNtIHNlcnZpY2UsIHN1Y2ggYXMgdGlt
ZW91dCwgbnVtYmVyIG9mIHJldHJpZXMsIGxvZ2dpbmcgbGV2ZWwsIGV0Yy4NCmliX2FjbWUgZ2Vu
ZXJhdGVzIHRoZSBhY21fb3B0cy5jZmcgZmlsZSB1c2luZyBzdGF0aWMgaW5mb3JtYXRpb24uICBB
DQpmdXR1cmUgZW5oYW5jZW1lbnQgd291bGQgYWRqdXN0IG9wdGlvbnMgYmFzZWQgb24gdGhlIGN1
cnJlbnQgc3lzdGVtDQphbmQgY2x1c3RlciBzaXplLiANCg0KDQppYl9hY206DQpUaGUgaWJfYWNt
IHNlcnZpY2UgaXMgcmVzcG9uc2libGUgZm9yIHJlc29sdmluZyBuYW1lcyBhbmQgYWRkcmVzc2Vz
IHRvDQpJbmZpbmlCYW5kIHBhdGggaW5mb3JtYXRpb24gYW5kIGNhY2hpbmcgc3VjaCBkYXRhLiAg
SXQgaXMgY3VycmVudGx5DQppbXBsZW1lbnRlZCBhcyBhbiBleGVjdXRhYmxlIGFwcGxpY2F0aW9u
LCBidXQgaXMgYSBjb25jZXB0dWFsIHNlcnZpY2UNCm9yIGRhZW1vbiB0aGF0IHNob3VsZCBleGVj
dXRlIHdpdGggYWRtaW5pc3RyYXRpdmUgcHJpdmlsZWdlcy4NCg0KVGhlIGliX2FjbSBpbXBsZW1l
bnRzIGEgY2xpZW50IGludGVyZmFjZSBvdmVyIFRDUCBzb2NrZXRzLCB3aGljaCBpcw0KYWJzdHJh
Y3RlZCBieSB0aGUgbGlicmRtYWNtIGxpYnJhcnkuICBPbmUgb3IgbW9yZSBiYWNrLWVuZCBwcm90
b2NvbHMgYXJlDQp1c2VkIGJ5IHRoZSBpYl9hY20gc2VydmljZSB0byBzYXRpc2Z5IHVzZXIgcmVx
dWVzdHMuICBBbHRob3VnaCB0aGUNCmliX2FjbSBzdXBwb3J0cyBzdGFuZGFyZCBTQSBwYXRoIHJl
Y29yZCBxdWVyaWVzIG9uIHRoZSBiYWNrLWVuZCwgaXQNCnByb3ZpZGVzIGFuIGV4cGVyaW1lbnRh
bCBtdWx0aWNhc3QgcmVzb2x1dGlvbiBwcm90b2NvbCBpbiBob3BlIG9mDQphY2hpZXZpbmcgZ3Jl
YXRlciBzY2FsYWJpbGl0eS4gIFRoZSBsYXR0ZXIgaXMgbm90IHVzYWJsZSBvbiBhbGwgZmFicmlj
DQp0b3BvbG9naWVzLCBzcGVjaWZpY2FsbHkgb25lcyB0aGF0IG1heSBub3QgaGF2ZSByZXZlcnNp
YmxlIHBhdGhzLg0KVXNlcnMgc2hvdWxkIHVzZSB0aGUgaWJfYWNtZSB1dGlsdHkgdG8gdmVyaWZ5
IHRoYXQgbXVsdGljYXN0IHByb3RvY29sDQppcyB1c2FibGUgYmVmb3JlIHJ1bm5pbmcgb3RoZXIg
YXBwbGljYXRpb25zLg0KDQpDb25jZXB0dWFsbHksIHRoZSBpYl9hY20gc2VydmljZSBpbXBsZW1l
bnRzIGFuIEFSUCBsaWtlIHByb3RvY29sIGFuZCBlaXRoZXINCnVzZXMgSUIgbXVsdGljYXN0IHJl
Y29yZHMgdG8gY29uc3RydWN0IHBhdGggcmVjb3JkIGRhdGEgb3IgcXVlcmllcyB0aGUNClNBIGRp
cmVjdGx5LCBkZXBlbmRpbmcgb24gdGhlIHNlbGVjdGVkIHJvdXRlIHByb3RvY29sLiAgQnkgZGVm
YXVsdCwgdGhlDQppYl9hY20gc2VydmljZXMgdXNlcyBhbmQgY2FjaGVzIFNBIHBhdGggcmVjb3Jk
IHF1ZXJpZXMuDQoNClNwZWNpZmljYWxseSwgYWxsIElCIGVuZHBvaW50cyBqb2luIGEgbnVtYmVy
IG9mIG11bHRpY2FzdCBncm91cHMuDQpNdWx0aWNhc3QgZ3JvdXBzIGRpZmZlciBiYXNlZCBvbiBy
YXRlcywgbXR1LCBzbCwgZXRjLiwgYW5kIGFyZSBwcmlvcml0aXplZC4NCkFsbCBwYXJ0aWNpcGF0
aW5nIGVuZHBvaW50cyBtdXN0IGJlIGFibGUgdG8gY29tbXVuaWNhdGUgb24gdGhlIGxvd2VzdA0K
cHJpb3JpdHkgbXVsdGljYXN0IGdyb3VwLiAgVGhlIGliX2FjbSBhc3NpZ25zIG9uZSBvciBtb3Jl
IG5hbWVzL2FkZHJlc3Nlcw0KdG8gZWFjaCBJQiBlbmRwb2ludCB1c2luZyB0aGUgYWNtX2FkZHIu
Y2ZnIGZpbGUuICBDbGllbnRzIHByb3ZpZGUgc291cmNlDQphbmQgZGVzdGluYXRpb24gbmFtZXMg
b3IgYWRkcmVzc2VzIGFzIGlucHV0IHRvIHRoZSBzZXJ2aWNlLCBhbmQgcmVjZWl2ZQ0KYXMgb3V0
cHV0IHBhdGggcmVjb3JkIGRhdGEuDQoNClRoZSBzZXJ2aWNlIG1hcHMgYSBjbGllbnQncyBzb3Vy
Y2UgbmFtZS9hZGRyZXNzIHRvIGEgbG9jYWwgSUIgZW5kcG9pbnQuDQpJZiBhIGNsaWVudCBkb2Vz
IG5vdCBwcm92aWRlIGEgc291cmNlIGFkZHJlc3MsIHRoZW4gdGhlIGliX2FjbSBzZXJ2aWNlDQp3
aWxsIHNlbGVjdCBvbmUgYmFzZWQgb24gdGhlIGRlc3RpbmF0aW9uIGFuZCBsb2NhbCByb3V0aW5n
IHRhYmxlcy4gIElmIHRoZQ0KZGVzdGluYXRpb24gbmFtZS9hZGRyZXNzIGlzIG5vdCBjYWNoZWQg
bG9jYWxseSwgaXQgc2VuZHMgYSBtdWx0aWNhc3QNCnJlcXVlc3Qgb3V0IG9uIHRoZSBsb3dlc3Qg
cHJpb3JpdHkgbXVsdGljYXN0IGdyb3VwIG9uIHRoZSBsb2NhbCBlbmRwb2ludC4NClRoZSByZXF1
ZXN0IGNhcnJpZXMgYSBsaXN0IG9mIG11bHRpY2FzdCBncm91cHMgdGhhdCB0aGUgc2VuZGVyIGNh
biB1c2UuDQpUaGUgcmVjaXBpZW50IG9mIHRoZSByZXF1ZXN0IHNlbGVjdHMgdGhlIGhpZ2hlc3Qg
cHJpb3JpdHkgbXVsdGljYXN0IGdyb3VwDQp0aGF0IGl0IGNhbiB1c2UgYXMgd2VsbCBhbmQgcmV0
dXJucyB0aGF0IGluZm9ybWF0aW9uIGRpcmVjdGx5IHRvIHRoZSBzZW5kZXIuDQpUaGUgcmVxdWVz
dCBkYXRhIGlzIGNhY2hlZCBieSBhbGwgZW5kcG9pbnRzIHRoYXQgcmVjZWl2ZSB0aGUgbXVsdGlj
YXN0DQpyZXF1ZXN0IG1lc3NhZ2UuICBUaGUgc291cmNlIGVuZHBvaW50IGFsc28gY2FjaGVzIHRo
ZSByZXNwb25zZSBhbmQgdXNlcw0KdGhlIG11bHRpY2FzdCBncm91cCB0aGF0IHdhcyBzZWxlY3Rl
ZCB0byBjb25zdHJ1Y3Qgb3Igb2J0YWluIHBhdGggcmVjb3JkDQpkYXRhLCB3aGljaCBpcyByZXR1
cm5lZCB0byB0aGUgY2xpZW50Lg0KDQpUaGUgY3VycmVudCBpbXBsZW1lbnRhdGlvbiBvZiB0aGUg
SUIgQUNNIGhhcyBzZXZlcmFsIGFkZGl0aW9uYWwgcmVzdHJpY3Rpb25zOg0KLSBUaGUgaWJfYWNt
IGlzIGxpbWl0ZWQgaW4gaXRzIGhhbmRsaW5nIG9mIGR5bmFtaWMgY2hhbmdlczsNCiAgdGhlIGli
X2FjbSBtdXN0IGJlIHN0b3BwZWQgYW5kIHJlc3RhcnRlZCBpZiBhIGNsdXN0ZXIgaXMgcmVjb25m
aWd1cmVkLg0KLSBDYWNoZWQgZGF0YSBkb2VzIG5vdCB0aW1lZCBvdXQgYW5kIGlzIG9ubHkgdXBk
YXRlZCBpZiBhIG5ldyByZXNvbHV0aW9uDQogIHJlcXVlc3QgaXMgcmVjZWl2ZWQgZnJvbSBhIGRp
ZmZlcmVudCBRUE4gdGhhbiBhIGNhY2hlZCByZXF1ZXN0Lg0KLSBTdXBwb3J0IGZvciBJUHY2IGhh
cyBub3QgYmVlbiB2ZXJpZmllZC4NCi0gVGhlIG51bWJlciBvZiBhZGRyZXNzZXMgdGhhdCBjYW4g
YmUgYXNzaWduZWQgdG8gYSBzaW5nbGUgZW5kcG9pbnQgaXMNCiAgbGltaXRlZCB0byA0Lg0KLSBU
aGUgbnVtYmVyIG9mIG11bHRpY2FzdCBncm91cHMgdGhhdCBhbiBlbmRwb2ludCBjYW4gc3VwcG9y
dCBpcyBsaW1pdGVkIHRvIDIuDQoNCg==

--_002_CF9C39F99A89134C9CF9C4CCB68B8DDF255F5DE68Aorsmsx501amrc_--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
