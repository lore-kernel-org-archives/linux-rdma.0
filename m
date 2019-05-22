From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 0/1] Use HMM for ODP v4
Date: Wed, 22 May 2019 15:32:03 -0300
Message-ID: <20190522183203.GE6054@ziepe.ca>
References: <20190411181314.19465-1-jglisse@redhat.com>
 <20190506195657.GA30261@ziepe.ca>
 <20190521205321.GC3331@redhat.com>
 <20190522005225.GA30819@ziepe.ca>
 <20190522174852.GA23038@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190522174852.GA23038@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jerome Glisse <jglisse@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 22, 2019 at 01:48:52PM -0400, Jerome Glisse wrote:

> From 0b429b2ffbec348e283693cb97d7ffce760d89da Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>
> Date: Sat, 8 Dec 2018 15:47:55 -0500
> Subject: [PATCH] RDMA/odp: convert to use HMM for ODP v5
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Convert ODP to use HMM so that we can build on common infrastructure
> for different class of devices that want to mirror a process address
> space into a device. There is no functional changes.
> 
> Changes since v4:
>     - Rebase on top of rdma-next
> Changes since v3:
>     - Rebase on top of 5.2-rc1
> Changes since v2:
>     - Update to match changes to HMM API
> Changes since v1:
>     - improved comments
>     - simplified page alignment computation
> 
> Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Cc: Leon Romanovsky <leonro@mellanox.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Artemy Kovalyov <artemyko@mellanox.com>
> Cc: Moni Shoua <monis@mellanox.com>
> Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Cc: Kaike Wan <kaike.wan@intel.com>
> Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
>  drivers/infiniband/core/umem_odp.c | 506 +++++++++--------------------
>  drivers/infiniband/hw/mlx5/mem.c   |  20 +-
>  drivers/infiniband/hw/mlx5/mr.c    |   2 +-
>  drivers/infiniband/hw/mlx5/odp.c   | 104 +++---
>  include/rdma/ib_umem_odp.h         |  47 +--
>  5 files changed, 233 insertions(+), 446 deletions(-)

The kconfig stuff is missing, and it doesn't compile in various cases
I tried.

The kconfig stuff for hmm is also really obnoxious, you can't just
enabe HMM_MIRROR, you have to track down all the little required
elements to get it to turn on..

Once I did get it to compile, I also get warnings:

mm/hmm.c: In function ‘hmm_vma_walk_pud’:
mm/hmm.c:782:28: warning: unused variable ‘pfn’ [-Wunused-variable]
   unsigned long i, npages, pfn;
                            ^~~
mm/hmm.c: In function ‘hmm_range_snapshot’:
mm/hmm.c:1027:19: warning: unused variable ‘h’ [-Wunused-variable]
    struct hstate *h = hstate_vma(vma);

Because this kernel doesn't have CONFIG_HUGETLB_PAGE

Please fold this into your patch if it has to be resent.. I think it
fixes the compilation problems.

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index cbfbea49f126cd..e3eefd0917985a 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -63,7 +63,7 @@ config INFINIBAND_USER_MEM
 config INFINIBAND_ON_DEMAND_PAGING
 	bool "InfiniBand on-demand paging support"
 	depends on INFINIBAND_USER_MEM
-	select MMU_NOTIFIER
+	depends on HMM_MIRROR
 	default y
 	---help---
 	  On demand paging support for the InfiniBand subsystem.
diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
index e1476e9ebb7906..f760103c07349a 100644
--- a/include/rdma/ib_umem_odp.h
+++ b/include/rdma/ib_umem_odp.h
@@ -115,6 +115,16 @@ static inline size_t ib_umem_odp_num_pages(struct ib_umem_odp *umem_odp)
 
 #define ODP_DMA_ADDR_MASK (~(ODP_READ_ALLOWED_BIT | ODP_WRITE_ALLOWED_BIT))
 
+#define ODP_READ_BIT	(1<<0ULL)
+#define ODP_WRITE_BIT	(1<<1ULL)
+/*
+ * The device bit is not use by ODP but is there to full-fill HMM API which
+ * also support device with device memory (like GPU). So from ODP/RDMA POV
+ * this can be ignored.
+ */
+#define ODP_DEVICE_BIT	(1<<2ULL)
+#define ODP_FLAGS_BITS	3
+
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 
 struct ib_ucontext_per_mm {
@@ -138,16 +148,6 @@ struct ib_umem_odp *ib_alloc_odp_umem(struct ib_umem_odp *root_umem,
 				      unsigned long addr, size_t size);
 void ib_umem_odp_release(struct ib_umem_odp *umem_odp);
 
-#define ODP_READ_BIT	(1<<0ULL)
-#define ODP_WRITE_BIT	(1<<1ULL)
-/*
- * The device bit is not use by ODP but is there to full-fill HMM API which
- * also support device with device memory (like GPU). So from ODP/RDMA POV
- * this can be ignored.
- */
-#define ODP_DEVICE_BIT	(1<<2ULL)
-#define ODP_FLAGS_BITS	3
-
 long ib_umem_odp_map_dma_pages(struct ib_umem_odp *umem_odp,
 			       struct hmm_range *range);
 
