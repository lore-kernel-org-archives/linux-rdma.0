From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/nldev: Fix multiple potential NULL pointer
 dereferences
Date: Fri, 9 Feb 2018 16:35:41 +0200
Message-ID: <20180209143541.GN2197@mtr-leonro.local>
References: <20180209063702.GA28685@embeddedgus>
 <20180209122549.GK2197@mtr-leonro.local>
 <20180209073649.Horde.OueGLKMtzpLyz4w36quXUca@gator4166.hostgator.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5p8PegU4iirBW1oA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180209073649.Horde.OueGLKMtzpLyz4w36quXUca-fU+oOHjIBR1LoJgMfuPDHBfZZeVsHd8q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Cc: "Gustavo A. R. Silva" <gustavo-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--5p8PegU4iirBW1oA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 09, 2018 at 07:36:49AM -0600, Gustavo A. R. Silva wrote:
> Hi Leon,
>
> Quoting Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
>
> > On Fri, Feb 09, 2018 at 12:37:02AM -0600, Gustavo A. R. Silva wrote:
> > > In case the message header and payload cannot be stored, function
> > > nlmsg_put returns null.
> > >
> > > Fix this by adding multiple sanity checks and avoid a potential
> > > null dereference on _nlh_ when calling nlmsg_end.
> > >
> > > Addresses-Coverity-ID: 1454215 ("Dereference null return value")
> > > Addresses-Coverity-ID: 1454223 ("Dereference null return value")
> > > Addresses-Coverity-ID: 1454224 ("Dereference null return value")
> > > Addresses-Coverity-ID: 1464669 ("Dereference null return value")
> > > Addresses-Coverity-ID: 1464670 ("Dereference null return value")
> > > Addresses-Coverity-ID: 1464672 ("Dereference null return value")
> > > Fixes: e5c9469efcb1 ("RDMA/netlink: Add nldev device doit implementation")
> > > Fixes: c3f66f7b0052 ("RDMA/netlink: Implement nldev port doit callback")
> > > Fixes: 7d02f605f0dc ("RDMA/netlink: Add nldev port dumpit implementation")
> > > Fixes: b5fa635aab8f ("RDMA/nldev: Provide detailed QP information")
> > > Fixes: bf3c5a93c523 ("RDMA/nldev: Provide global resource utilization")
> > > Signed-off-by: Gustavo A. R. Silva <gustavo-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
> > > ---
> > >  drivers/infiniband/core/nldev.c | 26 +++++++++++++++++++++++++-
> > >  1 file changed, 25 insertions(+), 1 deletion(-)
> > >
> >
> > It will be much better to fix the tool instead of fixing ghost case.
> > This scenario is impossible for all those flows.
> > We can receive the skv/msg in two ways:
> >  * First by allocating new message with NLMSG_DEFAULT_SIZE, which has
> > more room
> >    than nlmsg_total_size(payload), payload is 0.
> >  * Second by getting from netlink.c and it will be at least "struct
> > nlmsghdr" too.
> >
> > Can you please add this info to the commit message?
> >
>
> Actually, I was planing to send a new version of this patch. This time using
> the unlikely macro for all the null checks on nlh.
>
> What do you think?

It is not datapath, so "unlikely" is not needed. Let's assume that smart enough
compiler will optimize such flow anyway, because nlmsg_put returns NULL
in unlikely scenario, so this check will be unlikely automatically too.

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

--5p8PegU4iirBW1oA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlp9sb0ACgkQ5GN7iDZy
WKd7RRAA0dh2kNQ8F2e0pv2kyHamG1AwaP/Q5rGkCp0BsTkGF+45gjh8tslglOCQ
gk4TduZdqXuXQYkptW79B9lmuuxJq4DyogGy6mAbLSW/6wE1D1mX/IvPwUmYC2G1
3cPSm6RTX6OS+C2kVIoUPpK++wNmSnMGt02OnO49cCIe/E/GHh7ARt/kTd7CIAYV
Qhp1w4Le2AHiWQfj3ZIl+is0qUdxeR6grbyla/t5QqG3czwVQyJxx4A/wINdyTKt
L09jLKbDmLOB6Nree7TrXEwLyke9FT1xWo3LPlxQB+QHdnW1ZxbLMUKGr/07Tad1
SRU3uG1Phx78UbV8/4dkv3u2P1npkKbPo7DWm4L3vWRBmHaq+2MH1eS33zAUr6MA
2UntPpxaJ0TJVQHyfCASc+cgsIhFAA1Usty0OhKuwqNQ+XUb4qO1covlFe9BAtC6
/Lw09PWjYF9iVw+B9teuryLEiAE7kpsRJlKezuH7zhg/spXGQxS/Q7nyMIexI6zV
WEpNz3Qe841fRsvfTtzw96a7IhPp3QsCjcpW6yvAB7pebgbqdxHASg9UmNsgw2Vd
/33AAKxpNuLDaDgurGpUO9TzufRrAClXCG2HQE1LOc4JjUHQp6K6MikPNiEJhdyX
ie8+FD/bDGbEnowN/QvoZ3LHHzOpHqzq50fQRz6AUbVvVfR4RNw=
=vcZY
-----END PGP SIGNATURE-----

--5p8PegU4iirBW1oA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
