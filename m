From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC 0/2] IB/umad: Export mad snooping to userspace
Date: Tue, 12 Oct 2010 14:35:28 -0600
Message-ID: <20101012203528.GP24268@obsidianresearch.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA11D@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA11D-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 12, 2010 at 12:10:37PM -0700, Hefty, Sean wrote:
> The kernel mad interface allows a client to view all
> sent and received MADs.  This has proven to be a useful
> debugging technique when paired with the external kernel
> module, madeye.  However, madeye was never intended to
> be submitted upstream.
> 
> A couple of alternatives have been proposed for making
> this functionality available in the upstream kernel,
> using trace events or exporting the snooping interface
> to user space.  This patch series takes the latter approach.

TBH, I think this would be much better off integrating with the
existing paths tcpdump/setc uses rather than yet again something new
and unique. I think everone who has to actually use the IB stuff in
real life would be estatic if wireshark just worked...

Yes, I realize that is a bit awkward.. But maybe it is time we had a
netdev for the raw IB device?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
