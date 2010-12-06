From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6] SA Busy code
Date: Mon, 6 Dec 2010 13:00:09 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF511@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_4C2744E8AD2982428C5BFE523DF8CDCB4A208DF511MNEXMB1qlogic_"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--_002_4C2744E8AD2982428C5BFE523DF8CDCB4A208DF511MNEXMB1qlogic_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Removed redundant code.
---
The purpose of this patch is to cause the ib_mad driver to discard busy res=
ponses from the SA, effectively causing busy responses to become time outs.

This ensures that na=EFve IB applications cannot overwhelm the SA with quer=
ies, which could happen when a cluster is being rebooted, or when a large H=
PC application is started.

Signed-Off-By: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

----
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 64e660c..10fead0 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1828,14 +1828,21 @@ static void ib_mad_complete_recv(struct ib_mad_agen=
t_private *mad_agent_priv,
=20
 	/* Complete corresponding request */
 	if (ib_response_mad(mad_recv_wc->recv_buf.mad)) {
+		u16 busy =3D be16_to_cpu(mad_recv_wc->recv_buf.mad->mad_hdr.status) &
+							   IB_MGMT_MAD_STATUS_BUSY;
+
 		spin_lock_irqsave(&mad_agent_priv->lock, flags);
 		mad_send_wr =3D ib_find_send_mad(mad_agent_priv, mad_recv_wc);
-		if (!mad_send_wr) {
+		if (!mad_send_wr ||
+			(busy && mad_send_wr->retries_left &&
+			 (mad_recv_wc->recv_buf.mad->mad_hdr.method !=3D=20
+			  IB_MGMT_METHOD_TRAP_REPRESS))) {
 			spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
 			ib_free_recv_mad(mad_recv_wc);
 			deref_mad_agent(mad_agent_priv);
 			return;
 		}
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



--_002_4C2744E8AD2982428C5BFE523DF8CDCB4A208DF511MNEXMB1qlogic_
Content-Type: application/octet-stream; name="sa_busy_20101206.patch"
Content-Description: sa_busy_20101206.patch
Content-Disposition: attachment; filename="sa_busy_20101206.patch"; size=1765;
	creation-date="Mon, 06 Dec 2010 12:58:16 GMT";
	modification-date="Mon, 06 Dec 2010 12:58:16 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL21hZC5jIGIvZHJpdmVycy9pbmZp
bmliYW5kL2NvcmUvbWFkLmMKaW5kZXggNjRlNjYwYy4uMTBmZWFkMCAxMDA2NDQKLS0tIGEvZHJp
dmVycy9pbmZpbmliYW5kL2NvcmUvbWFkLmMKKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUv
bWFkLmMKQEAgLTE4MjgsMTQgKzE4MjgsMjEgQEAgc3RhdGljIHZvaWQgaWJfbWFkX2NvbXBsZXRl
X3JlY3Yoc3RydWN0IGliX21hZF9hZ2VudF9wcml2YXRlICptYWRfYWdlbnRfcHJpdiwKIAogCS8q
IENvbXBsZXRlIGNvcnJlc3BvbmRpbmcgcmVxdWVzdCAqLwogCWlmIChpYl9yZXNwb25zZV9tYWQo
bWFkX3JlY3Zfd2MtPnJlY3ZfYnVmLm1hZCkpIHsKKwkJdTE2IGJ1c3kgPSBiZTE2X3RvX2NwdSht
YWRfcmVjdl93Yy0+cmVjdl9idWYubWFkLT5tYWRfaGRyLnN0YXR1cykgJgorCQkJCQkJCSAgIElC
X01HTVRfTUFEX1NUQVRVU19CVVNZOworCiAJCXNwaW5fbG9ja19pcnFzYXZlKCZtYWRfYWdlbnRf
cHJpdi0+bG9jaywgZmxhZ3MpOwogCQltYWRfc2VuZF93ciA9IGliX2ZpbmRfc2VuZF9tYWQobWFk
X2FnZW50X3ByaXYsIG1hZF9yZWN2X3djKTsKLQkJaWYgKCFtYWRfc2VuZF93cikgeworCQlpZiAo
IW1hZF9zZW5kX3dyIHx8CisJCQkoYnVzeSAmJiBtYWRfc2VuZF93ci0+cmV0cmllc19sZWZ0ICYm
CisJCQkgKG1hZF9yZWN2X3djLT5yZWN2X2J1Zi5tYWQtPm1hZF9oZHIubWV0aG9kICE9IAorCQkJ
ICBJQl9NR01UX01FVEhPRF9UUkFQX1JFUFJFU1MpKSkgewogCQkJc3Bpbl91bmxvY2tfaXJxcmVz
dG9yZSgmbWFkX2FnZW50X3ByaXYtPmxvY2ssIGZsYWdzKTsKIAkJCWliX2ZyZWVfcmVjdl9tYWQo
bWFkX3JlY3Zfd2MpOwogCQkJZGVyZWZfbWFkX2FnZW50KG1hZF9hZ2VudF9wcml2KTsKIAkJCXJl
dHVybjsKIAkJfQorCiAJCWliX21hcmtfbWFkX2RvbmUobWFkX3NlbmRfd3IpOwogCQlzcGluX3Vu
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

--_002_4C2744E8AD2982428C5BFE523DF8CDCB4A208DF511MNEXMB1qlogic_--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
