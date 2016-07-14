From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Skip napi_schedule if ib_poll_cq fails (v2)
Date: Thu, 14 Jul 2016 08:11:01 +0300
Message-ID: <20160714051101.GH10079@leon.nu>
References: <1468423316-28246-1-git-send-email-yuval.shaia@oracle.com>
 <20160713153252.GG10079@leon.nu>
 <20160713184408.GA2985@yuval-lap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+G3HLlWI7eRTl+h"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160713184408.GA2985@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--k+G3HLlWI7eRTl+h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 13, 2016 at 09:44:10PM +0300, Yuval Shaia wrote:
> On Wed, Jul 13, 2016 at 06:32:52PM +0300, Leon Romanovsky wrote:
> > On Wed, Jul 13, 2016 at 08:21:55AM -0700, Yuval Shaia wrote:
> > > v0 -> v1:
> > > 	* Initialize n before use
> > >=20
> > > v1 -> v2
> > > 	* Add reviewers
> >=20
> > You don't need to resend patches with tags changes only.
> > Patchworks handles it and adds automatically when Doug
> > collects them before apply.
>=20
> I also added some off-list reviewers.

You could reply to your email with forgotten tags.

--k+G3HLlWI7eRTl+h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXhx7lAAoJEORje4g2clin5qcP/3wHELhUf7jQwJ7I9kQtN1Ua
ecCdmiw3J4kdYpCNN6NemMct6jUn4d0v4N2f2TNXDCg7VOzELPtMxiTNVDQDhLda
fnyIYETJa5MxdzLJY9YgL5zjM5VLT0m7nXVwOh3+o5H6ipyCfehDCG88fcU3MzrG
Xl92pDnrIctVfU89YQ9T6wy4LSbZKQYDWlkJ5AroaoQgzEDAt8ZVdojw9qCCMh0V
Vm8TbsOr3Kd9ErCuODaL91MGSOkWsLKegaDlfNVg50R2xlSGJCSytbKOt7U2tKY/
9x9YHNZLSNaWaZpEjqw8qLRRu8z1GTgZogKTOFhF0IJ+8QTfiPHR6aXIMgwF6yO8
jg8C9mAg7GdWByICTm/KKkeBBVwWwHBKnoRCpPQxzro6fjnLd2c45UxrHtuyjcDE
htqA7sBZjQANDuIlCIQ0T6DmlIYoegJunfaB73j6NoaMAb6gDK4aWMgkE3rMosH3
AFNHp2kHKBrl0r2kPSnTIVfUs5oT749AWCz4/FzwDfBqAoSnNUUZATXNbA7CxluR
4QHO/MXG2WEYh0pXgQkfPcv+fGSlnp/y2xjKehH7Vm4B5WmBrMMwhehtFJjsv7JZ
DN+8kFq1+ntMVgeJyOIS4COnd5tkVOatGZBINS2EnZB0lH201QBUn+9ufSGlTLYu
wkVo3lMJCMmH1rgrmIJd
=3hhq
-----END PGP SIGNATURE-----

--k+G3HLlWI7eRTl+h--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
