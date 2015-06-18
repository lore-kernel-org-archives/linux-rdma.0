From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC] IB: Add rdma_cap_ib_switch helper and use where
 appropriate
Date: Thu, 18 Jun 2015 14:25:19 -0600
Message-ID: <20150618202519.GA17737@obsidianresearch.com>
References: <55832793.1080105@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55832793.1080105-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 18, 2015 at 04:18:27PM -0400, Hal Rosenstock wrote:

> In addition, an ib_switch helper was added to ib_verbs.h
> based on the is_switch device bit rather than node_type
> (although those should be consistent).

This is basically fine, but it would be nicer to change the port
handling stuff over to port number code (ie end_port/start_port and
maybe some new stuff) than to keep the existing open coded versions.

> @@ -3299,7 +3300,7 @@ static void ib_mad_init_device(struct ib_device *device)
>  {
>  	int start, end, i;
>  
> -	if (device->node_type == RDMA_NODE_IB_SWITCH) {
> +	if (rdma_cap_ib_switch(device)) {
>  		start = 0;
>  		end   = 0;
>  	} else {

This sort of stuff especially.

Ira had patch that made some functions related to this public, not
sure if it is applied yet..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
