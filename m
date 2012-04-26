From: "Troy Leedberg" <troy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: ibstat does not recognize iWARP RNIC adapters
Date: Wed, 25 Apr 2012 17:38:36 -0700
Message-ID: <8A71B368A89016469F72CD08050AD3340B8AAE7F@maui.asicdesigners.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01CD2344.EB210B9F"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01CD2344.EB210B9F
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

I noticed that doing ibstat, none of the iWARP RNIC adapters were =
showing up.=A0 I have attached a patch to address the issue =
(libibumad.patch).

SYS_NODE_TYPE for iWARP RNIC is 4 and is_ib_type only checked to 3.


Before patch is applied:

[root@t4-2 SOURCES]# ibstat
[root@t4-2 SOURCES]#


After patch is applied:

[root@t4-2 libibumad-1.3.7]# ibstat
iWARP RNIC 'cxgb4_0'
=A0=A0=A0=A0=A0=A0=A0 iWARP RNIC type: cxgb4
=A0=A0=A0=A0=A0=A0=A0 Number of ports: 2
=A0=A0=A0=A0=A0=A0=A0 Firmware version: 1.4.23.0
=A0=A0=A0=A0=A0=A0=A0 Hardware version: 2
=A0=A0=A0=A0=A0=A0=A0 Node GUID: 0x000743101d000000
=A0=A0=A0=A0=A0=A0=A0 System image GUID: 0x000743101d000000
=A0=A0=A0=A0=A0=A0=A0 Port 1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 State: Active
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Physical state: No state =
change
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Rate: 20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Base lid: 0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 LMC: 0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 SM lid: 0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Capability mask: =
0x009f0000
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Port GUID: =
0x0000000000000000
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Link layer: Ethernet
=A0=A0=A0=A0=A0=A0=A0 Port 2:
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 State: Down
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Physical state: No state =
change
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0Rate: 20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Base lid: 0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 LMC: 0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 SM lid: 0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Capability mask: =
0x009f0000
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Port GUID: =
0x0000000000000000
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Link layer: Ethernet
[root@t4-2 libibumad-1.3.7]#


------_=_NextPart_001_01CD2344.EB210B9F
Content-Type: application/octet-stream;
	name="libibumad.patch"
Content-Transfer-Encoding: base64
Content-Description: libibumad.patch
Content-Disposition: attachment;
	filename="libibumad.patch"

ZGlmZiAtY3JCIGxpYmlidW1hZC0xLjMuNy5vcmlnL3NyYy91bWFkLmMgbGliaWJ1bWFkLTEuMy43
LmZpeC9zcmMvdW1hZC5jCioqKiBsaWJpYnVtYWQtMS4zLjcub3JpZy9zcmMvdW1hZC5jCTIwMTEt
MDItMTQgMDQ6MDg6MjkuMDAwMDAwMDAwIC0wNTAwCi0tLSBsaWJpYnVtYWQtMS4zLjcuZml4L3Ny
Yy91bWFkLmMJMjAxMi0wNC0yNSAxNDo1MzoyNi4wMDAwMDAwMDAgLTA0MDAKKioqKioqKioqKioq
KioqCioqKiA1MTcsNTIzICoqKioKICAJaWYgKHN5c19yZWFkX3VpbnQoZGlyX25hbWUsIFNZU19O
T0RFX1RZUEUsICZ0eXBlKSA8IDApCiAgCQlyZXR1cm4gMDsKICAKISAJcmV0dXJuIHR5cGUgPj0g
MSAmJiB0eXBlIDw9IDMgPyAxIDogMDsKICB9CiAgCiAgaW50IHVtYWRfZ2V0X2Nhc19uYW1lcyhj
aGFyIGNhc1tdW1VNQURfQ0FfTkFNRV9MRU5dLCBpbnQgbWF4KQotLS0gNTE3LDUyMyAtLS0tCiAg
CWlmIChzeXNfcmVhZF91aW50KGRpcl9uYW1lLCBTWVNfTk9ERV9UWVBFLCAmdHlwZSkgPCAwKQog
IAkJcmV0dXJuIDA7CiAgCiEgCXJldHVybiB0eXBlID49IDEgJiYgdHlwZSA8PSA0ID8gMSA6IDA7
CiAgfQogIAogIGludCB1bWFkX2dldF9jYXNfbmFtZXMoY2hhciBjYXNbXVtVTUFEX0NBX05BTUVf
TEVOXSwgaW50IG1heCkK

------_=_NextPart_001_01CD2344.EB210B9F--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
