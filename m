From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 for-4.1 0/4] Misc. fixes and cleanup for iw_cxgb4
Date: Tue, 21 Apr 2015 14:06:48 -0400
Message-ID: <1429639608.45956.49.camel@redhat.com>
References: <1429647301-6832-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-fGRfZf2perixwVWw+SeN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429647301-6832-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-fGRfZf2perixwVWw+SeN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-04-22 at 01:44 +0530, Hariprasad Shenai wrote:
> Hi,
>=20
> This patch series changes a macro definition to be consistent with other
> register macro defines. Fixes for 32b platform, use BAR2 register for ker=
nel
> mode CQ's and enforces qp/cq id requirements.
>=20
> The patches series is created against github for-4.1 branch.
> And includes patches on iw_cxgb4 driver.
>=20
> We have included all the maintainers of respective drivers. Kindly review=
 the
> change and let us know in case of any review comments.
>=20
> Thanks
>=20
> V2: Use uintptr_t instead of unsigned long, based on review comment by
>     Doug Ledford
>=20
> Hariprasad Shenai (4):
>   iw_cxgb4: Cleanup register defines/MACROS
>   iw_cxgb4: 32b platform fixes
>   iw_cxgb4: use BAR2 GTS register for T5 kernel mode CQs
>   iw_cxgb4: enforce qp/cq id requirements
>=20
>  drivers/infiniband/hw/cxgb4/cm.c          |  6 +++---
>  drivers/infiniband/hw/cxgb4/cq.c          | 21 ++++++++++++++-------
>  drivers/infiniband/hw/cxgb4/device.c      | 29 +++++++++++++++++++++++++=
+---
>  drivers/infiniband/hw/cxgb4/mem.c         | 10 +++++-----
>  drivers/infiniband/hw/cxgb4/qp.c          | 14 +++++++-------
>  drivers/infiniband/hw/cxgb4/t4.h          |  7 ++++---
>  drivers/infiniband/hw/cxgb4/t4fw_ri_api.h |  4 +++-
>  7 files changed, 62 insertions(+), 29 deletions(-)
>=20

These look better now, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-fGRfZf2perixwVWw+SeN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJVNpG4AAoJELgmozMOVy/dGsEP/ROZLYFxsaMTkcUV2EQ9GJQd
Y2etzg640S5XOJvVI5CDjH70ZTShDSiz65VhROkdqiGnUJT+6pRxrAs796pLXWWr
TVAuH+RFjuufSdONa+r2VJIsyrbprZ7GktQtMVL/7lLRHYUkevlrduB2gQW58tHc
nFE/YOimOE/d4RIHQM9gN0PPIMiUCcikLlK0elrP1yH1pI85IdHevd63jvavW9Dp
GUCAXoLPWQ80r+lXbqJ1Zwxt2Oa5xYpMj/EjIMNvDS5LVmTbpKDm+WnGkwhAyrK4
X1mBZPM6T2RPmCxNhE+ooROI33/WrYXA5sOT7nz4DIhTk/tT0ugmztUEQ8MbC7Cj
FNQJ5zYfrJUN2lI+YRtYiOVjSwXFXipMyaUjeFlbAzTwvLDPsoD21sSgLcNF7ZU8
RylVnRX705YTr4Ai56m0ZacQVtm5LbnIhLP8f+RKa9aqO4syhoEvUBG3jNBWMKI+
HlaPuxSEgpE1SnQXUgbe0JAYs9KSBSdC0GYcWJa7XspJV4rjkj2v6j1dcvP0f7rH
rEbawoRqywiRprUuu0b6u2T/m0rnDLLzYmONJaudxbrPbDwFLTDbA4foIyJKiXiu
HqqohzHGqCxtBtR/7h2jzfGycZwwjUeMZ6Ivtj0rXPDen/bfOI2Fyz33B1lfsSGg
+mnX97vHxUMS1357bzuw
=C8Mk
-----END PGP SIGNATURE-----

--=-fGRfZf2perixwVWw+SeN--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
