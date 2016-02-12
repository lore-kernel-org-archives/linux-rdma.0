From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC 0/7] Peer-direct memory
Date: Fri, 12 Feb 2016 13:36:49 -0700
Message-ID: <20160212203649.GA10540@obsidianresearch.com>
References: <1455207177-11949-1-git-send-email-artemyko@mellanox.com>
 <20160211191838.GA23675@obsidianresearch.com>
 <20160212201328.GA14122@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160212201328.GA14122-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-Dj0/KMMU01E@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 12, 2016 at 12:13:28PM -0800, Christoph Hellwig wrote:
> On Thu, Feb 11, 2016 at 12:18:38PM -0700, Jason Gunthorpe wrote:
> > Most of this stuff (eg the whole peer_memory_client thing) has no
> > buisness being part of the RDMA stack. We can't ask other drivers to
> > call IB functions just because their devices have ZONE_DIRECT memory.
> > 
> > Resubmit those parts under the mm subsystem, or another more
> > appropriate place.
> > 
> > This is the same comment as last time this was submitted.
> > 
> > If you want to make some incremental progress then implement the
> > existing ZONE_DEVICE API for the IB core and add the invalidate stuff
> > later, once you've negotiated a common API for that with linux-mm.
> 
> Agreed on all points.  Nevermind that seems to be missing a user of all
> the newly added infrastructure, which should come with the series.

Yep!

I've heard from the people working on NVMe cards that this approach
isn't needed, desired, or correct. I'm deeply skeptical that there
would be an in-kernel user.

AFAIK, this specific interface is only needed to support nvidia's
propritary kernel module, which has some oddball design where these
extra callbacks are needed.

But who knows, maybe someone can think up reason why filesystems might
want to do an invalidate as well.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
