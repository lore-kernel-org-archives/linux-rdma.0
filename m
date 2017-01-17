From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 1/9] IB/ipoib: Add warning message when
 changing the MTU in UD over the max range
Date: Tue, 17 Jan 2017 21:34:08 +0200
Message-ID: <20170117193408.GP32481@mtr-leonro.local>
References: <20161228124728.26619-1-leon@kernel.org>
 <20161228124728.26619-2-leon@kernel.org>
 <1484246776.123135.19.camel@redhat.com>
 <20170112193508.GO20392@mtr-leonro.local>
 <1484258308.123135.41.camel@redhat.com>
 <20170113151507.GR20392@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hD6P3ib1XCFtz2ni"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170113151507.GR20392-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--hD6P3ib1XCFtz2ni
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 13, 2017 at 05:15:07PM +0200, Leon Romanovsky wrote:
> On Thu, Jan 12, 2017 at 04:58:28PM -0500, Doug Ledford wrote:
> > On Thu, 2017-01-12 at 21:35 +0200, Leon Romanovsky wrote:
> > >=A0
> > > First of all, thank you for fixing wording, for me it is the hardest
> > > part of every commit.
> >
> > No worries.
> >
> > > Second, I have a different view from you on the issue. User
> > > configured
> > > some value, which is not correct for IPoIB. In ideal world (without
> > > legacy),
> > > we were supposed to return error to him with proper message,
> >
> > If you set an impossible MTU on an ethernet adapter, you get a return
> > of EINVAL. =A0But it doesn't mess with the kernel log at all, it's *jus=
t*
> > EINVAL to the calling program.
> >
> > >  but in our
> > > case (legacy applications) we can't (we tried and it broke some
> > > legacy
> > > ifcongfig, if I remember well).
> >
> > ifconfig is what I used to test what Ethernet does, so it should be
> > well and truly used to EINVAL as a return.
>
> I'll recheck with Feras next week which legacy tool
> didn't work and will post it.

At the end, it was ethtool and according to Jason's comments it was
correct thing do not to put return value, so we are fine.

>
> >
> > >  So it leaves us with one available
> > > option is to warn user about improper value.
> >
> > Even if you want to alert the user, there is no need to warn. =A0Warn is
> > reserved for something that is a serious error or condition, this is an
> > EINVAL of something that is, at best, a performance issue. =A0Unless pa=
th
> > MTU support is broken, failing to set a larger MTU will not ever hinder
> > actual operation. =A0So we should never be dumping out KERN_WARN messag=
es
> > into the kernel log that will ping up on any root login session as well
> > as clutter the kernel dmesg output.
> >
> > > User should know that he supplied wrong parameter.
> >
> > User can still find out, they just won't get proactive pings on all
> > root sessions, instead they will have to look in the dmesg output
> > because they are trying to figure out why their command didn't work.
> >
> > > >
> > > >
> > > > --
> > > > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > =A0 =A0 GPG KeyID: B826A3330E572FDD
> > > > =A0 =A0
> > > > Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =A01274 B826 A333 0E57
> > > > 2FDD
> > >
> > >
> > --
> > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > =A0 =A0 GPG KeyID: B826A3330E572FDD
> > =A0 =A0
> > Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =A01274 B826 A333 0E57 2FDD
>
>



--hD6P3ib1XCFtz2ni
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh+cbAACgkQ5GN7iDZy
WKdPfw/+KQ7HQ6gGfvYf2e8QDOMXx9AMzZan/KrqmrmDBC0XAVFYIr3mO6Cv62Zs
UotRms9hS7oAP6pn7lq0QNSUCxbxJxJf1TbdMQu50HxOlVdZ4DIE3ogvZR3+8Li/
+/6fJINx0/cQf7nckINyinX1Qw7iHVRy9VZlCdDkSJS0H25CDBrsQhpwHb6MVmWe
Nm8HrGKATZ0mdyMnaAhcPYzE1Rv53hibJUxYx/E6hao2lfHCglAuGTA8hHfTejC6
2oXmaF8ZKRd/fGwmfGjtY8WNOzv+gvoaFCXx18+c6HJgurEIjqfnRLg3vMJDmnTr
Z6Jg9JS6hweF3A3WgpXzNXXJ5Q84a11SWX3xh8C46G+zdYO0Rc/hWYlfg+NrpDT7
f93tKqiLnlRhQ8i0fb/gWz54GK3MPvzo1KzqeBrIxcvS0UAIDWif3ADdY94ia0os
mVOYJ2HSS5K6HWtSDMnWmyJkUJcLwzsQ2qdulO9VogT5loYCrOZPVYaWUQDxqkAg
8EoAbdTrscBD6WmTioxt2316+Thz+cra7Z0P1QV4Cz4E+cjGhdgXhSlGnARowask
k6P4Ig5eKaLBDZIu8pGeS00fWdXnZzoNytBUErVjchD8yidDfNISdsksZBYMpfW5
BOKULx+LsNYQDjlmdjXcdsTTBBKlEDtB9zJmVuFgK7KZMDdvabM=
=kteG
-----END PGP SIGNATURE-----

--hD6P3ib1XCFtz2ni--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
