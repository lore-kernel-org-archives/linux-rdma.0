From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Expose correct max_sge_rd limit
Date: Thu, 28 Apr 2016 10:53:14 -0400
Message-ID: <572223DA.7030805@redhat.com>
References: <1459440205-25208-1-git-send-email-sagig@grimberg.me>
 <20160401000426.GF2670@leon.nu> <570606B4.5040402@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PCGETE7X1QtowVqX7EWrQnqpVHV6uJDkU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <570606B4.5040402-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PCGETE7X1QtowVqX7EWrQnqpVHV6uJDkU
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/07/2016 03:05 AM, Sagi Grimberg wrote:
>=20
>=20
> On 01/04/16 03:04, Leon Romanovsky wrote:
>> On Thu, Mar 31, 2016 at 07:03:25PM +0300, Sagi Grimberg wrote:
>>> mlx5 devices (Connect-IB, ConnectX-4, ConnectX-4-LX) has a limitation=

>>> where rdma read work queue entries cannot exceed 512 bytes.
>>> A rdma_read wqe needs to fit in 512 bytes:
>>> - wqe control segment (16 bytes)
>>> - rdma segment (16 bytes)
>>> - scatter elements (16 bytes each)
>>>
>>> So max_sge_rd should be: (512 - 16 - 16) / 16 =3D 30.
>>>
>>> Reported-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>>> Tested-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>>> Signed-off-by: Sagi Grimberg <sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>>
>> Thanks Sagi,
>>
>> Excellent catch, the same as in commit: a5e4ba334e2
>> ("mlx4: Expose correct max_sge_rd limit")
>>
>> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Doug, this is stable material, can we get it to 4.6-rc
> and place a stable tag on it?
>=20
> Thanks,
> Sagi.

Done, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--PCGETE7X1QtowVqX7EWrQnqpVHV6uJDkU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXIiPaAAoJELgmozMOVy/dprIP/jHduLmPbrDJTHwHQiJmZ/4d
+apUurwwql/JyPHpFeXm5zxN4iMt5/7b1BkvQpXxLmM5RWMa1KoHAovlZWws22On
i9UwExxwLkTz88xJzGfdJa4GhYDHSSBH6go7VxVvtkCgMdPC7Z2sqQO3TzGrhByO
g4pWXDWwuQUtZQy50JEbMS/Qq9kKOHiGc/iFgO7L8JLZizFoFZc4HTkNJLhWoFq1
47w33cGASVaasrJc5tj4I5t1pMOgsdgxZ1PQDGspIXeK29oGzPNG8PhQsLOGx/Cy
A8uhHaFm1Mc0EpZIKnpDuREqNwZ4HNmoeNNSLgftietBvWwst9OlsWlFMgbYrqqw
gUuoVadIe1/fRJdg2jUSEjEekqG3tWYHJRZqPEOY7UpkQ+AKoFt+gQ9PLMwgciqv
qtuc1TVsmd94mSaMIA0T9ZlsBdJQAOtEAF3MOO05atMRQLzkfoVJCdYrJS9YWB9p
sr0BGJOTfrx8ki0BxK8u09ur80hkx90wmRR9t3W+5TtU7jTVxIChzjxpCN3RvFCM
JFpWJkskU/wN6v/mldSWGGUeFvZ95v6V1y0slCiHPb5ERhEmzqvmJxQA9fe95Rz/
MemTZT2P6CfuS/6HwX5LTbjIc4n+MKuE/BmWKvVhYxKsGxzOYwHz1EpppeIJlY8n
M3ULesYNmrmAYnWEY7Hh
=pOWR
-----END PGP SIGNATURE-----

--PCGETE7X1QtowVqX7EWrQnqpVHV6uJDkU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
