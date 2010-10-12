From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC 0/2] IB/umad: Export mad snooping to userspace
Date: Tue, 12 Oct 2010 15:10:52 -0600
Message-ID: <20101012211052.GT24268@obsidianresearch.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA11D@orsmsx501.amr.corp.intel.com> <20101012203528.GP24268@obsidianresearch.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA2A6@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA2A6-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 12, 2010 at 01:54:54PM -0700, Hefty, Sean wrote:
> > TBH, I think this would be much better off integrating with the
> > existing paths tcpdump/setc uses rather than yet again something new
> 
> This ties in with the existing MAD interface, which isn't going away
> anytime soon, if ever.

I didn't say the MAD interface was going away, I said it was not the
interface everything else in the kernel uses for packet capture.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
