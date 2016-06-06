From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] Various fixes for warnings reported by static source
 code analysis tools
Date: Mon, 6 Jun 2016 19:38:04 -0400
Message-ID: <bd7a66a5-48a2-3ae8-c464-3aea91ae0810@redhat.com>
References: <86c06ca1-753c-6b45-3f65-f9a19f7693cf@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vdFTqndcw71d85EeC4NUxqnEavmjM8jWh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <86c06ca1-753c-6b45-3f65-f9a19f7693cf-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vdFTqndcw71d85EeC4NUxqnEavmjM8jWh
Content-Type: multipart/mixed; boundary="tihkExaqjeH1E2v95w0UxWosUa9Wo7rnC"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <bd7a66a5-48a2-3ae8-c464-3aea91ae0810-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] Various fixes for warnings reported by static source
 code analysis tools
References: <86c06ca1-753c-6b45-3f65-f9a19f7693cf-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <86c06ca1-753c-6b45-3f65-f9a19f7693cf-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

--tihkExaqjeH1E2v95w0UxWosUa9Wo7rnC
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 6/3/2016 3:07 PM, Bart Van Assche wrote:
> Hello Doug,
>=20
> The following patches are what I came up with after having analyzed the=

> output of sparse and smatch for Linux RDMA kernel code:
>=20
> 0001-RDMA-core-Fix-indentation.patch
> 0002-IB-mad-Fix-indentation.patch
> 0003-IB-rdmavt-Annotate-rvt_reset_qp.patch
> 0004-IB-hfi1-Fix-indentation.patch
> 0005-IB-hfi1-Use-bit-0-instead-of-bit-1.patch
> 0006-IB-hfi1-Suppress-sparse-warnings.patch
>=20
> Bart.


Thanks Bart.  Modulo the hfi1 indent fix that was already partially
done, series applied.


--tihkExaqjeH1E2v95w0UxWosUa9Wo7rnC--

--vdFTqndcw71d85EeC4NUxqnEavmjM8jWh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVglcAAoJELgmozMOVy/dwA0P/3OQHwQiS5s1ZDLVzk8E2vUT
9IiaqSz4fXMeV5SE3g4NVRMgtbf1kJj98RABD7wB152HR+Kp5keQYBneLQl4It2y
9Tsk7+uxGenkTvPc6Lo/OoOM2PWeJZ9QAUT8U5HcZAUG9fDKSUW5eBp2C+VgQ1Mq
rDkg1D5MqbXoF96JHWfuUqFwXEylm7IZZpws+dUPm26aMkxOzSZR6OXhvddZ5P12
6Upi45r4KmYljccRwQvvJhvPDtsyeuYcy9d+7O0KBi8JuEleFXXzaExb98wuin+S
riQGSnLS1aYjCooDdUJPVbg+Qby8IAq/misewDSHCYUqUcS8tS6pMaHHfJzjafDh
YCCJZtzVqu0RNlap7aUqYXN9nHiURXD8algyBcW9DvvntlGbJMgERmkNtwS1wKr0
h1NHd8rJ0GLkUjWru5VkFeJo6EFSSaOPsCK2quAqBiRO6UwessO9QO47yQw9uwcm
WuV+0BnbTciOtjYE3z0iBAoIoE4S8EGN+X+WgV7iqAzAVdsEEIQMIQajNU4MWYpY
o8u50ARMLG18Wu8+jjFRCBwCauhoyOUKRQ46fvSddA/qqYwXZA50TE1yT1a3NMHB
ohEo/eoDWrSlC5QSOSVfjRXCl1f3xrlqaSNFh7x77Jet1kaMx7KUj3LbWZwo2uiW
dRMziCuMKK76h2okGTqD
=CPpF
-----END PGP SIGNATURE-----

--vdFTqndcw71d85EeC4NUxqnEavmjM8jWh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
