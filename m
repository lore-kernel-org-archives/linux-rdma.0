From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] nvme-rdma: Add handling for connecting to IPv6 targets
Date: Mon, 1 Aug 2016 09:06:07 -0700
Message-ID: <CAG4TOxPNnUKWeh7FUY8YB127sx8yMu41FuP4hxUMCan_HWQmVQ@mail.gmail.com>
References: <1469950060-18098-1-git-send-email-roland@kernel.org>
 <1469950060-18098-2-git-send-email-roland@kernel.org> <4acdd466-b8f6-8208-7287-e97dfd45bbf1@grimberg.me>
 <33dfc646-1804-363e-4d83-1ba618303dbb@grimberg.me> <20160801110956.GI16141@lst.de>
 <e6e54d3f-c6ee-2057-d4e5-13981cd95140@grimberg.me> <20160801155036.GC22771@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160801155036.GC22771-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 1, 2016 at 8:50 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> It'd still need all the scope ID handling similar to what Roland did,
> and that's a fair chunk of code.  We have a few options to handle the
> different allowed addresses:
>
>  (1) v4/v6 only flags
>  (2) having low-level v4/v6 handlers and one that tries these both
>  (3) using the try both handler and rejecting the wrong one after
>      parsing.
>
> (3) seems easiest, but (2) sounds fine to me.  But I'd really like to
> hear from folks on the netdev list what they think of that idea first.

I think adding a new helper that parses both v4 and v6 addresses +
scope ID seems like the best thing for now.  I did a grep for in6_pton
and it looks like at least fs/cifs/netmisc.c and net/sunrpc/addr.c
could use the helper.

What do you think of adding inet_pton_with_scope() to
net/core/utils.c?  I'm open to better ideas on the name.  But I can
code that up and use it in nvme, as well as convert over the two
places I mentioned above.  The first parameter of the function can be
an af, and the caller can pass in AF_UNSPEC, AF_INET, or AF_INET6 to
restrict the parsing to one type of address (or not).

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
