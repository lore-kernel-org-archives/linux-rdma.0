From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Add exponential backoff + random delay to MADs when
 retrying after timeout.
Date: Mon, 11 Oct 2010 10:34:09 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49D45E3CB6@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_4C2744E8AD2982428C5BFE523DF8CDCB49D45E3CB6MNEXMB1qlogic_"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--_002_4C2744E8AD2982428C5BFE523DF8CDCB49D45E3CB6MNEXMB1qlogic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This patch builds upon a discussion we had earlier this year on adding a ba=
ckoff function when retrying MAD sends after a timeout.

This patch does NOT implement the ABI/API changes that would be needed to t=
ake advantage of the new features, but it lays the groundwork for doing so.=
 In addition, it provides a new module parameter that allow the administrat=
or to coerce existing code into using the new capability.

First, I've added a new field called "randomized_wait" to the ib_mad_send_b=
uf structure. If this parameter is set, each time the WR times out, the the=
 timeout for the next retry is set to (send_wr->timeout_ms + 511<<(send_wr-=
>retries) - random32()&511). In other words, on the first retry, the random=
ization code will add between 0 and 1/2 second to the timeout. On the secon=
d retry, it will add between 1 and 1.5 seconds to the timeout, on the 3rd, =
between 2 and 2.5 seconds, on the 4th, between 4 and 4.5, et cetera. In add=
ition, a new field, total_timeout has been added to the ib_mad_send_wr_priv=
ate and is initialized to (send_wr->timeout * send_wr->max_retries). Retrie=
s cannot exceed this total time, even though that will mean a lower number =
of retry attempts.

Finally, I've added a module parameter to coerce all mad work requests to u=
se this feature if desired.

parm:           randomized_wait:When true, use a randomized backoff algorit=
hm to control retries for timeouts. (int)

--------

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index ef1304f..3b03f1c 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -42,6 +42,11 @@
 #include "smi.h"
 #include "agent.h"
=20
+#include "linux/random.h"
+
+#define MAD_MIN_TIMEOUT_MS 511
+#define MAD_RAND_TIMEOUT_MS 511
+
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("kernel IB MAD API");
 MODULE_AUTHOR("Hal Rosenstock");
