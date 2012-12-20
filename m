From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 1/3] IB/srp: Track connection state properly
Date: Thu, 20 Dec 2012 22:06:55 +0200
Message-ID: <CAJZOPZLE8hRR9vKq_iXU46tyEQhz6fsQzLfh+J9N+0BL9xLyrA@mail.gmail.com>
References: <50D1CD49.5080607@acm.org>
	<50D1CD7D.6030905@acm.org>
	<1355940274.23687.2.camel@frustration.ornl.gov>
	<50D2C8C4.3030308@acm.org>
	<1356016241.2507.1.camel@obelisk.thedillows.org>
	<50D32E7A.4070704@mellanox.com>
	<1356020823.8322.0.camel@frustration.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1356020823.8322.0.camel-zHLflQxYYDO4Hhoo1DtQwJ9G+ZOsUmrO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 20, 2012 at 6:27 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
> On Thu, 2012-12-20 at 17:27 +0200, Or Gerlitz wrote:

>> Dave, did you gave the patches a try?

> This one looks to be an obvious fix, but I have not tested the others; I
> have been relying on Bart, Alex, and yourself for the validation.

Taking into account that we've been going back and forth w.r.t that
validation -- that is initially things weren't working on our setups,
later with picking some patches from Bart's tree, that host removal
went OK, and now with the patches posted here, it doesn't go fine on
my setup  -- all in all, sounds like a 2nd opinion which is strengthen
by a test is needed here. You only need to boot with Roland's for-next
+ Bart's patches, connect to a target, take down the IB link and issue
dd. No multipath scheme is needed for the very basic validation, can
you?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
