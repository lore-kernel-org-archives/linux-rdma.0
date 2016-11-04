From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Fri, 4 Nov 2016 09:58:28 +0530
Message-ID: <CAG53R5XMHhEoRNV1r04vYwWvJriVgwD2HfroPtuFJxFg1RUmAg@mail.gmail.com>
References: <20161018215134.GB2761@htj.duckdns.org> <CAG53R5UEvkPBM0yFrR=fvEzyCrku2q=rLZyDVrSs9q+3hgbSmQ@mail.gmail.com>
 <20161019143345.GA18532@htj.duckdns.org> <CAG53R5WUyA7JBn=PeivUc5F5k210xf_HccPXFt3r7ZGYHOPaGA@mail.gmail.com>
 <20161019192006.GB3044@htj.duckdns.org> <CAG53R5X5dyo7J-UkeMxi_mSxgv=c54fV=anuCZtmf9kaYwDbPw@mail.gmail.com>
 <20161019200536.GC3044@htj.duckdns.org> <CAG53R5XkRKdo-SCaREZvov3AGp5MSd18RpQ+0HEu-htUzqwOOw@mail.gmail.com>
 <20161031065441.GY3617@leon.nu> <CAG53R5VKwntDHX101+5aaGoyKMKQuiKQWam575iFAxhmKxhE1g@mail.gmail.com>
 <20161103180006.GL3617@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161103180006.GL3617-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Leon, Christoph, Matan, Tejun,

Thanks for the update.
I need some more information in order to roll out new patch.
Inline clarification below.


On Thu, Nov 3, 2016 at 11:30 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Tue, Nov 01, 2016 at 04:33:23PM +0530, Parav Pandit wrote:
>> So my opinion is:
>> (a) Let cgroup define the current standard objects and new reasonable
>> set of vendor specific objects in future.
>> (b) Add new rdma.percentage parameter so that any new standard object
>> or vendor specific object can be abstracted from average end user and
>> applications which are yet to catch up.
>> I believe this takes care of your point (1), (3), (4)?
>
> We (Tejun, Christoph, Matan and me) had a face-to-face talk during
> KS/LPC and decided that the best way to move forward is to export to
> user one object (global HCA like) only and don't export anything else.
>

Can you please confirm the below points to make sure design fits-in.

1. so rdma.current and rdma.max, will show one overall current
percentage used and configured?
(Instead of per object absolute value)
2. As a starting point minimum percentage will be 1%. Default will be 100%.
3. So for example if user has configured 2% of resource, this 2% will
be applicable as 2% of MR, 2% of QP and so on.
4. rdma cgroup continues to do accounting, resource definition as done
in patch_v12.
Though there is provision for defining handful of vendor specific
objects in rdma cgroup, we don't define is currently and therefore
they won't be accounted.
5. In future when such need arise to account vendor specific objects,
they will be added to rdma cgroup.

> All internal calculations will be based on this percentage.
>
> Once the cgroups users will come with reasonable justification why they
> need to configure different unexposed objects, we will expose them.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
