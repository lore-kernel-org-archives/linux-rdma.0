From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: How far back does rdma-core X supports the kernel Y?
Date: Thu, 2 Nov 2017 07:54:33 +0200
Message-ID: <20171102055433.GV16127@mtr-leonro.local>
References: <BN3PR07MB2578883C85DD3855C496F367F85F0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171101163915.GB1030@ziepe.ca>
 <BN3PR07MB257867500E3A15914B2AD075F85F0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171101173324.GF1030@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jobRqqe4Hp8P9iE7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171101173324.GF1030-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--jobRqqe4Hp8P9iE7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 01, 2017 at 11:33:24AM -0600, Jason Gunthorpe wrote:
> On Wed, Nov 01, 2017 at 05:27:22PM +0000, Amrani, Ram wrote:
>
> > Also, currently they are marked in ib_verbs.h as reserved. This is misleading as
> > it hints they are for future use. We should mark them as don't ever use.
>
> We have tended to use reserved to mean dont use. Someone should
> inspect the git history before trying to use a reserved value..

Why don't we properly export these defines in uapi/rdma/ib_user_verbs.h?

The fact that change in internal to kernel value breaks user space
shows that interface between user-space (rdma-core) <-> kernel needs
improvement in sharing of the headers.

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--jobRqqe4Hp8P9iE7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln6sxkACgkQ5GN7iDZy
WKdKcxAAhJjHR9VUAGeru0Z1LHoRfO3N42dC3lshWd/+EL8JZM+J3CEQaAZTHpnM
JeNqUx3fy9lSXrTtGSycwcbiNphbeDg2SohcPA0llW+8nHjk7yXp5Sf7F4Yadnuj
39rRjw1JRcSnOwfWTuoHJTHJjcoY02eXMaHR+rYSouJ7EaLpplLY9Kpwvss92Nr/
H21JCuJgbaik9jHGntoRhcrCvs16i6DXR+4A+sY54bo41PMftiRNqctD4eqr0AH4
9/+0saJwtSx3l1v9hlMJoZgRnj3BonwDl9NUm9xhvSy8i/8u9sUbI3BWZD/Tyjmj
mQnRzRmuL2fntAxnCwa/4tERjXvqcGZsR7RleXUNifj7sUuEXt2kY76s/SYlYpjC
yVYqXkjq7cYlKOfGZsADe6Y6n8GUsMBRk1IMkvMYjqmXhCIDL2cT1yED6BBOhV/P
DC7V1BFH6oJj3FOdbAjHG4RlDVb/msBx6cWAcQxaI8B6IgGVNSOvzz6Eu/MUGIgR
AzWvDnROA83wwK34avaPk3KeEOmRoyERAqEzEl2MlhI+Z0eut3esS4bzMPJyIezN
lP6odSXzYAPNN6gY2gB8pL9ziDeozBDPznfDE4omIhXE+b6k5jErbzgmBKo6RtPc
3vquauf50IJrX3sEe4Q2VRV9nF7mY71ohUf3owEJ37PiRwGCWUs=
=1eYe
-----END PGP SIGNATURE-----

--jobRqqe4Hp8P9iE7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
