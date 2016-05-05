From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/21] IB/hfi1: First round of fixes for 4.7
Date: Thu, 5 May 2016 15:58:05 -0400
Message-ID: <912bc10b-3bed-c144-ec76-9f4d6b9882dc@redhat.com>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="V7275RlBVvxVCM118QWR8RhSs9uRs2pne"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412174746.24485.92280.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--V7275RlBVvxVCM118QWR8RhSs9uRs2pne
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 04/12/2016 01:49 PM, Dennis Dalessandro wrote:
> These patches do some clean ups and fix issues which may not be appropr=
iate for
> an RC so we are targeting these for 4.7. The current patch series appli=
es on top
> of the "Important bug fixes for 4.6 RC" patch set submitted just prior =
to this.
>=20
> Patches can be viewed in my GitHub repo at:
> https://github.com/ddalessa/kernel/tree/for-4.7.
>=20
> ---
>=20
> Dean Luick (13):
>       IB/hfi1: Fix sysfs file offset usage
>       IB/hfi1: Fix i2c resource reservation checks
>       IB/hfi1: Fix QOS num_vl bit width
>       IB/hfi1: Remove invalid QOS check
>       IB/hfi1: Fix QOS rule mappings
>       IB/hfi1: Correctly obtain the full service class
>       IB/hfi1: Simplify init_qpmap_table()
>       IB/hfi1: Guard against concurrent I2C access across all chains
>       IB/hfi1: Fix double QSFP resource acquire on cache refresh
>       IB/hfi1: Extract RSM map table init from QOS
>       IB/hfi1: Move QOS decision logic into its own function
>       IB/hfi1: Create a routine to set a receive side mapping rule
>       IB/hfi1: Add RSM rule for user FECN handling
>=20
> Easwar Hariharan (2):
>       IB/hfi1: Always turn on CDRs for low power QSFP modules
>       IB/hfi1: Remove module presence check outside pre-LNI checks
>=20
> Jianxin Xiong (1):
>       IB/hfi1: Reduce kernel context pio buffer allocation
>=20
> Jubin John (1):
>       IB/hfi1: Change default number of user contexts
>=20
> Mike Marciniszyn (2):
>       IB/hfi1: Remove unreachable code
>       IB/hfi1: Use global defines for upper bits in opcode
>=20
> Sebastian Sanchez (2):
>       IB/hfi1: Adjust default MTU to be 10KB
>       IB/hfi1: Check P_KEY for all sent packets from user mode
>=20
>=20
>  drivers/infiniband/sw/rdmavt/qp.c          |    6=20
>  drivers/staging/rdma/hfi1/affinity.c       |   93 +++--
>  drivers/staging/rdma/hfi1/affinity.h       |   19 +
>  drivers/staging/rdma/hfi1/chip.c           |  485 +++++++++++++++++++-=
--------
>  drivers/staging/rdma/hfi1/chip.h           |    1=20
>  drivers/staging/rdma/hfi1/chip_registers.h |    1=20
>  drivers/staging/rdma/hfi1/diag.c           |    3=20
>  drivers/staging/rdma/hfi1/driver.c         |    3=20
>  drivers/staging/rdma/hfi1/firmware.c       |    9 -
>  drivers/staging/rdma/hfi1/hfi.h            |   11 -
>  drivers/staging/rdma/hfi1/init.c           |    1=20
>  drivers/staging/rdma/hfi1/pio.c            |   52 ++-
>  drivers/staging/rdma/hfi1/pio.h            |    4=20
>  drivers/staging/rdma/hfi1/platform.c       |   99 +++---
>  drivers/staging/rdma/hfi1/qp.c             |    6=20
>  drivers/staging/rdma/hfi1/qsfp.c           |   58 ++-
>  drivers/staging/rdma/hfi1/qsfp.h           |   15 -
>  drivers/staging/rdma/hfi1/rc.c             |    2=20
>  drivers/staging/rdma/hfi1/sysfs.c          |    4=20
>  drivers/staging/rdma/hfi1/user_sdma.c      |    7=20
>  drivers/staging/rdma/hfi1/verbs.c          |  108 ++++--
>  drivers/staging/rdma/hfi1/verbs.h          |    3=20
>  22 files changed, 639 insertions(+), 351 deletions(-)
>=20

Series applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--V7275RlBVvxVCM118QWR8RhSs9uRs2pne
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXK6XNAAoJELgmozMOVy/dJuIQALincpdfAXkQta2lal5negw5
nOSUKBm13ORT/QJVN3JE5znRC/A/FDr/DlcHi0nmhXKFTEdn9iycItiWWADaUlpS
eU918+84yH13kVuejp0WlYdyc10An6nkpKknAoPMeI1G8GFSS4eQg/dWhTSGaGyh
fCRjcDPfCFRXcKo5kHT9i3FQjcXVzZkkR75FuN7RhgUM7mgeVux9mxCD6MW7RGUk
zo89dzfX6qR97wzEYsNgGwdI8JEYyK2IDgpaXaJBm97DV9IB94381/+9R6BapXir
xz4n4yYFC/X9DTs4B3ZK8vC+aEB95wEmjvFpfx29rz2a/zAW5w82fXnV1xscyx7b
FDf0MRx0i35fA0xYxa5O5JGzFpAcBQ3eAr3Zsj9rkY5QeCgY6MppLApeSvOQEo26
XyaBHMXY7kSVbqSnShrs2uxT+iPhcuEvfgKtliOPEO1h5sr4wjXd/MmNwMJ90xKF
BlDEIinsplE6BeE2vC+Waawyxx5kDeNpCx+Ti7Nj0cne9p1zSPbq6iNEAwqtRYk6
lkz2SagesdKEcE6/uJG5zpjr68gZ6BMhI0amujwSJ/sUV9Ksbfqmsy8iQz+SwZj8
psf7AjDZm6sqHnRUDnN/6lHL6Bxehhci/piPjJpISlzR1q29WC+fDU8CIkyUxUXq
YT4Z1Lxk7SQhh62N9bho
=PhRz
-----END PGP SIGNATURE-----

--V7275RlBVvxVCM118QWR8RhSs9uRs2pne--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
