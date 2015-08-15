From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB/hfi1: Remove inline from trace functions
Date: Fri, 14 Aug 2015 22:00:44 -0400
Message-ID: <55CE9D4C.9060808@redhat.com>
References: <20150813200524.28650.91753.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Fwv8bwBDgJIDPSqGerw9wIAsB42jbDsbb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150813200524.28650.91753.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Fwv8bwBDgJIDPSqGerw9wIAsB42jbDsbb
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/13/2015 04:05 PM, Mike Marciniszyn wrote:
> From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Inline in trace functions causes the following build error when
> CONFIG_OPTIMIZE_INLINING is not defined in the kernel config:
> error: function can never be inlined because it uses
> variable argument lists
>=20
> Reported by 0-day build:
> https://lists.01.org/pipermail/kbuild-all/2015-August/011215.html
>=20
> This patch converts to a non-inline version of the hfi1 trace functions=

>=20
> Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This has been added to the hfi1 branch.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Fwv8bwBDgJIDPSqGerw9wIAsB42jbDsbb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzp1MAAoJELgmozMOVy/de1cP/2+ynhK4unmnwuKyaHxTtsiW
sqtkwPBTvBGXvwTLrQY4Icx3zVgQf3nANoAhqhQ1vrlfPtAWlcQCdr4159dacTe1
3v2Hu3JApy3uTSIPXdW4b3N7o/QyZBi7J+dqK+J7ql+BUMgmVqbmU4G4XVa8raHw
Oy7Zb6SY4NJtX0fb8D0zDp+IT3ccEB+QT419SjBtce9Y9htMO/VHwTsrdUqs7J6x
X+zc7akiNWQH/qs7Io1GYY5W5Q4XmbL2yjEmjC+ugsBaM0BbrayPf/COkGZ1qFH3
BjuaoccqrfHzr1NBO9glUaZxDtPiTQo3XjiYPs1zaMbGWnbJcrFAyqkOkCoRPVsj
xo1tytUYwVvaaSkivAVfeg1DGhgB5zLLxeszfjNj60Z8VFmjBou5/AshKEhKMwZt
rt2MiXNKJ58gEnRRp0tetnZu44PvDCCFh/kCvrQIcYRJJBOsKFHvPmITUmOZI4t+
rtpcyggLJBwntoQTgIU2U7RDZ+pg/b/7ytgf06Scbjnxz8k908SZ4f5JKCvmT2gh
kkS+iOdiRNKkRFrVtyZk8xw7w2NRh2qjDi2elNhflAVkdUcH1UGF2UVioK9HFoLL
e1UYt9yai9dQVLXBvzDTCRFbGiPLU5SvxoRecC6KRdKHnX0jrfuzi/c5NsfcV97e
gnqRmg3VQDO1CvbxW/zr
=4OZq
-----END PGP SIGNATURE-----

--Fwv8bwBDgJIDPSqGerw9wIAsB42jbDsbb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
