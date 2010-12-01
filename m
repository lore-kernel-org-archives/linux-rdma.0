From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 1/5] IB Netlink Infrastructure
Date: Wed, 1 Dec 2010 18:05:43 +0200
Message-ID: <1291219543.3155.478.camel@nirm-desktop>
References: <1291047399-430-1-git-send-email-nirm@voltaire.com>
	 <1291047399-430-2-git-send-email-nirm@voltaire.com>
	 <20101129182159.GB16788@obsidianresearch.com>
	 <1291121801.3155.177.camel@nirm-desktop>
	 <20101130175152.GH16788@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101130175152.GH16788-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-11-30 at 10:51 -0700, Jason Gunthorpe wrote:

> On Tue, Nov 30, 2010 at 02:56:41PM +0200, Nir Muchtar wrote:
> 
> > Do you mean adding this to ib_core?  I'm not sure we want to
> > autoload ib_core whenever the userspace asks for "socket(PF_NETLINK,
> > SOCK_RAW, NETLINK_INFINIBAND)" What's wrong with receiving a
> > "protocol not supported" error?  If ib_core is not loaded then
> > there's no data anyway.  Am I missing other possible effects of
> > MODULE_ALIAS here?
> 
> It seems to be kernel policy to annotate this sort of autoload
> meta-data.
> 
> If the module is demand loaded or not is a userspace choice.
> 
> Apps using this should handle both cases.
> 
> Jason

MODULE_ALIAS_PF_PROTO is used by the netlink layer once netlink_create
is called by userspace (with request_module), So it is used by dedicated
netlink modules such as inet_diag and nf_netlink. netlink_scsitransport
is a closer example to our design, where there is no use of
MODULE_ALIAS.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
