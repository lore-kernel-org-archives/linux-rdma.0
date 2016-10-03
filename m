From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] IB/hfi1: Read platform configuration file from
 EPROM
Date: Mon, 3 Oct 2016 10:46:15 -0400
Message-ID: <1a7c9fac-9651-e39e-d1cd-c5449457ffd4@redhat.com>
References: <20160930114009.12716.95241.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FAXnoSKaO6xMoF39eiEEiTfFQwaqmmwoi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160930114009.12716.95241.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FAXnoSKaO6xMoF39eiEEiTfFQwaqmmwoi
Content-Type: multipart/mixed; boundary="lda888sxqJUGKgTSgEx8QWPM9ihQqKqsf";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan
 <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <1a7c9fac-9651-e39e-d1cd-c5449457ffd4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] IB/hfi1: Read platform configuration file from
 EPROM
References: <20160930114009.12716.95241.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
In-Reply-To: <20160930114009.12716.95241.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>

--lda888sxqJUGKgTSgEx8QWPM9ihQqKqsf
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/30/2016 7:41 AM, Dennis Dalessandro wrote:
> Doug,
>=20
> This series adds the capability to read configuration information used =
to init
> the link from the EPROM.
>=20
> It partially undoes some of the work that was removed when we removed t=
he
> user access. This is not done though in support of user access. This is=
 only so
> the driver can read the EPROM. All user access is still only through re=
source0.
>=20
> Series applies on previously submitted patches and should apply cleanly=
 to your
> for-4.9 branch. Can also be seen in GitHub at:
> https://github.com/ddalessa/kernel/tree/for-4.9
>=20
> Changes from v1:
> Squash the first two patches per Jason's request
>=20
> ---
>=20
> Dean Luick (3):
>       IB/hfi1: Restore EPROM read ability
>       IB/hfi1: Add ability to read platform config from the EPROM
>       IB/hfi1: Use EPROM platform configuration read

Thanks, series applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--lda888sxqJUGKgTSgEx8QWPM9ihQqKqsf--

--FAXnoSKaO6xMoF39eiEEiTfFQwaqmmwoi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8m83AAoJELgmozMOVy/dkd4P/2IwcTZyYUyK5aySpIae8ima
VV+FH5cLB5AjV1oYCbCZCU3g/Bzj1QfKtDtwXrypdpxxr6xaPT15FBUX+eWzJWp7
DBTEFZ2l2oEiB7qSxPQ2pEtLFikI28SJ7NDX+2f5LZ8f9xkaVIZoMQvKEC3VnJRs
BdLd5P4PITlde+nSZHHSWAqb+0r8OQrK74646+gHcXAHxA8mjSSwNMOab+vtsCc0
9Ksm0HbSMRV/MLbg2e8fO2xJiNfejVj5X0pa23yKBt8X42qzVnTTLv9PFv949nsD
AyAXUrBjHgOSnAwi7Z6g6qS5rExf8EZNBOj8BneEcyp3LHZ3koP+e2iQF6XRnOGe
IBUWkmIR2DeXOB48PtKa1HjGmqAC6CmiVy9rsiig1MOIDYrYcM/6+orwZK1T9xON
+HYbgloc77ZoJYe6Vdr54pJmPPDGOVcfiV3+ZNNkK4JUQfG4gOmqKfwj/MD4FrZ9
b7/Vo1uDtXS6iB8VEMN6XoKhl7IecqGlCEkYQNrVJY2Z+HcU/ZEvs3aJno67J/ng
3DgNkAs4EXEKgG2srRxANsOLeef+//bbTqZc7b8f9QcOZ5/47lVnnSt8aArN7Vyi
Rp3091lbzQsvUUKTPGuyaZkmJUVbCubMfA/7W88K5YcWpAw5UjlqLkratZWlbBl4
byxg4eet2dC9oBpI59Z0
=n8bo
-----END PGP SIGNATURE-----

--FAXnoSKaO6xMoF39eiEEiTfFQwaqmmwoi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
