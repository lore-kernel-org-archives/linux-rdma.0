From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] ib_mad: Ignore iWARP devices on device removal.
Date: Thu, 4 Mar 2010 13:53:19 -0800
Message-ID: <AFD61576933149C990D3373E7DF482F5@amr.corp.intel.com>
References: <20100304181818.18953.44421.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100304181818.18953.44421.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Steve Wise' <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>When you unload an iWARP device, the ib_mad module logs errors.
>It should be ignoring iWARP devices on device removal just like it does
>on device add.
>
>Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

>---
Looks okay to me.  Thanks, Steve.

>
> drivers/infiniband/core/mad.c |    3 +++
> 1 files changed, 3 insertions(+), 0 deletions(-)
>
>diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
>index 7522008..6216187 100644
>--- a/drivers/infiniband/core/mad.c
>+++ b/drivers/infiniband/core/mad.c
>@@ -2964,6 +2964,9 @@ static void ib_mad_remove_device(struct ib_device
>*device)
> {
> 	int i, num_ports, cur_port;
>
>+	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
>+		return;
>+
> 	if (device->node_type == RDMA_NODE_IB_SWITCH) {
> 		num_ports = 1;
> 		cur_port = 0;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
