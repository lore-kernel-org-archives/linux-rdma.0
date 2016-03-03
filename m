From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RESEND v3 5/6] staging/rdma/hfi1: adding per SDMA engine
 stats to hfistats
Date: Thu, 3 Mar 2016 10:50:41 -0500
Message-ID: <56D85D51.40800@redhat.com>
References: <1452555057-5155-1-git-send-email-jubin.john@intel.com>
 <1452555057-5155-6-git-send-email-jubin.john@intel.com>
 <56D5B567.4040706@redhat.com> <20160301202736.GA8501@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rFHNWcPbFqrl6K6Q1lwa9ANCCKjqkMkLQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160301202736.GA8501-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rFHNWcPbFqrl6K6Q1lwa9ANCCKjqkMkLQ
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/01/2016 03:27 PM, Jubin John wrote:
>>> diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/=
hfi1/sdma.c
>>> index 1d38be5..cb66bd0 100644
>>> --- a/drivers/staging/rdma/hfi1/sdma.c
>>> +++ b/drivers/staging/rdma/hfi1/sdma.c
>>> @@ -1061,7 +1061,6 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)=

>>>  		sde->desc_avail =3D sdma_descq_freecnt(sde);
>>>  		sde->sdma_shift =3D ilog2(descq_cnt);
>>>  		sde->sdma_mask =3D (1 << sde->sdma_shift) - 1;
>>> -		sde->descq_full_count =3D 0;
>>> =20
>>>  		/* Create a mask for all 3 chip interrupt sources */
>>>  		sde->imask =3D (u64)1 << (0*TXE_NUM_SDMA_ENGINES + this_idx)
>>> @@ -1073,6 +1072,8 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)=

>>>  		/* Create a mask specifically for sdma_progress */
>>>  		sde->progress_mask =3D
>>>  			(u64)1 << (TXE_NUM_SDMA_ENGINES + this_idx);
>>> +		sde->int_mask =3D
>>> +			(u64)1 << (0 * TXE_NUM_SDMA_ENGINES + this_idx);
>>                                    ^^^^^^^^^^^^^^^^^^^^^^^^
>> Why is that there?
>>
>=20
> Hi Doug,
>=20
> The zero was intentionally added in an attempt to highlight that this
> was for the first interrupt source, like we do in other places above th=
is
> where we have 1 * TXE_NUM_SDMA_ENGINES, 2 * TXE_NUM_SDMA_ENGINES etc.
> The interrupt sources are separated by the number of SDMA engines
> i.e TXE_NUM_SDMA_ENGINES. However, we agree that the code is not
> consistent throughout. Would you like us to do a cleanup of this code
> in a follow-on patch or rework this patch and resend the series?
>=20
> Jubin
>=20

Thanks, the code is confusing to read, so a cleanup would be nice.  Just
send me something I can squash into this patch is good enough.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--rFHNWcPbFqrl6K6Q1lwa9ANCCKjqkMkLQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW2F1RAAoJELgmozMOVy/dltYQAJv0BRDe6jWs6bjt/lzev1Qu
+GkrM8h9ToxOxxxRqDp5dmMXDuBw3V3VNb/nj0DKMsfRSL1oPcv8/EyGVdWuKq7z
im1NqOuoHkOoqbFUOpYIawCwgQ6x0IFNiQxMlSlrUqxR59xHsXUUAVTJH/CYiyPc
ODygOcEeEdz7AcS8uLvgr2weZbpkpMk3rPDT99thGzPA0xgoAWLFo12RvAQWQWQ7
+Zf0lUK03zOCEM1Qj85ev/0/MfiFYNfU2UMxlbuynDGJMFaAhqOpbNVd8M2ta6zt
Mk6+ZoW7S22LLbkrEXUMxRtGHjnzn5SrSwDDUm5o4SaQ0YAZUACfRxtWJwLxfLLj
fxHenHhXWHaTJIR2PC9yUE9szGpjv4ABPIrM6GxU81zasaRt39kWJk3QtgtLg7uy
e4EjTTvwp5tE5nhqCFd+JmtieezPIVn1+ijwQf0O7KjRbLXE39F85BRZ8sCtKrLE
Kt7VVPEYMosdAOn/ch2UDOoKYs/7AH1Uzl/cPO6jA8UJNhFLky7lmdIW+9p113sK
cSj9X1gZ1GtmmC7rn+WJAf472bdu5bkrC3AHKzXp/uzGyJXYYlSB7I8xK/jBQyak
pzxKY7J4r5krZAQbIL5wKGEiw7b1PMQQl3ZIWj8BAHDz0A0M5w/Gp2v5P1fYEDUR
VWu1sBV8BIINKaxRwkG9
=jlmG
-----END PGP SIGNATURE-----

--rFHNWcPbFqrl6K6Q1lwa9ANCCKjqkMkLQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
