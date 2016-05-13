From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] staging/rdma/hfi1: use RCU_INIT_POINTER() when NULLing.
Date: Fri, 13 May 2016 15:38:34 -0400
Message-ID: <d039b5f5-4b5e-f916-97d5-3d4f186aeb3c@redhat.com>
References: <1462106131-9073-1-git-send-email-falakreyaz@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="n50pDvBTok0edQS55ULb7tsLbxSQRgPLt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462106131-9073-1-git-send-email-falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Muhammad Falak R Wani <falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--n50pDvBTok0edQS55ULb7tsLbxSQRgPLt
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/01/2016 08:35 AM, Muhammad Falak R Wani wrote:
> It is safe to use RCU_INIT_POINTER() to NULL a pointer, instead of
> rcu_assign_pointer().
> This results in slightly smaller/faster code.
>=20
> Signed-off-by: Muhammad Falak R Wani <falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/staging/rdma/hfi1/init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hf=
i1/init.c
> index cfcdc16..34e0f90 100644
> --- a/drivers/staging/rdma/hfi1/init.c
> +++ b/drivers/staging/rdma/hfi1/init.c
> @@ -1303,7 +1303,7 @@ static void cleanup_device_data(struct hfi1_devda=
ta *dd)
> =20
>  		spin_lock(&ppd->cc_state_lock);
>  		cc_state =3D get_cc_state(ppd);
> -		rcu_assign_pointer(ppd->cc_state, NULL);
> +		RCU_INIT_POINTER(ppd->cc_state, NULL);
>  		spin_unlock(&ppd->cc_state_lock);
> =20
>  		if (cc_state)
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--n50pDvBTok0edQS55ULb7tsLbxSQRgPLt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNi06AAoJELgmozMOVy/dLtIP/RHP/Z0c+Ja7rmW4+t9f/6K5
C0Xyf+NJX40YK6I99al0Z/j+kf8WziwMUp6dChtSPmXoaeRHbbKAyOtvyBCRIO0O
BXWltFb2RLIipZB+6FA2IrBXiybWPXuy3KZmtl+xX9poi9+LkMmyhguMICxiSATN
1nB+lfSb3GorA6yHhYbOvONnNkD2T5yEgetLLwgStj9Pg++Yuh65do6Gs843LMTB
ANxmDf36bCM7jSEL64C7nfYIf1m18TQAI80MmTY9bA/+Pp3PnT/R4eboaV/OwHx8
xQKArcmvWkFkYpvZFH36WYAwV9n6O+5Th17ruOKT1RA9JTxK7UDuipuFUlgE7X5l
UFzeBODcI8uWMdw/zc8E2aMJmtrwD8g+mMUqmACVMhVCW5Bhm7aZxcMHeguC8wjB
K9ayofaS75JWVne375Srf4g8OVbAOPlipJcsuz4barH70FGLuhyR/FBm1P22bBhm
UEbn9JF6k9Wu9aw8+m2EaAlhUJ1IscxY4LmJLrWzB45X0qbNEtRxXJC2dkOa8zCL
NvzVZhSIu/hOdUOEaZ0QVmiyC3cAFLkCVe/p3HsLAlv7ndDlx+ZwW94v62muODCX
aQQiyZQ/tnJcdWifUAbcg2xkjfJH5swV24W0iQpgrr2aPClpuAS8ZZBiO6cfD1QA
RcCfj6UOr19EiVn/ifg+
=jaIJ
-----END PGP SIGNATURE-----

--n50pDvBTok0edQS55ULb7tsLbxSQRgPLt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
