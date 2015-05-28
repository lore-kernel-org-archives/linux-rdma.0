From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and hca_core_clock
 to query_device
Date: Thu, 28 May 2015 13:30:52 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1505281325150.1794@east.gentwo.org>
References: <CAJ3xEMh7JYN8sP5MYdVjH=tqPFURwvD7jVvV0=PBiEn1qEFi2A@mail.gmail.com> <20150526220724.GC4502@obsidianresearch.com> <CAJ3xEMgdqBnn6hobRJFut6Nyu2pKt40rb46Z3dYx3MaohR2urA@mail.gmail.com> <20150527184856.GA16059@obsidianresearch.com>
 <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com> <20150527222108.GA7855@obsidianresearch.com> <5566BDE4.50709@mellanox.com> <alpine.DEB.2.11.1505280908001.16142@east.gentwo.org> <20150528162416.GA6515@obsidianresearch.com>
 <alpine.DEB.2.11.1505281212330.1711@east.gentwo.org> <20150528175043.GA10966@obsidianresearch.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150528175043.GA10966-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 28 May 2015, Jason Gunthorpe wrote:

> > This is sufficient since it can be converted to ns or whatever one wants.
>
> Sure it is sufficient, but is it a robust UAPI, will it support
> multiple hardware vendors?

What would prevent other hardware vendors from exporting their counters?

> Is anyone else in ethernet using verbs to deliver IP packets?

This is not only for Ethernet. Internally Infiniband is frequently used
and there also timestamps are useful.

> Having a conversion function, or doing it in the wc generation is more
> 'obviously safe' for future proofing the UAPI.

Well no. There has been a history of putting time corrections etc etc into
these. Once you move from a raw counter to actual time various
complications may need to be dealt with. For simple time differentials the
counter is sufficient. If you really want proper "time" when something
happens then you may want to scale and correct etc the value and have some
sort of time sync approach.

> > But that requires additional processing.
>
> Well, it is only additional if the app is going to ignore the time
> stamp or not convert it to ns right away. Is that the common use case?

The app may not need proper time but just a cycle count differential. A
cycle count differential is often easier to handle than a ns value. And
having ns values leads to the assumption that they are "correct" so
various factors related to tuning the clock etc may have to be applied.
You want to deal with these issues only if really necessary.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
