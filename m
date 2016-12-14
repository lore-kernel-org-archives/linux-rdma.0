From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, RESEND] IB/srpt: Report login failures only once
Date: Wed, 14 Dec 2016 12:59:08 -0500
Message-ID: <4f4fa32b-1a47-9ac1-c330-c1f056a1063d@redhat.com>
References: <7737d8fc-d41d-0755-d7d2-a3a2b9b6a76e@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1bCFttS26clrfBDnwA7WC03IaQw6EKl3j"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7737d8fc-d41d-0755-d7d2-a3a2b9b6a76e-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1bCFttS26clrfBDnwA7WC03IaQw6EKl3j
Content-Type: multipart/mixed; boundary="WBXXMwX6BpDgOCdUKq9Q6Rnm3VQGONw2h";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <4f4fa32b-1a47-9ac1-c330-c1f056a1063d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, RESEND] IB/srpt: Report login failures only once
References: <7737d8fc-d41d-0755-d7d2-a3a2b9b6a76e-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <7737d8fc-d41d-0755-d7d2-a3a2b9b6a76e-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

--WBXXMwX6BpDgOCdUKq9Q6Rnm3VQGONw2h
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 11/11/2016 7:36 PM, Bart Van Assche wrote:
> Report the following message only once if no ACL has been configured
> yet for an initiator port:
>=20
> "Rejected login because no ACL has been configured yet for initiator %s=
=2E\n"
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Sagi Grimberg <sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--WBXXMwX6BpDgOCdUKq9Q6Rnm3VQGONw2h--

--1bCFttS26clrfBDnwA7WC03IaQw6EKl3j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUYhsAAoJELgmozMOVy/dwBsP/R9cRcspAIeHsORAI+1EflXN
iwfIHQjLEuzDT4bkB5NDlmLb9L+V00mjARaGKopkXJwmRM60pReWYBurx2ZaH6WB
8IBNikX20DLsa5dSX5H1JWd6D8oN0kve4qlPRqRGQcvqp0zSJKrUmtgMrIpExK2m
o+2KT161Pw/QwFu+oLUwoDnYO44WwYNVPXP9Lmp2QWZFKXAMNPWDyH7OT044lsR1
+ViDCtxR3/Kpg5oiUBW5xRLhGSGDXjOjhhAwOkSKhMZnW+v+X09YSgLXzv2iyMiw
Di7w9F+7v8GfF/inAV8ddQp8VTEGxoE/JX9plN1ZAOcJL8xacpac7HJCSxQmtRwS
Gea2w6ziXLqCL4bkpS4Vyo8EesMGdk+kJzFOA/OhzjZ+Pd2cXUJcsimgvkFp+EPJ
OQHsS0qCc+sQnsTQbP7xkgMSJ3BQkn8qm6Q3eKI3tUG0yAeqXXUsI4jhl/Ws2iXj
S3j4ZWbmyawbLEAd9Q8ewTmeso2/sTo5iEEyFfPMcy4vnqUUqLb3ePCKv49x8/vu
XrPJQ8sfvSy6jLn8Ancr11jiKwxbRg+XU2RETo5+OrAL7t28ITJOGOZGVgoo3Mj/
Sy7rMtA7kVHXwYRHQCfdsUueCstc4tb1rwmpzFgTZ3WnT9tJX4Z87a9zfn7YoQjt
67uzszijiVR/Y5cZy7im
=N+mJ
-----END PGP SIGNATURE-----

--1bCFttS26clrfBDnwA7WC03IaQw6EKl3j--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
