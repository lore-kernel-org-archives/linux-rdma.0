From: Bryce Lelbach <blelbach-eiRV2mVQLkiVc3sceRu5cw@public.gmane.org>
Subject: Patch: Support for Xeon Phi
Date: Fri, 24 May 2013 12:02:53 -0500
Message-ID: <20130524170253.GC2591@pyxis.br.cox.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4zI0WCX1RcnW9Hbu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--4zI0WCX1RcnW9Hbu
Content-Type: multipart/mixed; boundary="5QAgd0e35j3NYeGe"
Content-Disposition: inline


--5QAgd0e35j3NYeGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The attached patch modifies the kernel Infiniband drivers to support the Xe=
on Phi
co-processor.

This patch is a modified version of a patch from Intel's MPSS framework
(specifically, from the "KNC_gold_update_1-2.1.4982-15-rhel-6.3" package), =
which
will apply to a 3.7.8 kernel (I am about to try it on a 3.8 kernel). To the=
 best
of my knowledge, newer RHEL kernels are shipped with this patch.
=20
--=20
Bryce Adelstein-Lelbach aka wash
STE||AR Group, Center for Computation and Technology, LSU
--
225-317-3866 - iPhone
225-578-6182 - Work (no voicemail)
--
stellar.cct.lsu.edu
boost-spirit.com
llvm.linuxfoundation.org
cppnow.org
--

--5QAgd0e35j3NYeGe
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="linux_3.7.8_ib_xeon_phi.patch"
Content-Transfer-Encoding: quoted-printable

diff -u -r -N linux-source-3.7/drivers/infiniband/core/sysfs.c linux-source=
-3.7-xeon-phi/drivers/infiniband/core/sysfs.c
--- linux-source-3.7/drivers/infiniband/core/sysfs.c	2013-02-14 12:57:59.00=
0000000 -0600
+++ linux-source-3.7-xeon-phi/drivers/infiniband/core/sysfs.c	2013-04-16 15=
:34:29.954382402 -0500
@@ -610,6 +610,7 @@
 	case RDMA_NODE_RNIC:	  return sprintf(buf, "%d: RNIC\n", dev->node_type);
 	case RDMA_NODE_IB_SWITCH: return sprintf(buf, "%d: switch\n", dev->node_t=
ype);
 	case RDMA_NODE_IB_ROUTER: return sprintf(buf, "%d: router\n", dev->node_t=
ype);
+	case RDMA_NODE_MIC:	  return sprintf(buf, "%d: MIC\n", dev->node_type);
 	default:		  return sprintf(buf, "%d: <unknown>\n", dev->node_type);
 	}
 }
diff -u -r -N linux-source-3.7/drivers/infiniband/core/umem.c linux-source-=
3.7-xeon-phi/drivers/infiniband/core/umem.c
--- linux-source-3.7/drivers/infiniband/core/umem.c	2013-02-14 12:57:59.000=
000000 -0600
+++ linux-source-3.7-xeon-phi/drivers/infiniband/core/umem.c	2013-04-16 15:=
37:23.996479997 -0500
@@ -101,7 +101,6 @@
 	if (!umem)
 		return ERR_PTR(-ENOMEM);
=20
-	umem->context   =3D context;
 	umem->length    =3D size;
 	umem->offset    =3D addr & ~PAGE_MASK;
 	umem->page_size =3D PAGE_SIZE;
@@ -216,7 +215,6 @@
=20
 	return ret < 0 ? ERR_PTR(ret) : umem;
 }
-EXPORT_SYMBOL(ib_umem_get);
=20
 static void ib_umem_account(struct work_struct *work)
 {
@@ -230,10 +228,10 @@
 }
=20
 /**
- * ib_umem_release - release memory pinned with ib_umem_get
+ * ib_release_umem - release memory pinned with ib_umem_get
  * @umem: umem struct to release
  */
-void ib_umem_release(struct ib_umem *umem)
+void ib_release_umem(struct ib_umem *umem)
 {
 	struct ib_ucontext *context =3D umem->context;
 	struct mm_struct *mm;
@@ -274,9 +272,8 @@
 	mmput(mm);
 	kfree(umem);
 }
-EXPORT_SYMBOL(ib_umem_release);
=20
-int ib_umem_page_count(struct ib_umem *umem)
+int ib_page_count_umem(struct ib_umem *umem)
 {
 	struct ib_umem_chunk *chunk;
 	int shift;
@@ -292,4 +289,40 @@
=20
 	return n;
 }
