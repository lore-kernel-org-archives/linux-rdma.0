From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] Add a .travis.yml file
Date: Thu, 29 Sep 2016 11:20:08 -0400
Message-ID: <57ED3128.4060509@redhat.com>
References: <1475105337-18002-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="sqiGx93ho8VKpG4o5RCj8IckVb6uDMoU0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475105337-18002-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sqiGx93ho8VKpG4o5RCj8IckVb6uDMoU0
Content-Type: multipart/mixed; boundary="RLviQKrA35FJkV8Gd1gANd4cLn20X1RuH";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <57ED3128.4060509-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] Add a .travis.yml file
References: <1475105337-18002-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <1475105337-18002-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--RLviQKrA35FJkV8Gd1gANd4cLn20X1RuH
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/28/16 7:28 PM, Jason Gunthorpe wrote:
> Necessary to use the Travis CI service.
>=20
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  .travis.yml | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>  create mode 100644 .travis.yml
>=20
> Now that travis is enabled on repo, we need a yml file to make it run.
>=20
> Here is a basic one.
>=20
> I don't test with distros as old as precise and I don't expect that gli=
bc to
> be new enough to build this (eg missing timerfd, O_CLOEXEC, etc), and t=
he
> cmake certainly isn't. So we use the trusty 'beta' environment and inst=
all
> gcc 6.2.
>=20
> See it in action:
>=20
> https://github.com/linux-rdma/rdma-core/pull/7

Merged, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>    GPG Key ID: 0E572FDD
  Red Hat, Inc.
  100 E. Davie St
  Raleigh, NC 27601 USA


--RLviQKrA35FJkV8Gd1gANd4cLn20X1RuH--

--sqiGx93ho8VKpG4o5RCj8IckVb6uDMoU0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJX7TEoAAoJELgmozMOVy/d2pwP/1nx+0lLhd4MIeytzKIz1W3L
HkEpbaDoqUE7BUGELzzuNOd5Nq5VmmpClQuCurMK70oK4FvdcvXfSDtvFOpCbnWF
LEW+2BKJOvQ8mszjZIrzxeXNOb0k3Vuo16DNXgNtB6JWDcB0n6oCQOenr2pjQPad
Wspx3zPi0IVrBHtHUfLaQC7nf6iDwjU+XXI7wBgE7Mq3KyVbJEswIk4PocB4jKvE
blcYZEfjQTP6JBZRDDuDsMZ4Mj3RiRqJ3YgoJB+t/v/YiZeMCMN0gK4grD2SI1gq
lg/R5O0hZZpGTaxzXASRZQdYVJqWQydc+CmtcD5YJEcK0jLLBOT1wIntMmln0I2o
SqxgV+kfDRAnGkYXVMDQUFU6N1Ob+WrSjOGVnOaGbnlATZxkiNl7dKGaUTyZ+sOo
r5GnG6bbyDVZpHERD5ztpmlx+T1DEPMbZ9UkvyGhzzQtNZqhTJ8EkryfHLxtxKeX
RDcJtpm/38ewbwGdL3MYc/5Yjsi1FfejrU6/lUeEOHxFVmhl1vhZXeNUdqSxT+Us
nomlyC+dFLXbVIG1eIXLGwMyMG7dTpEhCnZw8buWzuQ5KpNKzwYlXiUhNg4hY5Q8
XKjSCqX7Ek31voPwtzD/HhBN1XX+Zoxaij5oH+mwM+bqRauHSdSnpJH1Aj4Mtb7h
gKyAd7+z15U5AHX9tnRR
=FycU
-----END PGP SIGNATURE-----

--sqiGx93ho8VKpG4o5RCj8IckVb6uDMoU0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
