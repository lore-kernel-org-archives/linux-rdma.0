From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ANNOUNCE] libibverbs 1.1.3 is released
Date: Fri, 06 Nov 2009 13:08:10 -0500
Message-ID: <4AF4660A.4040103@redhat.com>
References: <adaskd151b2.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3EDD29ECC50A93CCF5BBEF1C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaskd151b2.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3EDD29ECC50A93CCF5BBEF1C
Content-Type: multipart/mixed;
 boundary="------------010205020902010707030707"

This is a multi-part message in MIME format.
--------------010205020902010707030707
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/29/2009 05:37 PM, Roland Dreier wrote:
> libibverbs is a library that allows programs to use RDMA "verbs" for
> direct access to RDMA (currently InfiniBand and iWARP) hardware from
> userspace.
>=20
> The new stable release, 1.1.3, is available from
>=20
>     http://www.openfabrics.org//downloads/verbs/libibverbs-1.1.3.tar.gz=

>=20
> with sha1sum
>=20
>     aa8eb44c84e326799d986c8f07d636afd0b8b7eb  libibverbs-1.1.3.tar.gz
>=20
> I also pushed the latest tree and tag out to kernel.org:
>=20
>     git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git
>=20
> (the name of the tag is libibverbs-1.1.3).
>=20
> It's been too long since the previous release, and this release
> contains many small fixes and cleanups, including a few that have API
> impacts (although no changes in code using the library should be
> required).

No changes to precompiled code should be necessary, however to suppress
warnings when compiling against this new API there are a few minor
cleanups needed.  Those cleanups are already in the libmlx4 and libmthca
git repos.  This patch does the cleanups for libcxgb3.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband

--------------010205020902010707030707
Content-Type: text/plain;
 name="libcxgb3-1.2.5-verbs-api.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="libcxgb3-1.2.5-verbs-api.patch"

--- libcxgb3-1.2.5/src/verbs.c.api	2009-09-29 14:57:44.000000000 -0400
+++ libcxgb3-1.2.5/src/verbs.c	2009-11-06 12:37:33.172964811 -0500
@@ -108,7 +108,7 @@ int iwch_free_pd(struct ibv_pd *pd)
=20
 static struct ibv_mr *__iwch_reg_mr(struct ibv_pd *pd, void *addr,
 				    size_t length, uint64_t hca_va,
-				    enum ibv_access_flags access)
+				    int access)
 {
 	struct iwch_mr *mhp;
 	struct ibv_reg_mr cmd;
@@ -144,7 +144,7 @@ static struct ibv_mr *__iwch_reg_mr(stru
 }
=20
 struct ibv_mr *iwch_reg_mr(struct ibv_pd *pd, void *addr,
-			   size_t length, enum ibv_access_flags access)
+			   size_t length, int access)
 {
 	PDBG("%s addr %p length %ld\n", __FUNCTION__, addr, length);
 	return __iwch_reg_mr(pd, addr, length, (uintptr_t) addr, access);
@@ -267,7 +267,7 @@ struct ibv_srq *iwch_create_srq(struct i
 }
=20
 int iwch_modify_srq(struct ibv_srq *srq, struct ibv_srq_attr *attr,=20
-		    enum ibv_srq_attr_mask attr_mask)
+		    int attr_mask)
 {
 	return -ENOSYS;
 }
@@ -370,7 +370,7 @@ static void reset_qp(struct iwch_qp *qhp
 }
=20
 int iwch_modify_qp(struct ibv_qp *ibqp, struct ibv_qp_attr *attr,
-		   enum ibv_qp_attr_mask attr_mask)
+		   int attr_mask)
 {
 	struct ibv_modify_qp cmd;
 	struct iwch_qp *qhp =3D to_iwch_qp(ibqp);
@@ -424,7 +424,7 @@ int iwch_destroy_qp(struct ibv_qp *ibqp)
 }
=20
 int iwch_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
-		  enum ibv_qp_attr_mask attr_mask, struct ibv_qp_init_attr *init_attr)=