+
+struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long add=
r,
+			    size_t size, int access, int dmasync)
+{
+	struct ib_umem_ops *ops =3D context->umem_ops;
+	struct ib_umem *umem;
+
+	umem =3D (ops && ops->get) ?
+		ops->get(context, addr, size, access, dmasync) :
+		ib_get_umem(context, addr, size, access, dmasync);
+
+	if (!IS_ERR(umem))
+		umem->context =3D context;
+
+	return umem;
+}
+EXPORT_SYMBOL(ib_umem_get);
+
+void ib_umem_release(struct ib_umem *umem)
+{
+	struct ib_umem_ops *ops =3D umem->context->umem_ops;
+
+	if (ops && ops->release)
+		ops->release(umem);
+	else
+		ib_release_umem(umem);
+}
+EXPORT_SYMBOL(ib_umem_release);
+
+int ib_umem_page_count(struct ib_umem *umem)
+{
+	struct ib_umem_ops *ops =3D umem->context->umem_ops;
+
+	return (ops && ops->page_count) ?
+		ops->page_count(umem) : ib_page_count_umem(umem);
+}
 EXPORT_SYMBOL(ib_umem_page_count);
diff -u -r -N linux-source-3.7/drivers/infiniband/core/uverbs_cmd.c linux-s=
ource-3.7-xeon-phi/drivers/infiniband/core/uverbs_cmd.c
--- linux-source-3.7/drivers/infiniband/core/uverbs_cmd.c	2013-02-14 12:57:=
59.000000000 -0600
+++ linux-source-3.7-xeon-phi/drivers/infiniband/core/uverbs_cmd.c	2013-04-=
16 15:37:29.688406735 -0500
@@ -54,8 +54,24 @@
 static struct uverbs_lock_class srq_lock_class	=3D { .name =3D "SRQ-uobj" =
};
 static struct uverbs_lock_class xrcd_lock_class =3D { .name =3D "XRCD-uobj=
" };
=20
+static int uverbs_copy_from_udata(void *dest, struct ib_udata *udata, size=
_t len)
+{
+	return copy_from_user(dest, udata->inbuf, len) ? -EFAULT : 0;
+}
+
+static int uverbs_copy_to_udata(struct ib_udata *udata, void *src, size_t =
len)
+{
+	return copy_to_user(udata->outbuf, src, len) ? -EFAULT : 0;
+}
+
+static struct ib_udata_ops uverbs_copy =3D {
+	.copy_from =3D uverbs_copy_from_udata,
+	.copy_to   =3D uverbs_copy_to_udata
+};
+
 #define INIT_UDATA(udata, ibuf, obuf, ilen, olen)			\
 	do {								\
+		(udata)->ops    =3D &uverbs_copy;				\
 		(udata)->inbuf  =3D (void __user *) (ibuf);		\
 		(udata)->outbuf =3D (void __user *) (obuf);		\
 		(udata)->inlen  =3D (ilen);				\
@@ -321,6 +337,7 @@
 		goto err;
 	}
=20
+	ucontext->umem_ops =3D NULL;
 	ucontext->device =3D ibdev;
 	INIT_LIST_HEAD(&ucontext->pd_list);
 	INIT_LIST_HEAD(&ucontext->mr_list);
diff -u -r -N linux-source-3.7/drivers/infiniband/core/verbs.c linux-source=
-3.7-xeon-phi/drivers/infiniband/core/verbs.c
--- linux-source-3.7/drivers/infiniband/core/verbs.c	2013-02-14 12:57:59.00=
0000000 -0600
+++ linux-source-3.7-xeon-phi/drivers/infiniband/core/verbs.c	2013-04-16 15=
:37:35.676341755 -0500
@@ -114,6 +114,8 @@
 		return RDMA_TRANSPORT_IB;
 	case RDMA_NODE_RNIC:
 		return RDMA_TRANSPORT_IWARP;
+	case RDMA_NODE_MIC:
+		return RDMA_TRANSPORT_SCIF;
 	default:
 		BUG();
 		return 0;
diff -u -r -N linux-source-3.7/drivers/infiniband/hw/mthca/mthca_memfree.c =
linux-source-3.7-xeon-phi/drivers/infiniband/hw/mthca/mthca_memfree.c
--- linux-source-3.7/drivers/infiniband/hw/mthca/mthca_memfree.c	2013-02-14=
 12:57:59.000000000 -0600
+++ linux-source-3.7-xeon-phi/drivers/infiniband/hw/mthca/mthca_memfree.c	2=
013-04-16 15:50:22.647903759 -0500
@@ -39,6 +39,12 @@
=20
 #include <asm/page.h>
=20
+/* Must use the ib_umem routines to support the IB proxy server. */
+#define	MTHCA_IB_UMEM
+#ifdef	MTHCA_IB_UMEM
+#include <rdma/ib_umem.h>
+#endif
+
 #include "mthca_memfree.h"
 #include "mthca_dev.h"
 #include "mthca_cmd.h"
@@ -56,7 +62,11 @@
 	struct mutex mutex;
 	struct {
 		u64                uvirt;
+#ifdef	MTHCA_IB_UMEM
+		struct ib_umem	   *umem;
+#else
 		struct scatterlist mem;
+#endif
 		int                refcount;
 	}                page[0];
 };
