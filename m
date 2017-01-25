From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/8] mlx4: Add ability to poll CQs through
 iterator's style API
Date: Wed, 25 Jan 2017 19:11:12 +0200
Message-ID: <20170125171112.GR6005@mtr-leonro.local>
References: <1485355791-27646-1-git-send-email-yishaih@mellanox.com>
 <1485355791-27646-6-git-send-email-yishaih@mellanox.com>
 <20170125170413.GC16579@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vIXBmblrD40XNCy4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170125170413.GC16579-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--vIXBmblrD40XNCy4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 25, 2017 at 10:04:13AM -0700, Jason Gunthorpe wrote:
> On Wed, Jan 25, 2017 at 04:49:48PM +0200, Yishai Hadas wrote:
> > diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
> > index 5ab083c..cb4c8d4 100644
> > +++ b/providers/mlx4/mlx4.h
> > @@ -59,12 +59,20 @@ enum {
> >
> >  #ifndef likely
> >  #ifdef __GNUC__
> > -#define likely(x)       __builtin_expect(!!(x),1)
> > +#define likely(x)       __builtin_expect(!!(x), 1)
> >  #else
> >  #define likely(x)      (x)
> >  #endif
> >  #endif
> >
> > +#ifndef unlikely
> > +#ifdef __GNUC__
> > +#define unlikely(x)	    __builtin_expect(!!(x), 0)
> > +#else
> > +#define unlikely(x)	   (x)
> > +#endif
> > +#endif
>
> Also move all the copies of these into util/compiler.h instead of
> adding more.

I tried once :)
https://www.spinics.net/lists/linux-rdma/msg43086.html

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--vIXBmblrD40XNCy4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliI3DAACgkQ5GN7iDZy
WKe95A/+Ne2lEi+BcFwW+wQUEIJ9EYu20DruvywyKpze97+5VNzV2tvLF244Q2po
hrMFQI7v9QYuy2pqJKiVktZZ+8/cKqjqmPPcgs2p/TYXxpo8KSqnViZXitWLNh59
Hn243xqle8eZRdgmkPh7QYPReTzSalqWKcS47RBHsj3Zxo40/MX631ifDwm19toj
H6/4vUQJ651UgOuIN3Nw+YV6RSsBIW21aX6NlrryDfOu06wNNw6xKkN5lY2yYUZX
Yqma1Pwjha2vrYhl3XszVi3LI4JylzDcmnQSQDmwNeJEqjz4Q6U3T5HctPsNNQrO
bfIJOmWC3j/GTHbUOUBXPNjFyTIvmnpPOAiqN1vFYobDks49M7cUgtD77WU/mctt
DqD1Yi1kggrZ6Eck9qQ3wlW8kZC4d8ZNEPNKyqbeyjWdxV7g1QSZDY2qGdaRYT6A
K8bsZD4e1ivp9fVD1Vewu39eqviSWB9VJKRv2H9UtPEz8bKKnq4N/QXpuqscpqJX
h6LnTcU5De6rhB7mWMroDvTC1AU2X5hiQsn9iZq2dKD5y6ccqPSiUc1HmCVV9cf5
oigkF8slz0AF3NX5DQSje61U2g2gGEUqPLOZ/OAUg9w+1UdLSJ+6N9FHITvMqWiS
Nn+dBQW7Hkqp2bmGnO9OgmNYuAR1wxa3t0DqaneHpu7WgK9+u+A=
=sVWt
-----END PGP SIGNATURE-----

--vIXBmblrD40XNCy4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
