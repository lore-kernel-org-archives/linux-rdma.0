From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [Patch v2 3/3] IB/cache: don't fill the cache with junk
Date: Tue, 22 Oct 2013 08:35:05 +0200
Message-ID: <20131022083505.1d530531@jpm-OptiPlex-GX620>
References: <cover.1380056994.git.dledford@redhat.com>
	<4c88e00f5211787a98fa980a4d42c5c6374ab868.1380056994.git.dledford@redhat.com>
	<20131020085149.6e719ad2@jpm-OptiPlex-GX620>
	<5264A9C6.6000807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5264A9C6.6000807-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Drier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 21 Oct 2013 00:12:54 -0400
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> I think I like my suggestion better: go back to having a full table,
> but use a bitmap to indicate valid entries and then use the bitmap to
> limit our comparisons in the find_cached* functions, and put the
> get_* funtions back to being O(1).  But I would still do that
> incrementally from here I think.
> 
> But I'm not totally convinced of that either.  The exact sitiation I 
> listed above, lots of GIDs on an SRIOV PF, makes me concerned that we 
> can get back to a horrible situation in the find_cached* functions
> once we actually have lots of valid entries.  It makes me think we
> need something better than just a linear search of all valid entries
> when you take SRIOV into account.  Whether hash chains or ranges or
> something to make the lots of valid GIDs case faster, I suspect
> something needs to be done, but because things simply aren't in
> common use yet we don't know it.

Doug, I like your suggestion regarding bitmaps. I would rather hold off
on patch #3, though, because as you say, patches 1 and 2 do most of the
work and the patch #3 optimization won't do much if the GID table is
very populated (which will be the case under SRIOV).

I think what you say is correct, a linear search through a populated
table will be expensive -- and we need to come up with a better
strategy here.

ACK for first 2 patches, please hold off on the third.

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
