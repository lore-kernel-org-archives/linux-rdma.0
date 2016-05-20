From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] IB/core: Make device counter infrastructure dynamic
Date: Fri, 20 May 2016 14:43:14 -0400
Message-ID: <fa41b16b-cfdb-5595-b23d-951a011493a1@redhat.com>
References: <ecc98d137bffc959e6459d9ffd0fe53da0d84c9d.1463760487.git.dledford@redhat.com>
 <VI1PR05MB1391B8F7E83C21B653BC0C92D24B0@VI1PR05MB1391.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KWUk4HUJor2cfx5BDhndgdKkrLNjX9QcG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR05MB1391B8F7E83C21B653BC0C92D24B0-79XLn2atqDP8GeyK7vyn2tqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KWUk4HUJor2cfx5BDhndgdKkrLNjX9QcG
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/20/2016 12:53 PM, Mark Bloch wrote:
>=20
>=20
>> -----Original Message-----
>> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
>> Sent: Friday, May 20, 2016 7:15 PM
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>; Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>;=

>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Subject: [PATCH v4] IB/core: Make device counter infrastructure dynami=
c
> [snip]
>> +static struct rdma_hw_stats *iwch_alloc_stats(struct ib_device *ibdev=
,
>> +					      u8 port_num)
>> +{
>> +	struct rdma_hw_stats *stats;
>> +
>> +	/* Our driver only supports device level stats */
>> +	if (port_num !=3D 0)
>> +		return NULL;
>> +
>> +	/* Guard against buggy edits of the names array */
>> +	BUILD_BUG_ON(ARRAY_SIZE(names) !=3D NR_COUNTERS);
>> +
>> +	stats =3D kzalloc(sizeof(*stats) + NR_COUNTERS * sizeof(u64),
>> GFP_KERNEL);
>> +	if (!stats)
>> +		return NULL;
>> +	stats->name =3D names;
>> +	stats->num_counters =3D NR_COUNTERS;
>> +	stats->lifespan =3D -1;
>> +	return stats;
>> +}
> [snip]
>=20
>> +static struct rdma_hw_stats *c4iw_alloc_stats(struct ib_device *ibdev=
,
>> +					      u8 port_num)
>> +{
>> +	struct rdma_hw_stats *stats;
>> +
>> +	BUILD_BUG_ON(ARRAY_SIZE(names) !=3D NR_COUNTERS);
>> +
>> +	if (port_num !=3D 0)
>> +		return NULL;
>> +
>> +	stats =3D kzalloc(sizeof(*stats) + NR_COUNTERS * sizeof(u64),
>> GFP_KERNEL);
>> +	if (!stats)
>> +		return NULL;
>> +	stats->name =3D names;
>> +	stats->num_counters =3D NR_COUNTERS;
>> +	stats->lifespan =3D -1;
>> +	return stats;
>> +}
> [snip]
>> +static struct rdma_hw_stats *i40iw_alloc_hw_stats(struct ib_device *i=
bdev,
>> +						  u8 port_num)
>> +{
>> +	struct i40iw_device *iwdev =3D to_iwdev(ibdev);
>> +	struct i40iw_sc_dev *dev =3D &iwdev->sc_dev;
>> +	struct rdma_hw_stats *stats;
>> +
>> +	BUILD_BUG_ON(ARRAY_SIZE(i40iw_hw_stat_names) !=3D
>> +		     (I40IW_HW_STAT_INDEX_MAX_32 +
>> I40IW_HW_STAT_INDEX_MAX_64));
>> +
>> +	stats =3D kzalloc(sizeof(*stats) +
>> +			I40IW_HW_STAT_INDEX_MAX_32 * sizeof(u64) +
>> +			I40IW_HW_STAT_INDEX_MAX_64 * sizeof(u64),
>> GFP_KERNEL);
>> +	if (!stats)
>> +		return NULL;
>> +	stats->name =3D i40iw_hw_stat_names;
>> +	stats->num_counters =3D I40IW_HW_STAT_INDEX_MAX_32 +
>> +		I40IW_HW_STAT_INDEX_MAX_64;
>> +	/*
>> +	 * PFs get the default update lifespan, but VFs only update once
>> +	 * per second
>> +	 */
>> +	if (dev->is_pf)
>> +		stats->lifespan =3D -1;
>> +	else
>> +		stats->lifespan =3D msecs_to_jiffies(1000);
>> +	return stats;
>> +}
> Just a little nitpick, what about creating a function that allocates th=
e rdma_hw_stats struct?
> Something like:
>=20
> static inline static struct rdma_hw_stats *allocate_hw_stats_struct(con=
st char **name,
> 								         int num_counters,
> 								         unsigned long lifespan)
> {
> 	struct rdma_hw_stats *stats;
>=20
> 	stats =3D kzalloc(sizeof(*stats) + num_counters * sizeof(u64));
> 	if (!stats)
> 		return NULL;
>=20
> 	stats->name =3D name;
> 	stats->num_counters =3D num_counters;
> 	if (lifespan =3D=3D -1)
> 		stats->lifespan =3D -1;
> 	else
> 		stats->lifespan =3D msecs_to_jiffies(lifespan);
>=20
> 	return stats;
> }=20
>=20
> And putting it in ib_verbs.h?
> I feel like that copying this piece of code across drivers (3 with this=
 patch, adding mlx5 + mlx4 makes it 5)
> makes little sense, also I don't feel the drivers should care/know abou=
t how to allocate it.
> Specifically: kzalloc(sizeof(*stats) + num_counters * sizeof(u64)) seem=
s out of place inside a driver,
> It should be part of the infrastructure.

Sure, I'll add that.  I've got to fix the build issue too.

> Other than that, it looks really good.
>=20
> Mark
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--KWUk4HUJor2cfx5BDhndgdKkrLNjX9QcG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXP1rCAAoJELgmozMOVy/dyCIP/2M+3dSRpueDDt4rpgklih3/
bxOVa0+GMDI46BV1gFxGgTccg3Q5FIbeDlAzUtEXe235JDjEMHvsollTryPQn2w3
6eBohHoJ/PptK9TrsEUGOY9Qoq789JopDTDsCJphxtTrF6km0ff7ll5z7SeiSiH3
e6BKhGJi2Hj+9EoacJA4DNebWiyvpiMlSxIpYEqyS5RHBOHMsdbG1rqfwrbD2eg+
DH98cJsocxNB4Y64dihbJYmZj52HXT2P1J37uyZpT/o2mXQxZuFVbtEWGCFGTMYd
Kq5U7t85FRSHfNB93T+To/5YjdAEvc1V3MhK7NljrOTlR9kllWLi9Jzy67WD20ZV
4eppqm6HVksiE6owaJoxMgc9G+2kh8sYpm0y5qEiHrf+MXdxpsysdNyDBZqimR+g
nnnLHpQL3AaoSTgvaT1DfU8rQPK1RoPIsC/jRpE8mdrVzUDV3segRu+iwbz6Ev+F
E79eRZQyaITDc6Gczk42VEX8Is7McLR+vzWV1rwmv6433wf2769Vj8VbTE6VNmRf
9CCTYEFHwRco9kFXxtQV/w7set5u2ghH6foPC075UjwCeKhvl07D8vavQc7p9r0j
XiiHWrYPmvsupviY++mGKKemS5dyRNRhag1ayPxQ/nZLhYOGB3jpj20UuQN29NB0
dTeEAQh5jGkkpoxdFHsV
=kUuP
-----END PGP SIGNATURE-----

--KWUk4HUJor2cfx5BDhndgdKkrLNjX9QcG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
