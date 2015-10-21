From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: merge struct ib_device_attr into struct ib_device V2
Date: Wed, 21 Oct 2015 10:41:13 +0300
Message-ID: <56274199.1030800@mellanox.com>
References: <56262CF9.1040509@dev.mellanox.co.il>
 <CAJ3xEMhEE=Qp=LcYQYJB3rjfhdgd28QG_ZXbpFUCUubGD2uAGQ@mail.gmail.com>
 <56263CE6.5010005@dev.mellanox.co.il>
 <CAJ3xEMjmfNmiTiNctobN=BKvwB-oaMZtBxdqL5zVyvvG_M1KiQ@mail.gmail.com>
 <56265702.1030209@dev.mellanox.co.il>
 <CAJ3xEMh12RjU9ws3r5djigHdkMGnT35+uouRAMzGxj2jhmgKFA@mail.gmail.com>
 <20151021063830.GA19027@lst.de> <56273459.6050007@mellanox.com>
 <20151021065134.GA19210@lst.de> <56273AA1.6060607@mellanox.com>
 <20151021073338.GA19626@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151021073338.GA19626-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/21/2015 10:33 AM, Christoph Hellwig wrote:
> For anything you want to add you need to touch_a_  struct.  It's not any
> difference in efforts if it's ib_device_attr or ib_device.
>
> You're not even saving much memory if at all as every driver caches at
> least some fields of it in their own device structure, and iser, isert,
> srpt and nfs cache the full structure,

I know, but a patch that adds caching an attr pointer on the device will 
remove these local caches,
we actually had that/similar patch posted here and it was dropped/forgotten.

> so if you use one of those you're
> already having one of them per device.  If you use two of them you
> have multiple copies plus individual fields caches by other ULDs and core
> code.

again, the method I propose does remove these duplications all together.

I am still waiting to hear what is the precise argument for having this 
change.

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
