From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: iw_cxgb4: Pass qid range to user space driver
Date: Fri, 8 Jan 2016 16:12:47 +0300
Message-ID: <20160108131247.GA4738@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Hariprasad S,

The patch c5dfb000b904: "iw_cxgb4: Pass qid range to user space
driver" from Dec 11, 2015, leads to the following static checker
warning:

	drivers/infiniband/hw/cxgb4/device.c:857 c4iw_rdev_open()
	warn: variable dereferenced before check 'rdev->status_page' (see line 853)

drivers/infiniband/hw/cxgb4/device.c
   841          err = c4iw_rqtpool_create(rdev);
   842          if (err) {
   843                  printk(KERN_ERR MOD "error %d initializing rqt pool\n", err);
   844                  goto err3;
   845          }
   846          err = c4iw_ocqp_pool_create(rdev);
   847          if (err) {
   848                  printk(KERN_ERR MOD "error %d initializing ocqp pool\n", err);
   849                  goto err4;
   850          }
   851          rdev->status_page = (struct t4_dev_status_page *)
   852                              __get_free_page(GFP_KERNEL);
   853          rdev->status_page->qp_start = rdev->lldi.vr->qp.start;
   854          rdev->status_page->qp_size = rdev->lldi.vr->qp.size;
   855          rdev->status_page->cq_start = rdev->lldi.vr->cq.start;
   856          rdev->status_page->cq_size = rdev->lldi.vr->cq.size;
   857          if (!rdev->status_page) {
   858                  pr_err(MOD "error allocating status page\n");
   859                  goto err4;

Ugh...  Obviously move the error handling first.  But then fix the
GW-Basic labels to meaningful error names.  You wouldn't name functions
one(), two() or variables var1, var2, labels are the same.  Pick names
that reflect what the goto does.  "goto err_destroy_rqt;"  If we
had picked a good name we wouldn't have had to scroll down to see the
second bug.  It should be goto err_destroy_ocqp; but we are missing a
call to c4iw_ocqp_pool_destroy().

Normal error handling is formulaic and does not require active thinking.
It is easy to review because you just have to keep track of the most
recent allocation.

https://plus.google.com/106378716002406849458/posts/dnanfhQ4mHQ

   860          }
   861  
   862          if (c4iw_wr_log) {
   863                  rdev->wr_log = kzalloc((1 << c4iw_wr_log_size_order) *
   864                                         sizeof(*rdev->wr_log), GFP_KERNEL);
   865                  if (rdev->wr_log) {
   866                          rdev->wr_log_size = 1 << c4iw_wr_log_size_order;
   867                          atomic_set(&rdev->wr_log_idx, 0);
   868                  } else {
   869                          pr_err(MOD "error allocating wr_log. Logging disabled\n");
   870                  }
   871          }
   872  
   873          rdev->status_page->db_off = 0;
   874  
   875          return 0;
   876  err4:
   877          c4iw_rqtpool_destroy(rdev);
   878  err3:
   879          c4iw_pblpool_destroy(rdev);
   880  err2:

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
