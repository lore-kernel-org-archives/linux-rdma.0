From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rds: rds_ib_device.refcount overflow
Date: Wed, 29 Jul 2015 10:36:34 -0400
Message-ID: <55B8E4F2.2060700@redhat.com>
References: <1436164511-2411-1-git-send-email-wen.gang.wang@oracle.com>
 <55A31202.1030408@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MSlL25bTGvjVVv4lb2L6wjF7wXMgvfgvH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55A31202.1030408-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MSlL25bTGvjVVv4lb2L6wjF7wXMgvfgvH
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: quoted-printable

On 07/12/2015 09:18 PM, Wengang Wang wrote:
> Hi Doug,
>=20
> How do you think about this patch?

Sorry, I picked this up already.  I must have missed sending out the
acknowledgment on this one.

> thanks,
> wengang
>=20
> =D4=DA 2015=C4=EA07=D4=C206=C8=D5 14:35, Wengang Wang =D0=B4=B5=C0:
>> Fixes: 3e0249f9c05c ("RDS/IB: add refcount tracking to struct
>> rds_ib_device")
>>
>> There lacks a dropping on rds_ib_device.refcount in case rds_ib_alloc_=
fmr
>> failed(mr pool running out). this lead to the refcount overflow.
>>
>> A complain in line 117(see following) is seen. From vmcore:
>> s_ib_rdma_mr_pool_depleted is 2147485544 and rds_ibdev->refcount is
>> -2147475448.
>> That is the evidence the mr pool is used up. so rds_ib_alloc_fmr is
>> very likely
>> to return ERR_PTR(-EAGAIN).
>>
>> 115 void rds_ib_dev_put(struct rds_ib_device *rds_ibdev)
>> 116 {
>> 117         BUG_ON(atomic_read(&rds_ibdev->refcount) <=3D 0);
>> 118         if (atomic_dec_and_test(&rds_ibdev->refcount))
>> 119                 queue_work(rds_wq, &rds_ibdev->free_work);
>> 120 }
>>
>> fix is to drop refcount when rds_ib_alloc_fmr failed.
>>
>> Signed-off-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>   net/rds/ib_rdma.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
>> index 273b8bf..657ba9f 100644
>> --- a/net/rds/ib_rdma.c
>> +++ b/net/rds/ib_rdma.c
>> @@ -759,8 +759,10 @@ void *rds_ib_get_mr(struct scatterlist *sg,
>> unsigned long nents,
>>       }
>>         ibmr =3D rds_ib_alloc_fmr(rds_ibdev);
>> -    if (IS_ERR(ibmr))
>> +    if (IS_ERR(ibmr)) {
>> +        rds_ib_dev_put(rds_ibdev);
>>           return ibmr;
>> +    }
>>         ret =3D rds_ib_map_fmr(rds_ibdev, ibmr, sg, nents);
>>       if (ret =3D=3D 0)
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--MSlL25bTGvjVVv4lb2L6wjF7wXMgvfgvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVuOTyAAoJELgmozMOVy/dU9AQAJ5Ocx5hvHFYcm3g3k9VFk9u
9v/hZ+6TLpdf0E/M6PeOZTkuWpG2KmLViFc05XtSK8fWXD4UbdsiFsSCbcmZz63a
vlv3tOaN5g7kBsp8wrah0lGpivz4a2cqKgc8E+v+BJG/izaqrxogYiz7/cmUijQi
l6AxGgO8TkLT/N7r5p/b7lHBq71/QK05pIruUVqC5q4LfEedX8EoxXj28xWmicdY
d4Nksg+pZZN1FL8163qMxxK5Hjv5L5NuGUZT5genD/kv87hwCbhXCiINSx9wzTwM
9qgYUZlkr9iwOTcBPPI9SA2AqOpxs40ph5pDRqHVT1gFuZ/uJ9rf++s4EOQoOTjH
C2/pGe+edXW3YPl3nm1CyPqKUzSdlVBkO60spKrmk4GdNdyYaT1fJE+gX9VY1d/f
l3o75evnc+11zB1BL9+I6jayRfNnzowivEEoTeQv8oO3pHlJns91iEGjd5MHj+1B
U0BgnZuUWVrgBPiXR+h6/Q3RU421fqtYaJZNgHnSROhIxiO4NKTV4Xsa+OzpbG6m
OUSs9smGXXj/3x1Dt1jNgD9jqTdwOW+dXXrF5XNLj7aH30/fXkldvX5/4wucxpro
zc6JMFDe8XS8AnJNvJy2pWYtgdBZNND0lxCvdigBFQeq09PWqsOe02tpj+YkT+Bn
P8BqVOJa4GUkAbaQUu0W
=yxUK
-----END PGP SIGNATURE-----

--MSlL25bTGvjVVv4lb2L6wjF7wXMgvfgvH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
