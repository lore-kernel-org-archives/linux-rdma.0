From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/1] infiniband: hw: cxgb4: set errno on failure
Date: Wed, 14 Dec 2016 14:39:53 -0500
Message-ID: <a14c799c-3b1a-60bf-b34b-e7fa502717b5@redhat.com>
References: <1480770275-6155-1-git-send-email-bianpan201602@163.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kx40jLMrNL5GkmOuwvMn9Lq3x3kOFjaEm"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480770275-6155-1-git-send-email-bianpan201602@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pan Bian <bianpan201602@163.com>, Steve Wise <swise@chelsio.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kx40jLMrNL5GkmOuwvMn9Lq3x3kOFjaEm
Content-Type: multipart/mixed; boundary="8vhA9TtgDLuCelGu8PbJMfRMdoaEo4PO7";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Pan Bian <bianpan201602@163.com>, Steve Wise <swise@chelsio.com>,
 Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock
 <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Message-ID: <a14c799c-3b1a-60bf-b34b-e7fa502717b5@redhat.com>
Subject: Re: [PATCH 1/1] infiniband: hw: cxgb4: set errno on failure
References: <1480770275-6155-1-git-send-email-bianpan201602@163.com>
In-Reply-To: <1480770275-6155-1-git-send-email-bianpan201602@163.com>

--8vhA9TtgDLuCelGu8PbJMfRMdoaEo4PO7
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/3/2016 8:04 AM, Pan Bian wrote:
> From: Pan Bian <bianpan2016@163.com>
>=20
> In function c4iw_rdev_open(), the value of return variable err should b=
e
> negative on errors. However, when the call to __get_free_page() returns=

> a NULL pointer, its value is not set to "-ENOMEM" and keeps 0. 0 means
> no error. And thus, the behavior of its caller may be misled. This patc=
h
> fixes the bug.
>=20
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D188821
>=20
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  drivers/infiniband/hw/cxgb4/device.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/=
hw/cxgb4/device.c
> index 93e3d27..b99dc9e 100644
> --- a/drivers/infiniband/hw/cxgb4/device.c
> +++ b/drivers/infiniband/hw/cxgb4/device.c
> @@ -828,8 +828,10 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
>  	}
>  	rdev->status_page =3D (struct t4_dev_status_page *)
>  			    __get_free_page(GFP_KERNEL);
> -	if (!rdev->status_page)
> +	if (!rdev->status_page) {
> +		err =3D -ENOMEM;
>  		goto destroy_ocqp_pool;
> +	}
>  	rdev->status_page->qp_start =3D rdev->lldi.vr->qp.start;
>  	rdev->status_page->qp_size =3D rdev->lldi.vr->qp.size;
>  	rdev->status_page->cq_start =3D rdev->lldi.vr->cq.start;
>=20

This fix was previously submitted by Wei Yongjun.

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--8vhA9TtgDLuCelGu8PbJMfRMdoaEo4PO7--

--kx40jLMrNL5GkmOuwvMn9Lq3x3kOFjaEm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUaAJAAoJELgmozMOVy/ddHYQALbuseCgFekudSCLu7cltHDl
r5j3ARXnjwtj4Ycg/cmhtRXGc/bpCpLXJQB3z50F9DHfOcJB/skpo7XWulMvJ+pX
7xya0gaYLoleMGhLc2aD6oFtnU55ooHJB7LdaIpcq3MpXZjAaIPcHXKvlWPDD/2A
tOE5VBeAyD3oADsBQhU/iTdclCniWHziORt9Ikz8Ln4jzeFnAxtqczwYI5dvZr1u
PbutbYbQXNUpjE6m3cXOKZmBZjLPOZRC0GXPO5znP4MAouUrHlX3HalWnrT2AQAS
C58KvwGN27GGxHR7S/09PjFI9TYRWpVdu0o8bfxUOvmIrmrXT282RBVgeD6MJfBu
m+To8OV1am45D+6xOWTkpVwOw04b55Hfr8FJwoUIGZCBAG21wDyzFU8SbemoAacY
1NvkZPSxclJBqGnwo6Q3RBwnAfc9J3WkG+MGd/YLrtss7rSCrm29LaFxLLgJnHaJ
wkghNpvvj9fzpFW1JYHQ6INI2Df7XwvGAf9B2hH3NfTPWpNSyNL5pM5KKK2YoN5P
WKu5PM8vgZeJR2IuafLlxuRBDZhrCX1ygZYXc6suN9hT4S7n1dh2QYHoMzDBb5eK
FAd6/OX4T9ax3r3XTWQGEuvyTCVythQ+SXZOfRQ4neptDccb1olJfoYp5S65FzJb
APWj/kFVxB4mCOpUxBjo
=Fu6x
-----END PGP SIGNATURE-----

--kx40jLMrNL5GkmOuwvMn9Lq3x3kOFjaEm--
