From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RFC rdma cgroup
Date: Wed, 4 Nov 2015 22:53:36 +0530
Message-ID: <CAG53R5X4wD1G4wB5vETMmVTc3XzatkEy3zamiTiVZ36dVYDAqQ@mail.gmail.com>
References: <CAG53R5Vd=tLbKPeKy8ZKP2DoHG-rnzW85COiE1Hk4GLv6SAZyA@mail.gmail.com>
	<563233D7.90808@mellanox.com>
	<CAG53R5UrfXdq=t97u=CoqUhQ2v+mZjZrLCxqyBw6n8g__nuP3g@mail.gmail.com>
	<56376889.2080908@mellanox.com>
	<CAG53R5WUHZ7gcNGxcuadB5cGG3rnj_TKU_MEA-V5Q2Pmv19VTw@mail.gmail.com>
	<5639F2E3.8090101@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5639F2E3.8090101-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 4, 2015 at 5:28 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 03/11/2015 21:11, Parav Pandit wrote:
>> So it looks like below,
>> #cat rdma.resources.verbs.list
>> Output:
>> mlx4_0 uctx ah pd cq mr mw srq qp flow
>> mlx4_1 uctx ah pd cq mr mw srq qp flow rss_wq
> What happens if you set a limit of rss_wq to mlx4_0 in this example?
> Would it fail?
Yes, In above example, mlx4_0 device didn't had support for rss_wq, so
it didn't advertise in the list file that it supports rss_wq.

> I think it would be simpler for administrators if they
> can configure every resource supported by uverbs. If a resource is not
> supported by a specific device, you can never go over the limit anyway.
>
Exactly. Thats the implementation today.
