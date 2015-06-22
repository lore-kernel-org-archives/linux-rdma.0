From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCHv2 RFC] IB: Add rdma_cap_ib_switch helper and use where
 appropriate
Date: Mon, 22 Jun 2015 14:20:56 -0600
Message-ID: <20150622202056.GA8049@obsidianresearch.com>
References: <5583536C.3010504@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5583536C.3010504-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 18, 2015 at 07:25:32PM -0400, Hal Rosenstock wrote:
> Persuant to Liran's comments on node_type on linux-rdma
> mailing list:
> 
> In an effort to reform the RDMA core and ULPs to minimize use of
> node_type in struct ib_device, an additional bit is added to
> struct ib_device for is_switch (IB switch). This is needed 
> to be initialized by any IB switch device driver. This is a 
> NEW requirement on such device drivers which are all
> "out of tree".
> 
> In addition, an ib_switch helper was added to ib_verbs.h
> based on the is_switch device bit rather than node_type
> (although those should be consistent).
> 
> The RDMA core (MAD, SMI, agent, sa_query, multicast, sysfs)
> as well as (IPoIB and SRP) ULPs are updated where
> appropriate to use this new helper. In some cases,
> the helper is now used under the covers of using
> rdma_[start end]_port rather than the open coding
> previously used.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Looks pretty good now.

Reviewed-By: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Although a bitfield isn't my preference:

> index 986fddb..b0f898e 100644
> +++ b/include/rdma/ib_verbs.h
> @@ -1745,6 +1745,7 @@ struct ib_device {
>  	char			     node_desc[64];
>  	__be64			     node_guid;
>  	u32			     local_dma_lkey;
> +	u16                          is_switch:1;
>  	u8                           node_type;
>  	u8                           phys_port_cnt;

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
