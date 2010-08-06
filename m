From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCHv9 3/4] libibverbs: Add API to resolve GID to L2 address
Date: Fri, 6 Aug 2010 10:45:52 -0600
Message-ID: <20100806164552.GK11306@obsidianresearch.com>
References: <20100806144337.GP20588@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100806144337.GP20588@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 06, 2010 at 05:43:37PM +0300, Eli Cohen wrote:

> +int resolve_eth_gid(struct ibv_pd *pd, uint8_t port_num,
> +		    union ibv_gid *dgid, uint8_t sgid_index,
> +		    uint8_t mac[], uint16_t *vlan, uint8_t *tagged,
> +		    uint8_t *is_mcast);

Still missing the const on dgid

It also just occured to me that this should be ibv_resolve_eth_gid to
keep within the symbol namespace prefix used by libibverbs.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
