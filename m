From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 26/26] rdma/ucm: allow user space to specify AF_IB when	joining multicast
Date: Thu, 1 Apr 2010 16:10:02 -0700
Message-ID: <C3DE686AA3B749D99B38AD3B2161D54B@amr.corp.intel.com>
References: <9D903E76C4EA4CF48BF2548F2BC8D2EA@amr.corp.intel.com> <20100401173809.GA15629@obsidianresearch.com> <89AF89412472472786051768B3A22420@amr.corp.intel.com> <20100401182732.GD15629@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100401182732.GD15629-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>Humm, interesting.. So you propose to accept addresses for families
>other than the one used to create the cm_id?
>
>Just from a simplicity of the future perspective I'd say not to bother

Part of the reasoning behind the existing code is that users requested the
ability to join a multicast group using an address of 0, so the transport could
select what the address.  Once the address was selected, it was communicated to
remote peers, who would join using the assigned address.  Today, the assigned
address is passed as AF_INET6.  This patch tries to 'fix' that and allow the
address to be passed to the kernel as AF_IB instead.

For compatibility reasons, I think we want to continue to support AF_INET
rdma_cm_id's using AF_INET6 or AF_IB.  Off the top of my head, I can't think of
any reason why support for AF_IB id's would need AF_INET/AF_INET6.  I don't know
if IBoE would want this or not, but I can update the patch to remove this
support.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
