From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Remove macros I40IW_STAG_KEY_FROM_STAG and
 I40IW_STAG_INDEX_FROM_STAG
Date: Mon, 12 Dec 2016 17:15:45 -0500
Message-ID: <c1069145-b171-b595-c4ff-c5b13df50077@redhat.com>
References: <1475668538-12914-1-git-send-email-thuth@redhat.com>
 <20161005125711.GG9282@leon.nu> <20161006200220.GB14272@flatif-MOBL1>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gMnrascsrjjVBF8HuFcqeKxNs4amwW0Au"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161006200220.GB14272@flatif-MOBL1>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gMnrascsrjjVBF8HuFcqeKxNs4amwW0Au
Content-Type: multipart/mixed; boundary="mT4CI28wxCJfbuIuPmXUt1nchrXrEwXnl";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Message-ID: <c1069145-b171-b595-c4ff-c5b13df50077-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Remove macros I40IW_STAG_KEY_FROM_STAG and
 I40IW_STAG_INDEX_FROM_STAG
References: <1475668538-12914-1-git-send-email-thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161005125711.GG9282-2ukJVAZIZ/Y@public.gmane.org> <20161006200220.GB14272@flatif-MOBL1>
In-Reply-To: <20161006200220.GB14272@flatif-MOBL1>

--mT4CI28wxCJfbuIuPmXUt1nchrXrEwXnl
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/6/2016 4:02 PM, Faisal Latif wrote:
> On Wed, Oct 05, 2016 at 03:57:11PM +0300, Leon Romanovsky wrote:
>> On Wed, Oct 05, 2016 at 01:55:38PM +0200, Thomas Huth wrote:
>>> The macros I40IW_STAG_KEY_FROM_STAG and I40IW_STAG_INDEX_FROM_STAG ar=
e
>>> apparently bad - they are using the logical "&&" operation which
>>> does not make sense here. It should have been a bitwise "&" instead.
>>> Since the macros seem to be completely unused, let's simply remove
>>> them so that nobody accidentially uses them in the future. And while
>>> we're at it, also remove the unused macro I40IW_CREATE_STAG.
>>>
>>> Signed-off-by: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>> Thanks,
>> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Thanks
> Acked-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
>=20

Applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--mT4CI28wxCJfbuIuPmXUt1nchrXrEwXnl--

--gMnrascsrjjVBF8HuFcqeKxNs4amwW0Au
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYTyGRAAoJELgmozMOVy/dD54QAKtNAc5oXOhVbQtLkEiF1LQh
ybQpRNtqoYZZ4xfMHSPaMsb9qzpSQDHSm0hJiuHwXExc3oLkFUq40GIg3jSRrFe9
a+JTJNbjVPLT+ByXLNv3bSV8oR3vSbMmR9O0dyHQHrx2mHESYXBtRIa34hnSfv5h
gZFutT+XSYyJpuznHsFnWRbwKCfjbe8g2qRb13tFu7/aU4YZCnt/W9RDAbXWqhHU
XWR4vBYP8rCEG8bre6vDA2Apfox3k//PakQ1c/0fZC/xhJeluykm2DKj/TO55YXW
+QVQ+bzHXzyY/Bz5NeUmYqmCPxkeVhIvD5wkoa2jsRNjma3Mf0s7qNodZt+ANlZa
UGKkw/htD0p9SpZe5Dq26JyWLrHU/00idTyXexaFfph2a/Akiu3mIHcFlMaGuRVd
feYrC3YLms40buZEysh3uXCRFAlXIXeoCP04eO3zmyO87YnYGN6e2FDa5zX2ywYF
iAoTXOxoI6G5cD49j+ioW7++Blzo03gApi+yKonor9ewcGjcawjd6VPjeWNNs+As
SWGqO7EexwntJ36GUzAjD1Gw8mPPtIUdcaDb92NcyAsODOUILt74KuqAXDnwC7AZ
JHAkKQ5ZSFo86TsF1hqcER4H1YFsLsrSgQ/NU+AN06jI3OOieViBFik3Ifey0Pdl
IZoK6nQG3bjXPzEbKn8m
=MXoG
-----END PGP SIGNATURE-----

--gMnrascsrjjVBF8HuFcqeKxNs4amwW0Au--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
