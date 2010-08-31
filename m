From: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] ipoib: good references make good neighbors
Date: Tue, 31 Aug 2010 09:41:21 -0400
Message-ID: <20100831134121.GG3267@think>
References: <20100823195316.GL26773@think>
 <1283213461.16829.81.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1283213461.16829.81.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 30, 2010 at 05:11:01PM -0700, Ralph Campbell wrote:

[ add a reference to neighbours inside ipoib ]

> The problem with this solution is that it creates
> a reference counting "loop" so that the reference
> count never goes to zero.
> struct neighbour in the kernel points to struct ipoib_neigh
> which points back to struct neighbor. If the "back pointer"
> holds a reference, then something besides ipoib_neigh_free()
> has to do the neigh_release(neighbour).
> 
> I think the real fix is the patch I sent to linux-rdma:
> https://patchwork.kernel.org/patch/120013/

patchwork is keeping this one secret for now:

OperationalError at /patch/120013/

(1040, 'Too many connections')

But I'll check back later today.  We'd hit this corruption at least once
a day under load, and we couldn't reboot a rack of machines without half
of them exploding as others went down (without CONFIG_PAGE_DEBUG_ALLOC)

So I'm a bit relieved that someone else has seen it too ;)

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
