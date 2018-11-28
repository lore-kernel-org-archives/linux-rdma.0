From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/core: Perform modify QP on real one
Date: Wed, 28 Nov 2018 13:26:48 +0200
Message-ID: <20181128112648.GH4559@mtr-leonro.mtl.com>
References: <20181029151223.15114-1-leon@kernel.org>
 <20181128105820.GC1822@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="B4IIlcmfBL/1gGOG"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181128105820.GC1822@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-rdma@vger.kernel.org, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


--B4IIlcmfBL/1gGOG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 28, 2018 at 11:58:20AM +0100, Greg KH wrote:
> On Mon, Oct 29, 2018 at 05:12:23PM +0200, Leon Romanovsky wrote:
> > From: Parav Pandit <parav@mellanox.com>
> >
> > commit b2bedfb39541a7e14798d066b6f8685d84c8fcf5 upstream
> >
> > Currently qp->port stores the port number whenever IB_QP_PORT
> > QP attribute mask is set (during QP state transition to INIT state).
> > This port number should be stored for the real QP when XRC target QP
> > is used.
> >
> > Follow the ib_modify_qp() implementation and hide the access to ->real_=
qp.
> >
> > This commit is required for proper operation of commit 65be9cbe1224
> > ("RDMA/uverbs: Expand primary and alt AV port checks") which was added
> > to 4.14.61.
> >
> > Without this commit, XRC qp's do not work.
> >
> > Fixes: a512c2fbef9c ("IB/core: Introduce modify QP operation with udata=
")
> > Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > Reviewed-by: Daniel Jurgens <danielj@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leon@kernel.org>
> > Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> > ---
> >  drivers/infiniband/core/verbs.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
>
> Does not apply to the 4.14.y tree :(

Can you please try this file patch? I tested it now on 4201a586f1fa
(tag: v4.14.84, stable/linux-4.14.y) Linux 4.14.8.

Thanks

=46rom d63abe9b61d2a6789d1fa236f8e3b19df17eb3cb Mon Sep 17 00:00:00 2001
=46rom: Parav Pandit <parav@mellanox.com>
Date: Mon, 29 Oct 2018 17:12:23 +0200
Subject: [PATCH] IB/core: Perform modify QP on real one

commit b2bedfb39541a7e14798d066b6f8685d84c8fcf5 upstream

Currently qp->port stores the port number whenever IB_QP_PORT
QP attribute mask is set (during QP state transition to INIT state).
This port number should be stored for the real QP when XRC target QP
is used.

Follow the ib_modify_qp() implementation and hide the access to ->real_qp.

This commit is required for proper operation of commit 65be9cbe1224
("RDMA/uverbs: Expand primary and alt AV port checks") which was added
to 4.14.61.

Without this commit, XRC qp's do not work.

Fixes: a512c2fbef9c ("IB/core: Introduce modify QP operation with udata")
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Daniel Jurgens <danielj@mellanox.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/core/verbs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verb=
s.c
index feb80dbb5948..6d59af07d338 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1285,7 +1285,7 @@ EXPORT_SYMBOL(ib_resolve_eth_dmac);

 /**
  * ib_modify_qp_with_udata - Modifies the attributes for the specified QP.
- * @qp: The QP to modify.
+ * @ib_qp: The QP to modify.
  * @attr: On input, specifies the QP attributes to modify.  On output,
  *   the current values of selected QP attributes are returned.
  * @attr_mask: A bit-mask used to specify which attributes of the QP
@@ -1294,9 +1294,10 @@ EXPORT_SYMBOL(ib_resolve_eth_dmac);
  *   are being modified.
  * It returns 0 on success and returns appropriate error code on error.
  */
-int ib_modify_qp_with_udata(struct ib_qp *qp, struct ib_qp_attr *attr,
+int ib_modify_qp_with_udata(struct ib_qp *ib_qp, struct ib_qp_attr *attr,
 			    int attr_mask, struct ib_udata *udata)
 {
+	struct ib_qp *qp =3D ib_qp->real_qp;
 	int ret;

 	if (attr_mask & IB_QP_AV) {
--B4IIlcmfBL/1gGOG--
