From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 1/5] IB Netlink Infrastructure
Date: Tue, 30 Nov 2010 10:51:52 -0700
Message-ID: <20101130175152.GH16788@obsidianresearch.com>
References: <1291047399-430-1-git-send-email-nirm@voltaire.com>
 <1291047399-430-2-git-send-email-nirm@voltaire.com>
 <20101129182159.GB16788@obsidianresearch.com>
 <1291121801.3155.177.camel@nirm-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1291121801.3155.177.camel@nirm-desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 30, 2010 at 02:56:41PM +0200, Nir Muchtar wrote:

> Do you mean adding this to ib_core?  I'm not sure we want to
> autoload ib_core whenever the userspace asks for "socket(PF_NETLINK,
> SOCK_RAW, NETLINK_INFINIBAND)" What's wrong with receiving a
> "protocol not supported" error?  If ib_core is not loaded then
> there's no data anyway.  Am I missing other possible effects of
> MODULE_ALIAS here?

It seems to be kernel policy to annotate this sort of autoload
meta-data.

If the module is demand loaded or not is a userspace choice.

Apps using this should handle both cases.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
