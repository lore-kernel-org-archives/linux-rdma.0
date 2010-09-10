From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 2.6.37 09/11] RDMA/cxgb4: Support on-chip SQs.
Date: Fri, 10 Sep 2010 14:57:53 -0500
Message-ID: <4C8A8DC1.4040302@opengridcomputing.com>
References: <20100910161442.6829.91594.stgit@build.ogc.int> <20100910161530.6829.89294.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100910161530.6829.89294.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09/10/2010 11:15 AM, Steve Wise wrote:
> T4 support on-chip SQs to reduce latency.  This patch adds
> support for this in iw_cxgb4.
>
> Changes:
>
> Manage ocqp memory like other adapter mem resources.
>
> Allocate user mode SQs from ocqp mem if available.
>
> Map ocqp mem to user process using write combining.
>
> Map PCIE_MA_SYNC reg to user process.
>
> Bump uverbs ABI.
>
> Signed-off-by: Steve Wise<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>
>   drivers/infiniband/hw/cxgb4/device.c   |   19 ++++++
>   drivers/infiniband/hw/cxgb4/iw_cxgb4.h |    7 ++
>   drivers/infiniband/hw/cxgb4/provider.c |   28 ++++++---
>   drivers/infiniband/hw/cxgb4/qp.c       |   98 +++++++++++++++++++++++++++-----
>   drivers/infiniband/hw/cxgb4/resource.c |   56 ++++++++++++++++++
>   drivers/infiniband/hw/cxgb4/t4.h       |   40 +++++++++++--
>   drivers/infiniband/hw/cxgb4/user.h     |    7 ++
>   7 files changed, 226 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
> index 2851bf8..986cfd7 100644
> --- a/drivers/infiniband/hw/cxgb4/device.c
> +++ b/drivers/infiniband/hw/cxgb4/device.c
> @@ -364,7 +364,14 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
>   		printk(KERN_ERR MOD "error %d initializing rqt pool\n", err);
>   		goto err3;
>   	}
> +	err = c4iw_ocqp_pool_create(rdev);
> +	if (err) {
> +		printk(KERN_ERR MOD "error %d initializing ocqp pool\n", err);
> +		goto err4;
> +	}
>   	return 0;
> +err4:
> +	c4iw_rqtpool_destroy(rdev);
>   err3:
>   	c4iw_pblpool_destroy(rdev);
>   err2:
> @@ -391,6 +398,7 @@ static void c4iw_remove(struct c4iw_dev *dev)
>   	idr_destroy(&dev->cqidr);
>   	idr_destroy(&dev->qpidr);
>   	idr_destroy(&dev->mmidr);
> +	iounmap(dev->rdev.oc_mw_kva);
>   	ib_dealloc_device(&dev->ibdev);
>   }
>
> @@ -406,6 +414,17 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
>   	}
>   	devp->rdev.lldi = *infop;
>
> +	devp->rdev.oc_mw_pa = pci_resource_start(devp->rdev.lldi.pdev, 2) +
> +		(pci_resource_len(devp->rdev.lldi.pdev, 2) -
> +		 roundup_pow_of_two(devp->rdev.lldi.vr->ocq.size));
> +	devp->rdev.oc_mw_kva = ioremap_wc(devp->rdev.oc_mw_pa,
> +					       devp->rdev.lldi.vr->ocq.size);
> +
> +	printk(KERN_INFO MOD "ocq memory: "
> +	       "hw_start 0x%x size %u mw_pa 0x%lx mw_kva %p\n",
> +	       devp->rdev.lldi.vr->ocq.start, devp->rdev.lldi.vr->ocq.size,
> +	       devp->rdev.oc_mw_pa, devp->rdev.oc_mw_kva);
> +
>   	mutex_lock(&dev_mutex);
>
>   	ret = c4iw_rdev_open(&devp->rdev);
> diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> index 7780116..1c26922 100644
> --- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> +++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> @@ -112,8 +112,11 @@ struct c4iw_rdev {
>   	struct c4iw_dev_ucontext uctx;
>   	struct gen_pool *pbl_pool;
>   	struct gen_pool *rqt_pool;
> +	struct gen_pool *ocqp_pool;
>   	u32 flags;
>   	struct cxgb4_lld_info lldi;
> +	unsigned long oc_mw_pa;
> +	void __iomem *oc_mw_kva;
>   };
>
>   static inline int c4iw_fatal_error(struct c4iw_rdev *rdev)
> @@ -675,8 +678,10 @@ int c4iw_init_resource(struct c4iw_rdev *rdev, u32 nr_tpt, u32 nr_pdid);
>   int c4iw_init_ctrl_qp(struct c4iw_rdev *rdev);
>   int c4iw_pblpool_create(struct c4iw_rdev *rdev);
>   int c4iw_rqtpool_create(struct c4iw_rdev *rdev);
> +int c4iw_ocqp_pool_create(struct c4iw_rdev *rdev);
>   void c4iw_pblpool_destroy(struct c4iw_rdev *rdev);
>   void c4iw_rqtpool_destroy(struct c4iw_rdev *rdev);
> +void c4iw_ocqp_pool_destroy(struct c4iw_rdev *rdev);
>   void c4iw_destroy_resource(struct c4iw_resource *rscp);
>   int c4iw_destroy_ctrl_qp(struct c4iw_rdev *rdev);
>   int c4iw_register_device(struct c4iw_dev *dev);
> @@ -742,6 +747,8 @@ u32 c4iw_rqtpool_alloc(struct c4iw_rdev *rdev, int size);
>   void c4iw_rqtpool_free(struct c4iw_rdev *rdev, u32 addr, int size);
>   u32 c4iw_pblpool_alloc(struct c4iw_rdev *rdev, int size);
>   void c4iw_pblpool_free(struct c4iw_rdev *rdev, u32 addr, int size);
> +u32 c4iw_ocqp_pool_alloc(struct c4iw_rdev *rdev, int size);
> +void c4iw_ocqp_pool_free(struct c4iw_rdev *rdev, u32 addr, int size);
>   int c4iw_ofld_send(struct c4iw_rdev *rdev, struct sk_buff *skb);
>   void c4iw_flush_hw_cq(struct t4_cq *cq);
>   void c4iw_count_rcqes(struct t4_cq *cq, struct t4_wq *wq, int *count);
> diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
> index 8f645c8..a49a9c1 100644
> --- a/drivers/infiniband/hw/cxgb4/provider.c
> +++ b/drivers/infiniband/hw/cxgb4/provider.c
> @@ -149,19 +149,28 @@ static int c4iw_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
>   	addr = mm->addr;
>   	kfree(mm);
>
> -	if ((addr>= pci_resource_start(rdev->lldi.pdev, 2))&&
> -	    (addr<  (pci_resource_start(rdev->lldi.pdev, 2) +
> -		       pci_resource_len(rdev->lldi.pdev, 2)))) {
> +	if ((addr>= pci_resource_start(rdev->lldi.pdev, 0))&&
> +	    (addr<  (pci_resource_start(rdev->lldi.pdev, 0) +
> +		    pci_resource_len(rdev->lldi.pdev, 0)))) {
>
>   		/*
> -		 * Map T4 DB register.
> +		 * MA_SYNC register...
>   		 */
> -		if (vma->vm_flags&  VM_READ)
> -			return -EPERM;
> -
>   		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> -		vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND;
> -		vma->vm_flags&= ~VM_MAYREAD;
> +		ret = io_remap_pfn_range(vma, vma->vm_start,
> +					 addr>>  PAGE_SHIFT,
> +					 len, vma->vm_page_prot);
> +	} else if ((addr>= pci_resource_start(rdev->lldi.pdev, 2))&&
> +		   (addr<  (pci_resource_start(rdev->lldi.pdev, 2) +
> +		    pci_resource_len(rdev->lldi.pdev, 2)))) {
> +
> +		/*
> +		 * Map user DB or OCQP memory...
> +		 */
> +		if (addr>= rdev->oc_mw_pa)
> +			vma->vm_page_prot = t4_pgprot_wc(vma->vm_page_prot);
> +		else
> +			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>   		ret = io_remap_pfn_range(vma, vma->vm_start,
>   					 addr>>  PAGE_SHIFT,
>   					 len, vma->vm_page_prot);
> @@ -472,6 +481,7 @@ int c4iw_register_device(struct c4iw_dev *dev)
>   	dev->ibdev.post_send = c4iw_post_send;
>   	dev->ibdev.post_recv = c4iw_post_receive;
>   	dev->ibdev.get_protocol_stats = c4iw_get_mib;
> +	dev->ibdev.uverbs_abi_ver = C4IW_UVERBS_ABI_VERSION;
>
>   	dev->ibdev.iwcm = kmalloc(sizeof(struct iw_cm_verbs), GFP_KERNEL);
>   	if (!dev->ibdev.iwcm)
> diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
> index ee785e2..e0f433f 100644
> --- a/drivers/infiniband/hw/cxgb4/qp.c
> +++ b/drivers/infiniband/hw/cxgb4/qp.c
> @@ -31,6 +31,55 @@
>    */
>   #include "iw_cxgb4.h"
>
> +static int ocqp_support;
> +module_param(ocqp_support, int, 0644);
> +MODULE_PARM_DESC(ocqp_support, "Support on-chip SQs (default=0)");
> +
> +static void dealloc_oc_sq(struct c4iw_rdev *rdev, struct t4_sq *sq)
> +{
> +	c4iw_ocqp_pool_free(rdev, sq->dma_addr, sq->memsize);
> +}
> +
> +static void dealloc_host_sq(struct c4iw_rdev *rdev, struct t4_sq *sq)
> +{
> +	dma_free_coherent(&(rdev->lldi.pdev->dev), sq->memsize, sq->queue,
> +			  pci_unmap_addr(sq, mapping));
> +}
> +
> +static void dealloc_sq(struct c4iw_rdev *rdev, struct t4_sq *sq)
> +{
> +	if (t4_sq_onchip(sq))
> +		dealloc_oc_sq(rdev, sq);
> +	else
> +		dealloc_host_sq(rdev, sq);
> +}
> +
> +static int alloc_oc_sq(struct c4iw_rdev *rdev, struct t4_sq *sq)
> +{
> +	if (!ocqp_support || !t4_ocqp_supported())
> +		return -ENOSYS;
> +	sq->dma_addr = c4iw_ocqp_pool_alloc(rdev, sq->memsize);
> +	if (!sq->dma_addr)
> +		return -ENOMEM;
> +	sq->phys_addr = rdev->oc_mw_pa + sq->dma_addr -
> +			rdev->lldi.vr->ocq.start;
> +	sq->queue = (__force union t4_wr *)(rdev->oc_mw_kva + sq->dma_addr -
> +					    rdev->lldi.vr->ocq.start);
> +	sq->flags |= T4_SQ_ONCHIP;
> +	return 0;
> +}
> +
> +static int alloc_host_sq(struct c4iw_rdev *rdev, struct t4_sq *sq)
> +{
> +	sq->queue = dma_alloc_coherent(&(rdev->lldi.pdev->dev), sq->memsize,
> +				&(sq->dma_addr), GFP_KERNEL);
> +	if (!sq->queue)
> +		return -ENOMEM;
> +	sq->phys_addr = virt_to_phys(sq->queue);
> +	pci_unmap_addr_set(sq, mapping, sq->dma_addr);
> +	return 0;
> +}
> +
>   static int destroy_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
>   		      struct c4iw_dev_ucontext *uctx)
>   {
> @@ -41,9 +90,7 @@ static int destroy_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
>   	dma_free_coherent(&(rdev->lldi.pdev->dev),
>   			  wq->rq.memsize, wq->rq.queue,
>   			  dma_unmap_addr(&wq->rq, mapping));
> -	dma_free_coherent(&(rdev->lldi.pdev->dev),
> -			  wq->sq.memsize, wq->sq.queue,
> -			  dma_unmap_addr(&wq->sq, mapping));
> +	dealloc_sq(rdev,&wq->sq);
>   	c4iw_rqtpool_free(rdev, wq->rq.rqt_hwaddr, wq->rq.rqt_size);
>   	kfree(wq->rq.sw_rq);
>   	kfree(wq->sq.sw_sq);
> @@ -93,11 +140,12 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
>   	if (!wq->rq.rqt_hwaddr)
>   		goto err4;
>
> -	wq->sq.queue = dma_alloc_coherent(&(rdev->lldi.pdev->dev),
> -					  wq->sq.memsize,&(wq->sq.dma_addr),
> -					  GFP_KERNEL);
> -	if (!wq->sq.queue)
> -		goto err5;
> +	if (user) {
> +		if (alloc_oc_sq(rdev,&wq->sq)&&  alloc_host_sq(rdev,&wq->sq))
> +			goto err5;
> +	} else
> +		if (alloc_host_sq(rdev,&wq->sq))
> +			goto err5;
>   	memset(wq->sq.queue, 0, wq->sq.memsize);
>   	dma_unmap_addr_set(&wq->sq, mapping, wq->sq.dma_addr);
>
> @@ -158,6 +206,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
>   		V_FW_RI_RES_WR_HOSTFCMODE(0) |	/* no host cidx updates */
>   		V_FW_RI_RES_WR_CPRIO(0) |	/* don't keep in chip cache */
>   		V_FW_RI_RES_WR_PCIECHN(0) |	/* set by uP at ri_init time */
> +		t4_sq_onchip(&wq->sq) ? F_FW_RI_RES_WR_ONCHIP : 0 |
>   		V_FW_RI_RES_WR_IQID(scq->cqid));
>   	res->u.sqrq.dcaen_to_eqsize = cpu_to_be32(
>   		V_FW_RI_RES_WR_DCAEN(0) |
> @@ -212,9 +261,7 @@ err7:
>   			  wq->rq.memsize, wq->rq.queue,
>   			  dma_unmap_addr(&wq->rq, mapping));
>   err6:
> -	dma_free_coherent(&(rdev->lldi.pdev->dev),
> -			  wq->sq.memsize, wq->sq.queue,
> -			  dma_unmap_addr(&wq->sq, mapping));
> +	dealloc_sq(rdev,&wq->sq);
>   err5:
>   	c4iw_rqtpool_free(rdev, wq->rq.rqt_hwaddr, wq->rq.rqt_size);
>   err4:
> @@ -1361,7 +1408,7 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
>   	int sqsize, rqsize;
>   	struct c4iw_ucontext *ucontext;
>   	int ret;
> -	struct c4iw_mm_entry *mm1, *mm2, *mm3, *mm4;
> +	struct c4iw_mm_entry *mm1, *mm2, *mm3, *mm4, *mm5 = NULL;
>
>   	PDBG("%s ib_pd %p\n", __func__, pd);
>
> @@ -1459,7 +1506,15 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
>   			ret = -ENOMEM;
>   			goto err6;
>   		}
> -
> +		if (t4_sq_onchip(&qhp->wq.sq)) {
> +			mm5 = kmalloc(sizeof *mm5, GFP_KERNEL);
> +			if (!mm5) {
> +				ret = -ENOMEM;
> +				goto err7;
> +			}
> +			uresp.flags = C4IW_QPF_ONCHIP;
> +		} else
> +			uresp.flags = 0;
>   		uresp.qid_mask = rhp->rdev.qpmask;
>   		uresp.sqid = qhp->wq.sq.qid;
>   		uresp.sq_size = qhp->wq.sq.size;
> @@ -1468,6 +1523,10 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
>   		uresp.rq_size = qhp->wq.rq.size;
>   		uresp.rq_memsize = qhp->wq.rq.memsize;
>   		spin_lock(&ucontext->mmap_lock);
> +		if (mm5) {
> +			uresp.ma_sync_key = ucontext->key;
> +			ucontext->key += PAGE_SIZE;
> +		}
>   		uresp.sq_key = ucontext->key;
>   		ucontext->key += PAGE_SIZE;
>   		uresp.rq_key = ucontext->key;
> @@ -1479,9 +1538,9 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
>   		spin_unlock(&ucontext->mmap_lock);
>   		ret = ib_copy_to_udata(udata,&uresp, sizeof uresp);
>   		if (ret)
> -			goto err7;
> +			goto err8;
>   		mm1->key = uresp.sq_key;
> -		mm1->addr = virt_to_phys(qhp->wq.sq.queue);
> +		mm1->addr = qhp->wq.sq.phys_addr;
>   		mm1->len = PAGE_ALIGN(qhp->wq.sq.memsize);
>   		insert_mmap(ucontext, mm1);
>   		mm2->key = uresp.rq_key;
> @@ -1496,6 +1555,13 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
>   		mm4->addr = qhp->wq.rq.udb;
>   		mm4->len = PAGE_SIZE;
>   		insert_mmap(ucontext, mm4);
> +		if (mm5) {
> +			mm5->key = uresp.ma_sync_key;
> +			mm5->addr = (pci_resource_start(rhp->rdev.lldi.pdev, 0)
> +				    + A_PCIE_MA_SYNC)&  PAGE_MASK;
> +			mm5->len = PAGE_SIZE;
> +			insert_mmap(ucontext, mm5);
> +		}
>   	}
>   	qhp->ibqp.qp_num = qhp->wq.sq.qid;
>   	init_timer(&(qhp->timer));
> @@ -1503,6 +1569,8 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
>   	     __func__, qhp, qhp->attr.sq_num_entries, qhp->attr.rq_num_entries,
>   	     qhp->wq.sq.qid);
>   	return&qhp->ibqp;
> +err8:
> +	kfree(mm5);
>   err7:
>   	kfree(mm4);
>   err6:
> diff --git a/drivers/infiniband/hw/cxgb4/resource.c b/drivers/infiniband/hw/cxgb4/resource.c
> index 26365f6..4fb50d5 100644
> --- a/drivers/infiniband/hw/cxgb4/resource.c
> +++ b/drivers/infiniband/hw/cxgb4/resource.c
> @@ -422,3 +422,59 @@ void c4iw_rqtpool_destroy(struct c4iw_rdev *rdev)
>   {
>   	gen_pool_destroy(rdev->rqt_pool);
>   }
> +
> +/*
> + * On-Chip QP Memory.
> + */
> +#define MIN_OCQP_SHIFT 12	/* 4KB == min ocqp size */
> +
> +u32 c4iw_ocqp_pool_alloc(struct c4iw_rdev *rdev, int size)
> +{
> +	unsigned long addr = gen_pool_alloc(rdev->ocqp_pool, size);
> +	PDBG("%s addr 0x%x size %d\n", __func__, (u32)addr, size);
> +	return (u32)addr;
> +}
> +
> +void c4iw_ocqp_pool_free(struct c4iw_rdev *rdev, u32 addr, int size)
> +{
> +	PDBG("%s addr 0x%x size %d\n", __func__, addr, size);
> +	gen_pool_free(rdev->ocqp_pool, (unsigned long)addr, size);
> +}
> +
> +int c4iw_ocqp_pool_create(struct c4iw_rdev *rdev)
> +{
> +	unsigned start, chunk, top;
> +
> +	rdev->ocqp_pool = gen_pool_create(MIN_OCQP_SHIFT, -1);
> +	if (!rdev->ocqp_pool)
> +		return -ENOMEM;
> +
> +	start = rdev->lldi.vr->ocq.start;
> +	chunk = rdev->lldi.vr->ocq.size;
> +	top = start + chunk;
> +
> +	while (start<  top) {
> +		chunk = min(top - start + 1, chunk);
> +		if (gen_pool_add(rdev->ocqp_pool, start, chunk, -1)) {
> +			PDBG("%s failed to add OCQP chunk (%x/%x)\n",
> +			     __func__, start, chunk);
> +			if (chunk<= 1024<<  MIN_OCQP_SHIFT) {
> +				printk(KERN_WARNING MOD
> +				       "Failed to add all OCQP chunks (%x/%x)\n",
> +				       start, top - start);
> +				return 0;
> +			}
> +			chunk>>= 1;
> +		} else {
> +			PDBG("%s added OCQP chunk (%x/%x)\n",
> +			     __func__, start, chunk);
> +			start += chunk;
> +		}
> +	}
> +	return 0;
> +}
> +
> +void c4iw_ocqp_pool_destroy(struct c4iw_rdev *rdev)
> +{
> +	gen_pool_destroy(rdev->ocqp_pool);
> +}
> diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
> index 24f3690..51a845f 100644
> --- a/drivers/infiniband/hw/cxgb4/t4.h
> +++ b/drivers/infiniband/hw/cxgb4/t4.h
> @@ -52,6 +52,7 @@
>   #define T4_STAG_UNSET 0xffffffff
>   #define T4_FW_MAJ 0
>   #define T4_EQ_STATUS_ENTRIES (L1_CACHE_BYTES>  64 ? 2 : 1)
> +#define A_PCIE_MA_SYNC 0x30b4
>
>   struct t4_status_page {
>   	__be32 rsvd1;	/* flit 0 - hw owns */
> @@ -266,10 +267,36 @@ struct t4_swsqe {
>   	u16			idx;
>   };
>
> +static inline pgprot_t t4_pgprot_wc(pgprot_t prot)
> +{
> +#if defined(__i386__) || defined(__x86_64__)
> +	return pgprot_writecombine(prot);
> +#elif defined(CONFIG_PPC64)
> +	return __pgprot((pgprot_val(prot) | _PAGE_NO_CACHE)&
> +			~(pgprot_t)_PAGE_GUARDED);
> +#else
> +	return pgprot_noncached(prot);
> +#endif
> +}
> +
> +static inline int t4_ocqp_supported(void)
> +{
> +#if defined(__i386__) || defined(__x86_64__) || defined(CONFIG_PPC64)
> +	return 1;
> +#else
> +	return 0;
> +#endif
> +}
> +
> +enum {
> +	T4_SQ_ONCHIP = (1<<0),
> +};
> +
>   struct t4_sq {
>   	union t4_wr *queue;
>   	dma_addr_t dma_addr;
>   	DEFINE_DMA_UNMAP_ADDR(mapping);
> +	unsigned long phys_addr;
>   	struct t4_swsqe *sw_sq;
>   	struct t4_swsqe *oldest_read;
>   	u64 udb;
> @@ -280,6 +307,7 @@ struct t4_sq {
>   	u16 cidx;
>   	u16 pidx;
>   	u16 wq_pidx;
> +	u16 flags;
>   };
>
>   struct t4_swrqe {
> @@ -350,6 +378,11 @@ static inline void t4_rq_consume(struct t4_wq *wq)
>   		wq->rq.cidx = 0;
>   }
>
> +static inline int t4_sq_onchip(struct t4_sq *sq)
> +{
> +	return sq->flags&  T4_SQ_ONCHIP;
> +}
> +
>   static inline int t4_sq_empty(struct t4_wq *wq)
>   {
>   	return wq->sq.in_use == 0;
> @@ -396,30 +429,27 @@ static inline void t4_ring_rq_db(struct t4_wq *wq, u16 inc)
>
>   static inline int t4_wq_in_error(struct t4_wq *wq)
>   {
> -	return wq->sq.queue[wq->sq.size].status.qp_err;
> +	return wq->rq.queue[wq->sq.size].status.qp_err;
>    


Oops, cought this during regression testing:  The above line should be 
indexing by wq->rq.size, not wq->sq.size.  This error caused 
intermittent post failures and I missed it on my first round of testing.



>   }
>
>   static inline void t4_set_wq_in_error(struct t4_wq *wq)
>   {
> -	wq->sq.queue[wq->sq.size].status.qp_err = 1;
>   	wq->rq.queue[wq->rq.size].status.qp_err = 1;
>   }
>
>   static inline void t4_disable_wq_db(struct t4_wq *wq)
>   {
> -	wq->sq.queue[wq->sq.size].status.db_off = 1;
>   	wq->rq.queue[wq->rq.size].status.db_off = 1;
>   }
>
>   static inline void t4_enable_wq_db(struct t4_wq *wq)
>   {
> -	wq->sq.queue[wq->sq.size].status.db_off = 0;
>   	wq->rq.queue[wq->rq.size].status.db_off = 0;
>   }
>
>   static inline int t4_wq_db_enabled(struct t4_wq *wq)
>   {
> -	return !wq->sq.queue[wq->sq.size].status.db_off;
> +	return !wq->rq.queue[wq->sq.size].status.db_off;
>    

Same issue here.


>   }
>
>   struct t4_cq {
> diff --git a/drivers/infiniband/hw/cxgb4/user.h b/drivers/infiniband/hw/cxgb4/user.h
> index ed6414a..e6669d5 100644
> --- a/drivers/infiniband/hw/cxgb4/user.h
> +++ b/drivers/infiniband/hw/cxgb4/user.h
> @@ -50,7 +50,13 @@ struct c4iw_create_cq_resp {
>   	__u32 qid_mask;
>   };
>
> +
> +enum {
> +	C4IW_QPF_ONCHIP = (1<<0)
> +};
> +
>   struct c4iw_create_qp_resp {
> +	__u64 ma_sync_key;
>   	__u64 sq_key;
>   	__u64 rq_key;
>   	__u64 sq_db_gts_key;
> @@ -62,5 +68,6 @@ struct c4iw_create_qp_resp {
>   	__u32 sq_size;
>   	__u32 rq_size;
>   	__u32 qid_mask;
> +	__u32 flags;
>   };
>   #endif
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
