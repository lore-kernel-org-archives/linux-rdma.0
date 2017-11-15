From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 27/31] IB/cm: Fix honor address handle
 attribute init error
Date: Wed, 15 Nov 2017 10:20:16 +0200
Message-ID: <20171115082016.GW18825@mtr-leonro.local>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-28-leon@kernel.org>
 <CAJ3xEMjPsD7+YnN80A7Z3WjxEey20=TYKpxrRK_mRhKVMEnA8Q@mail.gmail.com>
 <VI1PR0502MB3008514AED6DA3E970381088D1280@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <CAJ3xEMg6bJt0obWHrSae86ZUN7RgCYqWJJiQXw9on82P=zO_VA@mail.gmail.com>
 <VI1PR0502MB300851A707AFA9DEC77B232ED1280@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20171114233841.GC25894@ziepe.ca>
 <20171115053155.GO18825@mtr-leonro.local>
 <CAJ3xEMiB6VUp1Kb9HBS5jkqnYN61UP6DYNxqs1T8qGLCUGELcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="V5RPc/ioYsxrZT/b"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiB6VUp1Kb9HBS5jkqnYN61UP6DYNxqs1T8qGLCUGELcg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--V5RPc/ioYsxrZT/b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 15, 2017 at 09:59:23AM +0200, Or Gerlitz wrote:
> On Wed, Nov 15, 2017 at 7:31 AM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wr=
ote:
> > On Tue, Nov 14, 2017 at 04:38:41PM -0700, Jason Gunthorpe wrote:
> >> On Tue, Nov 14, 2017 at 10:27:42PM +0000, Parav Pandit wrote:
> >>
> >> > > On Wed, Nov 15, 2017 at 12:13 AM, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> > > wrote:
> >> > > >> From: Or Gerlitz [mailto:gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> >> > >
> >> > > >> any reason not to point out the commit that introduced the bug?
> >> > > > No particular reason. I am not sure few years back it was bug or=
 not. In current
> >> > > code it appear so.
> >> > > > So I continued without Fixes commit line.
> >> > >
> >> > >
> >> > > The idea is that you do the git blaming and such work to get the
> >> > > Fixes line, and later, the maintainer of the sub-system and
> >> > > maintainers of stable kernel use that to decide if/where they want
> >> > > this to go beyond the -rc kernel you are fixing
> >>
> >> > Yes, I understand. But would that be a bug in initial commit, which
> >> > transport was it handling.. without error code check what could have
> >> > gone wrong..  I do not have answer for those questions. So I omitted
> >> > the Fixes line.  Wherever I knew for sure in this or other series, I
> >> > have added.
> >>
> >> While the fixes line is nice, the more important question is if any of
> >> these patches should have a 'Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org' ?
> >
> > No, this is why I didn't ask to add Fixes line, because stable@ takes
> > patches in semi-automatic mode by looking after Fixes line.
>
> And what's wrong with that? IMHO the right thing to do for fixes is
>
> (1) putng the Fixes line
> (2) cc the author of the offending patch
>
> This way you can get them a chance to review the fix and point out to
> you problems in the patch that may e.g introduce a 2nd problem or
> a side effect you don't envision. This is what we do on netdev,
> practically always.

Always, are you sure?

In the patch c1c1d86bdea4 ("net/mlxfw: Properly handle dependancy with
non-loadable mlx5"), you didn't add Fixes tag and didn't add relevant
people (Yotam, Arnd and Jakub).

It is how it looks in my mailer:
Date: Sun,  2 Jul 2017 18:57:28 +0300
=46rom: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, mlxsw@mel=
lanox.com, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH net-next] net/mlxfw: Properly handle dependancy with non-lo=
adable mlx5

Thanks

>
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--V5RPc/ioYsxrZT/b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloL+MAACgkQ5GN7iDZy
WKfsoA/+Jrb4k7pjr2Xm9SMZpSBu5raf390bqRKyVLNX4Dp2837SmDwKZTryo8Tj
gi/YCnf8yYnvgs35wK6myNh+J4Gk9BdPIg2FIqeSnY6CsB7Uq4H+jhdfSwrFQG5d
MFy3ggH1oAOef29HV4NzY6rmLTdZcRKWLxfW7su997GT07kTqhL3LftbWY2go5pz
5OZ0yFKBzpWaC9go1YrZ5/Kj1k5VjnUsUTRX83fbIxfYXCRHK3XxOANfCDdtZ1xu
Pmj+RbV/2kfSgKg5PH0F9Uq957XKOPApkb+pSw+doP6mpZpsPycI9cwFvrlLvOXR
r183RWLXtj/NJnhPBY1QwzDvQZRfaAt9IxHrtHVUrjgjRLscVguL47D4nLtRGvWd
xzlZJZ/vqwvTeO/GlkeBvYklMu62e0yEGPKGIPXlYU0Uod0cfCejuGDhBG//x70h
D/gwXFKt/5g0ZDZAEf0EPOzFZnPdab/DuWF+BVXcH6MfvaAO8eayK8A0W02uWOkk
5J6SIEYQ/6y8lVgZrZE5zQ/fwWWQpNRgyTdU1CwC2wdvSOg+h+miXMBrFlvdZwZE
TC1BGJpENmAOcoSfs8Spgmi0KE9qdrEWQv3TIjvk6NQL6YKuUOvkQQeBogfjbQMW
vhF9ZhN61MPq08dw0GESHMEoLz5XR7zOWavoiEDZEgmugZCvNgA=
=Gc5U
-----END PGP SIGNATURE-----

--V5RPc/ioYsxrZT/b--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
