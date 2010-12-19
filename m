From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V3 1/6] IB Netlink Infrastructure
Date: Sun, 19 Dec 2010 16:34:07 +0200
Message-ID: <1292769247.2369.2140.camel@nirm-desktop>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
	 <1292257370-24391-2-git-send-email-nirm@voltaire.com>
	 <20101214183401.GC2506@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101214183401.GC2506-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-12-14 at 11:34 -0700, Jason Gunthorpe wrote:
> On Mon, Dec 13, 2010 at 06:22:45PM +0200, Nir Muchtar wrote:
> 
> > +int ibnl_add_client(int index, int nops,
> > +		    int (*cb_table[])(struct sk_buff *skb,
> > +				      struct netlink_callback *nlcb))
> 
> If you are going this way, then I think it would be better to have
> netlink_dump_start be optional - not many calls need it.
> 

Yes, we may need such functionality in the future, but I'm reluctant to
add APIs that are not currently used, So I think we should wait until we
actually need this addition. It will be very straightforward to add once
we decide to. Don't you agree?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
