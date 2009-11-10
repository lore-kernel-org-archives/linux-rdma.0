From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RDMA] Fixup IPv6 support and IPv4 routing corner cases
	for RDMA CM
Date: Tue, 10 Nov 2009 14:25:52 -0700
Message-ID: <20091110212552.GK6188@obsidianresearch.com>
References: <20091028054253.GA22882@obsidianresearch.com> <1256846162.12957.27.camel@wilder.ibm.com> <20091029202106.GF1966@obsidianresearch.com> <4AF9D5A1.6030309@linux.vnet.ibm.com> <E34EB5B2A00C459EB20F307ED1C5B437@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E34EB5B2A00C459EB20F307ED1C5B437-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Pradeep Satyanarayana' <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2009 at 01:12:17PM -0800, Sean Hefty wrote:
> >How can we make progress? What are your thoughts?
> 
> I'm actually working on this today.  I've taken Jason's patch as a
> starting point, and I'm breaking it into separate patches for
> merging and testing.  I hope to post the patches within the next
> couple of days.  I'll compare my final patches against the ones
> submitted by David to see if anything got missed.

Oh, thanks, I didn't mean for you to do all that work..

But I won't be able to get to it till after SC|09 which is like the
23rd, so maybe it is best if there is some OFED related deadline.

Aside from testing and breaking up the remaining things I wanted to
review/adjust:
- David's notes on the patch
- The rdma_resolve_ip should require src/dst have the same family
- The arp checking paths needs to be examinined as per my post
- The arp reply waiting code may be better done by holding the dst
  and not polling on route lookups.
- Review the private data handling and check that mixed family cases
  work as they should

It was my intent to capture everything David had done in that big
patch, but I may have missed something.

My intuition is that the fixups to the ARP/ND code will matter for
IPv6, particularly multi-port link local cases, but I'm not 100% sure
on that.

For full IPv6 support the 2 multicast patches you already reviewed will
need to included in OFED as well.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
