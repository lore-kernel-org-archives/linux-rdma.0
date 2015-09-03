From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Add CSRs for CONFIG_SDMA_VERBOSITY
Date: Thu, 3 Sep 2015 15:29:05 -0400
Message-ID: <55E89F81.7000904@redhat.com>
References: <20150902144324.29183.67166.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Isgnau9hW3ACC1Cx0Ie3nvCILWc7HOlmx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150902144324.29183.67166.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Isgnau9hW3ACC1Cx0Ie3nvCILWc7HOlmx
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09/02/2015 10:43 AM, Mike Marciniszyn wrote:
> From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> 3 CSRs needed by the CONFIG_SDMA_VERBOSITY code were removed during
> the CSR clean up. Adding these CSRs back to resolve 0-day build failure=
:
> https://lists.01.org/pipermail/kbuild-all/2015-August/011919.html
>=20
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks, applied.

> ---
>  drivers/staging/rdma/hfi1/chip_registers.h |    3 +++
>  drivers/staging/rdma/hfi1/sdma.c           |    4 ++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/staging/rdma/hfi1/chip_registers.h b/drivers/stagi=
ng/rdma/hfi1/chip_registers.h
> index 6521030..bf45de2 100644
> --- a/drivers/staging/rdma/hfi1/chip_registers.h
> +++ b/drivers/staging/rdma/hfi1/chip_registers.h
> @@ -1285,5 +1285,8 @@
>  #define PCIE_CFG_REG_PL106_GEN3_EQ_PSET_REQ_VEC_SHIFT 8
>  #define PCIE_CFG_REG_PL106_GEN3_EQ_EVAL2MS_DISABLE_SMASK 0x20ull
>  #define PCIE_CFG_REG_PL106_GEN3_EQ_PHASE23_EXIT_MODE_SMASK 0x10ull
> +#define CCE_INT_BLOCKED (CCE + 0x000000110C00)
> +#define SEND_DMA_IDLE_CNT (TXE + 0x000000200040)
> +#define SEND_DMA_DESC_FETCHED_CNT (TXE + 0x000000200058)
> =20
>  #endif          /* DEF_CHIP_REG */
> diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hf=
i1/sdma.c
> index 37bd767..a8c903c 100644
> --- a/drivers/staging/rdma/hfi1/sdma.c
> +++ b/drivers/staging/rdma/hfi1/sdma.c
> @@ -1769,7 +1769,7 @@ void sdma_dumpstate(struct sdma_engine *sde)
>  	sdma_dumpstate_helper(SD(ENG_ERR_MASK));
> =20
>  	for (i =3D 0; i < CCE_NUM_INT_CSRS; ++i) {
> -		sdma_dumpstate_helper2(CCE_INT_STATUS));
> +		sdma_dumpstate_helper2(CCE_INT_STATUS);
>  		sdma_dumpstate_helper2(CCE_INT_MASK);
>  		sdma_dumpstate_helper2(CCE_INT_BLOCKED);
>  	}
> @@ -1777,7 +1777,7 @@ void sdma_dumpstate(struct sdma_engine *sde)
>  	sdma_dumpstate_helper(SD(TAIL));
>  	sdma_dumpstate_helper(SD(HEAD));
>  	sdma_dumpstate_helper(SD(PRIORITY_THLD));
> -	sdma_dumpstate_helper(SD(IDLE_CNT);
> +	sdma_dumpstate_helper(SD(IDLE_CNT));
>  	sdma_dumpstate_helper(SD(RELOAD_CNT));
>  	sdma_dumpstate_helper(SD(DESC_CNT));
>  	sdma_dumpstate_helper(SD(DESC_FETCHED_CNT));
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Isgnau9hW3ACC1Cx0Ie3nvCILWc7HOlmx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6J+BAAoJELgmozMOVy/d7RMQAMRUXIoc5/ur3Q2XknmDPpFh
BaWbfdTMNafKa57D1/GymoGOp3ZbH6JCnCEd1bg0ciDxUIJ6AaVn2PaF78q0HUrV
iPjYtxxzT7+p1p2AINPYp+5C999L/R2wlf8SoNd2mN3+ymLT/i6OmT1YWgA44ad+
BKEyS7Z9ha3HKwpKilzmSz9JEzeBl9RJBEbPy2Tj8r3eEuuajxQdYdmx0kLKs9Uq
245bmyKGp50P2T1puo5Q7IZ22Xbv3exyIs6HKSekA4N21YR52wHirkewccQSeZZX
iJyPN05Oqf7vIlV7/pi/+Iubxytf/9fbeEhnWG4oHunF4k7KqspSTGaADtsOVTyU
+t7NT2RTHhufYDUQNA9XOuwcKxHuTxFW+kH9JeRTqkjLV3tHJ9DxnXz4+TeYMAU4
G2T67eMKcxgFXNAJMHM68Xccx4DCPXvUVxJBYWtELNtugjsKXS3TGYddcbLo4T3D
S1mcozGpey0e7EaGAG7DtBPUMt7ZnLgwXiTeEizCBkCJUmxmxGNWoyu/9dsSxLNf
Zj1CkPDx2fOk1b0fcdAYk8UxqzTWfpBBzWEIOYP9XSJHVsn9N24RbiBqsTlUFxGH
dYZILL+owfqUGey8/isaFfkdXIk3YLJ81O2NWN+Zzqo4Bu9++zo9kF7kVzLYgqC7
F6UugAMSIvVVZ7F39Ke1
=yc8B
-----END PGP SIGNATURE-----

--Isgnau9hW3ACC1Cx0Ie3nvCILWc7HOlmx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
