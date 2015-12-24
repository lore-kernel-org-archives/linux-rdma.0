From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH V1 0/3] Add cross-channel support
Date: Thu, 24 Dec 2015 02:00:01 -0800
Message-ID: <20151224100001.GA21387@infradead.org>
References: <1450606571-15877-1-git-send-email-leon@leon.nu>
 <567BA695.8050403@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <567BA695.8050403-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 24, 2015 at 10:02:29AM +0200, Or Gerlitz wrote:
> We had consensus among the reviewers that the 1st patch ("IB/core: Align
> coding style of ib_device_cap_flags structure") is wrong cleanup which
> basically is (1) unneeded (2) creates more damage (git blame and such,
> non-applicable to uapi, more) than benefit, etc -- finally Leon was
> convinced too [1].

It's not really an issue vs uapi.  Using the the wierd BIT() macro
would have been, but without it I think this cleanup is ok, even if I
personally wouldn't have done it.  git-blame isn't really a major
issue either, as you can blame past revisions.

> Leon will re-spin in the coming 1-2 hours V2, could please pick it instead
> of V1, when people agree on direction X and you are not against it, lets do
> X and not Y.

It would be great if we could stop rebasing whats already in the tree
for the benefit of everyone building on top of this.  For example just
finished rebasing my series to move many constants includin this one
to the uapi headers, and I'd hate to rebase it once again now that
the dust has settled.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
