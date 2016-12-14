From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] infiniband: hw: ocrdma: fix bad initialization
Date: Wed, 14 Dec 2016 14:34:34 -0500
Message-ID: <b08b4a1e-f976-c4b6-4241-65cf398ec3cb@redhat.com>
References: <1480770621-6249-1-git-send-email-bianpan201602@163.com>
 <20161204062037.GH4497@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fpdwiXncBGUV3nS2V6TnKgAxdBj5wxAGx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161204062037.GH4497-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pan Bian <bianpan201602-9Onoh4P/yGk@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fpdwiXncBGUV3nS2V6TnKgAxdBj5wxAGx
Content-Type: multipart/mixed; boundary="6sMSVbSTwLX6tPBOlLLc4D8gfbKo9OcT6";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pan Bian <bianpan201602-9Onoh4P/yGk@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>,
 Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>,
 Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Sean Hefty
 <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
Message-ID: <b08b4a1e-f976-c4b6-4241-65cf398ec3cb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] infiniband: hw: ocrdma: fix bad initialization
References: <1480770621-6249-1-git-send-email-bianpan201602-9Onoh4P/yGk@public.gmane.org>
 <20161204062037.GH4497-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20161204062037.GH4497-2ukJVAZIZ/Y@public.gmane.org>

--6sMSVbSTwLX6tPBOlLLc4D8gfbKo9OcT6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/4/2016 1:20 AM, Leon Romanovsky wrote:
> On Sat, Dec 03, 2016 at 09:10:21PM +0800, Pan Bian wrote:
>> From: Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
>>
>> In function ocrdma_mbx_create_ah_tbl(), returns the value of status on=

>> errors. However, because status is initialized with 0, 0 will be
>> returned even if on error paths. This patch initialize status with
>> "-ENOMEM".
>>
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D188831
>>
>> Signed-off-by: Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
>=20
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--6sMSVbSTwLX6tPBOlLLc4D8gfbKo9OcT6--

--fpdwiXncBGUV3nS2V6TnKgAxdBj5wxAGx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUZ7KAAoJELgmozMOVy/dWQMP/3crw2PXepoJPDD6Wz48BdFz
2e+6v01f3Ct/nDnnjspT9edZXhLxQr3VkDci5VQqdaY+dFudwooY6CIhYBSWGWQA
ba2Koc/HOgYHdlmTL3KLW7GkFM2FVhhVJ2H4iIus4VFknyNqgnC5oHXIIeouY+PN
8o/Mu4GuHqdBWiQgofCCURqh/udbqQV2xdP8iN/hOJqFXPSXsduu6EbAX/fjYpig
K9GMQrB70ACLb7pGmPDclxBRgd6ZVSOJVN77wsuf7h2B8w7mMx8su6F3Yxjm2TZc
OJ4mYx6bJ6DJzJ3tm+6yzfVFM8Aa3grjdSG6GHwZLQB58Gg0Whi/6Zn0EFX0kH//
uyyvwF76785VzLr0OJwxOKOODUpBUwdDW6kY6y/L5DFWtYoZP+AzuWQbeNhNofPW
cH74FlaahaxtYYbvra6TKZavoYI6oMxLVMeGDUCKHkaymnrE57MK4Xb7KWXEo8Zd
hozxUc76RKnWtOPnbWD+KWpVzVFWOobrsw0lz4lOv1ppohN00R5CwWPM2JoLSS4V
bC8j66CJGfOvnTUYcDdVoJAa/jhJNOQtjQoNpXTMFdzJGOtvMOuVoZ/kxy4BKd+Z
HwtbD4rs35FzL81IlhKy7Xz6BMWiLAdf6KWu+9WXoIxieBbwe4+aUCWdJepn9prq
ypDXz2Juamj9TeG2fYXf
=eZ0W
-----END PGP SIGNATURE-----

--fpdwiXncBGUV3nS2V6TnKgAxdBj5wxAGx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