+		  int attr_mask, struct ibv_qp_init_attr *init_attr)
 {
 	return -ENOSYS;
 }
@@ -439,12 +439,12 @@ int iwch_destroy_ah(struct ibv_ah *ah)
 	return -ENOSYS;
 }
=20
-int iwch_attach_mcast(struct ibv_qp *qp, union ibv_gid *gid, uint16_t li=
d)
+int iwch_attach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint1=
6_t lid)
 {
 	return -ENOSYS;
 }
=20
-int iwch_detach_mcast(struct ibv_qp *qp, union ibv_gid *gid, uint16_t li=
d)
+int iwch_detach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint1=
6_t lid)
 {
 	return -ENOSYS;
 }
--- libcxgb3-1.2.5/src/iwch.h.api	2009-09-29 14:58:25.000000000 -0400
+++ libcxgb3-1.2.5/src/iwch.h	2009-11-06 12:37:19.981089104 -0500
@@ -150,7 +150,7 @@ extern struct ibv_pd *iwch_alloc_pd(stru
 extern int iwch_free_pd(struct ibv_pd *pd);
=20
 extern struct ibv_mr *iwch_reg_mr(struct ibv_pd *pd, void *addr,
-				  size_t length, enum ibv_access_flags access);
+				  size_t length, int access);
 extern int iwch_dereg_mr(struct ibv_mr *mr);
=20
 struct ibv_cq *iwch_create_cq(struct ibv_context *context, int cqe,
@@ -168,7 +168,7 @@ extern struct ibv_srq *iwch_create_srq(s
 				       struct ibv_srq_init_attr *attr);
 extern int iwch_modify_srq(struct ibv_srq *srq,
 			   struct ibv_srq_attr *attr,
-			   enum ibv_srq_attr_mask mask);
+			   int mask);
 extern int iwch_destroy_srq(struct ibv_srq *srq);
 extern int iwch_post_srq_recv(struct ibv_srq *ibsrq,
 			      struct ibv_recv_wr *wr,
@@ -177,11 +177,11 @@ extern int iwch_post_srq_recv(struct ibv
 extern struct ibv_qp *iwch_create_qp(struct ibv_pd *pd,
 				     struct ibv_qp_init_attr *attr);
 extern int iwch_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
-			  enum ibv_qp_attr_mask attr_mask);
+			  int attr_mask);
 extern int iwch_destroy_qp(struct ibv_qp *qp);
 extern int iwch_query_qp(struct ibv_qp *qp,
 			 struct ibv_qp_attr *attr,
-			 enum ibv_qp_attr_mask attr_mask,
+			 int attr_mask,
 			 struct ibv_qp_init_attr *init_attr);
 extern void iwch_flush_qp(struct iwch_qp *qhp);
 extern int t3a_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
@@ -195,9 +195,9 @@ extern int t3b_post_recv(struct ibv_qp *
 extern struct ibv_ah *iwch_create_ah(struct ibv_pd *pd,
 			     struct ibv_ah_attr *ah_attr);
 extern int iwch_destroy_ah(struct ibv_ah *ah);
-extern int iwch_attach_mcast(struct ibv_qp *qp, union ibv_gid *gid,
+extern int iwch_attach_mcast(struct ibv_qp *qp, const union ibv_gid *gid=
,
 			     uint16_t lid);
-extern int iwch_detach_mcast(struct ibv_qp *qp, union ibv_gid *gid,
+extern int iwch_detach_mcast(struct ibv_qp *qp, const union ibv_gid *gid=
,
 			     uint16_t lid);
 extern void t3b_async_event(struct ibv_async_event *event);
 #ifdef DEBUG

--------------010205020902010707030707--

--------------enig3EDD29ECC50A93CCF5BBEF1C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr0ZgoACgkQg6WylM+/8ZQ2xgCcCIj7XY7n0otpTsQyfEKxR2j9
kiUAoKFeNj9omx/bgfP2AH5SGr0HTQ0z
=1QzL
-----END PGP SIGNATURE-----

--------------enig3EDD29ECC50A93CCF5BBEF1C--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
