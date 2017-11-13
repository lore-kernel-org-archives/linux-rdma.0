From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Mon, 13 Nov 2017 14:16:10 +0200
Message-ID: <20171113121609.GK18825@mtr-leonro.local>
References: <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com>
 <20171110202455.GP18825@mtr-leonro.local>
 <f7c88e99-5726-2f3e-9763-1f179ac6b292@suse.de>
 <20171113081455.GD18825@mtr-leonro.local>
 <cb56c548-4962-58be-d293-5b4169c24b2e@suse.de>
 <20171113104146.GG18825@mtr-leonro.local>
 <838fb26a-363e-9874-728c-76e614943e56@suse.de>
 <20171113114300.GJ18825@mtr-leonro.local>
 <7569c13e-915f-a266-0d66-0a776079223d@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="V66X/350vc37cwHu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7569c13e-915f-a266-0d66-0a776079223d-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--V66X/350vc37cwHu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 13, 2017 at 12:44:51PM +0100, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 13/11/2017 =E0 12:43, Leon Romanovsky a =E9crit=A0:
> > On Mon, Nov 13, 2017 at 11:56:19AM +0100, Nicolas Morey-Chaisemartin wr=
ote:
> >>
> >> Le 13/11/2017 =E0 11:41, Leon Romanovsky a =E9crit=A0:
> >>
> >>>> I'm OK with keeping just the ML for the moment. If it becomes too mu=
ch of a mess, I'll come back with my github request (or something else).
> >>>> How do you suggest flagging me for those patches ? Should we follow =
the kernel stable process ?
> >>> I think so, the kernel process works, we just need to adapt it to rdm=
a-core.
> >>> Regarding the flagging procedure, we can do like Greg and Sasha do.
> >>>
> >>> Open email account (e.g. stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org), connect it to /dev/n=
ull,
> >>> so people won't get bounce emails while they sent patches to it, and
> >>> once a week or two run script [1], which will check master branch and
> >>> cherry-pick patches with Cc: stable@ in their commit messages.
> >>>
> >>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/sashal/stable-too=
ls.git/tree/
> >> Sounds fine to me.
> > Need to document that.
> > BTW: I opened stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org email, if you want I can forward all
> > emails from that account to you, right now, everything goes to /dev/nul=
l.
> >
> > Thanks
> >
> >
>
> Yes you can forward them to me.

Done, it will take a couple of hours till it will propagate.

Thanks

--V66X/350vc37cwHu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloJjQkACgkQ5GN7iDZy
WKeUpBAAg7k9kBCEzFG1RllLafnSEVHmC6Dzopkyzlq+4TL8io1dRqLmltNZ5Ahp
cVPfi3rQL15emRp/5/kEqcf6b5eyigrKy+Tv4eZNPNM+bHsCKUfRhcD0LWvtuxPF
bYxavNR3eNbGujuhpbP9812+/6GITofZcmjcVKix8wJvbcy8ERD4rHjqjqwnz6N/
CL7UY2QJLUlG4Ox1f9ZndRpx4HO/hFi37F+bBx6nH2uLT3igalWIy+zKIXx4WCKz
vS6BMRQGvdIYBsd/2+hN8cSrGcEczLEyKxqkNrQVyyapfVGv9LDasrPH8xRI15cw
I58ogzcImTZNuxZTkRqqRXZH6kWtVc6qdLxuVqgUB2KDbLyA1Oi4nWxovcd9VpQP
ALnc0IjEdCfP+wwmIp/s3KcNf6jdPGyfP9W9vv5SO36wGCoEZt9BOhUe7hy9E/99
yAk53gUcRC4nKEdrPsYNeSSUMYhkuGkSl2zDcqu0qO+wJdaXm3O5BLohlAuFFv8J
J2n0In7TwHG/5Uey6zjnKEO4zemKyRRze22ZaWlnMQ38zT0RBf5zxurfy/Gz2x/M
1r919mLrweyMIxUsj+gOLf7suwkvISL/HxpaTlhxr6dtKFMznErKqy/uHgDCSNOn
8xCVsIK3L3/kfRIth7TbWPrHc4dICtKB/7xgktiHDjadzGzReUM=
=hD0f
-----END PGP SIGNATURE-----

--V66X/350vc37cwHu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
