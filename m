From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: merge struct ib_device_attr into struct ib_device V2
Date: Tue, 20 Oct 2015 18:13:35 +0300
Message-ID: <56265A1F.6090204@dev.mellanox.co.il>
References: <1444633078-27166-1-git-send-email-hch@lst.de>
 <561B7CAE.3040505@dev.mellanox.co.il> <20151012144212.GB24770@lst.de>
 <56262CF9.1040509@dev.mellanox.co.il>
 <CAJ3xEMhEE=Qp=LcYQYJB3rjfhdgd28QG_ZXbpFUCUubGD2uAGQ@mail.gmail.com>
 <56263CE6.5010005@dev.mellanox.co.il>
 <CAJ3xEMjmfNmiTiNctobN=BKvwB-oaMZtBxdqL5zVyvvG_M1KiQ@mail.gmail.com>
 <56265702.1030209@dev.mellanox.co.il>
 <CAJ3xEMh12RjU9ws3r5djigHdkMGnT35+uouRAMzGxj2jhmgKFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMh12RjU9ws3r5djigHdkMGnT35+uouRAMzGxj2jhmgKFA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> But this makes struct ib_device much much bigger, and this structure
> is used in **fast** path,
> e.g the ULP traverses through a pointer from struct ib_device to
> post_send/recv, poll_cq and friends.

Umm, all the caps are appended to the end of the ib_device structure so
I don't see how it will affect the fast path - am I missing something?

>
> The networking community will let you work for 10y before they add a
> field to struct net_device exactly b/c
> of the reason I brought. Why here we can come out of the blue and add
> tens if not hundreds of fields to our device structure?

Keeping struct ib_device_attr embedded at the end of struct ib_device is
exactly the same isn't it?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
