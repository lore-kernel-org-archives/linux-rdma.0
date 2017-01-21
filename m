From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: release tarball top-level dir
Date: Sat, 21 Jan 2017 10:26:40 +0200
Message-ID: <20170121082640.GB28570@mtr-leonro.local>
References: <01b101d2733b$f0179df0$d046d9d0$@opengridcomputing.com>
 <1484943474.43764.4.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484943474.43764.4.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 20, 2017 at 03:17:54PM -0500, Doug Ledford wrote:
> On Fri, 2017-01-20 at 10:40 -0600, Steve Wise wrote:
> > Hey all,
> >
> > Is this the intended top level dir?
> >
> > [root@stevo3 tmp]# tar tzf rdma-core-12.tar.gz
> > rdma-core-rdma-core-12/
> > rdma-core-rdma-core-12/.gitignore
> > rdma-core-rdma-core-12/.travis.yml
> >
>
> No, but I don't know how to fix it just yet. =A0The problem is that I
> have to put rdma-core in the version tag or else the tarball is just
> called v12.tar.gz, which really is not suitable.

It is better do not do it and use standard vXX.0 annotated tag without
rdma-core embedded in it. Travis CI will handle release creation and
artifacts upload automatically (after proper configuration).

https://docs.travis-ci.com/user/deployment/releases/

Such setup will give similar look and feel to this library [1], see their
download links.

[1] https://github.com/AltBeacon/android-beacon-library/releases/tag/2.9.2

Thanks

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliDG0AACgkQ5GN7iDZy
WKf20RAArTf75ZWO+eT7g9H7KVsER02sdDDRuEohytAhBzTian8hJatZwXir0uFy
4kywkQm+CBSU//bT1DMpbEhQHmVtO1zZ5EP1Ui8LGhQKx4Gqa7Ss7Vbmg6pdaWgg
yo9RfnMb//8wpzDvCC5Ul6FAI8PFUZH3o25njUlvkJPZfo3GCqG/i+plKEkgVaRI
lfHBa4NjBPbDrFWkGTGsyV5QeZf6veYXCsy2UQgiIdhDDfEF2b1r57h1dACsml5A
wf5aXf/hGMSY34BAkn5CMh4C20otn3ykV9xGPoNAaKe+vidLvmjksv49+sSqssKO
+LTl891HBxel/i63IBbXbI8h91NuuVoBXZKiyk5W9ZAh8YtiHnghfwc2RJ4+cH9C
2iBXxKEvKcmkI9XIXFOrTZ69PsIYELl4kzFKHqUaFeQuBTMpbnRHD+dYW57IxRzk
AfQ48FY48S6Pn7+TUl2SxSyYkvBwemxYO1DScd36m9RZINmgtloBN2t8DOtnSGz5
5U9Hq2h9eNubqTGsLNLi4jeuV+Q3MZN51N34AuGu5SD0woYgvvxSmoS6EPT6lMbx
wz+e/QaypP8kQ1UHE1sXugeevbB44toFRh/kALn/mCgEXavJ+Na7gwJE1ScfBcm5
KOsTUflvQSKTcdjpQwlDr8oRbuGj3Cmm9gwVSd8AhrzEjPu2LUg=
=3UFD
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
