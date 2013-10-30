From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [ceph-users] Help needed porting Ceph to RSockets
Date: Wed, 30 Oct 2013 23:25:12 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CF3072@ORSMSX109.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237388CA7C88@ORSMSX109.amr.corp.intel.com>
 <20130910154847.3fb7dd02@doppio>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_1828884A29C6694DAF28B7E6B8A8237388CF3072ORSMSX109amrcor_"
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20130910154847.3fb7dd02@doppio>
Content-Language: en-US
Sender: ceph-devel-owner@vger.kernel.org
To: Andreas Bluemle <andreas.bluemle@itxperts.de>
Cc: Matthew Anderson <manderson8787@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--_002_1828884A29C6694DAF28B7E6B8A8237388CF3072ORSMSX109amrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Sorry it took so long to get to this.

> after some more analysis and debugging, I found
> workarounds for my problems; I have added these workarounds
> to the last version of the patch for the poll problem by Sean;
> see the attachment to this posting.
>=20
> The shutdown() operations below are all SHUT_RDWR.
>=20
> 1. shutdown() on side A of a connection waits for close() on side B
>=20
>    With rsockets, when a shutdown is done on side A of a socket
>    connection, then the shutdown will only return after side B
>    has done a close() on its end of the connection.
>
>    This is different from TCP/IP sockets: there a shutdown will cause
>    the other end to terminate the connection at the TCP level
>    instantly. The socket changes state into CLOSE_WAIT, which indicates
>    that the application level close is outstanding.
>=20
>    In the attached patch, the workaround is in rs_poll_cq(),
>    case RS_OP_CTRL, where for a RS_CTRL_DISCONNECT the rshutdown()
>    is called on side B; this will cause the termination of the
>    socket connection to acknowledged to side A and the shutdown()
>    there can now terminate.

rsockets should behave similar to sockets on this.  I believe that I introd=
uced the problem with my patch to fix the shutdown hang.  The line in quest=
ion was adding rdma_disconnect() in the rshutdown call.  I replaced the dis=
connect call with one that simply transitions the underlying QP into an err=
or state.

> 2. double (multiple) shutdown on side A: delay on 2nd shutdown
>=20
>    When an application does a shutdown() of side A and does a 2nd
>    shutdown() shortly after (for whatever reason) then the
>    return of the 2nd shutdown() is delayed by 2 seconds.
>=20
>    The delay happens in rdma_disconnect(), when this is called
>    from rshutdown() in the case that the rsocket state is
>    rs_disconnected.
>=20
>    Even if it could be considered as a bug if an application
>    calls shutdown() twice on the same socket, it still
>    does not make sense to delay that 2nd call to shutdown().

I'd like to avoid calling shutdown internally on the user's behalf.  The in=
ternal shutdown may be the reason shutdown ends up being called twice.

I don't understand why you see a 2 second delay, but hopefully removing the=
 overhead of the full rdma_disconnect call fixes things.
=20
Can you please try the attached patch in place of all previous patches?

Thanks
- Sean


rsockets: Handle race between rshutdown and rpoll

From: Sean Hefty <sean.hefty@intel.com>

Signed-off-by: Sean Hefty <sean.hefty@intel.com>
---
 src/cma.c     |   23 +++++++++++++----------
 src/cma.h     |    1 +
 src/rsocket.c |   35 +++++++++++++++++++++++++----------
 3 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index 374844c..4f41879 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -1543,22 +1543,25 @@ int rdma_notify(struct rdma_cm_id *id, enum ibv_eve=
nt_type event)
 	return 0;
 }
