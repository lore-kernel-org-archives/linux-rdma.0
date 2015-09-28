From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Expire sendonly joins (was Re: [PATCH rdma-rc 0/2] Add
 mechanism for ipoib neigh state change notifications)
Date: Mon, 28 Sep 2015 12:11:50 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1509281207250.31168@east.gentwo.org>
References: <1442486283-9699-1-git-send-email-ogerlitz@mellanox.com> <alpine.DEB.2.11.1509170940270.2052@east.gentwo.org> <CAJ3xEMg-h+J=cr2ddWvYUGU=MOBk4Aw-KtkeJutATH0Y17dnjg@mail.gmail.com> <alpine.DEB.2.20.1509241158420.21198@east.gentwo.org>
 <CAJ3xEMg2qQ3CXrfTrg=gUX2tQRuPnpxA-8PC98GzoF5iz=j5PQ@mail.gmail.com> <alpine.DEB.2.20.1509251140200.31792@east.gentwo.org> <CAJ3xEMj9kGaM6s+AqBQ_-ZTB_+cgDk3kefhq_O0V3PM120O9yQ@mail.gmail.com> <alpine.DEB.2.20.1509271136570.14486@east.gentwo.org>
 <5608282F.1020507@redhat.com> <alpine.DEB.2.20.1509272120090.18678@east.gentwo.org> <56095E6B.60509@redhat.com> <alpine.DEB.2.20.1509281046440.30710@east.gentwo.org> <560971DC.500@redhat.com>
Content-Type: multipart/mixed; BOUNDARY="8323329-67819438-1443460310=:31168"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <560971DC.500-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-67819438-1443460310=:31168
Content-Type: text/plain; charset=US-ASCII

Ok I refactored the whole thing to make it less invasive and keep more
functionality in ipoib_multicast.c. Since you are working on it it would
be best for you to have the newest version. I split this into two patches:
One preparatory and one that implements the actual logic.
Both attached. The patch that implements the join is inline here:


Subject: ipoib multicast: Expire MC groups when the address expires

Upon address expiration do the proper thing to also expire the
sendonly multicast group.

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Index: linux/drivers/infiniband/ulp/ipoib/ipoib.h
===================================================================
--- linux.orig/drivers/infiniband/ulp/ipoib/ipoib.h	2015-09-28 11:56:59.779764388 -0500
+++ linux/drivers/infiniband/ulp/ipoib/ipoib.h	2015-09-28 11:57:16.291764857 -0500
@@ -548,6 +548,8 @@

 int ipoib_mcast_attach(struct net_device *dev, u16 mlid,
 		       union ib_gid *mgid, int set_qkey);
+void ipoib_mcast_remove_mc_list(struct net_device *dev, struct list_head *list);
+void ipoib_mcast_detach_sendonly(struct ipoib_dev_priv *priv, u8 *mgid, struct list_head *list);

 int ipoib_init_qp(struct net_device *dev);
 int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca);
Index: linux/drivers/infiniband/ulp/ipoib/ipoib_main.c
===================================================================
--- linux.orig/drivers/infiniband/ulp/ipoib/ipoib_main.c	2015-09-28 11:56:59.779764388 -0500
+++ linux/drivers/infiniband/ulp/ipoib/ipoib_main.c	2015-09-28 11:56:59.775764388 -0500
@@ -1149,6 +1149,8 @@
 	unsigned long dt;
 	unsigned long flags;
 	int i;
+	LIST_HEAD(remove_list);
+	struct net_device *dev = priv->dev;

 	if (test_bit(IPOIB_STOP_NEIGH_GC, &priv->flags))
 		return;
@@ -1176,6 +1178,9 @@
 							  lockdep_is_held(&priv->lock))) != NULL) {
 			/* was the neigh idle for two GC periods */
 			if (time_after(neigh_obsolete, neigh->alive)) {
+
+				ipoib_mcast_detach_sendonly(priv, neigh->daddr + 4, &remove_list);
+
 				rcu_assign_pointer(*np,
 						   rcu_dereference_protected(neigh->hnext,
 									     lockdep_is_held(&priv->lock)));
@@ -1191,6 +1196,7 @@

 out_unlock:
 	spin_unlock_irqrestore(&priv->lock, flags);
+	ipoib_mcast_remove_mc_list(dev, &remove_list);
 }

 static void ipoib_reap_neigh(struct work_struct *work)
Index: linux/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
===================================================================
--- linux.orig/drivers/infiniband/ulp/ipoib/ipoib_multicast.c	2015-09-28 11:56:59.779764388 -0500
+++ linux/drivers/infiniband/ulp/ipoib/ipoib_multicast.c	2015-09-28 11:56:59.775764388 -0500
@@ -800,6 +800,23 @@
 	}
 }

