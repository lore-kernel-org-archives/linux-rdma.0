From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: CVE-2014-8159 kernel: infiniband: uverbs: unprotected physical
 memory access
Date: Thu, 02 Apr 2015 17:15:52 +0200
Message-ID: <1427987752.22575.65.camel@opteya.com>
References: <AM3PR05MB0935AABF569F15EA846B8E72DC000@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427969085.17020.5.camel@opteya.com>
	 <AM3PR05MB0935AA4898B4B519D2DAA3C4DCF20@AM3PR05MB0935.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <AM3PR05MB0935AA4898B4B519D2DAA3C4DCF20@AM3PR05MB0935.eurprd05.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: Shachar Raindel <raindel@mellanox.com>
Cc: "oss-security@lists.openwall.com" <oss-security@lists.openwall.com>, "<linux-rdma@vger.kernel.org> (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi,
Le jeudi 02 avril 2015 =C3=A0 10:52 +0000, Shachar Raindel a =C3=A9crit=
 :
> > -----Original Message-----
> > From: Yann Droneaud [mailto:ydroneaud@opteya.com]
> > Sent: Thursday, April 02, 2015 1:05 PM
> > Le mercredi 18 mars 2015 =C3=A0 17:39 +0000, Shachar Raindel a =C3=A9=
crit :
=2E..
> > > +	/*
> > > +	 * If the combination of the addr and size requested for this
> > memory
> > > +	 * region causes an integer overflow, return error.
> > > +	 */
> > > +	if ((PAGE_ALIGN(addr + size) <=3D size) ||
> > > +	    (PAGE_ALIGN(addr + size) <=3D addr))
> > > +		return ERR_PTR(-EINVAL);
> > > +
> >=20
> > Can access_ok() be used here ?
> >=20
> >          if (!access_ok(writable ? VERIFY_WRITE : VERIFY_READ,
> >                         addr, size))
> >                   return ERR_PTR(-EINVAL);
> >=20
>=20
> No, this will break the current ODP semantics.
>=20
> ODP allows the user to register memory that is not accessible yet.
> This is a critical design feature, as it allows avoiding holding
> a registration cache. Adding this check will break the behavior,
> forcing memory to be all accessible when registering an ODP MR.
>=20

=46ailed to notice previously, but since this would break ODP, and ODP =
is=20
only available starting v3.19-rc1, my proposed fix might be applicable=20
for older kernel (if not better).

=46rom 2a3beaeb4b35d968f127cb59cfda2f12dbd87e4b Mon Sep 17 00:00:00 200=
1
=46rom: Yann Droneaud <ydroneaud@opteya.com>
Date: Thu, 2 Apr 2015 17:01:05 +0200
Subject: [RFC PATCH] IB/core: reject invalid userspace memory range reg=
istration

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 drivers/infiniband/core/umem.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/u=
mem.c
index df0c4f605a21..6758b4ac56eb 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -90,6 +90,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *conte=
xt, unsigned long addr,
 	DEFINE_DMA_ATTRS(attrs);
 	struct scatterlist *sg, *sg_list_start;
 	int need_release =3D 0;
+	bool writable;
=20
 	if (dmasync)
 		dma_set_attr(DMA_ATTR_WRITE_BARRIER, &attrs);
@@ -97,6 +98,19 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *cont=
ext, unsigned long addr,
 	if (!can_do_mlock())
 		return ERR_PTR(-EPERM);
=20
+	/*
+	 * We ask for writable memory if any access flags other than
+	 * "remote read" are set.  "Local write" and "remote write"
+	 * obviously require write access.  "Remote atomic" can do
+	 * things like fetch and add, which will modify memory, and
+	 * "MW bind" can change permissions by binding a window.
+	 */
+	writable  =3D !!(access & ~IB_ACCESS_REMOTE_READ);
+
+	if (!access_ok(writable ? VERIFY_WRITE : VERIFY_READ,
+		       (void __user *)addr, size))
+		return ERR_PTR(-EFAULT);
+
 	umem =3D kzalloc(sizeof *umem, GFP_KERNEL);
 	if (!umem)
 		return ERR_PTR(-ENOMEM);
@@ -106,14 +120,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *co=
ntext, unsigned long addr,
 	umem->offset    =3D addr & ~PAGE_MASK;
 	umem->page_size =3D PAGE_SIZE;
 	umem->pid       =3D get_task_pid(current, PIDTYPE_PID);
-	/*
-	 * We ask for writable memory if any access flags other than
-	 * "remote read" are set.  "Local write" and "remote write"
-	 * obviously require write access.  "Remote atomic" can do
-	 * things like fetch and add, which will modify memory, and
-	 * "MW bind" can change permissions by binding a window.
-	 */
-	umem->writable  =3D !!(access & ~IB_ACCESS_REMOTE_READ);
+	umem->writable  =3D writable;
=20
 	/* We assume the memory is from hugetlb until proved otherwise */
 	umem->hugetlb   =3D 1;
--=20
2.1.0

Regards.

--=20
Yann Droneaud
OPTEYA
