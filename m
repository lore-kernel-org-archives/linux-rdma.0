From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 2/2] nvme-rdma: Add handling for connecting to IPv6
 targets
Date: Thu, 18 Aug 2016 10:44:49 +0300
Message-ID: <2b4f4727-58b5-c62e-e5fd-cc5e5b4ae6be@grimberg.me>
References: <1469950060-18098-1-git-send-email-roland@kernel.org>
 <1469950060-18098-2-git-send-email-roland@kernel.org>
 <4acdd466-b8f6-8208-7287-e97dfd45bbf1@grimberg.me>
 <33dfc646-1804-363e-4d83-1ba618303dbb@grimberg.me>
 <20160801110956.GI16141@lst.de>
 <e6e54d3f-c6ee-2057-d4e5-13981cd95140@grimberg.me>
 <20160801155036.GC22771@lst.de>
 <CAG4TOxPNnUKWeh7FUY8YB127sx8yMu41FuP4hxUMCan_HWQmVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxPNnUKWeh7FUY8YB127sx8yMu41FuP4hxUMCan_HWQmVQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> I think adding a new helper that parses both v4 and v6 addresses +
> scope ID seems like the best thing for now.  I did a grep for in6_pton
> and it looks like at least fs/cifs/netmisc.c and net/sunrpc/addr.c
> could use the helper.
>
> What do you think of adding inet_pton_with_scope() to
> net/core/utils.c?  I'm open to better ideas on the name.  But I can
> code that up and use it in nvme, as well as convert over the two
> places I mentioned above.  The first parameter of the function can be
> an af, and the caller can pass in AF_UNSPEC, AF_INET, or AF_INET6 to
> restrict the parsing to one type of address (or not).

Hey Roland,

Are you looking into this?

I'd love to get it into 4.9...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
