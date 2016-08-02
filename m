From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] Use smaller 512 byte messages for portmapper messages
Date: Tue, 02 Aug 2016 15:12:52 -0400
Message-ID: <1470165172.18081.32.camel@redhat.com>
References: <1468869709-66592-1-git-send-email-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-l79Krck5OXz9gNapTCrA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468869709-66592-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-l79Krck5OXz9gNapTCrA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-07-18 at 14:21 -0500, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Portmapper messages are short and do not occupy more than 512 bytes.
> Lower portmapper message size to 512 bytes. This change significantly
> reduces the amount of memory needed when trying to establish a large
> number of connections simultaneously. The old value is based on page
> size.=C2=A0
>=20
> Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>=20
> V2: update commit message with justification for lowered message size
> and
> its old value.
>=C2=A0

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-l79Krck5OXz9gNapTCrA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoPC0AAoJELgmozMOVy/dbZoQAKHvS/I1zo/XYV2Q1AcM/8C2
jA+oXMoB+J8dbJ+lv7Q2OJYq8PV0rLw9bGBPs9/gb3B10Q1HhPaiWDtBu3dxPLQa
6if+yiyzIZpCiMP1jg5bJ8D1p0v+FX2WWKUp5oEqNIw3SSHvNZChCNrUGia/5XFf
ChGRndCHA6gCrIK56ICg0jDZnrejtIAlqIYii2sBDktWy89pUyip3Ka4okXzvAda
TPuYiBEoLJizwqdVBElw0xIetQE8EQmbzwMhTG2DrwBCEYElEY31B4xJUURCALg9
OksKhch1dxuRUJ4uQ9XIY9HEEkE4zMrjM7Olzmn0SP/8JI2FBDeBze7Z/9eeXPf7
4k/vbhy6qPLQDaNJgRNNJ2vJmzeAtuDcP3986Y+17ZF9WwDib0mR7Coy5eB4p73P
JipAkrf2pNxzAZsHJ8FOy7DR5dPAjZC/c8K/Nl6Gckn6RCOUZCrTOpm8PPVCs1KN
jQuYE0FEl9bRkzcODuriHGEmM59pxm4JRoLRctS9FNUw+jwGHuwCLWu2hZwdCer9
ijuPbjVjCKrsB7am5wMhdALoIxVCwq5Z1iFQjhWwdwwZxEBVCyyNq74Bd/+mRhH+
Eq6uwd+vAQO/1ai2QpWPHa9Gtu0F/cevGyDvGpJuqsXysuv3U0LEwWbVj9mVpOxs
uBFxJiD8wJgn6kKCVpTO
=xepf
-----END PGP SIGNATURE-----

--=-l79Krck5OXz9gNapTCrA--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
