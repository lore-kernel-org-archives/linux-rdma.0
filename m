From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: merge struct ib_device_attr into struct ib_device V2
Date: Tue, 20 Oct 2015 18:07:31 +0300
Message-ID: <CAJ3xEMh12RjU9ws3r5djigHdkMGnT35+uouRAMzGxj2jhmgKFA@mail.gmail.com>
References: <1444633078-27166-1-git-send-email-hch@lst.de>
	<561B7CAE.3040505@dev.mellanox.co.il>
	<20151012144212.GB24770@lst.de>
	<56262CF9.1040509@dev.mellanox.co.il>
	<CAJ3xEMhEE=Qp=LcYQYJB3rjfhdgd28QG_ZXbpFUCUubGD2uAGQ@mail.gmail.com>
	<56263CE6.5010005@dev.mellanox.co.il>
	<CAJ3xEMjmfNmiTiNctobN=BKvwB-oaMZtBxdqL5zVyvvG_M1KiQ@mail.gmail.com>
	<56265702.1030209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56265702.1030209-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 20, 2015 at 6:00 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:


>> (2) re this one, as I wrote in the past, I am in favor of simple
>> caching of struct ib_device_attr on struct ib_device (best with pointer) and not adding
>> 333 fields to struct ib_device, I don't see the benefit from this patch.

> Christoph commented on that:
>
> "I'm strongly against this.  As the reviews show the move is highly
> confusing.  The attributes don't change and there is no need to 'cache'
> or 'query' them.  Just merge them into the device, follow years of
> experience with how every other Linux subsystem does it and be done
> with it."
>
> If the attributes are automatically a part of the ib_device then it
> does seem a bit redundant keeping the structure around...

But this makes struct ib_device much much bigger, and this structure
is used in **fast** path,
e.g the ULP traverses through a pointer from struct ib_device to
post_send/recv, poll_cq and friends.

The networking community will let you work for 10y before they add a
field to struct net_device exactly b/c
of the reason I brought. Why here we can come out of the blue and add
tens if not hundreds of fields to our device structure?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
