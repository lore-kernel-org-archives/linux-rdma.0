From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V2 05/11] IB/core: Add rdma_network_type to wc
Date: Thu, 10 Dec 2015 10:38:20 -0700
Message-ID: <20151210173820.GA21482@obsidianresearch.com>
References: <20151207063415.GB20066@obsidianresearch.com>
 <CAG9sBKMBt6Toa25Ouasr7hudAcOYrxZyBUFYMXzrMTFZvooWfQ@mail.gmail.com>
 <20151207171228.GA26969@obsidianresearch.com>
 <CAG9sBKNXnzp7PgJhfcjbYvje5qgZWYqygJYkbs4WyTZtDc4ckg@mail.gmail.com>
 <20151207184832.GA21402@obsidianresearch.com>
 <CAG9sBKNWMQA3XDGpDc_+2QoJcnnNL9o67p0JNoVqrU0u9UQCrA@mail.gmail.com>
 <20151208225251.GA27609@obsidianresearch.com>
 <CAG9sBKM2s9BMv8priCHnFaMcSnuafn4vf+6+0Rooc6Gw0ZSaLA@mail.gmail.com>
 <20151209180129.GD31636@obsidianresearch.com>
 <CAG9sBKPNWsO7ugdyhd5sYp_yOSrUkG0b-Lfq6Eenrydg3MzyvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKPNWsO7ugdyhd5sYp_yOSrUkG0b-Lfq6Eenrydg3MzyvQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2015 at 09:58:51AM +0200, Moni Shoua wrote:

> > creating a horrible API, or requiring all vendors to implement a
> > network type flag.
> >
> Actually you haven't suggested anything yet besides a name to the function.
> I already said that calculating gid_index from wc and grh requires
> extra CPU cycles and is prone to mistakes. But, I might be wrong and
> you have a better idea. Do you?

I told you, if a driver requires vendor specific information then
include it as private data in the grh.

I keep saying this: computing the gid index is not optional. If a
drive can't do it efficiently then too bad, it has to go the long way
around.

>> I think mlx made a big mistake returning network_type instead of gid
>> index, and I don't want to see that error enshrined in our API.
>>
> returning gid_index is wrong because it forces CQ pollers to be aware
> of the entire table. Like I already mentioned, the GID table is a HW
> resource that can be divided and handed to multiple VMs,

Please. If HW virt stuff can't sort this out it is broken, there are
many trivial solutions.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
