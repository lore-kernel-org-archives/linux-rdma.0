From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 27/31] IB/cm: Fix honor address handle
 attribute init error
Date: Wed, 15 Nov 2017 07:31:55 +0200
Message-ID: <20171115053155.GO18825@mtr-leonro.local>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-28-leon@kernel.org>
 <CAJ3xEMjPsD7+YnN80A7Z3WjxEey20=TYKpxrRK_mRhKVMEnA8Q@mail.gmail.com>
 <VI1PR0502MB3008514AED6DA3E970381088D1280@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <CAJ3xEMg6bJt0obWHrSae86ZUN7RgCYqWJJiQXw9on82P=zO_VA@mail.gmail.com>
 <VI1PR0502MB300851A707AFA9DEC77B232ED1280@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20171114233841.GC25894@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nBNKYIkUhonyaPEg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114233841.GC25894-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--nBNKYIkUhonyaPEg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 14, 2017 at 04:38:41PM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 14, 2017 at 10:27:42PM +0000, Parav Pandit wrote:
>
> > > On Wed, Nov 15, 2017 at 12:13 AM, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > wrote:
> > > >> From: Or Gerlitz [mailto:gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> > >
> > > >> any reason not to point out the commit that introduced the bug?
> > > > No particular reason. I am not sure few years back it was bug or not. In current
> > > code it appear so.
> > > > So I continued without Fixes commit line.
> > >
> > >
> > > The idea is that you do the git blaming and such work to get the
> > > Fixes line, and later, the maintainer of the sub-system and
> > > maintainers of stable kernel use that to decide if/where they want
> > > this to go beyond the -rc kernel you are fixing
>
> > Yes, I understand. But would that be a bug in initial commit, which
> > transport was it handling.. without error code check what could have
> > gone wrong..  I do not have answer for those questions. So I omitted
> > the Fixes line.  Wherever I knew for sure in this or other series, I
> > have added.
>
> While the fixes line is nice, the more important question is if any of
> these patches should have a 'Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org' ?

No, this is why I didn't ask to add Fixes line, because stable@ takes
patches in semi-automatic mode by looking after Fixes line.

Thanks


>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--nBNKYIkUhonyaPEg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloL0UsACgkQ5GN7iDZy
WKcd+A/9HzlGXY3Xw7As6VuEU1n5rSMFjOc6StnTdUMKIkeioDHlq9ptLqxB12G6
arOKgoUO3NeKgO2AF1NHE0Z6eohqWtbS96RoX7ZW86KPoX8NZBo6RpfeBdpYL3nm
Qxy4DX0fWMVDXHTRaVO+KhItr9ZlnxDXI+e/62A8yW876ws+FSCJCWyTnevaMaqW
23BHM4nabYMeM3r4RPbFGVO1pwLvoHUsE2i493FlbgS1EHRkm7/odRnmczSfq1nh
Q1YncQ4sYvxrLUAU8eNVNvQpSFzH3tLHyjNfzfix8YF5qbisW5JK8WuzEle4QHD4
y8C9aMuPJnGByG4G3faUSbQ2FJCUmNQUpDelF9/0JXH8reazZ5pNmo69/bhdHYvF
ySvZ4IdtgIYjDcZllMNYiwen9bK7n/NTKdSHdhByiVgcSBl3r60SQGs2+duw6Yap
uAIBcwyH4Tr7HspT7OsD2YmiOkr85+B7Je4aYuMB7VAqPV2GRNNqmOdClcLw66M0
5SSVSzpfAoYidQq0udjOzj2uilMeG084MKohFnTXeMGwX6196I9GDwkau7Fi/qOK
iExznxDxlsYa1kctlj69G01Wo3owf3h/dIh25vfxECVh8rjXvJgfwcobcEFW4bv1
JaXmJLeQLpEt98ESGxNuwyWGJak1eyRbJM6SWzR9sKhXtyGNOyw=
=C0ZV
-----END PGP SIGNATURE-----

--nBNKYIkUhonyaPEg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
