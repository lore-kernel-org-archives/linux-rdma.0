From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] DAPL v2.0: scm: change debug message level for listen/bind
 errors
Date: Wed, 2 Nov 2011 21:34:48 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916E93119@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

cmVkdWNlIHRvIENNX1dBUk4gaW5zdGVhZCBvZiBnZW5lcmFsIFdBUk4gbGV2ZWwuDQoNClNpZ25l
ZC1vZmYtYnk6IEFybGluIERhdmlzIDxhcmxpbi5yLmRhdmlzQGludGVsLmNvbT4NCi0tLQ0KIGRh
cGwvb3BlbmliX3NjbS9jbS5jIHwgICAgMiArLQ0KIDEgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRp
b25zKCspLCAxIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZGFwbC9vcGVuaWJfc2NtL2Nt
LmMgYi9kYXBsL29wZW5pYl9zY20vY20uYw0KaW5kZXggYjljYjFiYy4uYjQ1YTRhYiAxMDA2NDQN
Ci0tLSBhL2RhcGwvb3BlbmliX3NjbS9jbS5jDQorKysgYi9kYXBsL29wZW5pYl9zY20vY20uYw0K
QEAgLTk5NCw3ICs5OTQsNyBAQCBkYXBsaV9zb2NrZXRfbGlzdGVuKERBUExfSUEgKiBpYV9wdHIs
IERBVF9DT05OX1FVQUwgc2VydmljZUlELCBEQVBMX1NQICogc3BfcHRyKQ0KIAkJaWYgKGVyciA9
PSBFQUREUklOVVNFKQ0KIAkJCWRhdF9zdGF0dXMgPSBEQVRfQ09OTl9RVUFMX0lOX1VTRTsNCiAJ
CWVsc2Ugew0KLQkJCWRhcGxfbG9nKERBUExfREJHX1RZUEVfV0FSTiwNCisJCQlkYXBsX2xvZyhE
QVBMX0RCR19UWVBFX0NNX1dBUk4sDQogCQkJCSAiIGxpc3RlbjogRVJST1IgMHgleCAlcyBvbiBw
b3J0ICVkXG4iLA0KIAkJCQkgZXJyLCBzdHJlcnJvcihlcnIpLCBzZXJ2aWNlSUQgKyAxMDAwKTsN
CiAJCQlkYXRfc3RhdHVzID0gREFUX0lOVkFMSURfUEFSQU1FVEVSOw0KLS0gDQoxLjcuMw0KDQoN
Cg0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
