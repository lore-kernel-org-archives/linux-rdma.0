From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V3] SA Busy Handling
Date: Thu, 2 Dec 2010 14:28:52 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF31E@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_4C2744E8AD2982428C5BFE523DF8CDCB4A208DF31EMNEXMB1qlogic_"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--_002_4C2744E8AD2982428C5BFE523DF8CDCB4A208DF31EMNEXMB1qlogic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Fixed the loss of the trap repress handling, which must have gotten lost so=
mewhere between May and now...

Hal - your formatting nit, when I looked at the patch file, I see the corre=
ct spacing around the '&&' in the if statement.

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
+#define IB_MGMT_MAD_STATUS_BAD_VERERSION                0x0004
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


--_002_4C2744E8AD2982428C5BFE523DF8CDCB4A208DF31EMNEXMB1qlogic_
Content-Type: application/octet-stream; name="sa_busy_20101202.patch"
Content-Description: sa_busy_20101202.patch
Content-Disposition: attachment; filename="sa_busy_20101202.patch"; size=4797;
	creation-date="Thu, 02 Dec 2010 14:21:59 GMT";
	modification-date="Thu, 02 Dec 2010 14:28:03 GMT"
Content-Transfer-Encoding: base64

VGhpcyBwYXRjaCBwcm92aWRlcyBhIG5ldyBtb2R1bGUgcGFyYW1ldGVyIGZvciBpYl9tYWQgdGhh
dCB0ZWxscyBpYl9tYWQgdG8gdHJlYXQgQlVTWSByZXNwb25zZXMgYXMgDQp0aW1lb3V0cy4NCg0K
cGFybTogICAgICAgICAgIHRyZWF0X2J1c3lfYXNfdGltZW91dDpXaGVuIHRydWUsIHRyZWF0IEJV
U1kgcmVzcG9uc2VzIGFzIGlmIHRoZXkgd2VyZSB0aW1lb3V0cy4gKGludCkNCg0KV2hlbiB0aGlz
IHBhcmFtZXRlciBpcyB0cnVlLCBpYl9tYWQgd2lsbCB1bmlsYXRlcmFsbHkgdHJlYXQgQlVTWSBy
ZXNwb25zZXMgYXMgdGltZW91dHMgcmVnYXJkbGVzcyANCm9mIHRoZSBkZXNpcmVkIGJlaGF2aW9y
IG9mIHRoZSBjYWxsZXIuDQoNCkluIGFkZGl0aW9uLCB0aGlzIHBhdGNoIGFsc28gcHJvdmlkZXMg
Y2hhbmdlcyB0byBpYl9tYWRfc2VuZF9idWYgdG8gYWxsb3cgc2VuZGVycyBvZiBNQUQgcmVxdWVz
dHMNCnRvIHJlcXVlc3QgdGhpcyBiZWhhdmlvciBldmVuIGlmIHRoZSBwYXJhbWV0ZXIgaXMgbm90
IHNldC4gVGhlIHBhdGNoIGRvZXMgTk9UIHByb3ZpZGUgY2hhbmdlcyB0byANCmliX3VtYWQgdG8g
YWxsb3cgdXNlciBhcHBzIHRvIHNlbGVjdCB0aGlzIGZ1bmN0aW9uYWxpdHkuDQoNClNpZ25lZC1v
ZmYtYnk6IE1pY2hhZWwgSGVpbnogPG1pY2hhZWwuaGVpbnpAcWxvZ2ljLmNvbT4NCi0tLQ0KDQog
ZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvbWFkLmMgICAgICB8ICAgMjIgKysrKysrKysrKysrKysr
KysrKysrKw0KIGRyaXZlcnMvaW5maW5pYmFuZC9jb3JlL21hZF9wcml2LmggfCAgICAxICsNCiBp
bmNsdWRlL3JkbWEvaWJfbWFkLmggICAgICAgICAgICAgIHwgICAxMCArKysrKysrKysrDQogMyBm
aWxlcyBjaGFuZ2VkLCAzMyBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvbWFkLmMgYi9kcml2ZXJzL2luZmluaWJhbmQv
Y29yZS9tYWQuYw0KaW5kZXggNjRlNjYwYy4uMmUxMDNlZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
aW5maW5pYmFuZC9jb3JlL21hZC5jDQorKysgYi9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9tYWQu
Yw0KQEAgLTU0LDYgKzU0LDEwIEBAIE1PRFVMRV9QQVJNX0RFU0Moc2VuZF9xdWV1ZV9zaXplLCAi
U2l6ZSBvZiBzZW5kIHF1ZXVlIGluIG51bWJlciBvZiB3b3JrIHJlcXVlc3RzDQogbW9kdWxlX3Bh
cmFtX25hbWVkKHJlY3ZfcXVldWVfc2l6ZSwgbWFkX3JlY3ZxX3NpemUsIGludCwgMDQ0NCk7DQog
TU9EVUxFX1BBUk1fREVTQyhyZWN2X3F1ZXVlX3NpemUsICJTaXplIG9mIHJlY2VpdmUgcXVldWUg
aW4gbnVtYmVyIG9mIHdvcmsgcmVxdWVzdHMiKTsNCiANCitpbnQgbWFkX3dhaXRfb25fYnVzeSA9
IDA7DQorbW9kdWxlX3BhcmFtX25hbWVkKHRyZWF0X2J1c3lfYXNfdGltZW91dCwgbWFkX3dhaXRf
b25fYnVzeSwgaW50LCAwNDQ0KTsNCitNT0RVTEVfUEFSTV9ERVNDKHRyZWF0X2J1c3lfYXNfdGlt
ZW91dCwgIldoZW4gdHJ1ZSwgdHJlYXQgQlVTWSByZXNwb25zZXMgYXMgaWYgdGhleSB3ZXJlIHRp
bWVvdXRzLiIpOw0KKw0KIHN0YXRpYyBzdHJ1Y3Qga21lbV9jYWNoZSAqaWJfbWFkX2NhY2hlOw0K
IA0KIHN0YXRpYyBzdHJ1Y3QgbGlzdF9oZWFkIGliX21hZF9wb3J0X2xpc3Q7DQpAQCAtMTEyMCw2
ICsxMTI0LDcgQEAgaW50IGliX3Bvc3Rfc2VuZF9tYWQoc3RydWN0IGliX21hZF9zZW5kX2J1ZiAq
c2VuZF9idWYsDQogCQltYWRfc2VuZF93ci0+dGltZW91dCA9IG1zZWNzX3RvX2ppZmZpZXMoc2Vu
ZF9idWYtPnRpbWVvdXRfbXMpOw0KIAkJbWFkX3NlbmRfd3ItPm1heF9yZXRyaWVzID0gc2VuZF9i
dWYtPnJldHJpZXM7DQogCQltYWRfc2VuZF93ci0+cmV0cmllc19sZWZ0ID0gc2VuZF9idWYtPnJl
dHJpZXM7DQorCQltYWRfc2VuZF93ci0+d2FpdF9vbl9idXN5ID0gc2VuZF9idWYtPndhaXRfb25f
YnVzeSB8fCBtYWRfd2FpdF9vbl9idXN5Ow0KIAkJc2VuZF9idWYtPnJldHJpZXMgPSAwOw0KIAkJ
LyogUmVmZXJlbmNlIGZvciB3b3JrIHJlcXVlc3QgdG8gUVAgKyByZXNwb25zZSAqLw0KIAkJbWFk
X3NlbmRfd3ItPnJlZmNvdW50ID0gMSArIChtYWRfc2VuZF93ci0+dGltZW91dCA+IDApOw0KQEAg
LTE4MjgsNiArMTgzMyw5IEBAIHN0YXRpYyB2b2lkIGliX21hZF9jb21wbGV0ZV9yZWN2KHN0cnVj
dCBpYl9tYWRfYWdlbnRfcHJpdmF0ZSAqbWFkX2FnZW50X3ByaXYsDQogDQogCS8qIENvbXBsZXRl
IGNvcnJlc3BvbmRpbmcgcmVxdWVzdCAqLw0KIAlpZiAoaWJfcmVzcG9uc2VfbWFkKG1hZF9yZWN2
X3djLT5yZWN2X2J1Zi5tYWQpKSB7DQorCQl1MTYgYnVzeSA9IGJlMTZfdG9fY3B1KG1hZF9yZWN2
X3djLT5yZWN2X2J1Zi5tYWQtPm1hZF9oZHIuc3RhdHVzKSAmDQorCQkJCQkJCSAgIElCX01HTVRf
TUFEX1NUQVRVU19CVVNZOw0KKw0KIAkJc3Bpbl9sb2NrX2lycXNhdmUoJm1hZF9hZ2VudF9wcml2
LT5sb2NrLCBmbGFncyk7DQogCQltYWRfc2VuZF93ciA9IGliX2ZpbmRfc2VuZF9tYWQobWFkX2Fn
ZW50X3ByaXYsIG1hZF9yZWN2X3djKTsNCiAJCWlmICghbWFkX3NlbmRfd3IpIHsNCkBAIC0xODM2
LDYgKzE4NDQsMjAgQEAgc3RhdGljIHZvaWQgaWJfbWFkX2NvbXBsZXRlX3JlY3Yoc3RydWN0IGli
X21hZF9hZ2VudF9wcml2YXRlICptYWRfYWdlbnRfcHJpdiwNCiAJCQlkZXJlZl9tYWRfYWdlbnQo
bWFkX2FnZW50X3ByaXYpOw0KIAkJCXJldHVybjsNCiAJCX0NCisNCisJCXByaW50ayhLRVJOX0RF
QlVHIFBGWCAiQ29tcGxldGluZyByZWN2ICVwOiBidXN5ID0gJWQsIHJldHJpZXNfbGVmdCA9ICVk
LCB3YWl0X29uX2J1c3kgPSAlZFxuIiwNCisJCQkgICBtYWRfc2VuZF93ciwgYnVzeSwgbWFkX3Nl
bmRfd3ItPnJldHJpZXNfbGVmdCwgbWFkX3NlbmRfd3ItPndhaXRfb25fYnVzeSk7DQorDQorCQlp
ZiAoYnVzeSAmJiBtYWRfc2VuZF93ci0+cmV0cmllc19sZWZ0ICYmIG1hZF9zZW5kX3dyLT53YWl0
X29uX2J1c3kgJiYNCisJCSAgIChtYWRfcmVjdl93Yy0+cmVjdl9idWYubWFkLT5tYWRfaGRyLm1l
dGhvZCAhPSBJQl9NR01UX01FVEhPRF9UUkFQX1JFUFJFU1MpKSB7DQorCQkJLyogSnVzdCBsZXQg
dGhlIHF1ZXJ5IHRpbWVvdXQgYW5kIGhhdmUgaXQgcmVxdWV1ZWQgbGF0ZXIgKi8NCisJCQlzcGlu
X3VubG9ja19pcnFyZXN0b3JlKCZtYWRfYWdlbnRfcHJpdi0+bG9jaywgZmxhZ3MpOw0KKwkJCWli
X2ZyZWVfcmVjdl9tYWQobWFkX3JlY3Zfd2MpOw0KKwkJCWRlcmVmX21hZF9hZ2VudChtYWRfYWdl
bnRfcHJpdik7DQorCQkJcHJpbnRrKEtFUk5fSU5GTyBQRlggIlNBL1NNIHJlc3BvbmRlZCBNQURf
U1RBVFVTX0JVU1kuIEFsbG93aW5nIHJlcXVlc3QgdG8gdGltZSBvdXQuXG4iKTsNCisJCQlyZXR1
cm47DQorCQl9DQorDQogCQlpYl9tYXJrX21hZF9kb25lKG1hZF9zZW5kX3dyKTsNCiAJCXNwaW5f
dW5sb2NrX2lycXJlc3RvcmUoJm1hZF9hZ2VudF9wcml2LT5sb2NrLCBmbGFncyk7DQogDQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvbWFkX3ByaXYuaCBiL2RyaXZlcnMvaW5m
aW5pYmFuZC9jb3JlL21hZF9wcml2LmgNCmluZGV4IDhiNGRmMGEuLmI2NDc3Y2YgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9tYWRfcHJpdi5oDQorKysgYi9kcml2ZXJzL2lu
ZmluaWJhbmQvY29yZS9tYWRfcHJpdi5oDQpAQCAtMTM1LDYgKzEzNSw3IEBAIHN0cnVjdCBpYl9t
YWRfc2VuZF93cl9wcml2YXRlIHsNCiAJdW5zaWduZWQgbG9uZyB0aW1lb3V0Ow0KIAlpbnQgbWF4
X3JldHJpZXM7DQogCWludCByZXRyaWVzX2xlZnQ7DQorCWludCB3YWl0X29uX2J1c3k7DQogCWlu
dCByZXRyeTsNCiAJaW50IHJlZmNvdW50Ow0KIAllbnVtIGliX3djX3N0YXR1cyBzdGF0dXM7DQpk
aWZmIC0tZ2l0IGEvaW5jbHVkZS9yZG1hL2liX21hZC5oIGIvaW5jbHVkZS9yZG1hL2liX21hZC5o
DQppbmRleCBkM2I5NDAxLi5mYWRjMmMzIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9yZG1hL2liX21h
ZC5oDQorKysgYi9pbmNsdWRlL3JkbWEvaWJfbWFkLmgNCkBAIC03Nyw2ICs3NywxNSBAQA0KIA0K
ICNkZWZpbmUgSUJfTUdNVF9NQVhfTUVUSE9EUwkJCTEyOA0KIA0KKy8qIE1BRCBTdGF0dXMgZmll
bGQgYml0IG1hc2tzICovDQorI2RlZmluZSBJQl9NR01UX01BRF9TVEFUVVNfU1VDQ0VTUyAgICAg
ICAgICAgICAgICAgICAgICAweDAwMDANCisjZGVmaW5lIElCX01HTVRfTUFEX1NUQVRVU19CVVNZ
ICAgICAgICAgICAgICAgICAgICAgICAgIDB4MDAwMQ0KKyNkZWZpbmUgSUJfTUdNVF9NQURfU1RB
VFVTX1JFRElSRUNUX1JFUUQgICAgICAgICAgICAgICAgMHgwMDAyDQorI2RlZmluZSBJQl9NR01U
X01BRF9TVEFUVVNfQkFEX1ZFUkVSU0lPTiAgICAgICAgICAgICAgICAweDAwMDQNCisjZGVmaW5l
IElCX01HTVRfTUFEX1NUQVRVU19VTlNVUFBPUlRFRF9NRVRIT0QgICAgICAgICAgIDB4MDAwOA0K
KyNkZWZpbmUgSUJfTUdNVF9NQURfU1RBVFVTX1VOU1VQUE9SVEVEX01FVEhPRF9BVFRSSUIgICAg
MHgwMDBjDQorI2RlZmluZSBJQl9NR01UX01BRF9TVEFUVVNfSU5WQUxJRF9BVFRSSUJfVkFMVUUg
ICAgICAgICAweDAwMWMNCisNCiAvKiBSTVBQIGluZm9ybWF0aW9uICovDQogI2RlZmluZSBJQl9N
R01UX1JNUFBfVkVSU0lPTgkJCTENCiANCkBAIC0yNDYsNiArMjU1LDcgQEAgc3RydWN0IGliX21h
ZF9zZW5kX2J1ZiB7DQogCWludAkJCXNlZ19jb3VudDsNCiAJaW50CQkJc2VnX3NpemU7DQogCWlu
dAkJCXRpbWVvdXRfbXM7DQorCWludAkJCXdhaXRfb25fYnVzeTsNCiAJaW50CQkJcmV0cmllczsN
CiB9Ow0KIA0K

--_002_4C2744E8AD2982428C5BFE523DF8CDCB4A208DF31EMNEXMB1qlogic_--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
