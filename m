From: Doug Ledford <dledford@redhat.com>
Subject: Re: [patch] IB/core: off by one in error handling
Date: Fri, 28 Aug 2015 23:59:55 -0400
Message-ID: <55E12E3B.7030102@redhat.com>
References: <20150818092317.GF3965@mwanda>
 <20150829011800.GB2713@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RlFrP4egD6gXERV9oN0klIOWjjmrahxX3"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20150829011800.GB2713@phlsvsds.ph.intel.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: "ira.weiny" <ira.weiny@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Moni Shoua <monis@mellanox.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RlFrP4egD6gXERV9oN0klIOWjjmrahxX3
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/28/2015 09:18 PM, ira.weiny wrote:
> On Tue, Aug 18, 2015 at 12:23:17PM +0300, Dan Carpenter wrote:
>> This is a zero offset array.  The current code could try to free rando=
m
>> memory and crash.  Also it leaks the first element.
>>
>> Fixes: 230145ff8124 ('IB/core: Add RoCE GID table management')
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> I don't actually see this in Dougs to-be-rebased/for-4.3 tree.
>=20
> Looks like Doug picked up a different version of the patch in the lates=
t
> rebase.
>=20
> annotating cache.c I see a different change from Matan in commit
>=20
> 76680c1cfc5ab
>=20
> +rollback_table_setup:
> +       for (port =3D 0; port < ib_dev->phys_port_cnt; port++) {
> +               cleanup_gid_table_port(ib_dev, port + rdma_start_port(i=
b_dev),
> +                                      table[port]);
> +               release_gid_table(table[port]);
> +       }
>=20
> Ira

Correct, so I dropped this patch.

>>
>> diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core=
/cache.c
>> index a9d5c70..f5d14a7 100644
>> --- a/drivers/infiniband/core/cache.c
>> +++ b/drivers/infiniband/core/cache.c
>> @@ -582,7 +582,7 @@ static int _gid_table_setup_one(struct ib_device *=
ib_dev)
>>  	return 0;
>> =20
>>  rollback_table_setup:
>> -	for (port =3D 1; port <=3D ib_dev->phys_port_cnt; port++)
>> +	for (port =3D 0; port < ib_dev->phys_port_cnt; port++)
>>  		free_gid_table(ib_dev, port, table[port]);
>> =20
>>  	kfree(table);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--RlFrP4egD6gXERV9oN0klIOWjjmrahxX3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV4S47AAoJELgmozMOVy/dDPgQAJGTny1ZPx2oZR3sjpYn2PtB
5FtZ9x5zX8Er55rPFf5viGEm+uhllsZV5lRBwEpaD8Yk3DD6OxbEbalM+npl17tG
5YcPnQ2juhSWVR89ckyCqAtkJDyQx9XuHZQftcDWTfAeat7BC32r5Sx5Eag9iPmx
YzsymjEd39j+F9ylUhzqq69gk6hi5xbossOkv9dxbKSeC9Z4y38I2U1s7SL3az3D
CSwCmJIVmKlYB9Nc41VSuy8QR1vSn8b/ginFP4w/lYUtEICXyviu12VXvhS8rD6g
B69VL0sUngKyyCHdMyW2ZZ88l7YyYk8TEohKe9heD/J6HevNdnfebzvhLHy361mJ
9JksP2YEiuNhrl/zdJGBXpXYV9CjJK/w2zdJYZGBjDRO1/K0o3oBsetVlztBSq7n
PZqLKBAeJu1O8G05UKvKYx1wZaUOeax/U4KOSTF3QS6AVoQEq2brAt5MwhqcHmw7
F7ziLJ7SMPT9uzs5W7L5XqgexDpTOxKmrBqnHRSLKhqmoZ5CDFIipzhPgBreiotu
j6qNdO3+QDkNu4Qv8kc0cSoaBafyO4VNT8/vADDDgOWO7FwaFXSsHMX8F+o7MObD
vc7aOGjkma+y5M6hccRi9LDpNMakuBs7AF8+aSjze0LdBOSCNZpyxDBomZbcDdzR
i5JLJq6072ObIHPYg0eG
=+Yiu
-----END PGP SIGNATURE-----

--RlFrP4egD6gXERV9oN0klIOWjjmrahxX3--
