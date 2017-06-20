From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ib_core: Enable and expose force_mr module parameter
Date: Tue, 20 Jun 2017 21:03:48 +0300
Message-ID: <20170620180348.GV17846@mtr-leonro.local>
References: <20170619152351.2866.11046.stgit@klimt.1015granger.net>
 <20170620073236.GO17846@mtr-leonro.local>
 <DE0C511C-A4CB-4D76-8BA7-6BFF81F590B3@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="QXliVHAuIB9eJ4yJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DE0C511C-A4CB-4D76-8BA7-6BFF81F590B3-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: doug.ledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--QXliVHAuIB9eJ4yJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 20, 2017 at 11:43:56AM -0400, Chuck Lever wrote:
> Hi Leon-
>
>
> > On Jun 20, 2017, at 3:32 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Mon, Jun 19, 2017 at 11:26:40AM -0400, Chuck Lever wrote:
> >> The fourth parameter of the module_param_named macro is a set of
> >> file permissions. Passing 0 there means that module parameter is
> >> not created and that adding "options ib_core force_mr=1" to a
> >> modprobe.conf file has no effect.
> >>
> >> The default setting of rdma_rw_force_mr continues to be 0, or false.
> >>
> >> Fixes: a060b5629ab0 ("IB/core: generic RDMA READ/WRITE API")
> >> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >> ---
> >> Hi Doug-
> >>
> >> This doesn't seem appropriate to go through Bruce's tree for 4.13.
> >>
> >> Last discussion didn't seem to conclude with full consensus.
> >> Probably people don't care enough one way or another. But I'd like
> >> to see this get fixed if there aren't strong objections. Would you
> >> take it for 4.13?
> >
> > I care and believe that it should be removed from exposure to users.
> > The variable force_mr should be leaved in the code for the debug,
> > but module_param should be removed.
>
> I don't understand the technical grounds of your objection.
> Why is
>
>  options mlx4_core internal_err_reset=0
>
> acceptable, but
>
>  options ib_core force_mr=1
>
> not?

That mlx4 variable was exposed before I started to follow after
Mellanox's submissions.

The force_mr parameter is for debug of new ULP and/or conversion of
existing ULP to RW API. This is not very common situation and it is
for the developers and not for the users.

Thanks

>
>
> > Thanks
> >
> >
> >>
> >>
> >> drivers/infiniband/core/rw.c |    2 +-
> >> 1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
> >> index dbfd854..1cc8f07 100644
> >> --- a/drivers/infiniband/core/rw.c
> >> +++ b/drivers/infiniband/core/rw.c
> >> @@ -23,7 +23,7 @@ enum {
> >> };
> >>
> >> static bool rdma_rw_force_mr;
> >> -module_param_named(force_mr, rdma_rw_force_mr, bool, 0);
> >> +module_param_named(force_mr, rdma_rw_force_mr, bool, 0644);
> >> MODULE_PARM_DESC(force_mr, "Force usage of MRs for RDMA READ/WRITE operations");
> >>
> >> /*
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> Chuck Lever
>
>
>

--QXliVHAuIB9eJ4yJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllJY4IACgkQ5GN7iDZy
WKequA//SwSEvbtu66Nd8d9tnXAvxNqjdTtcxGWF/tpvfOYAStzAsK/9wIjPDRSb
XaeApdYI19hV85VpXQrrHxNsc1rBRDVU++vy4/8Q8ds24P5cOfQ7yEDMbKGJ8hxa
aBYp6erxQpx5e8uEHktcclR1RdYh7m3Kk0rj8m5PatsCqDI25gr1emxJLk57LYAQ
InmHwUAnU1QhRR+MLNCBMNAxsAeXD0/5TuC/VJv814l6ZInP5r0jUURe1JNCSzxC
YMvGh5lS2SQDgK42fI20fhar1OO0FhnzEuIlhhqNlMgTPXa2Gv1zWMoK/oJfUANI
Mvw+X5EBJLTzhLokv8MEsw5kyb4j5fy+alWFO590Y1faJ+RtO5PBH+Bb1MtpGhSI
DS5WZYdU8faShqzxl5GPHmQjSocQT85wm3OS0xtdhBWvmCaN3fQPoBgyq1lQ9bU8
3jFb/QnU1I93c42fDkGylLg2eaZMTIj+SSv6Px62h5F1te3B6QGNVQANC9fovfH9
uzCUxDQPeeEowrBt+HvYfpM4MdyqW6VHGWM955G3fYgvGc+UtD7nsohhLo1+SDtP
jCpus7MZ4U25qJf6k1kBylpLi2dLIARwdU/uMOU9rGXPyX8+4R+98pQfAlhSBHrS
VEs5K4yD/qZl737IFdDnGj7SCTkOjDHj1dK+oOXhry7BGQ/JmVQ=
=0Ws+
-----END PGP SIGNATURE-----

--QXliVHAuIB9eJ4yJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