+/*
+ * Check if this is a sendonly multicast group. If so remove it from the list and put it
+ * onto the given list for final removal.
+ */
+void ipoib_mcast_detach_sendonly(struct ipoib_dev_priv *priv, u8 *mgid, struct list_head *remove_list)
+{
+	struct ipoib_mcast *mcast;
+
+	/* Is this multicast ? */
+	if (mcast_auto_create && *mgid == 0xff) {
+		mcast = __ipoib_mcast_find(priv->dev, mgid);
+
+		if (mcast && test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
+			ipoib_detach_mc_group(priv, mcast, remove_list);
+	}
+}
+
 void ipoib_mcast_dev_flush(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);

--8323329-67819438-1443460310=:31168
Content-Type: text/plain; charset=US-ASCII; name=sendonly_prep_patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.20.1509281211500.31168-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Content-Description: Preparatory Patch
Content-Disposition: attachment; filename=sendonly_prep_patch

RnJvbTogQ2hyaXN0b3BoIExhbWV0ZXIgPGNsQGxpbnV4LmNvbT4NClN1Ympl
Y3Q6IGlwb2liIG11bHRpY2FzdDogRXh0cmFjdCB0d28gZnVuY3Rpb24gZnJv
bSBpcG9pYl9tY2FzdF9mbHVzaA0KDQpXZSBuZWVkIHRoZXNlIHR3byBmdW5j
dGlvbnMgbGF0ZXIgdG8gZG8gdGhlIGltcGxpY2l0IGxlYXZlIHdoZW4gdGhl
DQphZGRyZXNzIGhhbmRsZSBleHBpcmVzIHNvIHJlZmFjdG9yIHRoZSBjb2Rl
Lg0KDQpTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggTGFtZXRlciA8Y2xAbGlu
dXguY29tPg0KDQpJbmRleDogbGludXgvZHJpdmVycy9pbmZpbmliYW5kL3Vs
cC9pcG9pYi9pcG9pYl9tdWx0aWNhc3QuYw0KPT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQ0KLS0tIGxpbnV4Lm9yaWcvZHJpdmVycy9pbmZpbmliYW5kL3VscC9p
cG9pYi9pcG9pYl9tdWx0aWNhc3QuYwkyMDE1LTA5LTI4IDExOjIwOjA1LjM4
NzcwMTQ2MyAtMDUwMA0KKysrIGxpbnV4L2RyaXZlcnMvaW5maW5pYmFuZC91
bHAvaXBvaWIvaXBvaWJfbXVsdGljYXN0LmMJMjAxNS0wOS0yOCAxMToyMDo1
My44MTk3MDI4MzkgLTA1MDANCkBAIC03NzUsNiArNzc1LDMxIEBADQogCXNw
aW5fdW5sb2NrX2lycXJlc3RvcmUoJnByaXYtPmxvY2ssIGZsYWdzKTsNCiB9
DQogDQorLyoNCisgKiBEZXRhY2ggYSBtdWx0aWNhc3QgZ3JvdXAgZnJvbSB0
aGUgZGV2aWNlcyBtdWx0aWNhc3QgdHJlZSBhbmQgbW92ZSBpdA0KKyAqIHRv
IGEgbGlzdCBmb3IgZnV0dXJlIHJlbW92YWwNCisgKi8NCitzdGF0aWMgdm9p
ZCBpcG9pYl9kZXRhY2hfbWNfZ3JvdXAoc3RydWN0IGlwb2liX2Rldl9wcml2
ICpwcml2LA0KKwkJc3RydWN0IGlwb2liX21jYXN0ICptY2FzdCwgc3RydWN0
IGxpc3RfaGVhZCAqcmVtb3ZlX2xpc3QpDQorew0KKwlsaXN0X2RlbCgmbWNh
c3QtPmxpc3QpOw0KKwlyYl9lcmFzZSgmbWNhc3QtPnJiX25vZGUsICZwcml2
LT5tdWx0aWNhc3RfdHJlZSk7DQorCWxpc3RfYWRkX3RhaWwoJm1jYXN0LT5s
aXN0LCByZW1vdmVfbGlzdCk7DQorfQ0KKw0KKy8qDQorICogUmVtb3ZlIGEg
bGlzdCBvZiBtdWx0aWNhc3QgZ3JvdXBzIHRoYXQgaGFzIGJlZW4gZGV0YWNo
ZWQgYW5kIGZyZWUgdGhlbQ0KKyAqLw0KK3ZvaWQgaXBvaWJfbWNhc3RfcmVt
b3ZlX21jX2xpc3Qoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwgc3RydWN0IGxp
c3RfaGVhZCAqcmVtb3ZlX2xpc3QpDQorew0KKwlzdHJ1Y3QgaXBvaWJfbWNh
c3QgKm1jYXN0LCAqdG1jYXN0Ow0KKw0KKwlsaXN0X2Zvcl9lYWNoX2VudHJ5
X3NhZmUobWNhc3QsIHRtY2FzdCwgcmVtb3ZlX2xpc3QsIGxpc3QpIHsNCisJ
CWlwb2liX21jYXN0X2xlYXZlKGRldiwgbWNhc3QpOw0KKwkJaXBvaWJfbWNh
c3RfZnJlZShtY2FzdCk7DQorCX0NCit9DQorDQogdm9pZCBpcG9pYl9tY2Fz
dF9kZXZfZmx1c2goc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCiB7DQogCXN0
cnVjdCBpcG9pYl9kZXZfcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7
DQpAQCAtNzg2LDExICs4MTEsOCBAQA0KIA0KIAlzcGluX2xvY2tfaXJxc2F2
ZSgmcHJpdi0+bG9jaywgZmxhZ3MpOw0KIA0KLQlsaXN0X2Zvcl9lYWNoX2Vu
dHJ5X3NhZmUobWNhc3QsIHRtY2FzdCwgJnByaXYtPm11bHRpY2FzdF9saXN0
LCBsaXN0KSB7DQotCQlsaXN0X2RlbCgmbWNhc3QtPmxpc3QpOw0KLQkJcmJf
ZXJhc2UoJm1jYXN0LT5yYl9ub2RlLCAmcHJpdi0+bXVsdGljYXN0X3RyZWUp
Ow0KLQkJbGlzdF9hZGRfdGFpbCgmbWNhc3QtPmxpc3QsICZyZW1vdmVfbGlz
dCk7DQotCX0NCisJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKG1jYXN0LCB0
bWNhc3QsICZwcml2LT5tdWx0aWNhc3RfbGlzdCwgbGlzdCkNCisJCWlwb2li
X2RldGFjaF9tY19ncm91cChwcml2LCBtY2FzdCwgJnJlbW92ZV9saXN0KTsN
CiANCiAJaWYgKHByaXYtPmJyb2FkY2FzdCkgew0KIAkJcmJfZXJhc2UoJnBy
aXYtPmJyb2FkY2FzdC0+cmJfbm9kZSwgJnByaXYtPm11bHRpY2FzdF90cmVl
KTsNCkBAIC04MDgsMTAgKzgzMCw3IEBADQogCQlpZiAodGVzdF9iaXQoSVBP
SUJfTUNBU1RfRkxBR19CVVNZLCAmbWNhc3QtPmZsYWdzKSkNCiAJCQl3YWl0
X2Zvcl9jb21wbGV0aW9uKCZtY2FzdC0+ZG9uZSk7DQogDQotCWxpc3RfZm9y
X2VhY2hfZW50cnlfc2FmZShtY2FzdCwgdG1jYXN0LCAmcmVtb3ZlX2xpc3Qs
IGxpc3QpIHsNCi0JCWlwb2liX21jYXN0X2xlYXZlKGRldiwgbWNhc3QpOw0K
LQkJaXBvaWJfbWNhc3RfZnJlZShtY2FzdCk7DQotCX0NCisJaXBvaWJfbWNh
c3RfcmVtb3ZlX21jX2xpc3QoZGV2LCAmcmVtb3ZlX2xpc3QpOw0KIH0NCiAN
CiBzdGF0aWMgaW50IGlwb2liX21jYXN0X2FkZHJfaXNfdmFsaWQoY29uc3Qg
dTggKmFkZHIsIGNvbnN0IHU4ICpicm9hZGNhc3QpDQo=

--8323329-67819438-1443460310=:31168
Content-Type: text/plain; charset=US-ASCII; name=sendonly_join_on_address_expiration
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.20.1509281211501.31168-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Content-Description: Implement the join
Content-Disposition: attachment; filename=sendonly_join_on_address_expiration

U3ViamVjdDogaXBvaWIgbXVsdGljYXN0OiBFeHBpcmUgTUMgZ3JvdXBzIHdo
ZW4gdGhlIGFkZHJlc3MgZXhwaXJlcw0KDQpVcG9uIGFkZHJlc3MgZXhwaXJh
dGlvbiBkbyB0aGUgcHJvcGVyIHRoaW5nIHRvIGFsc28gZXhwaXJlIHRoZQ0K
c2VuZG9ubHkgbXVsdGljYXN0IGdyb3VwLg0KDQpTaWduZWQtb2ZmLWJ5OiBD
aHJpc3RvcGggTGFtZXRlciA8Y2xAbGludXguY29tPg0KDQpJbmRleDogbGlu
dXgvZHJpdmVycy9pbmZpbmliYW5kL3VscC9pcG9pYi9pcG9pYi5oDQo9PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09DQotLS0gbGludXgub3JpZy9kcml2ZXJzL2lu
ZmluaWJhbmQvdWxwL2lwb2liL2lwb2liLmgJMjAxNS0wOS0yOCAxMTo1Njo1
OS43Nzk3NjQzODggLTA1MDANCisrKyBsaW51eC9kcml2ZXJzL2luZmluaWJh
bmQvdWxwL2lwb2liL2lwb2liLmgJMjAxNS0wOS0yOCAxMTo1NzoxNi4yOTE3
NjQ4NTcgLTA1MDANCkBAIC01NDgsNiArNTQ4LDggQEANCiANCiBpbnQgaXBv
aWJfbWNhc3RfYXR0YWNoKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIHUxNiBt
bGlkLA0KIAkJICAgICAgIHVuaW9uIGliX2dpZCAqbWdpZCwgaW50IHNldF9x
a2V5KTsNCit2b2lkIGlwb2liX21jYXN0X3JlbW92ZV9tY19saXN0KHN0cnVj
dCBuZXRfZGV2aWNlICpkZXYsIHN0cnVjdCBsaXN0X2hlYWQgKmxpc3QpOw0K
K3ZvaWQgaXBvaWJfbWNhc3RfZGV0YWNoX3NlbmRvbmx5KHN0cnVjdCBpcG9p
Yl9kZXZfcHJpdiAqcHJpdiwgdTggKm1naWQsIHN0cnVjdCBsaXN0X2hlYWQg
Kmxpc3QpOw0KIA0KIGludCBpcG9pYl9pbml0X3FwKHN0cnVjdCBuZXRfZGV2
aWNlICpkZXYpOw0KIGludCBpcG9pYl90cmFuc3BvcnRfZGV2X2luaXQoc3Ry
dWN0IG5ldF9kZXZpY2UgKmRldiwgc3RydWN0IGliX2RldmljZSAqY2EpOw0K
SW5kZXg6IGxpbnV4L2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXBvaWIvaXBv
aWJfbWFpbi5jDQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQotLS0gbGludXgu
b3JpZy9kcml2ZXJzL2luZmluaWJhbmQvdWxwL2lwb2liL2lwb2liX21haW4u
YwkyMDE1LTA5LTI4IDExOjU2OjU5Ljc3OTc2NDM4OCAtMDUwMA0KKysrIGxp
bnV4L2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXBvaWIvaXBvaWJfbWFpbi5j
CTIwMTUtMDktMjggMTE6NTY6NTkuNzc1NzY0Mzg4IC0wNTAwDQpAQCAtMTE0
OSw2ICsxMTQ5LDggQEANCiAJdW5zaWduZWQgbG9uZyBkdDsNCiAJdW5zaWdu
ZWQgbG9uZyBmbGFnczsNCiAJaW50IGk7DQorCUxJU1RfSEVBRChyZW1vdmVf
bGlzdCk7DQorCXN0cnVjdCBuZXRfZGV2aWNlICpkZXYgPSBwcml2LT5kZXY7
DQogDQogCWlmICh0ZXN0X2JpdChJUE9JQl9TVE9QX05FSUdIX0dDLCAmcHJp
di0+ZmxhZ3MpKQ0KIAkJcmV0dXJuOw0KQEAgLTExNzYsNiArMTE3OCw5IEBA
DQogCQkJCQkJCSAgbG9ja2RlcF9pc19oZWxkKCZwcml2LT5sb2NrKSkpICE9
IE5VTEwpIHsNCiAJCQkvKiB3YXMgdGhlIG5laWdoIGlkbGUgZm9yIHR3byBH
QyBwZXJpb2RzICovDQogCQkJaWYgKHRpbWVfYWZ0ZXIobmVpZ2hfb2Jzb2xl
dGUsIG5laWdoLT5hbGl2ZSkpIHsNCisNCisJCQkJaXBvaWJfbWNhc3RfZGV0
YWNoX3NlbmRvbmx5KHByaXYsIG5laWdoLT5kYWRkciArIDQsICZyZW1vdmVf
bGlzdCk7DQorDQogCQkJCXJjdV9hc3NpZ25fcG9pbnRlcigqbnAsDQogCQkJ
CQkJICAgcmN1X2RlcmVmZXJlbmNlX3Byb3RlY3RlZChuZWlnaC0+aG5leHQs
DQogCQkJCQkJCQkJICAgICBsb2NrZGVwX2lzX2hlbGQoJnByaXYtPmxvY2sp
KSk7DQpAQCAtMTE5MSw2ICsxMTk2LDcgQEANCiANCiBvdXRfdW5sb2NrOg0K
IAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZwcml2LT5sb2NrLCBmbGFncyk7
DQorCWlwb2liX21jYXN0X3JlbW92ZV9tY19saXN0KGRldiwgJnJlbW92ZV9s
aXN0KTsNCiB9DQogDQogc3RhdGljIHZvaWQgaXBvaWJfcmVhcF9uZWlnaChz
dHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQpJbmRleDogbGludXgvZHJpdmVy
cy9pbmZpbmliYW5kL3VscC9pcG9pYi9pcG9pYl9tdWx0aWNhc3QuYw0KPT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PQ0KLS0tIGxpbnV4Lm9yaWcvZHJpdmVycy9p
bmZpbmliYW5kL3VscC9pcG9pYi9pcG9pYl9tdWx0aWNhc3QuYwkyMDE1LTA5
LTI4IDExOjU2OjU5Ljc3OTc2NDM4OCAtMDUwMA0KKysrIGxpbnV4L2RyaXZl
cnMvaW5maW5pYmFuZC91bHAvaXBvaWIvaXBvaWJfbXVsdGljYXN0LmMJMjAx
NS0wOS0yOCAxMTo1Njo1OS43NzU3NjQzODggLTA1MDANCkBAIC04MDAsNiAr
ODAwLDIzIEBADQogCX0NCiB9DQogDQorLyoNCisgKiBDaGVjayBpZiB0aGlz
IGlzIGEgc2VuZG9ubHkgbXVsdGljYXN0IGdyb3VwLiBJZiBzbyByZW1vdmUg
aXQgZnJvbSB0aGUgbGlzdCBhbmQgcHV0IGl0DQorICogb250byB0aGUgZ2l2
ZW4gbGlzdCBmb3IgZmluYWwgcmVtb3ZhbC4NCisgKi8NCit2b2lkIGlwb2li
X21jYXN0X2RldGFjaF9zZW5kb25seShzdHJ1Y3QgaXBvaWJfZGV2X3ByaXYg
KnByaXYsIHU4ICptZ2lkLCBzdHJ1Y3QgbGlzdF9oZWFkICpyZW1vdmVfbGlz
dCkNCit7DQorCXN0cnVjdCBpcG9pYl9tY2FzdCAqbWNhc3Q7DQorDQorCS8q
IElzIHRoaXMgbXVsdGljYXN0ID8gKi8NCisJaWYgKG1jYXN0X2F1dG9fY3Jl
YXRlICYmICptZ2lkID09IDB4ZmYpIHsNCisJCW1jYXN0ID0gX19pcG9pYl9t
Y2FzdF9maW5kKHByaXYtPmRldiwgbWdpZCk7DQorDQorCQlpZiAobWNhc3Qg
JiYgdGVzdF9iaXQoSVBPSUJfTUNBU1RfRkxBR19TRU5ET05MWSwgJm1jYXN0
LT5mbGFncykpDQorCQkJaXBvaWJfZGV0YWNoX21jX2dyb3VwKHByaXYsIG1j
YXN0LCByZW1vdmVfbGlzdCk7DQorCX0NCit9DQorDQogdm9pZCBpcG9pYl9t
Y2FzdF9kZXZfZmx1c2goc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCiB7DQog
CXN0cnVjdCBpcG9pYl9kZXZfcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRl
dik7DQo=

--8323329-67819438-1443460310=:31168--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
