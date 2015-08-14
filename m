From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Add Infiniband dependency to Kconfig
Date: Fri, 14 Aug 2015 16:56:21 -0400
Message-ID: <55CE55F5.1050804@redhat.com>
References: <20150804161652.24483.80145.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5lD0Od3V7docTfKRdifaDlSiTwRkH3Mar"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150804161652.24483.80145.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5lD0Od3V7docTfKRdifaDlSiTwRkH3Mar
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/04/2015 12:16 PM, Mike Marciniszyn wrote:
> From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> The hfi1 driver depends on the infiniband core stack.
> Building a kernel without the infiniband core but with the
> hfi1 driver causes undefined reference errors to the ib_* functions.
>=20
> Reported by 0-day build:
> https://lists.01.org/pipermail/kbuild-all/2015-August/011216.html
>=20
> This is a temporary patch and is only needed while the hfi1 driver is
> in staging. Remove when moving driver back to drivers/infiniband.
>=20
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Picked up, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--5lD0Od3V7docTfKRdifaDlSiTwRkH3Mar
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzlX1AAoJELgmozMOVy/dXeYP/2Dt2/gaWXeqWDIMflzZgG4I
dr+m4chs6O++dE63VL2ry0IX8pNJw1XQG8XUQ51yEtTYM2mnVrdwq5vdgTOfzNvh
pEEkwc4T9xG25HREuviibOgN/+UgOBsRJ/b/x2xDha09LdtERD5SFUoeBFcGgUEZ
hNSncJMlQwE2I2CzBoNkdcnL+Eliv4Pqmp68W5AjEPTbL3t/jtGCTaQfCYmz8uwB
eKuOeFWqiFYqhHNPMpRYQeLQb2tq8qajWDQYOB8AVnQsiXTluHGH2giHdzEAe+Ij
hgVvUWjx2V9ghBRPby9PTEKK6SJadG92lhrchbJx/lgOuEsXdM4LHrcU0CTs7ibJ
Aa9FZCCpuvE8QpFZN9+hv6apbYKhjlfwLlAep4VaOW3bKgv346mfc1XExwfMnbiv
PhnUmcBgZ8fOfgAT6bKCCraUibWq5SMuahUs68JoaCf/R4n8baTP4eLAmRqFpU2B
4VYnV+onmcBqhbFC2yq+klGSNQUQu7S7EhZYcxq7WCXyFoaB7juopCAjeu+ZhSGn
NLU5TnggHMyHPOA+qjbRoDE/rwfZufXL0teKG2ZCAet4i+X0TSivLrrGGTkCxxZg
6S+oE1MJbbpfD1dDuFJzotvBsX1urAJqQCIcy3Co2978V3oBJYhZOj67XBANwAnu
c6abinLTg2l0S/sHQFUo
=pWKU
-----END PGP SIGNATURE-----

--5lD0Od3V7docTfKRdifaDlSiTwRkH3Mar--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
