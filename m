From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 2/3] IB/core: Use rdma_cap_opa_mad to check for OPA
Date: Fri, 22 Dec 2017 08:45:52 -0800
Message-ID: <20171222164549.29731.42998.stgit@scvm10.sc.intel.com>
References: <20171222164036.29731.43475.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171222164036.29731.43475.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use rdma_cap_opa_mad() to check for OPA to promote code reuse.

Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/user_mad.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 4b64dd0..33d5e8e 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -233,8 +233,7 @@ static void recv_handler(struct ib_mad_agent *agent,
 	 * On OPA devices it is okay to lose the upper 16 bits of LID as this
 	 * information is obtained elsewhere. Mask off the upper 16 bits.
 	 */
-	if (agent->device->port_immutable[agent->port_num].core_cap_flags &
-	    RDMA_CORE_PORT_INTEL_OPA)
+	if (rdma_cap_opa_mad(agent->device, agent->port_num))
 		packet->mad.hdr.lid = ib_lid_be16(0xFFFF &
 						  mad_recv_wc->wc->slid);
 	else

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
