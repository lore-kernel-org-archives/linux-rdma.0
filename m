From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 1/3] IB/core: Align coding style of ib_device_cap_flags structure
Date: Mon, 21 Dec 2015 11:36:03 -0500
Message-ID: <20151221163603.GF3860@phlsvsds.ph.intel.com>
References: <1450606571-15877-1-git-send-email-leon@leon.nu> <1450606571-15877-2-git-send-email-leon@leon.nu> <20151221062252.GE3860@phlsvsds.ph.intel.com> <CALq1K=J2e=aw1QuJHGhFFcKkY391myz11r7tG-H+fYbQEyr+Gw@mail.gmail.com> <20151221080346.GA21779@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151221080346.GA21779-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 21, 2015 at 12:03:46AM -0800, Christoph Hellwig wrote:
> On Mon, Dec 21, 2015 at 08:37:26AM +0200, Leon Romanovsky wrote:
> > You are right and it is a preferred way for me too, however the
> > downside of such change will be one of two:
> > 1. Change this structure only => we will have style mix of BITs and
> > shifts in the same file. IMHO it looks awful.
> > 2. Change the whole file => the work with "git blame" will be less
> > straightforward.
> 
> Honestly, the BIT macros are horribly, and anyone who thinks it's useful
> really should read a book on computer architectured and one on C.

It would be nice if we were not having to do this for staging then.  Also
perhaps it should be removed from checkpatch --strict?

I'm not a big fan of everything checkpatch does, this being one of them, but
Leon was trying to do the right thing here.

Where are the guidelines for when one can ignore checkpatch and when they can
not?  It would be nice to know when we can "be developers" vs "being robots to
some tool".

I await Dougs guidance.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
