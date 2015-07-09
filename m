From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Use flow-counters for process_mad only when
 appropriate
Date: Thu, 09 Jul 2015 10:49:50 -0400
Message-ID: <559E8A0E.70600@redhat.com>
References: <1435243538-26937-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OikXLhxhuqvGQ0fCLCUXK9HugORnevq1K"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435243538-26937-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hadar Har-Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OikXLhxhuqvGQ0fCLCUXK9HugORnevq1K
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/25/2015 10:45 AM, Or Gerlitz wrote:
> For IB links, reading HCA flow counters through iboe_process_mad() shou=
ld=20
> be used when mlx4_ib_process_mad() is invoked only for VFs PMA queries =
and=20
> exactly nothing else.
>=20
> Fixes: 7193a141eb74 ('IB/mlx4: Set VF to read from QP counters')
> Reported-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>=20
> Hi Doug, Dave=20
>=20
> Doug, I've rebased the patch on top of Ira's fix [1], also you would ne=
ed to=20
> merge the mlx4 (7193a141eb74 etc) changes that went-in through net-next=
 for=20
> the patch to apply -- simply fetch from the latest upstream tree, they'=
re there.
>=20
> Dave, to make it clear, the fix will go through the IB subsystem, as it=
=20
> depends on other changes on that area.

I fixed up your commit message slightly (subject was too long),
otherwise applied as is.  Thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--OikXLhxhuqvGQ0fCLCUXK9HugORnevq1K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVnooOAAoJELgmozMOVy/d1zoQAKDBmGzxamJkxWLSIcZU7T/m
KnBHxTmtyVtAFtmdA9F8UFhYu3orNLx0dL+0LmyMdIV9bB/7afCOwD+nb5k5Z+xb
NOOKzrspnSoSa/gE4b8BoCk9NOKGOYoCRTsdNdqcWilMvIf1DrdGrzFd2DrfAIEa
tbVjUO5ZuTOf2vAwXjTwWkCpLo6bNEiMrrkSCBcOdCHtwBJ4oEqIKX28dFMj2gNK
2JXfwRIiFizimeVqrnQcnWDebS+F5iWsHkOERFuW1gQ3vpf7C4vbDfKixXXOSY99
CHlYn3GQm8ifj89RsM0pgyrQScqsLt4gKhL3SmNNghSvzoaeJuBsVgbjIhiysDZA
m6Eq8qAIJGKYPwCOpevWiuOfPxlEnAlMYV8tcQt7b1sbgr+wMk5PdIk/yaq+RaLt
Kybeg3ilzibxO1HYceusxkYxw4WiW+Vt6T1qQ7nYx6atJs1qYW/VxXarEVe6dFHT
52qN+jWoGyMU+F5NEVkkt980rI6wN/dbtihInRPHIKroLwOin13JmEAybYYm6Aw4
gB3VyiEjM6AaywRGtDU5Tb78Bz9ODo1PK2oj0tD98ADBvU1BZ5BUJUtXmMGuwwkS
++HkCbPb9TW7JQ6HQJSdxadZGqB4zqNCfBsVdYbGK9pi7uN7P5E9H6IAWWMzn9rw
ZnBW4TSmPrc58zQMavpP
=z7MX
-----END PGP SIGNATURE-----

--OikXLhxhuqvGQ0fCLCUXK9HugORnevq1K--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
