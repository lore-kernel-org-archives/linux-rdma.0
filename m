From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/nldev: Fix multiple potential NULL pointer
 dereferences
Date: Fri, 9 Feb 2018 18:49:18 +0200
Message-ID: <20180209164918.GP2197@mtr-leonro.local>
References: <20180209063702.GA28685@embeddedgus>
 <20180209122549.GK2197@mtr-leonro.local>
 <20180209073649.Horde.OueGLKMtzpLyz4w36quXUca@gator4166.hostgator.com>
 <20180209143541.GN2197@mtr-leonro.local>
 <20180209095600.Horde.e7EqwCs_5bRLfE3Nnkfl3L3@gator4166.hostgator.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rMWmSaSbD7nr+du9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180209095600.Horde.e7EqwCs_5bRLfE3Nnkfl3L3-fU+oOHjIBR1LoJgMfuPDHBfZZeVsHd8q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Cc: "Gustavo A. R. Silva" <gustavo-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--rMWmSaSbD7nr+du9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 09, 2018 at 09:56:00AM -0600, Gustavo A. R. Silva wrote:
>
> Quoting Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
>
> > On Fri, Feb 09, 2018 at 07:36:49AM -0600, Gustavo A. R. Silva wrote:
> > > Hi Leon,
> > >
> > > Quoting Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> > >
> > > > On Fri, Feb 09, 2018 at 12:37:02AM -0600, Gustavo A. R. Silva wrote:
> > > > > In case the message header and payload cannot be stored, function
> > > > > nlmsg_put returns null.
> > > > >
> > > > > Fix this by adding multiple sanity checks and avoid a potential
> > > > > null dereference on _nlh_ when calling nlmsg_end.
> > > > >
> > > > > Addresses-Coverity-ID: 1454215 ("Dereference null return value")
> > > > > Addresses-Coverity-ID: 1454223 ("Dereference null return value")
> > > > > Addresses-Coverity-ID: 1454224 ("Dereference null return value")
> > > > > Addresses-Coverity-ID: 1464669 ("Dereference null return value")
> > > > > Addresses-Coverity-ID: 1464670 ("Dereference null return value")
> > > > > Addresses-Coverity-ID: 1464672 ("Dereference null return value")
> > > > > Fixes: e5c9469efcb1 ("RDMA/netlink: Add nldev device doit
> > > implementation")
> > > > > Fixes: c3f66f7b0052 ("RDMA/netlink: Implement nldev port doit callback")
> > > > > Fixes: 7d02f605f0dc ("RDMA/netlink: Add nldev port dumpit
> > > implementation")
> > > > > Fixes: b5fa635aab8f ("RDMA/nldev: Provide detailed QP information")
> > > > > Fixes: bf3c5a93c523 ("RDMA/nldev: Provide global resource utilization")
> > > > > Signed-off-by: Gustavo A. R. Silva <gustavo-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
> > > > > ---
> > > > >  drivers/infiniband/core/nldev.c | 26 +++++++++++++++++++++++++-
> > > > >  1 file changed, 25 insertions(+), 1 deletion(-)
> > > > >
> > > >
> > > > It will be much better to fix the tool instead of fixing ghost case.
> > > > This scenario is impossible for all those flows.
> > > > We can receive the skv/msg in two ways:
> > > >  * First by allocating new message with NLMSG_DEFAULT_SIZE, which has
> > > > more room
> > > >    than nlmsg_total_size(payload), payload is 0.
> > > >  * Second by getting from netlink.c and it will be at least "struct
> > > > nlmsghdr" too.
> > > >
> > > > Can you please add this info to the commit message?
> > > >
> > >
> > > Actually, I was planing to send a new version of this patch. This time using
> > > the unlikely macro for all the null checks on nlh.
> > >
> > > What do you think?
> >
> > It is not datapath, so "unlikely" is not needed. Let's assume that smart
> > enough
> > compiler will optimize such flow anyway, because nlmsg_put returns NULL
> > in unlikely scenario, so this check will be unlikely automatically too.
> >
>
> I'm curious about why the return value of nlmsg_put is null checked 118 out
> of 129 times (based on Coverity reports) in the last linux-next tree.
>
> So based on what you mention, do you think all those checks are actually
> unnecessary and, maybe they should be removed?

I honestly don't know about all cases, but if message is allocated with
NLMSG_DEFAULT_SIZE and payload is 0, this check won't be needed.

So go ahead, add check if (!...) in all places, but be cautious with
"potential null dereference" claims, it is not always true.

Thanks

>
> Thanks
> --
> Gustavo
>
>
>
>
>
>

--rMWmSaSbD7nr+du9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlp90Q0ACgkQ5GN7iDZy
WKeNuhAAtgXlgYhyXlMTHnvoaUI3xeMVxqvrQbZLGm+vgectS8KPa9yHFiORETJK
ksWaNEkxkqGWaX6AY0OdxIYWsQOyxmplx8Gv825uFkdOtrdq1OotSv11MLUY2s7S
6ICnFUrTtXYPcPmHK4+/gPkIm9+jEflAQwCL3xVWd/KXlsUZUjVTzYqftaInJqQ2
Hjeienm4cDFPH0Us26kQLdwv5c/wQEtI+Qwwb8em11u3MqGayEip8krDzjotfNq4
wUMz96DvxontCKfjYDBwJo9cKjr4CyDkRbzQwfCuTMi6ubL58OSFqhpfDXV0go48
nABShN3BWH/8GtXlxLPwPYQrmD8HJAWZVv221B+TqT11M8i1/NsL2qRlPEQo8/lg
Dza1b6vI9dDBMD+Rof1fLAR2jlwve8O4fGVgxJr8WgKod2GwDHZWLTVF8NJVzqX/
MdbJg/POVrar8lwhtdlMkrEKiGF45JuSCmkzlMNNVXgMdShfJG8chjL8mVtaLNVV
oxyix1iC66+bQfOYU1qHJlk5Fy/blh+qww2IbOKRvacIWm38cEiCe0yscjv3wZdV
divTiK7IM7DMZUTeBUYjb+xdfQmrlojPclcRvvSSaOcqT5wxWDACcwkVvqJdp6OB
OSbAFwLTfMUx7sYqVGm142LlnBhty+pJLC2l4M0Pv3PSqI+Cn7E=
=SB7n
-----END PGP SIGNATURE-----

--rMWmSaSbD7nr+du9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
