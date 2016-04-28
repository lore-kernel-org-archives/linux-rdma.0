From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 for-4.6] RDMA/iw_cxgb4: Fix bar2 virtual address
 calculation for T4 adapters
Date: Thu, 28 Apr 2016 10:45:21 -0400
Message-ID: <57222201.4080503@redhat.com>
References: <1459832028-27852-1-git-send-email-hariprasad@chelsio.com>
 <20160405053407.GI5264@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="C3xtxO2QSBI34jnFn0NJOMBtTvNIfMofA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160405053407.GI5264-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-2ukJVAZIZ/Y@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C3xtxO2QSBI34jnFn0NJOMBtTvNIfMofA
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/05/2016 01:34 AM, Leon Romanovsky wrote:
> On Tue, Apr 05, 2016 at 10:23:48AM +0530, Hariprasad Shenai wrote:
>>
>> Fixes: 74217d4c6a4fb0d8 ("iw_cxgb4: support for bar2 qid densities exc=
eeding the page size")
>>
>> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>> Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
>> ---
>> V2: Add RDMA to subject line, add kernel panic trace and the commit wh=
ere
>>     issue was introduced, based on review comment by Leon Romanovsky <=
leon-2ukJVAZIZ/Y@public.gmane.org>
>=20
> Thanks a lot,
> Reviewed-by: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
>=20

I picked this up for 4.6-rc, but I reworded the commit message a bit
(the subject line was too long).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--C3xtxO2QSBI34jnFn0NJOMBtTvNIfMofA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXIiIBAAoJELgmozMOVy/dwusP/AhLgxm45tX8J918/jlAVI00
VRxUg7xbRs8Pe8v7fY7hK7J7t94+J3m+yrrwrY4oeE2l+xQQCpPbsILVaq4oPol8
/fYZY8U4Nvqyc6JX6tcRTcjmU1bD/nvwiBK3sF0dSfLxJjJKPegg3IaTxPpgk77E
rPnXFCgqxlAPMHrUmJTwW5bBcPTGYii7TjSoJseHi+YxrZ3FlanUaiMew+KYJKbg
V9ShLZ/yoSUiS1vEenvsfmReGE3dvB2k9lTXiF/QgPaHmXPOGG7gA6xa7m1S7Ozg
VMoKkrLHzvgZL2LeXzOkbX/h++0vHOZyzdIQbqmY4rj4yZO2kkY2DzJEwGjnEjGI
aYT1FzVvmTm42SbzY5J22p3XJzZjrB8aFZuqsC5UiQXrXV4zVpOK8erfvBkd2P+h
HTMrxocydlOSfm+rvhSPNsIZP5wP+P2VLft5EMvfVZtcwRlNwRg53q7TLs01EGQh
VJ2OMoQleGojY6Y2JUQCGonnVBGRfCuZvwCFsmQdoOLbH6hpxucN/K55JzpHjmQn
kHp4AKe1Uy4RNTxwfWDQEDVkMYCMZBBgQeduLINP43rirPfwiD+RBmLra9GNlylg
TS5/mdTIfkNUckvQmXa3e21AzlTW4FLmg2mQIAoGIgWLDbXBNsT/krCkoQ6kiuAY
e28+OBjuUZPY9pRgr7GP
=tNAg
-----END PGP SIGNATURE-----

--C3xtxO2QSBI34jnFn0NJOMBtTvNIfMofA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
