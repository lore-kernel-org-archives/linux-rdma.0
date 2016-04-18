From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 00/21] IB/hfi1: First round of fixes for 4.7
Date: Mon, 18 Apr 2016 15:19:44 +0300
Message-ID: <20160418121944.GL6349@leon.nu>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com>
 <20160418070936.GK6349@leon.nu>
 <20160418120754.GC17987@phlsvsds.ph.intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Mit9XoPEfICDqq/V"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160418120754.GC17987-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Mit9XoPEfICDqq/V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 18, 2016 at 08:07:55AM -0400, Dennis Dalessandro wrote:
> On Mon, Apr 18, 2016 at 10:09:36AM +0300, Leon Romanovsky wrote:
> >On Tue, Apr 12, 2016 at 10:49:52AM -0700, Dennis Dalessandro wrote:
> >>These patches do some clean ups and fix issues which may not be appropr=
iate for
> >>an RC so we are targeting these for 4.7. The current patch series appli=
es on top
> >>of the "Important bug fixes for 4.6 RC" patch set submitted just prior =
to this.
> >>
> >>Patches can be viewed in my GitHub repo at:
> >>https://github.com/ddalessa/kernel/tree/for-4.7.
> >
> >Please follow SubmittingPatches guide - submitting fixes section.
> >
>=20
> Can you please be more specific with what your complaint is here? Which
> section are you referring to? There is no "submitting fixes" section in t=
he
> document.


If your patch fixes a bug in a specific commit, e.g. you found an issue
using git-bisect, please use the 'Fixes:' tag with the first 12 characters =
of
the SHA-1 ID, and the one line summary.  For example:

  Fixes: e21d2170f366 ("video: remove unnecessary platform_set_drvdata()")

https://www.kernel.org/doc/Documentation/SubmittingPatches

>
> -Denny

--Mit9XoPEfICDqq/V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXFNDgAAoJEORje4g2clinDrgP/3tRL/awz+DGK7mB3nVJS1F8
mZmYYBmJwdcF1pTkxhzX9kfdVMB92TpOh0HwHLd7tgONonGGmcyka5dDO34g5qoC
k9eAVTU6SAFprtOOzB204Smz6HgVcD3jyDB+DxZ8XXhZlR7Uub4KO3/MiWQQ3dRi
eJNU/VzhoylKPV3QxRw9ABaz5hONiTzZl4DF6LARAstGHhDJ/z3+kLjaAc5t8wFF
xDDMXTjKICDMsZgalLw488/EhKUchxQPh/ZDrvGOfBRcK+T2TYrQOjrwWxL1fey6
W5eNv0gu8/I+nGbaE1MogsKReytW2dqqk622J7n7qOV/+7f+NzCW/sklZuTs4g3C
+v6wGnWURbpZKXXzfjsM5gBwyM8Ohhcu51A5COjm/EpiaMC17cchdXexVgjbZX4u
7gNX8vDvLPJrAbMSeMFoiuoPy1GD4vORbR2A8l7FZkfNNiv3DyZAw07/VJkmdo1C
ACX7xeRlYuH23/upfgui3UQ4VCvsgBjLkPvTqH4OXuI2Dd6AMQFswRJ85PPJZJR3
Zzi2plEzbvLn1fdkjXsAm8roiZqfJTzti8u8SvmVe5Zoo2vSCZ1M2m8pxvm8tpcp
icL87d3B2yTUA++ircWWVSTcmAJQcfrWtuPf9Nelr8lJvJBHtkpJBu9g7MDpABiE
9LC6UZPKY5ZI597SqCel
=yZ/T
-----END PGP SIGNATURE-----

--Mit9XoPEfICDqq/V--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
