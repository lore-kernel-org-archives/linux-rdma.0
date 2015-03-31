From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 0/9] mlx4 changes in virtual GID management
Date: Tue, 31 Mar 2015 12:46:01 -0600
Message-ID: <20150331184601.GA17782@obsidianresearch.com>
References: <1427637093-6711-1-git-send-email-ogerlitz@mellanox.com>
 <CAJ3xEMj0T8QXBQdVHmfEFMXwjAFVD-O6ywAwyyVY+M3oRLzAVA@mail.gmail.com>
 <20150330.233602.155832546277570456.davem@davemloft.net>
 <CAL1RGDUmDGCGdTBeTTBiHygO5UgEbRm_Qgxtx-+bxo1vg1v-8g@mail.gmail.com>
 <551A6556.9030708@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <551A6556.9030708-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 31, 2015 at 12:13:58PM +0300, Sagi Grimberg wrote:

> We had a talk about a similar topic at LSFMM15. Linux-scsi subsystem
> is a large scale subsystem and also has the "single maintainer with
> limited time for upstream maintenance" bottleneck.
> 
> Christoph created the "scsi-queue" tree to feed James in order to
> accelerate the work process.

[..]

> One problem with that is that we need "a christoph" to poke people for
> review since not a lot of people giving review.

I have tried for a few years to get enough interested/qualified people
together to do this kind of system, but it just hasn't happened.

It feels like we are stuck in a loop: People and companies *do not*
want to work on drivers/infiniband because too often patches just die.
Asking people to work on it, and companies to fund work, gets met with
the above.

I think there is a broad agreement we need to change the system
here. So, lets hear from people and companies: put your name forward,
consistently provide time to do serious review work on all patches.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