@@ -446,7 +456,12 @@
 int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
 		      struct mthca_user_db_table *db_tab, int index, u64 uaddr)
 {
+#ifdef	MTHCA_IB_UMEM
+	struct mthca_ucontext *context;
+	struct ib_umem_chunk *chunk;
+#else
 	struct page *pages[1];
+#endif
 	int ret =3D 0;
 	int i;
=20
@@ -472,6 +487,22 @@
 		goto out;
 	}
=20
+#ifdef	MTHCA_IB_UMEM
+	context =3D container_of(uar, struct mthca_ucontext, uar);
+
+	db_tab->page[i].umem =3D ib_umem_get(&context->ibucontext,
+					   uaddr & PAGE_MASK, PAGE_SIZE, 0, 0);
+	if (IS_ERR(db_tab->page[i].umem)) {
+		ret =3D PTR_ERR(db_tab->page[i].umem);
+		goto out;
+	}
+
+	chunk =3D list_entry(db_tab->page[i].umem->chunk_list.next,
+			   struct ib_umem_chunk, list);
+
+	ret =3D mthca_MAP_ICM_page(dev, sg_dma_address(&chunk->page_list[0]),
+				 mthca_uarc_virt(dev, uar, i));
+#else
 	ret =3D get_user_pages(current, current->mm, uaddr & PAGE_MASK, 1, 1, 0,
 			     pages, NULL);
 	if (ret < 0)
@@ -488,9 +519,14 @@
=20
 	ret =3D mthca_MAP_ICM_page(dev, sg_dma_address(&db_tab->page[i].mem),
 				 mthca_uarc_virt(dev, uar, i));
+#endif
 	if (ret) {
+#ifdef MTHCA_IB_UMEM
+       ib_umem_release(db_tab->page[i].umem);
+#else
 		pci_unmap_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
 		put_page(sg_page(&db_tab->page[i].mem));
+#endif
 		goto out;
 	}
=20
@@ -505,17 +541,29 @@
 void mthca_unmap_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
 			 struct mthca_user_db_table *db_tab, int index)
 {
+#ifdef	MTHCA_IB_UMEM
+	int i;
+#endif
 	if (!mthca_is_memfree(dev))
 		return;
=20
+	mutex_lock(&db_tab->mutex);
+
+#ifdef	MTHCA_IB_UMEM
+	i =3D index / MTHCA_DB_REC_PER_PAGE;
+	if (!--db_tab->page[i].refcount) {
+		mthca_UNMAP_ICM(dev, mthca_uarc_virt(dev, uar, i), 1);
+		ib_umem_release(db_tab->page[i].umem);
+		db_tab->page[i].uvirt =3D 0;
+	}
+#else
 	/*
 	 * To make our bookkeeping simpler, we don't unmap DB
 	 * pages until we clean up the whole db table.
 	 */
=20
-	mutex_lock(&db_tab->mutex);
-
 	--db_tab->page[index / MTHCA_DB_REC_PER_PAGE].refcount;
+#endif
=20
 	mutex_unlock(&db_tab->mutex);
 }
@@ -538,7 +586,11 @@
 	for (i =3D 0; i < npages; ++i) {
 		db_tab->page[i].refcount =3D 0;
 		db_tab->page[i].uvirt    =3D 0;
+#ifdef	MTHCA_IB_UMEM
+		db_tab->page[i].umem     =3D NULL;
+#else
 		sg_init_table(&db_tab->page[i].mem, 1);
+#endif
 	}
=20
 	return db_tab;
@@ -555,8 +607,12 @@
 	for (i =3D 0; i < dev->uar_table.uarc_size / MTHCA_ICM_PAGE_SIZE; ++i) {
 		if (db_tab->page[i].uvirt) {
 			mthca_UNMAP_ICM(dev, mthca_uarc_virt(dev, uar, i), 1);
+#ifdef MTHCA_IB_UMEM
+           ib_umem_release(db_tab->page[i].umem);
+#else
 			pci_unmap_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
 			put_page(sg_page(&db_tab->page[i].mem));
+#endif
 		}
 	}
