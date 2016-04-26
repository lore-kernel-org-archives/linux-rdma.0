From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Tue, 26 Apr 2016 16:10:26 -0700
Message-ID: <571FF562.3040902@sandisk.com>
References: <571A936F.7040409@sandisk.com> <571A94AF.7000609@sandisk.com>
 <20160424083538.GF7974@leon.nu> <571D6975.2020905@sandisk.com>
 <20160425055433.GG7974@leon.nu> <571DE793.6090705@grimberg.me>
 <20160425155320.GH7974@leon.nu> <571E42D2.70705@sandisk.com>
 <20160426141229.GI7974@leon.nu> <571FD8D3.1060403@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <571FD8D3.1060403-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/26/2016 02:08 PM, Sagi Grimberg wrote:
>>> I can add a WARN_ON_ONCE() statement for max_pages_per_mr == 1. That 
>>> will
>>> make it easy to figure out where to start looking if in the future a HCA
>>> driver would be added that causes max_pages_per_mr == 1.
> 
> If we're on the imaginary path, you can flat out fail the host creation.

How about folding the following change into this patch - this change
disables memory registration if max_mr_size <= 1:

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 8ae1543..9072f7f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3586,7 +3586,7 @@ static void srp_add_one(struct ib_device *device)
 			   IB_DEVICE_MEM_MGT_EXTENSIONS);
 	if (!srp_dev->has_fmr && !srp_dev->has_fr) {
 		dev_warn(&device->dev, "neither FMR nor FR is supported\n");
-	} else if (register_always >= 0) {
+	} else if (register_always >= 0 && device->attrs.max_mr_size > 1) {
 		srp_dev->use_fast_reg = (srp_dev->has_fr &&
 					 (!srp_dev->has_fmr || prefer_fr));
 		srp_dev->use_fmr = !srp_dev->use_fast_reg && srp_dev->has_fmr;

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
