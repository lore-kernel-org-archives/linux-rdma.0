From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 1/5] IB Netlink Infrastructure
Date: Tue, 30 Nov 2010 14:56:41 +0200
Message-ID: <1291121801.3155.177.camel@nirm-desktop>
References: <1291047399-430-1-git-send-email-nirm@voltaire.com>
	 <1291047399-430-2-git-send-email-nirm@voltaire.com>
	 <20101129182159.GB16788@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101129182159.GB16788-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-11-29 at 11:21 -0700, Jason Gunthorpe wrote:
> On Mon, Nov 29, 2010 at 06:16:35PM +0200, Nir Muchtar wrote:
> > The basic IB netlink infrastructure.
> > It allows for registration of IB module for which data is to be exported.
> > It supplies skb/message construction callbacks.
> 
> You need to setup the module aliases for autoloading ie like:
> 
> MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_INFINIBAND);

Do you mean adding this to ib_core?
I'm not sure we want to autoload ib_core whenever the userspace asks for
"socket(PF_NETLINK, SOCK_RAW, NETLINK_INFINIBAND)"
What's wrong with receiving a "protocol not supported" error?
If ib_core is not loaded then there's no data anyway.
Am I missing other possible effects of MODULE_ALIAS here?
This would make more sense if ib_netlink was in a separate module.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