=20
diff -u -r -N linux-source-3.7/include/rdma/ib_verbs.h linux-source-3.7-xeo=
n-phi/include/rdma/ib_verbs.h
--- linux-source-3.7/include/rdma/ib_verbs.h	2013-02-14 12:57:59.000000000 =
-0600
+++ linux-source-3.7-xeon-phi/include/rdma/ib_verbs.h	2013-04-16 15:32:44.5=
19537838 -0500
@@ -67,12 +67,14 @@
 	RDMA_NODE_IB_CA 	=3D 1,
 	RDMA_NODE_IB_SWITCH,
 	RDMA_NODE_IB_ROUTER,
-	RDMA_NODE_RNIC
+	RDMA_NODE_RNIC,
+	RDMA_NODE_MIC
 };
=20
 enum rdma_transport_type {
 	RDMA_TRANSPORT_IB,
-	RDMA_TRANSPORT_IWARP
+	RDMA_TRANSPORT_IWARP,
+	RDMA_TRANSPORT_SCIF
 };
=20
 enum rdma_transport_type
@@ -82,6 +84,7 @@
 	IB_LINK_LAYER_UNSPECIFIED,
 	IB_LINK_LAYER_INFINIBAND,
 	IB_LINK_LAYER_ETHERNET,
+	IB_LINK_LAYER_SCIF
 };
=20
 enum ib_device_cap_flags {
@@ -877,7 +880,18 @@
 	u8	page_shift;
 };
=20
+struct ib_ucontext;
+struct ib_umem_ops {
+	struct ib_umem	     *(*get)(struct ib_ucontext *context,
+				     unsigned long addr, size_t size,
+				     int access, int dmasync);
+	void		      (*release)(struct ib_umem *umem);
+	int		      (*page_count)(struct ib_umem *umem);
+};
+
 struct ib_ucontext {
+	struct ib_umem_ops     *umem_ops;	/* set to NULL for default ops */
+	void		       *umem_private_data;
 	struct ib_device       *device;
 	struct list_head	pd_list;
 	struct list_head	mr_list;
@@ -901,11 +915,20 @@
 	int			live;
 };
=20
+struct ib_udata;
+struct ib_udata_ops {
+	int		      (*copy_from)(void *dest, struct ib_udata *udata,
+					    size_t len);
+	int		      (*copy_to)(struct ib_udata *udata, void *src,
+					  size_t len);
+};
+
 struct ib_udata {
-	void __user *inbuf;
-	void __user *outbuf;
-	size_t       inlen;
-	size_t       outlen;
+	struct ib_udata_ops    *ops;
+	void __user	       *inbuf;
+	void __user	       *outbuf;
+	size_t			inlen;
+	size_t			outlen;
 };
=20
 struct ib_pd {
@@ -1281,12 +1304,12 @@
=20
 static inline int ib_copy_from_udata(void *dest, struct ib_udata *udata, s=
ize_t len)
 {
-	return copy_from_user(dest, udata->inbuf, len) ? -EFAULT : 0;
+	return udata->ops->copy_from(dest, udata, len);
 }
=20
 static inline int ib_copy_to_udata(struct ib_udata *udata, void *src, size=
_t len)
 {
-	return copy_to_user(udata->outbuf, src, len) ? -EFAULT : 0;
+	return udata->ops->copy_to(udata, src, len);
 }
=20
 /**

--5QAgd0e35j3NYeGe--

--4zI0WCX1RcnW9Hbu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJRn509AAoJEBLaNmtPI4b86/AIAL0Io4qaHQ8OY6m/qwZgElfp
cmBHkK1g0MjvKPjl8t3xL84DEZ6WF60vNRCDziMV3S3tyyhUEZtOyisAP/2oTnIs
JPnGDMJbDoGBVpdg84TdbdJfHdM4rUsY8h7Rm/mYHeVLYZEINKlscd/fJodMKC3I
nI7bSBYmtXHM5pQrQDS+75Qf1MdzEHIXwngr843fvl9gtVjY9DDmKkYGkyNk2mn4
wMfsb5Z/7oGJp5TN1ZulbX1w55O4BbUHc9r/rN1oAIrZdTS2SJx3Pd7kQYt+abmb
innsp/pl+zKHCzKZN8xjSpwR9eKAU/a2/4X7YltfpxWqFhKlVHW0hjwWtXoClOc=
=N00l
-----END PGP SIGNATURE-----

--4zI0WCX1RcnW9Hbu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
