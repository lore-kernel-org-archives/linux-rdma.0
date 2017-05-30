From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 5/9] IB/hfi1: Remove subtraction of uninitialized
 value
Date: Mon, 29 May 2017 17:19:46 -0700
Message-ID: <20170530001926.534.29964.stgit@scvm10.sc.intel.com>
References: <20170530000314.534.72983.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530000314.534.72983.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In process_receive_packet the packet header field is used to calculate
the length of the packet. However this is not necessarily setup. In fact
only if the ECN prescan is enabled will the packet header be valid at
this point.

The code works as is because we do not do anything with the packet
length at this point in the packet processing. The length and header are
setup correctly in hfi1_setup_ib_header which is called by the following
sequence:

process_receive_packet()
-> rhf_receieve_function_map[]()
--> process_receive_ib()
---> hfi1_setup_9B_packet()
----> hfi1_setup_ib_header()

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 2a1022e..9e59430 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -703,7 +703,6 @@ static inline int process_rcv_packet(struct hfi1_packet *packet, int thread)
 
 	packet->etype = rhf_rcv_type(packet->rhf);
 
-	packet->hlen = (u8 *)packet->rhf_addr - (u8 *)packet->hdr;
 	/* total length */
 	packet->tlen = rhf_pkt_len(packet->rhf); /* in bytes */
 	/* retrieve eager buffer details */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
