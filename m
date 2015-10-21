From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/5] set MPA revision to 2 and misc. fixes for
 iw_cxgb4
Date: Wed, 21 Oct 2015 17:16:47 -0400
Message-ID: <562800BF.6070100@redhat.com>
References: <1441686421-5899-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aSIAUwpTPfmUlcuIE0WVlDlKPeONODHq0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441686421-5899-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aSIAUwpTPfmUlcuIE0WVlDlKPeONODHq0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/08/2015 12:26 AM, Hariprasad Shenai wrote:
> Hi,
>=20
> This patch series adds the following.
> Detect errors while creating listening servers, pass ird/ord info in
> connect reply events, fix misuse of ord for ird calculation and for the=

> ESTABLISHED event we should have the peer's ord/ird so swap the values =
in
> the event before the upcall. Set default MPA version to 2.
>=20
> This patch series has been created against Doug's linux tree and includ=
es
> patches on iw_cxgb4 driver.
>=20
> We have included all the maintainers of respective drivers. Kindly revi=
ew
> the change and let us know in case of any review comments.
>=20
> Thanks
>=20
>=20
> Hariprasad Shenai (5):
>   iw_cxgb4: detect fatal errors while creating listening filters
>   iw_cxgb4: pass the ord/ird in connect reply events
>   iw_cxgb4: fix misuse of ep->ord for minimum ird calculation
>   iw_cxgb4: reverse the ord/ird in the ESTABLISHED upcall
>   iw_cxgb4: set the default MPA version to 2
>=20
>  drivers/infiniband/hw/cxgb4/cm.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>=20

The series, minus the last one which I managed to get into a previous
release, has been picked up.  Thanks!

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--aSIAUwpTPfmUlcuIE0WVlDlKPeONODHq0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWKAC/AAoJELgmozMOVy/dMdwP/RWmRPAAj/YJiPf11DExNQ4M
xR/rqoANhBe0Y/QQsd0M34PdRZYkB1ZhZHUs6o3QktI1k7wApwmtOIpWRwLBS74+
FGd5mt4147XTVX1/ffGGmpI9c7zPnfnZbTkEgmg8UvmZcgppR4Eo1QGKn4HIIEKO
+alND90oqlWOLQzCCiGnjbzbb6/0eBaogTa+4UKK9i7PhJbE+rBxXOaTSsOc5L9/
X/2fBFjwVhSstXLPrg/G0l5ofG6e6xMo6JMmlYZO1GPBUuJlsK5If+V/Ifw8CY8F
CUu8qMtE6FONB9qEENApQKloDpfS0DtYODqAHDA+p6E5faNi0nihlNuZi9kh/rat
PAyzY59ydRF4evrWBYp4c7XeLVNYYzPHYS6lTdotgX5tyzRQWNvjmSdu1P74Bz5i
97YNrYE9IejoXtPDu4WluMt45UFGMWxB07wjVAzoCYonzgK/6gRgxhzSEI4i8W79
zVSv76qNxyDN1j0+b8gbB6v//0bAHCSDU0oGG/YSUGtWbGXWCotpcWYC9DEQHk00
/Y2k09QxjcQviSMcZzpOmI2T2pBI7sI10e6A6HBKFN2UZh3GtFC5gvRqP+WrMKJ1
brw9ioKG8KkM4lHKtierMkbDa21ec6Zxzlbl3B72MwVoSp222l6q5+xakSYj6wuE
rxeiwsjIBQx/ovlm//kJ
=G6L2
-----END PGP SIGNATURE-----

--aSIAUwpTPfmUlcuIE0WVlDlKPeONODHq0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