=20
-int rdma_disconnect(struct rdma_cm_id *id)
+int ucma_shutdown(struct rdma_cm_id *id)
 {
-	struct ucma_abi_disconnect cmd;
-	struct cma_id_private *id_priv;
-	int ret;
-
 	switch (id->verbs->device->transport_type) {
 	case IBV_TRANSPORT_IB:
-		ret =3D ucma_modify_qp_err(id);
-		break;
+		return ucma_modify_qp_err(id);
 	case IBV_TRANSPORT_IWARP:
-		ret =3D ucma_modify_qp_sqd(id);
-		break;
+		return ucma_modify_qp_sqd(id);
 	default:
-		ret =3D ERR(EINVAL);
+		return ERR(EINVAL);
 	}
+}
+
+int rdma_disconnect(struct rdma_cm_id *id)
+{
+	struct ucma_abi_disconnect cmd;
+	struct cma_id_private *id_priv;
+	int ret;
+
+	ret =3D ucma_shutdown(id);
 	if (ret)
 		return ret;
=20
diff --git a/src/cma.h b/src/cma.h
index e944a9a..4c991b4 100644
--- a/src/cma.h
+++ b/src/cma.h
@@ -150,6 +150,7 @@ void ucma_set_sid(enum rdma_port_space ps, struct socka=
ddr *addr,
 		  struct sockaddr_ib *sib);
 int ucma_max_qpsize(struct rdma_cm_id *id);
 int ucma_complete(struct rdma_cm_id *id);
+int ucma_shutdown(struct rdma_cm_id *id);
=20
 static inline int ERR(int err)
 {
diff --git a/src/rsocket.c b/src/rsocket.c
index d544dd0..c7a491b 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -1822,7 +1822,12 @@ static int rs_poll_cq(struct rsocket *rs)
 					rs->state =3D rs_disconnected;
 					return 0;
 				} else if (rs_msg_data(msg) =3D=3D RS_CTRL_SHUTDOWN) {
-					rs->state &=3D ~rs_readable;
+					if (rs->state & rs_writable) {
+						rs->state &=3D ~rs_readable;
+					} else {
+						rs->state =3D rs_disconnected;
+						return 0;
+					}
 				}
 				break;
 			case RS_OP_WRITE:
@@ -2948,10 +2953,12 @@ static int rs_poll_events(struct pollfd *rfds, stru=
ct pollfd *fds, nfds_t nfds)
=20
 		rs =3D idm_lookup(&idm, fds[i].fd);
 		if (rs) {
+			fastlock_acquire(&rs->cq_wait_lock);
 			if (rs->type =3D=3D SOCK_STREAM)
 				rs_get_cq_event(rs);
 			else
 				ds_get_cq_event(rs);
+			fastlock_release(&rs->cq_wait_lock);
 			fds[i].revents =3D rs_poll_rs(rs, fds[i].events, 1, rs_poll_all);
 		} else {
 			fds[i].revents =3D rfds[i].revents;
@@ -3098,7 +3105,8 @@ int rselect(int nfds, fd_set *readfds, fd_set *writef=
ds,
=20
 /*
  * For graceful disconnect, notify the remote side that we're
- * disconnecting and wait until all outstanding sends complete.
+ * disconnecting and wait until all outstanding sends complete, provided
+ * that the remote side has not sent a disconnect message.
  */
 int rshutdown(int socket, int how)
 {
@@ -3106,11 +3114,6 @@ int rshutdown(int socket, int how)
 	int ctrl, ret =3D 0;
=20
 	rs =3D idm_at(&idm, socket);
-	if (how =3D=3D SHUT_RD) {
-		rs->state &=3D ~rs_readable;
-		return 0;
-	}
-
 	if (rs->fd_flags & O_NONBLOCK)
 		rs_set_nonblocking(rs, 0);
=20
@@ -3118,15 +3121,20 @@ int rshutdown(int socket, int how)
 		if (how =3D=3D SHUT_RDWR) {
 			ctrl =3D RS_CTRL_DISCONNECT;
 			rs->state &=3D ~(rs_readable | rs_writable);
-		} else {
+		} else if (how =3D=3D SHUT_WR) {
 			rs->state &=3D ~rs_writable;
 			ctrl =3D (rs->state & rs_readable) ?
 				RS_CTRL_SHUTDOWN : RS_CTRL_DISCONNECT;
+		} else {
+			rs->state &=3D ~rs_readable;
+			if (rs->state & rs_writable)
+				goto out;
+			ctrl =3D RS_CTRL_DISCONNECT;
 		}
 		if (!rs->ctrl_avail) {
 			ret =3D rs_process_cq(rs, 0, rs_conn_can_send_ctrl);
 			if (ret)
-				return ret;
+				goto out;
 		}
=20
 		if ((rs->state & rs_connected) && rs->ctrl_avail) {
@@ -3138,10 +3146,17 @@ int rshutdown(int socket, int how)
 	if (rs->state & rs_connected)
 		rs_process_cq(rs, 0, rs_conn_all_sends_done);
=20
+out:
 	if ((rs->fd_flags & O_NONBLOCK) && (rs->state & rs_connected))
 		rs_set_nonblocking(rs, rs->fd_flags);
=20
-	return 0;
+	if (rs->state & rs_disconnected) {
+		/* Generate event by flushing receives to unblock rpoll */
+		ibv_req_notify_cq(rs->cm_id->recv_cq, 0);
+		ucma_shutdown(rs->cm_id);
+	}
+
+	return ret;
 }
=20
 static void ds_shutdown(struct rsocket *rs)



--_002_1828884A29C6694DAF28B7E6B8A8237388CF3072ORSMSX109amrcor_
Content-Type: application/octet-stream; name="shutdown"
Content-Description: shutdown
Content-Disposition: attachment; filename="shutdown"; size=4327;
	creation-date="Wed, 30 Oct 2013 23:22:43 GMT";
	modification-date="Wed, 30 Oct 2013 23:22:20 GMT"
Content-Transfer-Encoding: base64

cnNvY2tldHM6IEhhbmRsZSByYWNlIGJldHdlZW4gcnNodXRkb3duIGFuZCBycG9sbAoKRnJvbTog
U2VhbiBIZWZ0eSA8c2Vhbi5oZWZ0eUBpbnRlbC5jb20+CgpTaWduZWQtb2ZmLWJ5OiBTZWFuIEhl
ZnR5IDxzZWFuLmhlZnR5QGludGVsLmNvbT4KLS0tCiBzcmMvY21hLmMgICAgIHwgICAyMyArKysr
KysrKysrKysrLS0tLS0tLS0tLQogc3JjL2NtYS5oICAgICB8ICAgIDEgKwogc3JjL3Jzb2NrZXQu
YyB8ICAgMzUgKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0KIDMgZmlsZXMgY2hh
bmdlZCwgMzkgaW5zZXJ0aW9ucygrKSwgMjAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvc3Jj
L2NtYS5jIGIvc3JjL2NtYS5jCmluZGV4IDM3NDg0NGMuLjRmNDE4NzkgMTAwNjQ0Ci0tLSBhL3Ny
Yy9jbWEuYworKysgYi9zcmMvY21hLmMKQEAgLTE1NDMsMjIgKzE1NDMsMjUgQEAgaW50IHJkbWFf
bm90aWZ5KHN0cnVjdCByZG1hX2NtX2lkICppZCwgZW51bSBpYnZfZXZlbnRfdHlwZSBldmVudCkK
IAlyZXR1cm4gMDsKIH0KIAotaW50IHJkbWFfZGlzY29ubmVjdChzdHJ1Y3QgcmRtYV9jbV9pZCAq
aWQpCitpbnQgdWNtYV9zaHV0ZG93bihzdHJ1Y3QgcmRtYV9jbV9pZCAqaWQpCiB7Ci0Jc3RydWN0
IHVjbWFfYWJpX2Rpc2Nvbm5lY3QgY21kOwotCXN0cnVjdCBjbWFfaWRfcHJpdmF0ZSAqaWRfcHJp
djsKLQlpbnQgcmV0OwotCiAJc3dpdGNoIChpZC0+dmVyYnMtPmRldmljZS0+dHJhbnNwb3J0X3R5
cGUpIHsKIAljYXNlIElCVl9UUkFOU1BPUlRfSUI6Ci0JCXJldCA9IHVjbWFfbW9kaWZ5X3FwX2Vy
cihpZCk7Ci0JCWJyZWFrOworCQlyZXR1cm4gdWNtYV9tb2RpZnlfcXBfZXJyKGlkKTsKIAljYXNl
IElCVl9UUkFOU1BPUlRfSVdBUlA6Ci0JCXJldCA9IHVjbWFfbW9kaWZ5X3FwX3NxZChpZCk7Ci0J
CWJyZWFrOworCQlyZXR1cm4gdWNtYV9tb2RpZnlfcXBfc3FkKGlkKTsKIAlkZWZhdWx0OgotCQly
ZXQgPSBFUlIoRUlOVkFMKTsKKwkJcmV0dXJuIEVSUihFSU5WQUwpOwogCX0KK30KKworaW50IHJk
bWFfZGlzY29ubmVjdChzdHJ1Y3QgcmRtYV9jbV9pZCAqaWQpCit7CisJc3RydWN0IHVjbWFfYWJp
X2Rpc2Nvbm5lY3QgY21kOworCXN0cnVjdCBjbWFfaWRfcHJpdmF0ZSAqaWRfcHJpdjsKKwlpbnQg
cmV0OworCisJcmV0ID0gdWNtYV9zaHV0ZG93bihpZCk7CiAJaWYgKHJldCkKIAkJcmV0dXJuIHJl
dDsKIApkaWZmIC0tZ2l0IGEvc3JjL2NtYS5oIGIvc3JjL2NtYS5oCmluZGV4IGU5NDRhOWEuLjRj
OTkxYjQgMTAwNjQ0Ci0tLSBhL3NyYy9jbWEuaAorKysgYi9zcmMvY21hLmgKQEAgLTE1MCw2ICsx
NTAsNyBAQCB2b2lkIHVjbWFfc2V0X3NpZChlbnVtIHJkbWFfcG9ydF9zcGFjZSBwcywgc3RydWN0
IHNvY2thZGRyICphZGRyLAogCQkgIHN0cnVjdCBzb2NrYWRkcl9pYiAqc2liKTsKIGludCB1Y21h
X21heF9xcHNpemUoc3RydWN0IHJkbWFfY21faWQgKmlkKTsKIGludCB1Y21hX2NvbXBsZXRlKHN0
cnVjdCByZG1hX2NtX2lkICppZCk7CitpbnQgdWNtYV9zaHV0ZG93bihzdHJ1Y3QgcmRtYV9jbV9p
ZCAqaWQpOwogCiBzdGF0aWMgaW5saW5lIGludCBFUlIoaW50IGVycikKIHsKZGlmZiAtLWdpdCBh
L3NyYy9yc29ja2V0LmMgYi9zcmMvcnNvY2tldC5jCmluZGV4IGQ1NDRkZDAuLmM3YTQ5MWIgMTAw
NjQ0Ci0tLSBhL3NyYy9yc29ja2V0LmMKKysrIGIvc3JjL3Jzb2NrZXQuYwpAQCAtMTgyMiw3ICsx
ODIyLDEyIEBAIHN0YXRpYyBpbnQgcnNfcG9sbF9jcShzdHJ1Y3QgcnNvY2tldCAqcnMpCiAJCQkJ
CXJzLT5zdGF0ZSA9IHJzX2Rpc2Nvbm5lY3RlZDsKIAkJCQkJcmV0dXJuIDA7CiAJCQkJfSBlbHNl
IGlmIChyc19tc2dfZGF0YShtc2cpID09IFJTX0NUUkxfU0hVVERPV04pIHsKLQkJCQkJcnMtPnN0
YXRlICY9IH5yc19yZWFkYWJsZTsKKwkJCQkJaWYgKHJzLT5zdGF0ZSAmIHJzX3dyaXRhYmxlKSB7
CisJCQkJCQlycy0+c3RhdGUgJj0gfnJzX3JlYWRhYmxlOworCQkJCQl9IGVsc2UgeworCQkJCQkJ
cnMtPnN0YXRlID0gcnNfZGlzY29ubmVjdGVkOworCQkJCQkJcmV0dXJuIDA7CisJCQkJCX0KIAkJ
CQl9CiAJCQkJYnJlYWs7CiAJCQljYXNlIFJTX09QX1dSSVRFOgpAQCAtMjk0OCwxMCArMjk1Mywx
MiBAQCBzdGF0aWMgaW50IHJzX3BvbGxfZXZlbnRzKHN0cnVjdCBwb2xsZmQgKnJmZHMsIHN0cnVj
dCBwb2xsZmQgKmZkcywgbmZkc190IG5mZHMpCiAKIAkJcnMgPSBpZG1fbG9va3VwKCZpZG0sIGZk
c1tpXS5mZCk7CiAJCWlmIChycykgeworCQkJZmFzdGxvY2tfYWNxdWlyZSgmcnMtPmNxX3dhaXRf
bG9jayk7CiAJCQlpZiAocnMtPnR5cGUgPT0gU09DS19TVFJFQU0pCiAJCQkJcnNfZ2V0X2NxX2V2
ZW50KHJzKTsKIAkJCWVsc2UKIAkJCQlkc19nZXRfY3FfZXZlbnQocnMpOworCQkJZmFzdGxvY2tf
cmVsZWFzZSgmcnMtPmNxX3dhaXRfbG9jayk7CiAJCQlmZHNbaV0ucmV2ZW50cyA9IHJzX3BvbGxf
cnMocnMsIGZkc1tpXS5ldmVudHMsIDEsIHJzX3BvbGxfYWxsKTsKIAkJfSBlbHNlIHsKIAkJCWZk
c1tpXS5yZXZlbnRzID0gcmZkc1tpXS5yZXZlbnRzOwpAQCAtMzA5OCw3ICszMTA1LDggQEAgaW50
IHJzZWxlY3QoaW50IG5mZHMsIGZkX3NldCAqcmVhZGZkcywgZmRfc2V0ICp3cml0ZWZkcywKIAog
LyoKICAqIEZvciBncmFjZWZ1bCBkaXNjb25uZWN0LCBub3RpZnkgdGhlIHJlbW90ZSBzaWRlIHRo
YXQgd2UncmUKLSAqIGRpc2Nvbm5lY3RpbmcgYW5kIHdhaXQgdW50aWwgYWxsIG91dHN0YW5kaW5n
IHNlbmRzIGNvbXBsZXRlLgorICogZGlzY29ubmVjdGluZyBhbmQgd2FpdCB1bnRpbCBhbGwgb3V0
c3RhbmRpbmcgc2VuZHMgY29tcGxldGUsIHByb3ZpZGVkCisgKiB0aGF0IHRoZSByZW1vdGUgc2lk
ZSBoYXMgbm90IHNlbnQgYSBkaXNjb25uZWN0IG1lc3NhZ2UuCiAgKi8KIGludCByc2h1dGRvd24o
aW50IHNvY2tldCwgaW50IGhvdykKIHsKQEAgLTMxMDYsMTEgKzMxMTQsNiBAQCBpbnQgcnNodXRk
b3duKGludCBzb2NrZXQsIGludCBob3cpCiAJaW50IGN0cmwsIHJldCA9IDA7CiAKIAlycyA9IGlk
bV9hdCgmaWRtLCBzb2NrZXQpOwotCWlmIChob3cgPT0gU0hVVF9SRCkgewotCQlycy0+c3RhdGUg
Jj0gfnJzX3JlYWRhYmxlOwotCQlyZXR1cm4gMDsKLQl9Ci0KIAlpZiAocnMtPmZkX2ZsYWdzICYg
T19OT05CTE9DSykKIAkJcnNfc2V0X25vbmJsb2NraW5nKHJzLCAwKTsKIApAQCAtMzExOCwxNSAr
MzEyMSwyMCBAQCBpbnQgcnNodXRkb3duKGludCBzb2NrZXQsIGludCBob3cpCiAJCWlmIChob3cg
PT0gU0hVVF9SRFdSKSB7CiAJCQljdHJsID0gUlNfQ1RSTF9ESVNDT05ORUNUOwogCQkJcnMtPnN0
YXRlICY9IH4ocnNfcmVhZGFibGUgfCByc193cml0YWJsZSk7Ci0JCX0gZWxzZSB7CisJCX0gZWxz
ZSBpZiAoaG93ID09IFNIVVRfV1IpIHsKIAkJCXJzLT5zdGF0ZSAmPSB+cnNfd3JpdGFibGU7CiAJ
CQljdHJsID0gKHJzLT5zdGF0ZSAmIHJzX3JlYWRhYmxlKSA/CiAJCQkJUlNfQ1RSTF9TSFVURE9X
TiA6IFJTX0NUUkxfRElTQ09OTkVDVDsKKwkJfSBlbHNlIHsKKwkJCXJzLT5zdGF0ZSAmPSB+cnNf
cmVhZGFibGU7CisJCQlpZiAocnMtPnN0YXRlICYgcnNfd3JpdGFibGUpCisJCQkJZ290byBvdXQ7
CisJCQljdHJsID0gUlNfQ1RSTF9ESVNDT05ORUNUOwogCQl9CiAJCWlmICghcnMtPmN0cmxfYXZh
aWwpIHsKIAkJCXJldCA9IHJzX3Byb2Nlc3NfY3EocnMsIDAsIHJzX2Nvbm5fY2FuX3NlbmRfY3Ry
bCk7CiAJCQlpZiAocmV0KQotCQkJCXJldHVybiByZXQ7CisJCQkJZ290byBvdXQ7CiAJCX0KIAog
CQlpZiAoKHJzLT5zdGF0ZSAmIHJzX2Nvbm5lY3RlZCkgJiYgcnMtPmN0cmxfYXZhaWwpIHsKQEAg
LTMxMzgsMTAgKzMxNDYsMTcgQEAgaW50IHJzaHV0ZG93bihpbnQgc29ja2V0LCBpbnQgaG93KQog
CWlmIChycy0+c3RhdGUgJiByc19jb25uZWN0ZWQpCiAJCXJzX3Byb2Nlc3NfY3EocnMsIDAsIHJz
X2Nvbm5fYWxsX3NlbmRzX2RvbmUpOwogCitvdXQ6CiAJaWYgKChycy0+ZmRfZmxhZ3MgJiBPX05P
TkJMT0NLKSAmJiAocnMtPnN0YXRlICYgcnNfY29ubmVjdGVkKSkKIAkJcnNfc2V0X25vbmJsb2Nr
aW5nKHJzLCBycy0+ZmRfZmxhZ3MpOwogCi0JcmV0dXJuIDA7CisJaWYgKHJzLT5zdGF0ZSAmIHJz
X2Rpc2Nvbm5lY3RlZCkgeworCQkvKiBHZW5lcmF0ZSBldmVudCBieSBmbHVzaGluZyByZWNlaXZl
cyB0byB1bmJsb2NrIHJwb2xsICovCisJCWlidl9yZXFfbm90aWZ5X2NxKHJzLT5jbV9pZC0+cmVj
dl9jcSwgMCk7CisJCXVjbWFfc2h1dGRvd24ocnMtPmNtX2lkKTsKKwl9CisKKwlyZXR1cm4gcmV0
OwogfQogCiBzdGF0aWMgdm9pZCBkc19zaHV0ZG93bihzdHJ1Y3QgcnNvY2tldCAqcnMpCg==

--_002_1828884A29C6694DAF28B7E6B8A8237388CF3072ORSMSX109amrcor_--
