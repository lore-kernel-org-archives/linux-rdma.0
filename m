From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V4] SA Busy Handling
Date: Fri, 3 Dec 2010 10:49:53 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3AF@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3AFMNEXMB1qlogic_"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--_002_4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3AFMNEXMB1qlogic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Fixes typo introduced at some point.

---
This patch provides a new module parameter for ib_mad that tells ib_mad to =
treat BUSY responses as timeouts.

parm:           treat_busy_as_timeout:When true, treat BUSY responses as if=
 they were timeouts. (int)

When this parameter is true, ib_mad will unilaterally treat BUSY responses =
as timeouts regardless of the desired behavior of the caller.

In addition, this patch also provides changes to ib_mad_send_buf to allow s=
enders of MAD requests to request this behavior even if the parameter is no=
t set. The patch does NOT provide changes to ib_umad to allow user apps to =
select this functionality.

Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/core/mad.c      |   22 ++++++++++++++++++++++
 drivers/infiniband/core/mad_priv.h |    1 +
 include/rdma/ib_mad.h              |   10 ++++++++++
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 64e660c..2e103ed 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -54,6 +54,10 @@ MODULE_PARM_DESC(send_queue_size, "Size of send queue in=
 number of work requests
 module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
 MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of work=
 requests");
=20
+int mad_wait_on_busy =3D 0;
+module_param_named(treat_busy_as_timeout, mad_wait_on_busy, int, 0444);
+MODULE_PARM_DESC(treat_busy_as_timeout, "When true, treat BUSY responses a=
s if they were timeouts.");
+
 static struct kmem_cache *ib_mad_cache;
=20
 static struct list_head ib_mad_port_list;
@@ -1120,6 +1124,7 @@ int ib_post_send_mad(struct ib_mad_send_buf *send_buf=
,
 		mad_send_wr->timeout =3D msecs_to_jiffies(send_buf->timeout_ms);
 		mad_send_wr->max_retries =3D send_buf->retries;
 		mad_send_wr->retries_left =3D send_buf->retries;
+		mad_send_wr->wait_on_busy =3D send_buf->wait_on_busy || mad_wait_on_busy=
;
 		send_buf->retries =3D 0;
 		/* Reference for work request to QP + response */
 		mad_send_wr->refcount =3D 1 + (mad_send_wr->timeout > 0);
@@ -1828,6 +1833,9 @@ static void ib_mad_complete_recv(struct ib_mad_agent_=
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
@@ -1836,6 +1844,20 @@ static void ib_mad_complete_recv(struct ib_mad_agent=
_private *mad_agent_priv,
 			deref_mad_agent(mad_agent_priv);
 			return;
 		}
+
+		printk(KERN_DEBUG PFX "Completing recv %p: busy =3D %d, retries_left =3D=
 %d, wait_on_busy =3D %d\n",
+			   mad_send_wr, busy, mad_send_wr->retries_left, mad_send_wr->wait_on_b=
usy);
+
+		if (busy && mad_send_wr->retries_left && mad_send_wr->wait_on_busy &&
+		   (mad_recv_wc->recv_buf.mad->mad_hdr.method !=3D IB_MGMT_METHOD_TRAP_R=
EPRESS)) {
+			/* Just let the query timeout and have it requeued later */
+			spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
+			ib_free_recv_mad(mad_recv_wc);
+			deref_mad_agent(mad_agent_priv);
+			printk(KERN_INFO PFX "SA/SM responded MAD_STATUS_BUSY. Allowing request=
 to time out.\n");
+			return;
+		}
+
 		ib_mark_mad_done(mad_send_wr);
 		spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
=20
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/m=
ad_priv.h
index 8b4df0a..b6477cf 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -135,6 +135,7 @@ struct ib_mad_send_wr_private {
 	unsigned long timeout;
 	int max_retries;
 	int retries_left;
+	int wait_on_busy;
 	int retry;
 	int refcount;
 	enum ib_wc_status status;
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index d3b9401..fadc2c3 100644
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
@@ -246,6 +255,7 @@ struct ib_mad_send_buf {
 	int			seg_count;
 	int			seg_size;
 	int			timeout_ms;
+	int			wait_on_busy;
 	int			retries;
 };


--_002_4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3AFMNEXMB1qlogic_
Content-Type: application/octet-stream; name="sa_busy_20101202.patch"
Content-Description: sa_busy_20101202.patch
Content-Disposition: attachment; filename="sa_busy_20101202.patch"; size=3798;
	creation-date="Thu, 02 Dec 2010 14:21:59 GMT";
	modification-date="Fri, 03 Dec 2010 10:49:08 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL21hZC5jIGIvZHJpdmVycy9pbmZp
bmliYW5kL2NvcmUvbWFkLmMKaW5kZXggNjRlNjYwYy4uMmUxMDNlZCAxMDA2NDQKLS0tIGEvZHJp
dmVycy9pbmZpbmliYW5kL2NvcmUvbWFkLmMKKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUv
bWFkLmMKQEAgLTU0LDYgKzU0LDEwIEBAIE1PRFVMRV9QQVJNX0RFU0Moc2VuZF9xdWV1ZV9zaXpl
LCAiU2l6ZSBvZiBzZW5kIHF1ZXVlIGluIG51bWJlciBvZiB3b3JrIHJlcXVlc3RzCiBtb2R1bGVf
cGFyYW1fbmFtZWQocmVjdl9xdWV1ZV9zaXplLCBtYWRfcmVjdnFfc2l6ZSwgaW50LCAwNDQ0KTsK
IE1PRFVMRV9QQVJNX0RFU0MocmVjdl9xdWV1ZV9zaXplLCAiU2l6ZSBvZiByZWNlaXZlIHF1ZXVl
IGluIG51bWJlciBvZiB3b3JrIHJlcXVlc3RzIik7CiAKK2ludCBtYWRfd2FpdF9vbl9idXN5ID0g
MDsKK21vZHVsZV9wYXJhbV9uYW1lZCh0cmVhdF9idXN5X2FzX3RpbWVvdXQsIG1hZF93YWl0X29u
X2J1c3ksIGludCwgMDQ0NCk7CitNT0RVTEVfUEFSTV9ERVNDKHRyZWF0X2J1c3lfYXNfdGltZW91
dCwgIldoZW4gdHJ1ZSwgdHJlYXQgQlVTWSByZXNwb25zZXMgYXMgaWYgdGhleSB3ZXJlIHRpbWVv
dXRzLiIpOworCiBzdGF0aWMgc3RydWN0IGttZW1fY2FjaGUgKmliX21hZF9jYWNoZTsKIAogc3Rh
dGljIHN0cnVjdCBsaXN0X2hlYWQgaWJfbWFkX3BvcnRfbGlzdDsKQEAgLTExMjAsNiArMTEyNCw3
IEBAIGludCBpYl9wb3N0X3NlbmRfbWFkKHN0cnVjdCBpYl9tYWRfc2VuZF9idWYgKnNlbmRfYnVm
LAogCQltYWRfc2VuZF93ci0+dGltZW91dCA9IG1zZWNzX3RvX2ppZmZpZXMoc2VuZF9idWYtPnRp
bWVvdXRfbXMpOwogCQltYWRfc2VuZF93ci0+bWF4X3JldHJpZXMgPSBzZW5kX2J1Zi0+cmV0cmll
czsKIAkJbWFkX3NlbmRfd3ItPnJldHJpZXNfbGVmdCA9IHNlbmRfYnVmLT5yZXRyaWVzOworCQlt
YWRfc2VuZF93ci0+d2FpdF9vbl9idXN5ID0gc2VuZF9idWYtPndhaXRfb25fYnVzeSB8fCBtYWRf
d2FpdF9vbl9idXN5OwogCQlzZW5kX2J1Zi0+cmV0cmllcyA9IDA7CiAJCS8qIFJlZmVyZW5jZSBm
b3Igd29yayByZXF1ZXN0IHRvIFFQICsgcmVzcG9uc2UgKi8KIAkJbWFkX3NlbmRfd3ItPnJlZmNv
dW50ID0gMSArIChtYWRfc2VuZF93ci0+dGltZW91dCA+IDApOwpAQCAtMTgyOCw2ICsxODMzLDkg
QEAgc3RhdGljIHZvaWQgaWJfbWFkX2NvbXBsZXRlX3JlY3Yoc3RydWN0IGliX21hZF9hZ2VudF9w
cml2YXRlICptYWRfYWdlbnRfcHJpdiwKIAogCS8qIENvbXBsZXRlIGNvcnJlc3BvbmRpbmcgcmVx
dWVzdCAqLwogCWlmIChpYl9yZXNwb25zZV9tYWQobWFkX3JlY3Zfd2MtPnJlY3ZfYnVmLm1hZCkp
IHsKKwkJdTE2IGJ1c3kgPSBiZTE2X3RvX2NwdShtYWRfcmVjdl93Yy0+cmVjdl9idWYubWFkLT5t
YWRfaGRyLnN0YXR1cykgJgorCQkJCQkJCSAgIElCX01HTVRfTUFEX1NUQVRVU19CVVNZOworCiAJ
CXNwaW5fbG9ja19pcnFzYXZlKCZtYWRfYWdlbnRfcHJpdi0+bG9jaywgZmxhZ3MpOwogCQltYWRf
c2VuZF93ciA9IGliX2ZpbmRfc2VuZF9tYWQobWFkX2FnZW50X3ByaXYsIG1hZF9yZWN2X3djKTsK
IAkJaWYgKCFtYWRfc2VuZF93cikgewpAQCAtMTgzNiw2ICsxODQ0LDIwIEBAIHN0YXRpYyB2b2lk
IGliX21hZF9jb21wbGV0ZV9yZWN2KHN0cnVjdCBpYl9tYWRfYWdlbnRfcHJpdmF0ZSAqbWFkX2Fn
ZW50X3ByaXYsCiAJCQlkZXJlZl9tYWRfYWdlbnQobWFkX2FnZW50X3ByaXYpOwogCQkJcmV0dXJu
OwogCQl9CisKKwkJcHJpbnRrKEtFUk5fREVCVUcgUEZYICJDb21wbGV0aW5nIHJlY3YgJXA6IGJ1
c3kgPSAlZCwgcmV0cmllc19sZWZ0ID0gJWQsIHdhaXRfb25fYnVzeSA9ICVkXG4iLAorCQkJICAg
bWFkX3NlbmRfd3IsIGJ1c3ksIG1hZF9zZW5kX3dyLT5yZXRyaWVzX2xlZnQsIG1hZF9zZW5kX3dy
LT53YWl0X29uX2J1c3kpOworCisJCWlmIChidXN5ICYmIG1hZF9zZW5kX3dyLT5yZXRyaWVzX2xl
ZnQgJiYgbWFkX3NlbmRfd3ItPndhaXRfb25fYnVzeSAmJgorCQkgICAobWFkX3JlY3Zfd2MtPnJl
Y3ZfYnVmLm1hZC0+bWFkX2hkci5tZXRob2QgIT0gSUJfTUdNVF9NRVRIT0RfVFJBUF9SRVBSRVNT
KSkgeworCQkJLyogSnVzdCBsZXQgdGhlIHF1ZXJ5IHRpbWVvdXQgYW5kIGhhdmUgaXQgcmVxdWV1
ZWQgbGF0ZXIgKi8KKwkJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJm1hZF9hZ2VudF9wcml2LT5s
b2NrLCBmbGFncyk7CisJCQlpYl9mcmVlX3JlY3ZfbWFkKG1hZF9yZWN2X3djKTsKKwkJCWRlcmVm
X21hZF9hZ2VudChtYWRfYWdlbnRfcHJpdik7CisJCQlwcmludGsoS0VSTl9JTkZPIFBGWCAiU0Ev
U00gcmVzcG9uZGVkIE1BRF9TVEFUVVNfQlVTWS4gQWxsb3dpbmcgcmVxdWVzdCB0byB0aW1lIG91
dC5cbiIpOworCQkJcmV0dXJuOworCQl9CisKIAkJaWJfbWFya19tYWRfZG9uZShtYWRfc2VuZF93
cik7CiAJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJm1hZF9hZ2VudF9wcml2LT5sb2NrLCBmbGFn
cyk7CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL21hZF9wcml2LmggYi9k
cml2ZXJzL2luZmluaWJhbmQvY29yZS9tYWRfcHJpdi5oCmluZGV4IDhiNGRmMGEuLmI2NDc3Y2Yg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL21hZF9wcml2LmgKKysrIGIvZHJp
dmVycy9pbmZpbmliYW5kL2NvcmUvbWFkX3ByaXYuaApAQCAtMTM1LDYgKzEzNSw3IEBAIHN0cnVj
dCBpYl9tYWRfc2VuZF93cl9wcml2YXRlIHsKIAl1bnNpZ25lZCBsb25nIHRpbWVvdXQ7CiAJaW50
IG1heF9yZXRyaWVzOwogCWludCByZXRyaWVzX2xlZnQ7CisJaW50IHdhaXRfb25fYnVzeTsKIAlp
bnQgcmV0cnk7CiAJaW50IHJlZmNvdW50OwogCWVudW0gaWJfd2Nfc3RhdHVzIHN0YXR1czsKZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvcmRtYS9pYl9tYWQuaCBiL2luY2x1ZGUvcmRtYS9pYl9tYWQuaApp
bmRleCBkM2I5NDAxLi5mYWRjMmMzIDEwMDY0NAotLS0gYS9pbmNsdWRlL3JkbWEvaWJfbWFkLmgK
KysrIGIvaW5jbHVkZS9yZG1hL2liX21hZC5oCkBAIC03Nyw2ICs3NywxNSBAQAogCiAjZGVmaW5l
IElCX01HTVRfTUFYX01FVEhPRFMJCQkxMjgKIAorLyogTUFEIFN0YXR1cyBmaWVsZCBiaXQgbWFz
a3MgKi8KKyNkZWZpbmUgSUJfTUdNVF9NQURfU1RBVFVTX1NVQ0NFU1MgICAgICAgICAgICAgICAg
ICAgICAgMHgwMDAwCisjZGVmaW5lIElCX01HTVRfTUFEX1NUQVRVU19CVVNZICAgICAgICAgICAg
ICAgICAgICAgICAgIDB4MDAwMQorI2RlZmluZSBJQl9NR01UX01BRF9TVEFUVVNfUkVESVJFQ1Rf
UkVRRCAgICAgICAgICAgICAgICAweDAwMDIKKyNkZWZpbmUgSUJfTUdNVF9NQURfU1RBVFVTX0JB
RF9WRVJTSU9OICAgICAgICAgICAgICAgICAgMHgwMDA0CisjZGVmaW5lIElCX01HTVRfTUFEX1NU
QVRVU19VTlNVUFBPUlRFRF9NRVRIT0QgICAgICAgICAgIDB4MDAwOAorI2RlZmluZSBJQl9NR01U
X01BRF9TVEFUVVNfVU5TVVBQT1JURURfTUVUSE9EX0FUVFJJQiAgICAweDAwMGMKKyNkZWZpbmUg
SUJfTUdNVF9NQURfU1RBVFVTX0lOVkFMSURfQVRUUklCX1ZBTFVFICAgICAgICAgMHgwMDFjCisK
IC8qIFJNUFAgaW5mb3JtYXRpb24gKi8KICNkZWZpbmUgSUJfTUdNVF9STVBQX1ZFUlNJT04JCQkx
CiAKQEAgLTI0Niw2ICsyNTUsNyBAQCBzdHJ1Y3QgaWJfbWFkX3NlbmRfYnVmIHsKIAlpbnQJCQlz
ZWdfY291bnQ7CiAJaW50CQkJc2VnX3NpemU7CiAJaW50CQkJdGltZW91dF9tczsKKwlpbnQJCQl3
YWl0X29uX2J1c3k7CiAJaW50CQkJcmV0cmllczsKIH07CiAK

--_002_4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3AFMNEXMB1qlogic_--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
