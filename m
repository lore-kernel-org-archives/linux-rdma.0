From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv9 3/4] libibverbs: Add API to resolve GID to L2 address
Date: Mon, 16 Aug 2010 15:51:10 +0300
Message-ID: <20100816125110.GA22111@mtldesk30>
References: <20100806144337.GP20588@mtldesk30>
 <20100806164552.GK11306@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100806164552.GK11306-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 06, 2010 at 10:45:52AM -0600, Jason Gunthorpe wrote:
> On Fri, Aug 06, 2010 at 05:43:37PM +0300, Eli Cohen wrote:
> 
> > +int resolve_eth_gid(struct ibv_pd *pd, uint8_t port_num,
> > +		    union ibv_gid *dgid, uint8_t sgid_index,
> > +		    uint8_t mac[], uint16_t *vlan, uint8_t *tagged,
> > +		    uint8_t *is_mcast);
> 
> Still missing the const on dgid

OK, I failed to use const in the prototype of the function. I am just
curios why is it necessary at all? The are many places where you pass
a pointer to struct that is not meant to be changed and you do not use
const. For example, ibv_create_ah() passes as the first parameter a
pointer to a struct ibv_pd and does not use const.

> 
> It also just occured to me that this should be ibv_resolve_eth_gid to
> keep within the symbol namespace prefix used by libibverbs.
> 
That was deliberate. Since it is meant to be used by the hardware
level libraries only I did not use the the ibv_ prefix but it I don't
have a strong opinion about this so I will change it anyway.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
