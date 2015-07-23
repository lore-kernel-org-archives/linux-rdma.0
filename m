From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 00/10] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Thu, 23 Jul 2015 12:30:44 -0600
Message-ID: <20150723183044.GA1868@obsidianresearch.com>
References: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55B0F06E.8000603@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55B0F06E.8000603@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Amir Vadai <amirv@mellanox.com>, Andy Grover <andy.grover@oracle.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, Zach Brown <zach.brown@oracle.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 23, 2015 at 06:47:26AM -0700, Bart Van Assche wrote:
> On 07/22/15 16:34, Jason Gunthorpe wrote:
> >The remaining users of ib_get_dma_mr are all unsafe:
> >   [ ... ]
> >  drivers/infiniband/ulp/srp/ib_srp.c:
> >	srp_dev->mr = ib_get_dma_mr(srp_dev->pd,
> >				    IB_ACCESS_LOCAL_WRITE |
> >				    IB_ACCESS_REMOTE_READ |
> >				    IB_ACCESS_REMOTE_WRITE);
> 
> Hello Jason,
> 
> This statement might need some clarification. Are you aware that this memory
> region is only used if the kernel module parameter register_always is zero ?

It doesn't matter, just making the above call is enough to create the
security problem, even if the rkey is not used.

I looked at the register_always stuff, it isn't obvious to me that it
interacts with this path:

static int srp_map_sg(struct srp_map_state *state, struct srp_rdma_ch *ch,
	if (dev->use_fast_reg) {
	} else {
		use_mr = !!ch->fmr_pool;
[..]
		if (srp_map_sg_entry(state, ch, sg, i, use_mr)) {

static int srp_map_sg_entry(struct srp_map_state *state,
	if (!use_mr) {
		srp_map_desc(state, dma_addr, dma_len, target->rkey);

Perhaps the above is dead code, all our IB drivers either support FMR
or FRWR, so maybe use_mr is always true?

It looks to me like register_always is similar to iSER, it is trying
to avoid a MR if there is only 1 S/G entry. That performance behavior
needs to default to disabled. The kernel must default to secure out of
the box.

> I will try to find some time to test the SRP changes in this series but I'm
> not sure yet when I will be able to do that.

This probably also takes care of the security issue for SRP, what do you
think?

>From d1ae6713fc011b6ff392e42cfb342899da8561ff Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date: Thu, 23 Jul 2015 12:19:53 -0600
Subject: [PATCH] IB/srp: Do not create an all physical insecure rkey by
 default

The ULP only needs this if the insecure register_always performance
optimization is enabled, or if FRWR/FMR is not supported in the driver.

Do not create an all physical MR unless it is needed to support either
of those modes. Default register_always to true so the out of the box
configuration does not create an insecure all physical MR.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 31 +++++++++++++++++++++----------
 drivers/infiniband/ulp/srp/ib_srp.h |  2 +-
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index fb9fed0fac28..a1e3818d0791 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -69,7 +69,7 @@ static unsigned int cmd_sg_entries;
 static unsigned int indirect_sg_entries;
 static bool allow_ext_sg;
 static bool prefer_fr;
-static bool register_always;
+static bool register_always = true;
 static int topspin_workarounds = 1;
 
 module_param(srp_sg_tablesize, uint, 0444);
@@ -3150,7 +3150,8 @@ static ssize_t srp_create_target(struct device *dev,
 	target->scsi_host	= target_host;
 	target->srp_host	= host;
 	target->lkey		= host->srp_dev->pd->local_dma_lkey;
-	target->rkey		= host->srp_dev->mr->rkey;
+	if (host->srp_dev->rkey_mr)
+		target->rkey		= host->srp_dev->rkey_mr->rkey;
 	target->cmd_sg_cnt	= cmd_sg_entries;
 	target->sg_tablesize	= indirect_sg_entries ? : cmd_sg_entries;
 	target->allow_ext_sg	= allow_ext_sg;
@@ -3381,6 +3382,7 @@ static void srp_add_one(struct ib_device *device)
 	struct srp_host *host;
 	int mr_page_shift, s, e, p;
 	u64 max_pages_per_mr;
+	unsigned int mr_flags = 0;
 
 	dev_attr = kmalloc(sizeof *dev_attr, GFP_KERNEL);
 	if (!dev_attr)
@@ -3399,8 +3401,11 @@ static void srp_add_one(struct ib_device *device)
 			    device->map_phys_fmr && device->unmap_fmr);
 	srp_dev->has_fr = (dev_attr->device_cap_flags &
 			   IB_DEVICE_MEM_MGT_EXTENSIONS);
-	if (!srp_dev->has_fmr && !srp_dev->has_fr)
+	if (!srp_dev->has_fmr && !srp_dev->has_fr) {
 		dev_warn(&device->dev, "neither FMR nor FR is supported\n");
+		/* Fall back to using an insecure all physical rkey */
+		mr_flags |= IB_ACCESS_REMOTE_READ | IB_ACCESS_REMOTE_WRITE;
+	}
 
 	srp_dev->use_fast_reg = (srp_dev->has_fr &&
 				 (!srp_dev->has_fmr || prefer_fr));
@@ -3436,12 +3441,17 @@ static void srp_add_one(struct ib_device *device)
 	if (IS_ERR(srp_dev->pd))
 		goto free_dev;
 
-	srp_dev->mr = ib_get_dma_mr(srp_dev->pd,
-				    IB_ACCESS_LOCAL_WRITE |
-				    IB_ACCESS_REMOTE_READ |
-				    IB_ACCESS_REMOTE_WRITE);
-	if (IS_ERR(srp_dev->mr))
-		goto err_pd;
+	if (register_always)
+		mr_flags |= IB_ACCESS_REMOTE_READ | IB_ACCESS_REMOTE_WRITE;
+
+	if (mr_flags) {
+		srp_dev->rkey_mr = ib_get_dma_mr(
+		    srp_dev->pd, IB_ACCESS_LOCAL_WRITE | mr_flags);
+		if (IS_ERR(srp_dev->rkey_mr))
+			goto err_pd;
+	} else
+		srp_dev->rkey_mr = NULL;
+
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH) {
 		s = 0;
@@ -3506,7 +3516,8 @@ static void srp_remove_one(struct ib_device *device)
 		kfree(host);
 	}
 
-	ib_dereg_mr(srp_dev->mr);
+	if (srp_dev->rkey_mr)
+		ib_dereg_mr(srp_dev->rkey_mr);
 	ib_dealloc_pd(srp_dev->pd);
 
 	kfree(srp_dev);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 17ee3f80ba55..8b241f17f8b8 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -95,7 +95,7 @@ struct srp_device {
 	struct list_head	dev_list;
 	struct ib_device       *dev;
 	struct ib_pd	       *pd;
-	struct ib_mr	       *mr;
+	struct ib_mr	       *rkey_mr;
 	u64			mr_page_mask;
 	int			mr_page_size;
 	int			mr_max_size;
-- 
2.1.4
