From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 7/8 v2] IB/mlx5/hmm: add page fault support for ODP on HMM v2.
Date: Thu, 13 Aug 2015 15:20:52 -0400
Message-ID: <1439493653-1191-8-git-send-email-jglisse@redhat.com>
References: <1439493653-1191-1-git-send-email-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439493653-1191-1-git-send-email-jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christophe Harle <charle-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Duncan Poole <dpoole-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Sherry Cheung <SCheung-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Subhash Gutti <sgutti-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Mark Hairgrove <mhairgrove-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Lucien Dunning <ldunning-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Cameron Buschardt <cabuschardt-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Arvind Gopalakrishnan <arvindg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch add HMM specific support for hardware page faulting of
user memory region.

Changed since v1:
  - Adapt to HMM page table changes.
  - Turn some sanity test to BUG_ON().

Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 144 +++++++++++++++++++++++++++++++=
+++++++-
 1 file changed, 143 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/m=
lx5/odp.c
index 5ef31da..658bfca 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -54,6 +54,52 @@ static struct mlx5_ib_mr *mlx5_ib_odp_find_mr_lkey(s=
truct mlx5_ib_dev *dev,
=20
 #if IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM)
=20
+struct mlx5_hmm_pfault {
+	struct mlx5_ib_mr	*mlx5_ib_mr;
+	u64			start_idx;
+	dma_addr_t		access_mask;
+	unsigned		npages;
+	struct hmm_event	event;
+};
+
+static int mlx5_hmm_pfault(struct mlx5_ib_dev *mlx5_ib_dev,
+			   struct hmm_mirror *mirror,
+			   const struct hmm_event *event)
+{
+	struct mlx5_hmm_pfault *pfault;
+	struct hmm_pt_iter iter;
+	unsigned long addr, cnt;
+	int ret;
+
+	pfault =3D container_of(event, struct mlx5_hmm_pfault, event);
+	hmm_pt_iter_init(&iter, &mirror->pt);
+
+	for (addr =3D event->start, cnt =3D 0; addr < event->end;
+	     addr +=3D PAGE_SIZE, ++cnt) {
+		unsigned long next =3D event->end;
+		dma_addr_t *ptep;
+
+		/* Get and lock pointer to mirror page table. */
+		ptep =3D hmm_pt_iter_lookup(&iter, addr, &next);
+		BUG_ON(!ptep);
+		for (; ptep && addr < next; addr +=3D PAGE_SIZE, ptep++) {
+			/* This could be BUG_ON() as it can not happen. */
+			BUG_ON(!hmm_pte_test_valid_dma(ptep));
+			BUG_ON((pfault->access_mask & ODP_WRITE_ALLOWED_BIT) &&
+				!hmm_pte_test_write(ptep));
+			if (hmm_pte_test_write(ptep))
+				hmm_pte_set_bit(ptep, ODP_WRITE_ALLOWED_SHIFT);
+			hmm_pte_set_bit(ptep, ODP_READ_ALLOWED_SHIFT);
+			pfault->npages++;
+		}
+	}
+	ret =3D mlx5_ib_update_mtt(pfault->mlx5_ib_mr,
+				 pfault->start_idx,
+				 cnt, 0, &iter);
+	hmm_pt_iter_fini(&iter);
+	return ret;
+}
+
 int mlx5_ib_umem_invalidate(struct ib_umem *umem, u64 start,
 			    u64 end, void *cookie)
 {
@@ -179,12 +225,19 @@ static int mlx5_hmm_update(struct hmm_mirror *mir=
ror,
 			    struct hmm_event *event)
 {
 	struct device *device =3D mirror->device->dev;
+	struct mlx5_ib_dev *mlx5_ib_dev;
+	struct ib_device *ib_device;
 	int ret =3D 0;
=20
+	ib_device =3D container_of(mirror->device, struct ib_device, hmm_dev)=
;
+	mlx5_ib_dev =3D to_mdev(ib_device);
+
 	switch (event->etype) {
 	case HMM_DEVICE_RFAULT:
 	case HMM_DEVICE_WFAULT:
-		/* FIXME implement. */
+		ret =3D mlx5_hmm_pfault(mlx5_ib_dev, mirror, event);
+		if (ret)
+			return ret;
 		break;
 	case HMM_NONE:
 	default:
@@ -227,6 +280,95 @@ void mlx5_dev_fini_odp_hmm(struct ib_device *ib_de=
vice)
 	hmm_device_unregister(&ib_device->hmm_dev);
 }
=20
+/*
+ * Handle a single data segment in a page-fault WQE.
+ *
+ * Returns number of pages retrieved on success. The caller will conti=
nue to
+ * the next data segment.
+ * Can return the following error codes:
+ * -EAGAIN to designate a temporary error. The caller will abort handl=
ing the
+ *  page fault and resolve it.
+ * -EFAULT when there's an error mapping the requested pages. The call=
er will
+ *  abort the page fault handling and possibly move the QP to an error=
 state.
+ * On other errors the QP should also be closed with an error.
+ */
+static int pagefault_single_data_segment(struct mlx5_ib_qp *qp,
+					 struct mlx5_ib_pfault *pfault,
+					 u32 key, u64 io_virt, size_t bcnt,
+					 u32 *bytes_mapped)
+{
+	struct mlx5_ib_dev *mlx5_ib_dev =3D to_mdev(qp->ibqp.pd->device);
+	struct ib_mirror *ib_mirror;
+	struct mlx5_hmm_pfault hmm_pfault;
+	int srcu_key;
+	int ret =3D 0;
+
+	srcu_key =3D srcu_read_lock(&mlx5_ib_dev->mr_srcu);
+	hmm_pfault.mlx5_ib_mr =3D mlx5_ib_odp_find_mr_lkey(mlx5_ib_dev, key);
+	/*
+	 * If we didn't find the MR, it means the MR was closed while we were
+	 * handling the ODP event. In this case we return -EFAULT so that the
+	 * QP will be closed.
+	 */
+	if (!hmm_pfault.mlx5_ib_mr || !hmm_pfault.mlx5_ib_mr->ibmr.pd) {
+		pr_err("Failed to find relevant mr for lkey=3D0x%06x, probably the M=
R was destroyed\n",
+		       key);
+		ret =3D -EFAULT;
+		goto srcu_unlock;
+	}
+	if (!hmm_pfault.mlx5_ib_mr->umem->odp_data) {
+		pr_debug("skipping non ODP MR (lkey=3D0x%06x) in page fault handler.=
\n",
+			 key);
+		if (bytes_mapped)
+			*bytes_mapped +=3D
+				(bcnt - pfault->mpfault.bytes_committed);
+		goto srcu_unlock;
+	}
+	if (hmm_pfault.mlx5_ib_mr->ibmr.pd !=3D qp->ibqp.pd) {
+		pr_err("Page-fault with different PDs for QP and MR.\n");
+		ret =3D -EFAULT;
+		goto srcu_unlock;
+	}
+
+	ib_mirror =3D hmm_pfault.mlx5_ib_mr->umem->odp_data->ib_mirror;
+	if (ib_mirror->base.hmm =3D=3D NULL) {
+		/* Somehow the mirror was kill from under us. */
+		ret =3D -EFAULT;
+		goto srcu_unlock;
+	}
+
+	/*
+	 * Avoid branches - this code will perform correctly
+	 * in all iterations (in iteration 2 and above,
+	 * bytes_committed =3D=3D 0).
+	 */
+	io_virt +=3D pfault->mpfault.bytes_committed;
+	bcnt -=3D pfault->mpfault.bytes_committed;
+
+	hmm_pfault.npages =3D 0;
+	hmm_pfault.start_idx =3D (io_virt - (hmm_pfault.mlx5_ib_mr->mmr.iova =
&
+					   PAGE_MASK)) >> PAGE_SHIFT;
+	hmm_pfault.access_mask =3D ODP_READ_ALLOWED_BIT;
+	hmm_pfault.access_mask |=3D hmm_pfault.mlx5_ib_mr->umem->writable ?
+				  ODP_WRITE_ALLOWED_BIT : 0;
+	hmm_pfault.event.start =3D io_virt & PAGE_MASK;
+	hmm_pfault.event.end =3D PAGE_ALIGN(io_virt + bcnt);
+	hmm_pfault.event.etype =3D hmm_pfault.mlx5_ib_mr->umem->writable ?
+				 HMM_DEVICE_WFAULT : HMM_DEVICE_RFAULT;
+	ret =3D hmm_mirror_fault(&ib_mirror->base, &hmm_pfault.event);
+
+	if (!ret && hmm_pfault.npages && bytes_mapped) {
+		u32 new_mappings =3D hmm_pfault.npages * PAGE_SIZE -
+				   (io_virt - round_down(io_virt, PAGE_SIZE));
+		*bytes_mapped +=3D min_t(u32, new_mappings, bcnt);
+	}
+
+srcu_unlock:
+	srcu_read_unlock(&mlx5_ib_dev->mr_srcu, srcu_key);
+	pfault->mpfault.bytes_committed =3D 0;
+	return ret ? ret : hmm_pfault.npages;
+}
+
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
=20
=20
--=20
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
