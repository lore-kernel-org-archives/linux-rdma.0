From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 09/12] IB/srp: Do not create an all physical insecure
 rkey by default
Date: Mon, 3 Aug 2015 08:39:32 -0700
Message-ID: <20150803153932.GA10054@infradead.org>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1438298547-21404-10-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438298547-21404-10-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Amir Vadai <amirv@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

In addition to the comments on the cover letter I think your
changes to srp_add_one could use this incremental cleanup:

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a546256..5e2cb53 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3381,7 +3381,7 @@ static void srp_add_one(struct ib_device *device)
 	struct srp_host *host;
 	int mr_page_shift, p;
 	u64 max_pages_per_mr;
-	unsigned int mr_flags = 0;
+	bool need_phys_rkey = false;
 
 	dev_attr = kmalloc(sizeof *dev_attr, GFP_KERNEL);
 	if (!dev_attr)
@@ -3403,7 +3403,7 @@ static void srp_add_one(struct ib_device *device)
 	if (!srp_dev->has_fmr && !srp_dev->has_fr) {
 		dev_warn(&device->dev, "neither FMR nor FR is supported\n");
 		/* Fall back to using an insecure all physical rkey */
-		mr_flags |= IB_ACCESS_REMOTE_READ | IB_ACCESS_REMOTE_WRITE;
+		need_phys_rkey = true;
 	}
 
 	srp_dev->use_fast_reg = (srp_dev->has_fr &&
@@ -3441,11 +3441,13 @@ static void srp_add_one(struct ib_device *device)
 		goto free_dev;
 
 	if (!register_always)
-		mr_flags |= IB_ACCESS_REMOTE_READ | IB_ACCESS_REMOTE_WRITE;
+		need_phys_rkey = true;
 
-	if (mr_flags) {
+	if (need_phys_rkey) {
 		srp_dev->rkey_mr = ib_get_dma_mr(
-		    srp_dev->pd, IB_ACCESS_LOCAL_WRITE | mr_flags);
+		    srp_dev->pd, IB_ACCESS_LOCAL_WRITE |
+		    		 IB_ACCESS_REMOTE_READ |
+				 IB_ACCESS_REMOTE_WRITE);
 		if (IS_ERR(srp_dev->rkey_mr))
 			goto err_pd;
 	} else
