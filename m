From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/15] IB/hfi1, rdmavt, core: Misc fixes and improvements
 for 4.7
Date: Thu, 12 May 2016 14:53:48 -0400
Message-ID: <fabf06ac-62b6-b4ab-6a0b-c22ac169c404@redhat.com>
References: <20160512172050.9741.84190.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vg9EfNjHRX07q83mvkRfhfHGnvUtWjVUA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160512172050.9741.84190.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vg9EfNjHRX07q83mvkRfhfHGnvUtWjVUA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/12/2016 01:22 PM, Dennis Dalessandro wrote:
> Here are some patches that address a few bugs and a couple other clean =
ups that
> did not make it in time for 4.6. There are also a couple performance re=
lated
> patches as well.
>=20
> There are more clean-ups on the way to address some of the feedback rec=
eived
> during reviews of other patches, however this stuff stands on its own s=
o
> separating it out into its own series.
>=20
> This patch series applies on Doug's k.o/for-4.7 branch.
>=20
> Patches can also be viewed in my repo at:
> https://github.com/ddalessa/kernel/tree/for-4.7
>=20
> ---
>=20
> Ashutosh Dixit (1):
>       IB/hfi1: Change hfi1_init loop to preserve error returns
>=20
> Dean Luick (2):
>       IB/hfi1: Remove no-op QSFP reset code
>       IB/hfi1: Immediately apply congestion setting MAD
>=20
> Easwar Hariharan (3):
>       IB/hfi1: Ignore non-temperature warnings on a downed link
>       IB/hfi1: Wait for QSFP modules to initialize
>       IB/hfi1: Correct external device configuration shift
>=20
> Jakub Pawlak (1):
>       IB/hfi1: Correct log message strings
>=20
> Jianxin Xiong (2):
>       IB/hfi1: Keep SC_USER as the last send context type
>       ib_pack.h: Add opcode definition for send with invalidate
>=20
> Jubin John (2):
>       IB/hfi1: Remove unnecessary header
>       IB/hfi1: Fix hfi_rcvhdr tracepoint
>=20
> Mike Marciniszyn (3):
>       IB/hfi1: Fix pio wait counter double increment
>       IB/hfi1: Fix potential panic with sdma drained mechanism
>       IB/rdmavt: Increase CQ callback thread priority
>=20
> Mitko Haralanov (1):
>       IB/hfi1: Improve performance of interval RB trees
>=20
>=20
>  drivers/infiniband/sw/rdmavt/cq.c    |    1=20
>  drivers/staging/rdma/hfi1/chip.c     |   32 ++++++++----
>  drivers/staging/rdma/hfi1/diag.c     |    2 -
>  drivers/staging/rdma/hfi1/driver.c   |    2 -
>  drivers/staging/rdma/hfi1/hfi.h      |    6 +-
>  drivers/staging/rdma/hfi1/init.c     |    6 +-
>  drivers/staging/rdma/hfi1/mad.c      |   93 ++++++++++++++++++++++----=
--------
>  drivers/staging/rdma/hfi1/mmu_rb.c   |   22 ++++----
>  drivers/staging/rdma/hfi1/pio.h      |    8 +--
>  drivers/staging/rdma/hfi1/platform.c |   21 +++++---
>  drivers/staging/rdma/hfi1/platform.h |    1=20
>  drivers/staging/rdma/hfi1/qp.c       |    1=20
>  drivers/staging/rdma/hfi1/sdma.c     |    2 -
>  drivers/staging/rdma/hfi1/sysfs.c    |    4 +
>  drivers/staging/rdma/hfi1/trace.h    |    2 -
>  drivers/staging/rdma/hfi1/verbs.c    |    2 -
>  include/rdma/ib_pack.h               |    5 ++
>  17 files changed, 128 insertions(+), 82 deletions(-)
>=20

These all look fine, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--vg9EfNjHRX07q83mvkRfhfHGnvUtWjVUA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNNE8AAoJELgmozMOVy/deV4QAMF0aActx0A1vG+BYrhvBuVY
ojjZq5aMLzZsAeaNlXnohNjGFWVb3jRZIA/Qs3V5Q8wuO+X2r6gDryZAgOkMwmeQ
dn+gJQwmQt913Ga/rBIJ/Ib/uuvzLrheYfL9V9pWxcoY7QOAlx4Zsimcqxcs/4i5
1uH7F07MSO0x5a4oYFbR3uskNv/+l+V+wngcT+dXLaKPE9KIKbUd0s/Yx5KCSFUP
AWOPFAcPLW5UyytdoShKdmPplKjF9iFCVvUszTlkk8P2D8I91UahDQaRRHCsvRjd
iroCqOZazV34/su554Z10fz8Bzs2fMLJuo8YYQ6OtkW5L5FEqbqgUsGrHGFp0P2x
8T+SDp0lG1xmTY6WgoEugvDFz5U2loL8JNztqwNXRtirrK2m1JAFhqMC0Ob4bScx
Sn14C25rt0MAttzEj6ZfZPZ1MWsl9d2rdapc+7R2/Ue6++lmowYm9e7nwnIdWc43
Wdb6QuDQGCDGgYOZ+9ZvQ712qTWBfI+nOvRyV6x1BECl/q4Q9FmaujMc5PjXTYVI
coDLcwdvZLCG8bQAiOFTW+r/G9JB4oxzWt/F3XKWQTnTUdnq9bPLTWN7PVvqra+F
ikIW4r7rVM08EDfYAFCr4kzjL25yMpOOVQuMaSwD4gBZ7/LjY3brIB166j6EjaFD
dOuYVmvkEPF3tCnE5FW9
=soY4
-----END PGP SIGNATURE-----

--vg9EfNjHRX07q83mvkRfhfHGnvUtWjVUA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
