From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: merge struct ib_device_attr into struct ib_device V2
Date: Wed, 21 Oct 2015 09:33:38 +0200
Message-ID: <20151021073338.GA19626@lst.de>
References: <56262CF9.1040509@dev.mellanox.co.il> <CAJ3xEMhEE=Qp=LcYQYJB3rjfhdgd28QG_ZXbpFUCUubGD2uAGQ@mail.gmail.com> <56263CE6.5010005@dev.mellanox.co.il> <CAJ3xEMjmfNmiTiNctobN=BKvwB-oaMZtBxdqL5zVyvvG_M1KiQ@mail.gmail.com> <56265702.1030209@dev.mellanox.co.il> <CAJ3xEMh12RjU9ws3r5djigHdkMGnT35+uouRAMzGxj2jhmgKFA@mail.gmail.com> <20151021063830.GA19027@lst.de> <56273459.6050007@mellanox.com> <20151021065134.GA19210@lst.de> <56273AA1.6060607@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56273AA1.6060607-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2015 at 10:11:29AM +0300, Or Gerlitz wrote:
>
> We will have many more device query extensions,

None of which use struct ib_device_attr I hope!

> but the point I tried to 
> make here is a bit different --
> we do need to keep the user/kernel device attr struct as part of the UAPI, 

It's an entirely separate ib_uverbs_query_device_resp structure. 

> and don't see any reason to
> avoid it in the kernel, just because some other subsystems do that, 
> according to your view. As I said, you
> would have to work real (real) hard to convince the networking ppl to add 
> fields to struct net_device sk_buff

Or, please stop these bullshit strawman arguments.  Yes, adding fields to
struct sk_buff will be hard, but that's not the right comparism.  struct
sk_buff is a structured allocated for the data buffers in great quantities and
not the net_device structure allocated once per device.  I'm going to
finish this email, but if you don't even try to get your facts right I'll stop
responding ro you because it's futile.

> and friends... the nature of rdma/offloading is such that new attr come 
> often and I don't think we need
> to touch our device struct every release.

For anything you want to add you need to touch _a_ struct.  It's not any
difference in efforts if it's ib_device_attr or ib_device.

You're not even saving much memory if at all as every driver caches at
least some fields of it in their own device structure, and iser, isert, 
srpt and nfs cache the full structure, so if you use one of those you're
already having one of them per device.  If you use two of them you
have multiple copies plus individual fields caches by other ULDs and core
code.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
