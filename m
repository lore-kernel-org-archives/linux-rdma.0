From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/2] Add port counter support for raw packet QP
Date: Sat, 1 Oct 2016 19:35:21 -0400
Message-ID: <48636958-cb8c-d246-a3e3-6b034e583d08@redhat.com>
References: <1472376353-632-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NVNXgk7p6xOtiWx442EjBbqniQk8aKekN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472376353-632-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NVNXgk7p6xOtiWx442EjBbqniQk8aKekN
Content-Type: multipart/mixed; boundary="UoK0KXWABpR8lmhLpOeqk9VQ1P4bfSSkw";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <48636958-cb8c-d246-a3e3-6b034e583d08-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/2] Add port counter support for raw packet QP
References: <1472376353-632-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1472376353-632-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--UoK0KXWABpR8lmhLpOeqk9VQ1P4bfSSkw
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/28/2016 5:25 AM, Leon Romanovsky wrote:
> RDMA Counters weren't updated due to raw packet QPs' traffic since
> the port counter-id was not associated with the QP. FW support is
> required for this feature, without this support raw packet QP
> counters will not count. A minor re-factor to the modify raw packet
> QP function was needed to pass the  q-counter-id to modify RQ command
> function.
>=20
> Available in the "topic/raw_qp_ctr_supp" topic branch of this git repo:=

> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>=20
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtopic/raw_qp_ctr_supp

Series applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--UoK0KXWABpR8lmhLpOeqk9VQ1P4bfSSkw--

--NVNXgk7p6xOtiWx442EjBbqniQk8aKekN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8Eg5AAoJELgmozMOVy/dS5IP/A0hNmjxxvPHwZ4YYpi7EwYW
Uqunw5INYUG5Yer0N3fMJccoypIDWPAil9PgI7gCmjgYNqj0IRFJUosEwtp9r3pe
MeoGRi4Ha28RZl/0jSbVoH/1+SWeDAoJ0UjeAOCEEGLW363MnflmyFQ49TzONwOx
cgytSXWlvsoU74UHbD6Lkq6C/xG3gCxhs+/R7nVea5xNjYyD8mIbOW9dYY5umWiH
ldLVXXTdnOrqHHArjybRnvfuuTis8c0QHSjUoY1joSw/9scs4+kwpQ+dY+D2sAbm
2vpwEMjca2fqhabiLr19gci/Qqrp58ewd0Mm9h+spHlyIUmdq2DNAFTo7MQtdy/F
wdpUVXZKG7FKZO94FDO2/JQFdt9QuiSCFlkTXmkgJ/jrceLlwXyXX+mMK2IIkmZB
E5oAQIninZ2LK85+v6daJjyG34iOFHQXhsAZJD+kIpqWZvCYKzAZERhnHZffzKSd
+b1m9eD//Cps4SFX7vovLUE6spzFyvlMAoJG2Fecr7tvWJQXiy6jEkenr7PGuKKs
cXMQSKarcHu1TeYy9V5r/dLygxiJU2BS3+RTwoqIOmsuXViw6PNPYc1IX02hf/Gi
JU9b8G+wbC7K/cxcMb612f6wSfkK3S9ouTl8dTiDu5o7eIOWwkkyl+xgiMFHmWeF
VIIJuefgTrqdh3AWrBlY
=/yLw
-----END PGP SIGNATURE-----

--NVNXgk7p6xOtiWx442EjBbqniQk8aKekN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
