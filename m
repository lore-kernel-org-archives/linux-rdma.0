From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/core: add support for extended performance counters
 in sysfs
Date: Tue, 20 Dec 2011 13:49:16 +0200
Message-ID: <4EF0763C.1080609@mellanox.com>
References: <CAL1RGDXdkiZNtAsnqDtgbCJGLXLFvk8s-YA5mR189kmg6FkabQ@mail.gmail.com> <CAJZOPZ+K3u+u5XutGfBhKh3DaBpNRKV_bw67CLK6jy3060OHqA@mail.gmail.com> <20111101162218.GA10710@obsidianresearch.com> <CAJZOPZLXZL=vEDdXE3rE5Jzw840SrdY=73M7QgKSNzOysRE6MQ@mail.gmail.com> <20111101173625.GH26974@obsidianresearch.com> <CAJZOPZJCY5ehTGw8htsxw0dJgMXJJAS-=LGJde9ddcMsmhqvMg@mail.gmail.com> <20111101183730.GI26974@obsidianresearch.com> <CAG4TOxMOPaTy+Y+M+4xuO_uQ-vqs+Z=GV172UJcqdMrA+mPv=w@mail.gmail.com> <4EB17AF9.3000608@mellanox.com> <CAG4TOxOYAnuB8oKkJgr9_6EpF+YR-h9WNak+gSWwpV0Nz-LeZg@mail.gmail.com> <20111108010952.GC4934@obsidianresearch.com> <20111108080606.7c5dd62c.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111108080606.7c5dd62c.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ira Weiny wrote:
> Jason Gunthorpe<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>  wrote:
> How do you feel about having counters_ext appear in ethernet mode and
> disappear in IB mode?
>
> That might get complicated with ports which can be either mode.

Ira (reviving this thread),

At the ib core level, the link layer sysfs attribute is read only.

At the mlx4 VPI level support, a port has given link layer at certain 
point of time, and further, AFAIK, this isn't something that can be 
changed in the life-cycle of the ib device exported by mlx4_ib, which is 
deleted/re-added when the port link  layer change, see commit 
7ff93f8b7ecbc36e7ffc5c11a61643821c1bfee5 which states " When the type of 
a port is changed, all mlx4 interfaces are unregistered, and then 
registered again with the new port types"

Still, this patch makes the decision when the ib device is added, so you 
have a point here w.r.t to future devices which could change their link 
layer at run time, I'll look on that.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
