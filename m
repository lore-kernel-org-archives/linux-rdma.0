From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/core: add support for extended performance
 counters in sysfs
Date: Tue, 20 Dec 2011 21:56:30 +0200
Message-ID: <CAJZOPZLRvkyuJqa1f_Po1hnz_yFwFWKJiSi6NYX8FFHfPYAdqg@mail.gmail.com>
References: <20111101173625.GH26974@obsidianresearch.com>
	<CAJZOPZJCY5ehTGw8htsxw0dJgMXJJAS-=LGJde9ddcMsmhqvMg@mail.gmail.com>
	<20111101183730.GI26974@obsidianresearch.com>
	<CAG4TOxMOPaTy+Y+M+4xuO_uQ-vqs+Z=GV172UJcqdMrA+mPv=w@mail.gmail.com>
	<4EB17AF9.3000608@mellanox.com>
	<CAG4TOxOYAnuB8oKkJgr9_6EpF+YR-h9WNak+gSWwpV0Nz-LeZg@mail.gmail.com>
	<20111108010952.GC4934@obsidianresearch.com>
	<4EF07993.2090900@mellanox.com>
	<20111220174639.GE25774@obsidianresearch.com>
	<CAJZOPZ+rBKck50kmyhLZ3VNLNmoS_K6cA3Pj3L6XQjcBQo6DjA@mail.gmail.com>
	<20111220195014.GH25774@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111220195014.GH25774-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> We're talking now only on the IB extended counters who are all 64 bits

> netdev counters are 32 bit or 64 bit, depending on how the kernel was
> compiled. I think indicating the size explicitly, or always being 64
> bit (and extending all the lessor counters in future) is the way to go for IB..

So for the extended counters which we are dealing with now,  and who
are all 64bit, anything I should change in my patches?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