@@ -55,6 +60,10 @@ MODULE_PARM_DESC(send_queue_size, "Size of send queue in=
 number of work requests
 module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
 MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of work=
 requests");
=20
+int mad_randomized_wait =3D 0;
+module_param_named(randomized_wait, mad_randomized_wait, int, 0444);
+MODULE_PARM_DESC(randomized_wait, "When true, use a randomized backoff alg=
orithm to control retries for timeouts.");
+
 static struct kmem_cache *ib_mad_cache;
=20
 static struct list_head ib_mad_port_list;
@@ -1102,11 +1111,18 @@ int ib_post_send_mad(struct ib_mad_send_buf *send_b=
uf,
 		}
=20
 		mad_send_wr->tid =3D ((struct ib_mad_hdr *) send_buf->mad)->tid;
+
+		mad_send_wr->randomized_wait =3D mad_randomized_wait || send_buf->random=
ized_wait;
+		mad_send_wr->total_timeout =3D msecs_to_jiffies(send_buf->timeout_ms) * =
send_buf->retries;
+	=09
 		/* Timeout will be updated after send completes */
 		mad_send_wr->timeout =3D msecs_to_jiffies(send_buf->timeout_ms);
+
 		mad_send_wr->max_retries =3D send_buf->retries;
 		mad_send_wr->retries_left =3D send_buf->retries;
+	=09
 		send_buf->retries =3D 0;
+	=09
 		/* Reference for work request to QP + response */
 		mad_send_wr->refcount =3D 1 + (mad_send_wr->timeout > 0);
 		mad_send_wr->status =3D IB_WC_SUCCESS;
@@ -1803,6 +1819,7 @@ static void ib_mad_complete_recv(struct ib_mad_agent_=
private *mad_agent_priv,
=20
 	/* Complete corresponding request */
 	if (ib_response_mad(mad_recv_wc->recv_buf.mad)) {
+
 		spin_lock_irqsave(&mad_agent_priv->lock, flags);
 		mad_send_wr =3D ib_find_send_mad(mad_agent_priv, mad_recv_wc);
 		if (!mad_send_wr) {
@@ -1811,6 +1828,7 @@ static void ib_mad_complete_recv(struct ib_mad_agent_=
private *mad_agent_priv,
 			deref_mad_agent(mad_agent_priv);
 			return;
 		}
+
 		ib_mark_mad_done(mad_send_wr);
 		spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
=20
@@ -2429,14 +2447,33 @@ static int retry_send(struct ib_mad_send_wr_private=
 *mad_send_wr)
 {
 	int ret;
=20
-	if (!mad_send_wr->retries_left)
+	if (!mad_send_wr->retries_left || (mad_send_wr->total_timeout =3D=3D 0))
 		return -ETIMEDOUT;
=20
 	mad_send_wr->retries_left--;
 	mad_send_wr->send_buf.retries++;
=20
-	mad_send_wr->timeout =3D msecs_to_jiffies(mad_send_wr->send_buf.timeout_m=
s);
+	if (mad_send_wr->randomized_wait) {
+		mad_send_wr->timeout =3D msecs_to_jiffies(mad_send_wr->send_buf.timeout_=
ms +
+			(MAD_MIN_TIMEOUT_MS<<mad_send_wr->send_buf.retries) -
+			(random32()&MAD_RAND_TIMEOUT_MS));
+		if (mad_send_wr->timeout > mad_send_wr->total_timeout) {
+			mad_send_wr->timeout =3D mad_send_wr->total_timeout;
+			mad_send_wr->total_timeout =3D 0;
+		} else {
+			mad_send_wr->total_timeout -=3D mad_send_wr->timeout;
+		}
+	} else {
+		mad_send_wr->timeout =3D msecs_to_jiffies(mad_send_wr->send_buf.timeout_=
ms);
+	}
=20
+	printk(KERN_DEBUG PFX "Retrying send %p: retries: %u, retries_left: %u, t=
imeout: %lu, total_timeout: %lu\n",
+		mad_send_wr,
+		mad_send_wr->send_buf.retries,
+		mad_send_wr->retries_left,
+		mad_send_wr->timeout,
+		mad_send_wr->total_timeout);
+	=09
 	if (mad_send_wr->mad_agent_priv->agent.rmpp_version) {
 		ret =3D ib_retry_rmpp(mad_send_wr);
 		switch (ret) {
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/m=
ad_priv.h
index 9430ab4..01fb7ed 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -132,8 +132,10 @@ struct ib_mad_send_wr_private {
 	struct ib_sge sg_list[IB_MAD_SEND_REQ_MAX_SG];
 	__be64 tid;
 	unsigned long timeout;
+	unsigned long total_timeout;
 	int max_retries;
 	int retries_left;
+	int randomized_wait;
 	int retry;
 	int refcount;
 	enum ib_wc_status status;
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index d3b9401..c3d6efb 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -77,6 +77,15 @@
=20
 #define IB_MGMT_MAX_METHODS			128
=20
+/* MAD Status field bit masks */
+#define IB_MGMT_MAD_STATUS_SUCCESS						0x0000
+#define IB_MGMT_MAD_STATUS_BUSY							0x0001
+#define IB_MGMT_MAD_STATUS_REDIRECT_REQD				0x0002
+#define IB_MGMT_MAD_STATUS_BAD_VERERSION				0x0004=09
+#define IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD			0x0008=09
+#define IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD_ATTRIB	0x000c
+#define IB_MGMT_MAD_STATUS_INVALID_ATTRIB_VALUE			0x001c
+
 /* RMPP information */
 #define IB_MGMT_RMPP_VERSION			1
=20
@@ -246,6 +255,7 @@ struct ib_mad_send_buf {
 	int			seg_count;
 	int			seg_size;
 	int			timeout_ms;
+	int			randomized_wait;
 	int			retries;
 };


--_002_4C2744E8AD2982428C5BFE523DF8CDCB49D45E3CB6MNEXMB1qlogic_
Content-Type: application/octet-stream; name="randomized_mad_timeout.patch"
Content-Description: randomized_mad_timeout.patch
Content-Disposition: attachment; filename="randomized_mad_timeout.patch";
	size=4914; creation-date="Mon, 11 Oct 2010 10:22:01 GMT";
	modification-date="Mon, 11 Oct 2010 10:22:01 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL21hZC5jIGIvZHJpdmVycy9pbmZp
bmliYW5kL2NvcmUvbWFkLmMKaW5kZXggZWYxMzA0Zi4uM2IwM2YxYyAxMDA2NDQKLS0tIGEvZHJp
dmVycy9pbmZpbmliYW5kL2NvcmUvbWFkLmMKKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUv
bWFkLmMKQEAgLTQyLDYgKzQyLDExIEBACiAjaW5jbHVkZSAic21pLmgiCiAjaW5jbHVkZSAiYWdl
bnQuaCIKIAorI2luY2x1ZGUgImxpbnV4L3JhbmRvbS5oIgorCisjZGVmaW5lIE1BRF9NSU5fVElN
RU9VVF9NUyA1MTEKKyNkZWZpbmUgTUFEX1JBTkRfVElNRU9VVF9NUyA1MTEKKwogTU9EVUxFX0xJ
Q0VOU0UoIkR1YWwgQlNEL0dQTCIpOwogTU9EVUxFX0RFU0NSSVBUSU9OKCJrZXJuZWwgSUIgTUFE
IEFQSSIpOwogTU9EVUxFX0FVVEhPUigiSGFsIFJvc2Vuc3RvY2siKTsKQEAgLTU1LDYgKzYwLDEw
IEBAIE1PRFVMRV9QQVJNX0RFU0Moc2VuZF9xdWV1ZV9zaXplLCAiU2l6ZSBvZiBzZW5kIHF1ZXVl
IGluIG51bWJlciBvZiB3b3JrIHJlcXVlc3RzCiBtb2R1bGVfcGFyYW1fbmFtZWQocmVjdl9xdWV1
ZV9zaXplLCBtYWRfcmVjdnFfc2l6ZSwgaW50LCAwNDQ0KTsKIE1PRFVMRV9QQVJNX0RFU0MocmVj
dl9xdWV1ZV9zaXplLCAiU2l6ZSBvZiByZWNlaXZlIHF1ZXVlIGluIG51bWJlciBvZiB3b3JrIHJl
cXVlc3RzIik7CiAKK2ludCBtYWRfcmFuZG9taXplZF93YWl0ID0gMDsKK21vZHVsZV9wYXJhbV9u
YW1lZChyYW5kb21pemVkX3dhaXQsIG1hZF9yYW5kb21pemVkX3dhaXQsIGludCwgMDQ0NCk7CitN
T0RVTEVfUEFSTV9ERVNDKHJhbmRvbWl6ZWRfd2FpdCwgIldoZW4gdHJ1ZSwgdXNlIGEgcmFuZG9t
aXplZCBiYWNrb2ZmIGFsZ29yaXRobSB0byBjb250cm9sIHJldHJpZXMgZm9yIHRpbWVvdXRzLiIp
OworCiBzdGF0aWMgc3RydWN0IGttZW1fY2FjaGUgKmliX21hZF9jYWNoZTsKIAogc3RhdGljIHN0
cnVjdCBsaXN0X2hlYWQgaWJfbWFkX3BvcnRfbGlzdDsKQEAgLTExMDIsMTEgKzExMTEsMTggQEAg
aW50IGliX3Bvc3Rfc2VuZF9tYWQoc3RydWN0IGliX21hZF9zZW5kX2J1ZiAqc2VuZF9idWYsCiAJ
CX0KIAogCQltYWRfc2VuZF93ci0+dGlkID0gKChzdHJ1Y3QgaWJfbWFkX2hkciAqKSBzZW5kX2J1
Zi0+bWFkKS0+dGlkOworCisJCW1hZF9zZW5kX3dyLT5yYW5kb21pemVkX3dhaXQgPSBtYWRfcmFu
ZG9taXplZF93YWl0IHx8IHNlbmRfYnVmLT5yYW5kb21pemVkX3dhaXQ7CisJCW1hZF9zZW5kX3dy
LT50b3RhbF90aW1lb3V0ID0gbXNlY3NfdG9famlmZmllcyhzZW5kX2J1Zi0+dGltZW91dF9tcykg
KiBzZW5kX2J1Zi0+cmV0cmllczsKKwkJCiAJCS8qIFRpbWVvdXQgd2lsbCBiZSB1cGRhdGVkIGFm
dGVyIHNlbmQgY29tcGxldGVzICovCiAJCW1hZF9zZW5kX3dyLT50aW1lb3V0ID0gbXNlY3NfdG9f
amlmZmllcyhzZW5kX2J1Zi0+dGltZW91dF9tcyk7CisKIAkJbWFkX3NlbmRfd3ItPm1heF9yZXRy
aWVzID0gc2VuZF9idWYtPnJldHJpZXM7CiAJCW1hZF9zZW5kX3dyLT5yZXRyaWVzX2xlZnQgPSBz
ZW5kX2J1Zi0+cmV0cmllczsKKwkJCiAJCXNlbmRfYnVmLT5yZXRyaWVzID0gMDsKKwkJCiAJCS8q
IFJlZmVyZW5jZSBmb3Igd29yayByZXF1ZXN0IHRvIFFQICsgcmVzcG9uc2UgKi8KIAkJbWFkX3Nl
bmRfd3ItPnJlZmNvdW50ID0gMSArIChtYWRfc2VuZF93ci0+dGltZW91dCA+IDApOwogCQltYWRf
c2VuZF93ci0+c3RhdHVzID0gSUJfV0NfU1VDQ0VTUzsKQEAgLTE4MDMsNiArMTgxOSw3IEBAIHN0
YXRpYyB2b2lkIGliX21hZF9jb21wbGV0ZV9yZWN2KHN0cnVjdCBpYl9tYWRfYWdlbnRfcHJpdmF0
ZSAqbWFkX2FnZW50X3ByaXYsCiAKIAkvKiBDb21wbGV0ZSBjb3JyZXNwb25kaW5nIHJlcXVlc3Qg
Ki8KIAlpZiAoaWJfcmVzcG9uc2VfbWFkKG1hZF9yZWN2X3djLT5yZWN2X2J1Zi5tYWQpKSB7CisK
IAkJc3Bpbl9sb2NrX2lycXNhdmUoJm1hZF9hZ2VudF9wcml2LT5sb2NrLCBmbGFncyk7CiAJCW1h
ZF9zZW5kX3dyID0gaWJfZmluZF9zZW5kX21hZChtYWRfYWdlbnRfcHJpdiwgbWFkX3JlY3Zfd2Mp
OwogCQlpZiAoIW1hZF9zZW5kX3dyKSB7CkBAIC0xODExLDYgKzE4MjgsNyBAQCBzdGF0aWMgdm9p
ZCBpYl9tYWRfY29tcGxldGVfcmVjdihzdHJ1Y3QgaWJfbWFkX2FnZW50X3ByaXZhdGUgKm1hZF9h
Z2VudF9wcml2LAogCQkJZGVyZWZfbWFkX2FnZW50KG1hZF9hZ2VudF9wcml2KTsKIAkJCXJldHVy
bjsKIAkJfQorCiAJCWliX21hcmtfbWFkX2RvbmUobWFkX3NlbmRfd3IpOwogCQlzcGluX3VubG9j
a19pcnFyZXN0b3JlKCZtYWRfYWdlbnRfcHJpdi0+bG9jaywgZmxhZ3MpOwogCkBAIC0yNDI5LDE0
ICsyNDQ3LDMzIEBAIHN0YXRpYyBpbnQgcmV0cnlfc2VuZChzdHJ1Y3QgaWJfbWFkX3NlbmRfd3Jf
cHJpdmF0ZSAqbWFkX3NlbmRfd3IpCiB7CiAJaW50IHJldDsKIAotCWlmICghbWFkX3NlbmRfd3It
PnJldHJpZXNfbGVmdCkKKwlpZiAoIW1hZF9zZW5kX3dyLT5yZXRyaWVzX2xlZnQgfHwgKG1hZF9z
ZW5kX3dyLT50b3RhbF90aW1lb3V0ID09IDApKQogCQlyZXR1cm4gLUVUSU1FRE9VVDsKIAogCW1h
ZF9zZW5kX3dyLT5yZXRyaWVzX2xlZnQtLTsKIAltYWRfc2VuZF93ci0+c2VuZF9idWYucmV0cmll
cysrOwogCi0JbWFkX3NlbmRfd3ItPnRpbWVvdXQgPSBtc2Vjc190b19qaWZmaWVzKG1hZF9zZW5k
X3dyLT5zZW5kX2J1Zi50aW1lb3V0X21zKTsKKwlpZiAobWFkX3NlbmRfd3ItPnJhbmRvbWl6ZWRf
d2FpdCkgeworCQltYWRfc2VuZF93ci0+dGltZW91dCA9IG1zZWNzX3RvX2ppZmZpZXMobWFkX3Nl
bmRfd3ItPnNlbmRfYnVmLnRpbWVvdXRfbXMgKworCQkJKE1BRF9NSU5fVElNRU9VVF9NUzw8bWFk
X3NlbmRfd3ItPnNlbmRfYnVmLnJldHJpZXMpIC0KKwkJCShyYW5kb20zMigpJk1BRF9SQU5EX1RJ
TUVPVVRfTVMpKTsKKwkJaWYgKG1hZF9zZW5kX3dyLT50aW1lb3V0ID4gbWFkX3NlbmRfd3ItPnRv
dGFsX3RpbWVvdXQpIHsKKwkJCW1hZF9zZW5kX3dyLT50aW1lb3V0ID0gbWFkX3NlbmRfd3ItPnRv
dGFsX3RpbWVvdXQ7CisJCQltYWRfc2VuZF93ci0+dG90YWxfdGltZW91dCA9IDA7CisJCX0gZWxz
ZSB7CisJCQltYWRfc2VuZF93ci0+dG90YWxfdGltZW91dCAtPSBtYWRfc2VuZF93ci0+dGltZW91
dDsKKwkJfQorCX0gZWxzZSB7CisJCW1hZF9zZW5kX3dyLT50aW1lb3V0ID0gbXNlY3NfdG9famlm
ZmllcyhtYWRfc2VuZF93ci0+c2VuZF9idWYudGltZW91dF9tcyk7CisJfQogCisJcHJpbnRrKEtF
Uk5fREVCVUcgUEZYICJSZXRyeWluZyBzZW5kICVwOiByZXRyaWVzOiAldSwgcmV0cmllc19sZWZ0
OiAldSwgdGltZW91dDogJWx1LCB0b3RhbF90aW1lb3V0OiAlbHVcbiIsCisJCW1hZF9zZW5kX3dy
LAorCQltYWRfc2VuZF93ci0+c2VuZF9idWYucmV0cmllcywKKwkJbWFkX3NlbmRfd3ItPnJldHJp
ZXNfbGVmdCwKKwkJbWFkX3NlbmRfd3ItPnRpbWVvdXQsCisJCW1hZF9zZW5kX3dyLT50b3RhbF90
aW1lb3V0KTsKKwkJCiAJaWYgKG1hZF9zZW5kX3dyLT5tYWRfYWdlbnRfcHJpdi0+YWdlbnQucm1w
cF92ZXJzaW9uKSB7CiAJCXJldCA9IGliX3JldHJ5X3JtcHAobWFkX3NlbmRfd3IpOwogCQlzd2l0
Y2ggKHJldCkgewpkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvbWFkX3ByaXYu
aCBiL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL21hZF9wcml2LmgKaW5kZXggOTQzMGFiNC4uMDFm
YjdlZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvbWFkX3ByaXYuaAorKysg
Yi9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9tYWRfcHJpdi5oCkBAIC0xMzIsOCArMTMyLDEwIEBA
IHN0cnVjdCBpYl9tYWRfc2VuZF93cl9wcml2YXRlIHsKIAlzdHJ1Y3QgaWJfc2dlIHNnX2xpc3Rb
SUJfTUFEX1NFTkRfUkVRX01BWF9TR107CiAJX19iZTY0IHRpZDsKIAl1bnNpZ25lZCBsb25nIHRp
bWVvdXQ7CisJdW5zaWduZWQgbG9uZyB0b3RhbF90aW1lb3V0OwogCWludCBtYXhfcmV0cmllczsK
IAlpbnQgcmV0cmllc19sZWZ0OworCWludCByYW5kb21pemVkX3dhaXQ7CiAJaW50IHJldHJ5Owog
CWludCByZWZjb3VudDsKIAllbnVtIGliX3djX3N0YXR1cyBzdGF0dXM7CmRpZmYgLS1naXQgYS9p
bmNsdWRlL3JkbWEvaWJfbWFkLmggYi9pbmNsdWRlL3JkbWEvaWJfbWFkLmgKaW5kZXggZDNiOTQw
MS4uYzNkNmVmYiAxMDA2NDQKLS0tIGEvaW5jbHVkZS9yZG1hL2liX21hZC5oCisrKyBiL2luY2x1
ZGUvcmRtYS9pYl9tYWQuaApAQCAtNzcsNiArNzcsMTUgQEAKIAogI2RlZmluZSBJQl9NR01UX01B
WF9NRVRIT0RTCQkJMTI4CiAKKy8qIE1BRCBTdGF0dXMgZmllbGQgYml0IG1hc2tzICovCisjZGVm
aW5lIElCX01HTVRfTUFEX1NUQVRVU19TVUNDRVNTCQkJCQkJMHgwMDAwCisjZGVmaW5lIElCX01H
TVRfTUFEX1NUQVRVU19CVVNZCQkJCQkJCTB4MDAwMQorI2RlZmluZSBJQl9NR01UX01BRF9TVEFU
VVNfUkVESVJFQ1RfUkVRRAkJCQkweDAwMDIKKyNkZWZpbmUgSUJfTUdNVF9NQURfU1RBVFVTX0JB
RF9WRVJFUlNJT04JCQkJMHgwMDA0CQorI2RlZmluZSBJQl9NR01UX01BRF9TVEFUVVNfVU5TVVBQ
T1JURURfTUVUSE9ECQkJMHgwMDA4CQorI2RlZmluZSBJQl9NR01UX01BRF9TVEFUVVNfVU5TVVBQ
T1JURURfTUVUSE9EX0FUVFJJQgkweDAwMGMKKyNkZWZpbmUgSUJfTUdNVF9NQURfU1RBVFVTX0lO
VkFMSURfQVRUUklCX1ZBTFVFCQkJMHgwMDFjCisKIC8qIFJNUFAgaW5mb3JtYXRpb24gKi8KICNk
ZWZpbmUgSUJfTUdNVF9STVBQX1ZFUlNJT04JCQkxCiAKQEAgLTI0Niw2ICsyNTUsNyBAQCBzdHJ1
Y3QgaWJfbWFkX3NlbmRfYnVmIHsKIAlpbnQJCQlzZWdfY291bnQ7CiAJaW50CQkJc2VnX3NpemU7
CiAJaW50CQkJdGltZW91dF9tczsKKwlpbnQJCQlyYW5kb21pemVkX3dhaXQ7CiAJaW50CQkJcmV0
cmllczsKIH07CiAK

--_002_4C2744E8AD2982428C5BFE523DF8CDCB49D45E3CB6MNEXMB1qlogic_--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
