From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 iw_cxgb4-4.8] RDMA/iw_cxgb4: Use kfree_skb instead of
 kfree
Date: Tue, 02 Aug 2016 13:05:24 -0400
Message-ID: <1470157524.18081.13.camel@redhat.com>
References: <1467267273-25048-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-ScqvgepMNP7bbr3tcVdJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467267273-25048-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-ScqvgepMNP7bbr3tcVdJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-06-30 at 11:44 +0530, Hariprasad Shenai wrote:
> The commit 0f8ab0b6e91b4d53 ("RDMA/iw_cxgb4: Low resource fixes for
> Memory
> registration") from Jun 10, 2016, leads to the following static
> checker
> warning:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0drivers/infiniband/hw/cxg=
b4/mem.c:612 c4iw_alloc_mw()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0error: use kfree_skb() he=
re instead of kfree(mhp->dereg_skb)
>=20
> Also fixes skb leak in c4iw_dealloc_mw
>=20
> Fixes: 0f8ab0b6e91b4d53 ("RDMA/iw_cxgb4: Low resource fixes for
> Memory registration")
>=20
> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
>=20
> V2: kfree_skb() checks if skb is freed, so no need to check again.
> =C2=A0=C2=A0=C2=A0=C2=A0Based on review comments by Leon Romanovsky <leon=
@kernel.org>
>=20
> =C2=A0drivers/infiniband/hw/cxgb4/mem.c | 26 +++++++++++++++-----------
> =C2=A01 file changed, 15 insertions(+), 11 deletions(-)
>=C2=A0

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-ScqvgepMNP7bbr3tcVdJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoNLUAAoJELgmozMOVy/dObkP/2nEj9vBQ1AejV5Iw2jCxkfX
YBCnjtLZIV75+eORnDkqLFC6QXA4uXj3J8Bh7nym619y3MwEDQcEwIRXkDboZykX
Ba2Ki98a5BM9kp3AcluidFtBtyCP272SJlEe6spFdcjn2VJZgklQVj3pXmVZPrAW
HdOj4DgGsT8ANvm9xlHZZE0A7bdSzeM7yuP5xTkP0U/ck6hjBMIwTmLliBp1aays
77D/kr+oFiROMLjhqcf6ID1V0wMDFGqv6OAZd/qQ4n/LFumekgqcI9YT7xmn1Y5t
oLFJHNbYzfCh/JrdZs6BqutEkmLQMKEpQSo0gLK6345kFdibCY1t7z5uE4CK1RmG
oPISUPz3VKfN9reovwDH2RRzezztRDXDkstIXybFoamvDUN0z0YT4N0Wjid7cEDG
NvLpkdN3vMmJorNvVhrq+Xl/ec9dubuZsXI5wHROahyVjjsbDoo63NPXshJQPdcs
IJGwYxOYEPQBT/OqkLwtquZol1NoYl6m7tKjqJU4qr//37+rCkH3tz5Muezcywef
rMWQYoBEWfRIWJmwR9eCz4psI0PIaT/7sfL3+ZIQ/+EWZdMJKSkqmK1SG4uk6X6U
RIdONE2Dki70Pa1sJ63tCujTEdOQ5g4zUpNZba5p33ObdqK3tUecHH1kGB1xbrnb
/DN4rrxLyQhHtlv/1usY
=pAGQ
-----END PGP SIGNATURE-----

--=-ScqvgepMNP7bbr3tcVdJ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
