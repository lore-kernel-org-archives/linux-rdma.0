From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and hca_core_clock
 to query_device
Date: Mon, 1 Jun 2015 06:44:50 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1506010640060.25165@east.gentwo.org>
References: <CAJ3xEMj5qphSq5QQHKPsihuK6StmJ+NHiPbkY-ZVGmpViB1AXA@mail.gmail.com> <20150526185315.GF11800@obsidianresearch.com> <CAJ3xEMh7JYN8sP5MYdVjH=tqPFURwvD7jVvV0=PBiEn1qEFi2A@mail.gmail.com> <20150526220724.GC4502@obsidianresearch.com>
 <CAJ3xEMgdqBnn6hobRJFut6Nyu2pKt40rb46Z3dYx3MaohR2urA@mail.gmail.com> <20150527184856.GA16059@obsidianresearch.com> <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com> <20150527222108.GA7855@obsidianresearch.com> <5566BDE4.50709@mellanox.com>
 <alpine.DEB.2.11.1505280908001.16142@east.gentwo.org> <20150528162416.GA6515@obsidianresearch.com> <alpine.DEB.2.11.1505281212330.1711@east.gentwo.org> <1432918767.114391.110.camel@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432918767.114391.110.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> > This is sufficient since it can be converted to ns or whatever one wants.
>
> It is sufficient for your use.  It is not, however, a good API.

I hate these foggy statements that you guys come up with. Why is it not a
good API? Having a cycle counter without processiing overhead is a good
thing and the way counters are handled is pretty well established.

> > The API provides the abilty to retrieve the clock freq which is
> > sufficient for the user to convert the value to meaningful time values.
>
> I would prefer if the access to the timestamp were implemented via a
> function in libibverbs (I haven't looked at the git repo, too little
> time, I'll get to it).  Something like ibv_get_cqe_timestamp().  That
> function should be general and return a suitable, normalized value (ns
> probably).  If you just want a simple comparator without the overhead of
> normalizing to time, and are willing to accept the consequences of that,
> then I would expect you to use something like

That would introduce additional latencies and would make that feature no
longer useful to us. The advantage of this approach is that the counter is
in the same cacheline that is already used. It is very low overhead.

> ibv_get_raw_cqe_timestamp() to get the unadulterated cycle counter.  For
> the most part, the user space application should not know details like
> "we are using a cycle counter in the HCA processor for timestamping",

Why not? A cycle counter is the general way of providing
timestamps in hardware. RDTSC is such a cycle counter as well. There are
numerous examples of counters like that.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
