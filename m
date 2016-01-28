From: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Subject: [PATCH RESEND] staging: rdma: hfi1: diag: constify hfi1_filter_array
 structure
Date: Thu, 28 Jan 2016 22:50:21 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1601282248250.2020@localhost6.localdomain6>
References: <20160128203021.GA19371@phlsvsds.ph.intel.com> <20160128204802.GA15184@kroah.com> <alpine.DEB.2.02.1601282151460.2020@localhost6.localdomain6> <20160128214224.GB19371@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160128214224.GB19371-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The hfi1_filter_array structure is never modified, so declare it as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>

---
No change, resent to be picked up by Doug Ledford

 drivers/staging/rdma/hfi1/diag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 0c88317..e41159f 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -257,7 +257,7 @@ static int hfi1_filter_ib_service_level(void *ibhdr, void *packet_data,
 static int hfi1_filter_ib_pkey(void *ibhdr, void *packet_data, void *value);
 static int hfi1_filter_direction(void *ibhdr, void *packet_data, void *value);
 
-static struct hfi1_filter_array hfi1_filters[] = {
+static const struct hfi1_filter_array hfi1_filters[] = {
 	{ hfi1_filter_lid },
 	{ hfi1_filter_dlid },
 	{ hfi1_filter_mad_mgmt_class },

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
