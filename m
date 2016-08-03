From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/uverbs: Fix race between uverbs_close
 and remove_one
Date: Tue, 02 Aug 2016 22:43:14 -0400
Message-ID: <1470192194.18081.49.camel@redhat.com>
References: <1467548899-21923-1-git-send-email-leon@kernel.org>
	 <1467548899-21923-2-git-send-email-leon@kernel.org>
	 <1470162706.18081.27.camel@redhat.com>
	 <CALq1K=LUb+bvx5+3JYLQw+OnhzP5MuqmuydMS8G7eS8Kvyb9Ow@mail.gmail.com>
	 <20160802192647.GB20709@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-xgIZCfES3C2qmVqw0GCw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160802192647.GB20709-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-xgIZCfES3C2qmVqw0GCw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-08-02 at 13:26 -0600, Jason Gunthorpe wrote:
> On Tue, Aug 02, 2016 at 09:50:14PM +0300, Leon Romanovsky wrote:
> >=20
> > >=20
> > > The only reason I hadn't taken this patch before is because Jason
> > > said
> > > it was totally untested and someone (Devesh in this case) needed
> > > to
> > > test it to make sure it resolved their problem.=C2=A0=C2=A0I don't se=
e a
> > > test-by
> > > line here, so has this happened?
> >=20
> > I can't say about Devesh, but we verified it as part of our
> > verification phase.
> > Do you need anything special except Yishai's SOB?
>=20
> I was hoping to see Devesh confirm that the race he was able to
> reproduce is in fact closed, unless Mellanox did the reproduction?
>=20
> At least your testing shows it doesn't make things worse, so it is
> probably OK to go ahead if Devesh does not respond soon.
>=20
> Jason

I'm not sure what Devesh is off doing now a days, so I went ahead and
took this. =C2=A0With the fact that Mellanox tested it, I'd rather have it
in than out.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-xgIZCfES3C2qmVqw0GCw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoVpCAAoJELgmozMOVy/dN1gQALrCj0S7G1L4lh0jF+1hi/u0
+1E6M5PN75dPJf+KBitY2UtHKaf3zxb8306a6OadDwm7K5Mt22JjSxvucecUd5bF
ErdOeTdQt1STx3NCXbNLeLX8D+xXALzaur8TLMmWoKfvbLCK8gfb+CgooyCa0Wh0
y8YFU/tyApXrSeuyOsCm/PTkt3nJ8VUQQ4/kPCht84o+uP0xlH9uYsXfI7X7GLR6
nT3MkM6TPe7u003h+Q+iipvNgaWr14gA3KrZOxmn4svqB0gP6zrTz6cZb1Xn9r4T
w+RQv23yPIZCR9vS+8m7BTwEfT3ZrZxeg6ABrh5z6GHQJTdA+RcP/UoDZhgdRpDJ
Q+XLQsjeNY59nI6Bg72O15Rr2QLYURHLHoUmjH9i/p4DQk6x2fL1Xk4PlzYaOqqK
NaODoGn+uRAug7c82aKUV5Nf8Yz0pScpmVPWY5Axsnr0hlWjZX5tX82QVUEomKEe
SPiZbS/I+ovU0DxOg32GUULAcZi0DJTcXCnkzHF1u8SPtWqn2wAuPit7HmkKC+hi
M+M8qx8vlNH0wJhJxqHY5EcHkDnLqobzpKPo8dKt4hMVkGNx3xRz0T/5DQiidPyK
9X19rLARCjybSPwgcVsB29kIwL1Z58tLQDqoXTSs0JZoYRHbBShzAGLzDbJmCXSq
Qd8D6Zjm6SXNmivh2uPp
=+SRK
-----END PGP SIGNATURE-----

--=-xgIZCfES3C2qmVqw0GCw--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
