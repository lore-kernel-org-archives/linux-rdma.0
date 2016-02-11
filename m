From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv3 1/3] rdmacg: Added rdma cgroup controller.
Date: Fri, 12 Feb 2016 02:47:18 +0530
Message-ID: <CAG53R5VNt3Q+1Uaze6MVak7dkeFFtcioFHdsX0CXiEvRB-p4wQ@mail.gmail.com>
References: <1454167387-31260-1-git-send-email-pandit.parav@gmail.com>
	<1454167387-31260-2-git-send-email-pandit.parav@gmail.com>
	<20160130183015.GP32380@htj.duckdns.org>
	<CAG53R5XrnYY1AVBnu1b6BVfWwiUgyq+EsXay=CianRXnsUDviQ@mail.gmail.com>
	<20160131100237.GS32380@htj.duckdns.org>
	<CAG53R5WOLA_=gD9qVnsVk_oPs0iyacL3M+1qD+RAbrnciVXEOA@mail.gmail.com>
	<20160131110420.GV32380@htj.duckdns.org>
	<CAG53R5XXaW-fhb9megcp+Xnv05bSuonDws2fE-D6Wk3JNqS2Aw@mail.gmail.com>
	<20160201184046.GD14091@mtj.duckdns.org>
	<CAG53R5U=ojbn5tQoq=xR0DUb3Tm6yw+oO6mXVAQ2cUOhbvCdKQ@mail.gmail.com>
	<56BB6502.8040507@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56BB6502.8040507-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 10, 2016 at 9:57 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
> There is indeed an effort to backport the latest RDMA subsystem modules to
> older kernels, and it would be preferable to be able to introduce new
> resources through these modules.
Right. There is hardly 10 to 20 lines of code that allows to support
this functionality. So I think its good thing to have.


> > If resources are defined by RDMA cgroup kernel than adding/removing
> > resource means, someone have to do lot of engineering with different
> > versions of kernel support and loadable module support using compat.h
> > etc at driver level, which in my mind is some amount of engineering
> > compare to what v5 has to offer and its already available. With one
> > round of cleanup in resource definition, it should be usable.
> If I understand correctly, if the resources are defined in the cgroup,
> you simply won't be able to add new resources with a module update,
> no matter how hard you work.
>

Yes.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
