From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/9] Add RoCE v2 support
Date: Mon, 12 Oct 2015 10:41:54 -0400
Message-ID: <561BC6B2.9090403@redhat.com>
References: <1439481794-27998-1-git-send-email-matanb@mellanox.com>
 <561A74CA.4060707@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pRe1Eqo6PMoBGDrgUUx6tVIrIhUtlm47g"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <561A74CA.4060707-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pRe1Eqo6PMoBGDrgUUx6tVIrIhUtlm47g
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/11/2015 10:40 AM, Matan Barak wrote:

> Hi,
>=20
> I've rebased the patches against your k.o/for-4.4 tree. I've also added=

> some fixes to bugs we found lately. I can re-spin the whole series if
> necessary (with the fixes squashed).

Yes please.  I haven't done my review on this yet, so might as well have
an updated version.

> My git tree is available in:
> https://github.com/matanb10/linux.git         branch: rocev2-for-4.4
>=20
> Thanks,
> Matan


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--pRe1Eqo6PMoBGDrgUUx6tVIrIhUtlm47g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWG8ayAAoJELgmozMOVy/dkkEQALNQuUqQHg9ghvfAbXt2Rkgr
UEorU5fd7d2vMTOBo+8bG7B4o40yk/s4zJlpfblKZRZ+3XWlYCGDpfltWoRhvz9U
9IScD20yaqMTxyloLIFcWv6qWf4WJT/z15FwYPgAIbLlt5R9g/WvFLdKLd6N640E
QxV3b5wxfOGG0pK06m/hFeHJnsGpPmf08dZB95617PWyoX577odMUv5BWDRzqpip
l1vPGWZ8sNwvxZaMw57Gw4Ey4VQZtfmbcLMKMVywU4X3Bgg2Pl2/C0AyY4/n8E9+
/HPNpVdYlO340+zYzjorPDd8Nf/8pYVlyFnWDh5egKHDKUISyVrLLjR5Oib+E0Xn
gnCWknGt/or3JAkSA9WIs7KHvkJaaT7v2BRSuljcCq3k/wLT4ViCJOraN3JBpomA
0aqjxhdyQ4nDKl+Zzinsg1g0YvPILtjBJzx43NJUqNfe/oGwQ1rW0kbPohZ2q/bB
H1vkg38uirTEPJLZA+4+HHU+E7KEkoybGNBm9sFLjOaeMvpsPKpAtIQbWjRD3YuP
2maJcz3GNkjHPD1sMcbuetYgY+HxA+DWfCBkzC02Ee0GoGheG9earFrFZ1sj9XOV
eMguNO8AUTKtjMWKJKp0sMx0AnUS0Xv9i4S3MTZwN6PkoF/1AU1XAVMeOG76Yk6f
YwYMUDoS7AyLcQp63q9D
=Kvo+
-----END PGP SIGNATURE-----

--pRe1Eqo6PMoBGDrgUUx6tVIrIhUtlm47g--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
