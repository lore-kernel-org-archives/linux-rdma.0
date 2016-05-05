From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/11] More SRP patches for kernel v4.7
Date: Thu, 5 May 2016 16:44:30 -0400
Message-ID: <f406cd39-c6dc-d458-0ab0-c400fdd5b243@redhat.com>
References: <571A936F.7040409@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rrnQnT8mGgwGWDFtDqhr3kbt4vjB7mDIL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <571A936F.7040409-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rrnQnT8mGgwGWDFtDqhr3kbt4vjB7mDIL
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 04/22/2016 05:11 PM, Bart Van Assche wrote:
> Hello Doug,
>=20
> This patch series is what I came up with while retesting the SRP
> initiator. Please consider these patches for inclusion in kernel v4.7.
> Several of the patches in this series had already been posted in Octobe=
r
> 2015. See also http://thread.gmane.org/gmane.linux.drivers.rdma/30216.
>=20
> The individual patches in this series are:
>=20
> 0001-IB-srp-Fix-a-spelling-error-in-a-source-code-comment.patch
> 0002-IB-srp-Fix-a-comment.patch
> 0003-IB-srp-Document-srp_map_data-return-value.patch
> 0004-IB-srp-Fix-srp_map_data-error-paths.patch
> 0005-IB-srp-Introduce-target-mr_pool_size.patch
> 0006-IB-srp-Avoid-that-mapping-failure-triggers-an-infini.patch
> 0007-IB-srp-Move-code-out-of-a-loop.patch
> 0008-IB-srp-Move-common-code-into-the-caller.patch
> 0009-IB-srp-Fix-a-NULL-pointer-dereference.patch
> 0010-IB-srp-Do-not-register-memory-if-register_always-1.patch
> 0011-IB-srp-Prevent-mapping-failures.patch

Hi Bart,

I've pulled in the first 8 of these patches.  The last three all had
comments.  When you respin those, just spin those and not the first 8.

Thanks!

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--rrnQnT8mGgwGWDFtDqhr3kbt4vjB7mDIL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXK7CuAAoJELgmozMOVy/dsesP/irYbbTgQbfgIoe2m5TGGSze
QjA9zGthvmtKvqKWiyUXE41KTxiEYp4/b2HVMjhFIwuJgt8sFPTiFHYZJxVZiNyX
fnd46LG7ayH9VcYKQM/NhNzuzOJENyPP8yOla/EWd2N8T8sHJB2b3INRjqpNyZiI
Nzv3rAEwOlLfz/RcNJj9rNW77+gJHWaXdfSvrhH8T5s09rs+RjOwPmM0W/4F2sDb
muP4bJeUop9y4H0osnRhIVMdFzAjgUhA06vCV8bWLlD6+ThFrXJ88X26zHglIOpO
yRtVUPaQRVYe7nyPkP0Pp6lEc1lkWO5aileeZ1BMeip8R/IYmqOVTjNKqGgJGKD3
zOYJNAmQW/MqI8ysDQiS2NK3O09jXVMAwN1QYaLepem1U5g0h0DWfoDKR+PBaBtR
W/FGnMghWLgpH/YVJltU1uEaz5p9o/FmC8Su3/kcsVHFKUhKWAY8aftbzFYG8ZGu
KYEHT61Rv0B+QRGi8Y5Fw8DXt0L/uLMue2p9q5QTHoRBMWd9HQGuQTgrpNLsnf0q
2EuW5clpVbXDgNHRFb2Y96olIzKp/AyfYWH1C9ZuGCM/dAdoIupyNYPTvo7do1TH
Gl4JE4JWChiz7QV/aBr0iVnR2ZJXvkUmwxWT7lyGwKCyXVnihCq7Xb4io5/s6Bzo
fzKlTVs4JugUFeYZ/7Eh
=gjwe
-----END PGP SIGNATURE-----

--rrnQnT8mGgwGWDFtDqhr3kbt4vjB7mDIL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
