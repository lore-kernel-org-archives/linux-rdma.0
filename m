From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH V1 1/3] IB/core: Align coding style of
 ib_device_cap_flags structure
Date: Mon, 21 Dec 2015 00:03:46 -0800
Message-ID: <20151221080346.GA21779@infradead.org>
References: <1450606571-15877-1-git-send-email-leon@leon.nu>
 <1450606571-15877-2-git-send-email-leon@leon.nu>
 <20151221062252.GE3860@phlsvsds.ph.intel.com>
 <CALq1K=J2e=aw1QuJHGhFFcKkY391myz11r7tG-H+fYbQEyr+Gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALq1K=J2e=aw1QuJHGhFFcKkY391myz11r7tG-H+fYbQEyr+Gw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 21, 2015 at 08:37:26AM +0200, Leon Romanovsky wrote:
> You are right and it is a preferred way for me too, however the
> downside of such change will be one of two:
> 1. Change this structure only => we will have style mix of BITs and
> shifts in the same file. IMHO it looks awful.
> 2. Change the whole file => the work with "git blame" will be less
> straightforward.

Honestly, the BIT macros are horribly, and anyone who thinks it's useful
really should read a book on computer architectured and one on C.

Also the capabilities are used by userspace, so they will need to move
to a uapi heder sooner or later, where this stupid macro isn't even
available.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
