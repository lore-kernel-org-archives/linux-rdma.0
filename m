From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC] RDMA/core: add rdma_get_dma_mr()
Date: Sun, 28 Jun 2015 18:47:15 +0300
Message-ID: <55901703.3050001@mellanox.com>
References: <20150625212917.14869.66238.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150625212917.14869.66238.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 26/06/2015 00:29, Steve Wise wrote:
> +enum rdma_mr_roles {
> +	RDMA_MRR_RECV			= 1,
> +	RDMA_MRR_SEND			= (1<<1),
> +	RDMA_MRR_READ_SOURCE		= (1<<2),
> +	RDMA_MRR_READ_SINK		= (1<<3),

Maybe it's just me, but it took me a second to figure out which was the
source and which was the sink in RDMA reads. Do you think calling them
initiator and responder/target would be better?

> +	RDMA_MRR_WRITE_SOURCE		= (1<<4),
> +	RDMA_MRR_WRITE_SINK		= (1<<5),
> +	RDMA_MRR_ATOMIC			= (1<<6),
> +	RDMA_MRR_MW_BIND		= (1<<7),
> +	RDMA_MRR_ZERO_BASED		= (1<<8),
> +	RDMA_MRR_ACCESS_ON_DEMAND	= (1<<9),
> +};

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
