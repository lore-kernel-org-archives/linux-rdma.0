From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/7] IB/srpt: Change default behavior from using SRQ to
 not using SRQ
Date: Tue, 10 Oct 2017 07:14:23 +0300
Message-ID: <20171010041423.GJ1252@mtr-leonro.local>
References: <20171006214243.11296-1-bart.vanassche@wdc.com>
 <20171006214243.11296-4-bart.vanassche@wdc.com>
 <20171008100317.GR25829@mtr-leonro.local>
 <1507568205.46071.46.camel@redhat.com>
 <1507568492.2674.11.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CxDuMX1Cv2n9FQfo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1507568492.2674.11.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--CxDuMX1Cv2n9FQfo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 09, 2017 at 05:01:33PM +0000, Bart Van Assche wrote:
> On Mon, 2017-10-09 at 12:56 -0400, Doug Ledford wrote:
> > On Sun, 2017-10-08 at 13:03 +0300, Leon Romanovsky wrote:
> > > It is a little bit strange to ask from user to decide if his adapter
> > > supports SRQ or not.
> > >
> > > It should be automatically.
> >
> > I think Bart's intent is that the driver not use SRQ as the default
> > behavior even if the adapter supports it, so querying the adapter for
> > support and enabling it if it exists would not achieve his desired
> > result.  This would then be used to override that behavior.  Is that
> > correct Bart?
>
> Hello Leon and Doug,
>
> The changes realized by this patch are:
> - Instead of using SRQ as default, use non-SRQ mode as default.
> - If SRQ has been chosen as default, and if SRQ is not supported, fall back
>   to non-SRQ mode (see also the if (IS_ERR(sdev->srq)) ... code).
>
> Please let me know if you have any further questions about this patch.

Yes, in case HCA supports SRQ, when do you set that module parameter?

In the commit message, you mentioned disadvantages of using SRQ is a
default and among them - locks contention, which can be changed in the
future. Won't it mean that users stuck with current default, because
change of default will "break" their scripts?

Setting visible to user default won't allow us to change SRP behavior in
the future.

I wouldn't recommend to make such option accessible by users.

Thanks

>
> Bart.

--CxDuMX1Cv2n9FQfo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlncSR8ACgkQ5GN7iDZy
WKdsgBAAgTHSu+hKle9uBkl/AbkcOJt8j7itF37tFzr2kfQEV7Ev9zC82eA5DDpg
Lh0A2bbgJnlGpLx7qUZ+fkzd0ZxWI8WGyH6VIIpSU1YV82FGyeLj50sOpJbMbrxm
Bvm1hK6r/7SMwQ5eIZZ7W2Q0L/1jfT1j3UlPlH0U00Za410B96oLF8i36+Uqq989
VBga7MO+Yfo30d9zF/ylwdHxGsM93iZ9kMm52G4FcXpmT0kTnYV7okPtbabTgUTI
/RXaI8vMkuJoID71ZinvvjkzW8XEJQaykW8bfyp4NNbj5PZj7+vQbAws5q/Wfu1e
KzMkCCNuLrt0O1HUU+71lWzPOPAlfHMkfWSUIIeymDnr9rRCUY6tAJNyRohzOesj
xBBlKnHAwaexupFhhbk7XGe4F7+4EyUvSPQLKV+SO/JoPqh5Q/fPwLPG97WI5sa6
EVS3+1xd8sN4IWAFFA66jRMCmEpKkhHoXwEAAOPB8pQslkZTCO23bZZmYuW0g9aA
rO6aORIBzuVXzJBMph0TQT6LTjC3CaWOmQJaorb2eW32RmY7uHo3hh6j38jUaNHF
1/bILyILt9yLgNp0kwDSSbX4AutD0smvuVx6NmdBvS17jeGOIfv1pZZ0XbeMe8/M
J25kfAJRAsQEC9xeTTFFqYxXRC8xEkZYrxJv237ZMHPMpMY0o6w=
=hJRP
-----END PGP SIGNATURE-----

--CxDuMX1Cv2n9FQfo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
