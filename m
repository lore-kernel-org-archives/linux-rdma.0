From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V5] SA Busy Handling
Date: Fri, 3 Dec 2010 15:57:48 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF42A@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_4C2744E8AD2982428C5BFE523DF8CDCB4A208DF42AMNEXMB1qlogic_"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--_002_4C2744E8AD2982428C5BFE523DF8CDCB4A208DF42AMNEXMB1qlogic_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

The purpose of this patch is to cause the ib_mad driver to discard busy res=
ponses from the SA, effectively causing busy responses to become time outs.

This ensures that na=EFve IB applications cannot overwhelm the SA with quer=
ies, which could happen when a cluster is being rebooted, or when a large H=
PC application is started.

Signed-Off-By: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

----

 drivers/infiniband/core/mad.c |   13 +++++++++++++
 include/rdma/ib_mad.h         |    9 +++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 64e660c..b322173 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1828,6 +1828,9 @@ static void ib_mad_complete_recv(struct ib_mad_agent_=
private *mad_agent_priv,
=20
 	/* Complete corresponding request */
 	if (ib_response_mad(mad_recv_wc->recv_buf.mad)) {
+		u16 busy =3D be16_to_cpu(mad_recv_wc->recv_buf.mad->mad_hdr.status) &
+							   IB_MGMT_MAD_STATUS_BUSY;
+
 		spin_lock_irqsave(&mad_agent_priv->lock, flags);
 		mad_send_wr =3D ib_find_send_mad(mad_agent_priv, mad_recv_wc);
 		if (!mad_send_wr) {
@@ -1836,6 +1839,16 @@ static void ib_mad_complete_recv(struct ib_mad_agent=
_private *mad_agent_priv,
 			deref_mad_agent(mad_agent_priv);
 			return;
 		}
+
+		if (busy && mad_send_wr->retries_left &&
+		   (mad_recv_wc->recv_buf.mad->mad_hdr.method !=3D IB_MGMT_METHOD_TRAP_R=
EPRESS)) {
+			/* Just let the query timeout and have it requeued later */
+			spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
+			ib_free_recv_mad(mad_recv_wc);
+			deref_mad_agent(mad_agent_priv);
+			return;
+		}
+
 		ib_mark_mad_done(mad_send_wr);
 		spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
=20
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index d3b9401..b901968 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -77,6 +77,15 @@
=20
 #define IB_MGMT_MAX_METHODS			128
=20
+/* MAD Status field bit masks */
+#define IB_MGMT_MAD_STATUS_SUCCESS                      0x0000
+#define IB_MGMT_MAD_STATUS_BUSY                         0x0001
+#define IB_MGMT_MAD_STATUS_REDIRECT_REQD                0x0002
+#define IB_MGMT_MAD_STATUS_BAD_VERSION                  0x0004
+#define IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD           0x0008
+#define IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD_ATTRIB    0x000c
+#define IB_MGMT_MAD_STATUS_INVALID_ATTRIB_VALUE         0x001c
+
 /* RMPP information */
 #define IB_MGMT_RMPP_VERSION			1
=20



--_002_4C2744E8AD2982428C5BFE523DF8CDCB4A208DF42AMNEXMB1qlogic_
Content-Type: application/octet-stream; name="sa_busy_20101203.patch"
Content-Description: sa_busy_20101203.patch
Content-Disposition: attachment; filename="sa_busy_20101203.patch"; size=2107;
	creation-date="Fri, 03 Dec 2010 15:53:43 GMT";
	modification-date="Fri, 03 Dec 2010 15:53:43 GMT"
Content-Transfer-Encoding: base64

IGRyaXZlcnMvaW5maW5pYmFuZC9jb3JlL21hZC5jIHwgICAxMyArKysrKysrKysrKysrCiBpbmNs
dWRlL3JkbWEvaWJfbWFkLmggICAgICAgICB8ICAgIDkgKysrKysrKysrCiAyIGZpbGVzIGNoYW5n
ZWQsIDIyIGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCmRpZmYgLS1naXQgYS9kcml2ZXJz
L2luZmluaWJhbmQvY29yZS9tYWQuYyBiL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL21hZC5jCmlu
ZGV4IDY0ZTY2MGMuLmIzMjIxNzMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3Jl
L21hZC5jCisrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL21hZC5jCkBAIC0xODI4LDYgKzE4
MjgsOSBAQCBzdGF0aWMgdm9pZCBpYl9tYWRfY29tcGxldGVfcmVjdihzdHJ1Y3QgaWJfbWFkX2Fn
ZW50X3ByaXZhdGUgKm1hZF9hZ2VudF9wcml2LAogCiAJLyogQ29tcGxldGUgY29ycmVzcG9uZGlu
ZyByZXF1ZXN0ICovCiAJaWYgKGliX3Jlc3BvbnNlX21hZChtYWRfcmVjdl93Yy0+cmVjdl9idWYu
bWFkKSkgeworCQl1MTYgYnVzeSA9IGJlMTZfdG9fY3B1KG1hZF9yZWN2X3djLT5yZWN2X2J1Zi5t
YWQtPm1hZF9oZHIuc3RhdHVzKSAmCisJCQkJCQkJICAgSUJfTUdNVF9NQURfU1RBVFVTX0JVU1k7
CisKIAkJc3Bpbl9sb2NrX2lycXNhdmUoJm1hZF9hZ2VudF9wcml2LT5sb2NrLCBmbGFncyk7CiAJ
CW1hZF9zZW5kX3dyID0gaWJfZmluZF9zZW5kX21hZChtYWRfYWdlbnRfcHJpdiwgbWFkX3JlY3Zf
d2MpOwogCQlpZiAoIW1hZF9zZW5kX3dyKSB7CkBAIC0xODM2LDYgKzE4MzksMTYgQEAgc3RhdGlj
IHZvaWQgaWJfbWFkX2NvbXBsZXRlX3JlY3Yoc3RydWN0IGliX21hZF9hZ2VudF9wcml2YXRlICpt
YWRfYWdlbnRfcHJpdiwKIAkJCWRlcmVmX21hZF9hZ2VudChtYWRfYWdlbnRfcHJpdik7CiAJCQly
ZXR1cm47CiAJCX0KKworCQlpZiAoYnVzeSAmJiBtYWRfc2VuZF93ci0+cmV0cmllc19sZWZ0ICYm
CisJCSAgIChtYWRfcmVjdl93Yy0+cmVjdl9idWYubWFkLT5tYWRfaGRyLm1ldGhvZCAhPSBJQl9N
R01UX01FVEhPRF9UUkFQX1JFUFJFU1MpKSB7CisJCQkvKiBKdXN0IGxldCB0aGUgcXVlcnkgdGlt
ZW91dCBhbmQgaGF2ZSBpdCByZXF1ZXVlZCBsYXRlciAqLworCQkJc3Bpbl91bmxvY2tfaXJxcmVz
dG9yZSgmbWFkX2FnZW50X3ByaXYtPmxvY2ssIGZsYWdzKTsKKwkJCWliX2ZyZWVfcmVjdl9tYWQo
bWFkX3JlY3Zfd2MpOworCQkJZGVyZWZfbWFkX2FnZW50KG1hZF9hZ2VudF9wcml2KTsKKwkJCXJl
dHVybjsKKwkJfQorCiAJCWliX21hcmtfbWFkX2RvbmUobWFkX3NlbmRfd3IpOwogCQlzcGluX3Vu
bG9ja19pcnFyZXN0b3JlKCZtYWRfYWdlbnRfcHJpdi0+bG9jaywgZmxhZ3MpOwogCmRpZmYgLS1n
aXQgYS9pbmNsdWRlL3JkbWEvaWJfbWFkLmggYi9pbmNsdWRlL3JkbWEvaWJfbWFkLmgKaW5kZXgg
ZDNiOTQwMS4uYjkwMTk2OCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9yZG1hL2liX21hZC5oCisrKyBi
L2luY2x1ZGUvcmRtYS9pYl9tYWQuaApAQCAtNzcsNiArNzcsMTUgQEAKIAogI2RlZmluZSBJQl9N
R01UX01BWF9NRVRIT0RTCQkJMTI4CiAKKy8qIE1BRCBTdGF0dXMgZmllbGQgYml0IG1hc2tzICov
CisjZGVmaW5lIElCX01HTVRfTUFEX1NUQVRVU19TVUNDRVNTICAgICAgICAgICAgICAgICAgICAg
IDB4MDAwMAorI2RlZmluZSBJQl9NR01UX01BRF9TVEFUVVNfQlVTWSAgICAgICAgICAgICAgICAg
ICAgICAgICAweDAwMDEKKyNkZWZpbmUgSUJfTUdNVF9NQURfU1RBVFVTX1JFRElSRUNUX1JFUUQg
ICAgICAgICAgICAgICAgMHgwMDAyCisjZGVmaW5lIElCX01HTVRfTUFEX1NUQVRVU19CQURfVkVS
U0lPTiAgICAgICAgICAgICAgICAgIDB4MDAwNAorI2RlZmluZSBJQl9NR01UX01BRF9TVEFUVVNf
VU5TVVBQT1JURURfTUVUSE9EICAgICAgICAgICAweDAwMDgKKyNkZWZpbmUgSUJfTUdNVF9NQURf
U1RBVFVTX1VOU1VQUE9SVEVEX01FVEhPRF9BVFRSSUIgICAgMHgwMDBjCisjZGVmaW5lIElCX01H
TVRfTUFEX1NUQVRVU19JTlZBTElEX0FUVFJJQl9WQUxVRSAgICAgICAgIDB4MDAxYworCiAvKiBS
TVBQIGluZm9ybWF0aW9uICovCiAjZGVmaW5lIElCX01HTVRfUk1QUF9WRVJTSU9OCQkJMQogCg==

--_002_4C2744E8AD2982428C5BFE523DF8CDCB4A208DF42AMNEXMB1qlogic_--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
