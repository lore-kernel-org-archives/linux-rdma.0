From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Mon, 10 Oct 2016 19:02:11 +0530
Message-ID: <CAG53R5ULKCqtw45E6t4hYdRV+y_OQqVazf=7A7Ax_XAJ2K0_dw@mail.gmail.com>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <20161005112206.GC9282@leon.nu> <CAG53R5VNVb=8-LJbDRqjtOZG347ucPuc420bcfnDgBKMoKqU-w@mail.gmail.com>
 <20161010044623.GI9282@leon.nu> <CAG53R5UM6nSTZ7=0S9reKGX45CpNBi8soSDVZyXkN-z0_XXWWQ@mail.gmail.com>
 <20161010122545.GA27360@mtj.duckdns.org> <CAG53R5V5yE4PsDBjP9BieG_=39M0G1kx-AfBEzWK4LUCxNnYBA@mail.gmail.com>
 <20161010132014.GD29742@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161010132014.GD29742-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Tejun,

On Mon, Oct 10, 2016 at 6:50 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Parav.
>
> On Mon, Oct 10, 2016 at 06:43:59PM +0530, Parav Pandit wrote:
>> > Also, I don't get what you mean by using percentage and when people
>> > brought up this idea, it always has been stemming from
>> > misunderstanding.  Can you please elaborate how percentage based
>> > proportional control would work?  What would 100% mean when cgroups
>> > can come and go?
>>
>> When 100% is given to one cgroup, all resources of all type can be
>> charged by processes of that cgroup.
>> Resources are stateful resource. So when cgroup goes away, they go
>> back to global pool (or hw).
>> Giving 100% to two cgroups is configuration error anyway (or without config).
>
> That isn't proportional control.  That's using percentage as the unit
> to implement absolute limits.  Proportional control implies work
> conservation.
>
>> As you know weight configuration allows automatic increase/decrease of
>> resource to other cgroups when one of them go away, as opposed to
>> absolute value. How this is going to work in exact terms for stateful
>
> Hmm.... so are you saying that ti'd be work-conserving?
They cannot be work conversing.

> But what does
> it mean to say "30%" and then have it all resources when there are no
> other users.  Also, is it even possible to take back what have already
> been allocated and are in use?
>
Most resources that I know of, and whats described in current
cgroup_rdma.h are not work conversing, therefore it cannot be taken
back.

>> Nop. Thats not true.
>> (a) Every new resource has to be defined in cgroup_rdma.h
>> (b) charge()/uncharge() has to happen by the cgroup for each.
>> (c) Letting drivers do will make things fall apart. There are no APIs
>> exposed either to let drivers know process cgroup either. There is no
>> intention either.
>>
>> (d) ratio means -if adapter has
>> 100 resources of type - A,
>> 80 resource of type - B,
>>
>> 10% for cgroup-1 means,
>> 10 resource of type - A
>> 8 resource of type - B
>
> So, this is not work-conserving.  There's too much confusion here.

Give me some more time, I will think more and take feeback from Leon
and others on
(a) how can we implement or want to implement weight like
functionality for non-work-conversing resource
(b) what could be its acceptable limitations of that interface would be
before we propose you.

At minimum we would need to expose actual value in rdma.max in
subsequent patch, instead of exposing just "max" string. I don't want
to complicate this discussion but similar functionality is needed for
pid controller as well to expose actual value.

>
> Thanks.
>
> --
> tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
