From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V1 2/3] IB/core: RoCE GID management separate
 cleanup and release
Date: Fri, 14 Aug 2015 17:49:56 -0400
Message-ID: <55CE6284.1070604@redhat.com>
References: <1438607342-11964-1-git-send-email-matanb@mellanox.com>
 <1438607342-11964-3-git-send-email-matanb@mellanox.com>
 <20150804031038.GA27627@obsidianresearch.com>
 <CAAKD3BBESq61-UJJvqm=ni5vrtu8yuNJvC57mWwCpehQSd1k4A@mail.gmail.com>
 <20150804164650.GA3858@obsidianresearch.com>
 <CAAKD3BDDKcyA0xitGpuMkKsr6=9onxFgdVXHE3n-zb=xjX4Uhg@mail.gmail.com>
 <20150804212334.GB10934@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="i1FqVdF6hcwemV8wATXw2dr92O1ikvsTA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150804212334.GB10934-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--i1FqVdF6hcwemV8wATXw2dr92O1ikvsTA
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/04/2015 05:23 PM, Jason Gunthorpe wrote:
> On Tue, Aug 04, 2015 at 09:55:03PM +0300, Matan Barak wrote:
>=20
>> If it fails in ib_device_register_sysfs, the device release function
>> isn't called and the device pointer isn't freed.
>=20
> Ugh, yes, the abuse in ib_dealloc_device needs to go too.
>=20
> Attached is a compile tested patch that fixes that up. Feel free to
> fix it up as necessary. It should be sequenced before your 'Add RoCE
> GID table management'.. It would probably be helpful for doug to
> resend that one patch adjusted.
>=20
>> If ib_cache_setup_one fails, we call ib_device_unregister_sysfs and
>> the memory will be freed.
>=20
> ?? ib_device_unregister_sysfs doesn't free memory..
>=20
> At the driver the sequence should be:
>  ib_alloc_device
>  ib_register_device
>  ib_unregister_device
>  ib_dealloc_device
>=20
> The issue I'm looking (which I suspected before, but just went and
> confirmed) at is that sysfs's show_port_gid calls ib_query_gid which
> your series now makes use the cache, so sysfs should ideally be shut
> off before the cache stuff.
>=20
> .. and we must setup the cache before setting up sysfs, otherwise
> there is a race where userspace can trigger a cache call before
> setup.. (null deref?)
>=20
>> ib_device_unregister_sysfs (otherwise I'll have use-after-free).
>> What do you think?
>=20
> I'm still not sure what you are seeing..
>=20
> You might also want the cache code to have an entry from
> ib_alloc_device to setup locks and other no-fail initalization
> things. AFIAK there isn't a strong reason to do this other than to
> keep with the basic idiom.
>=20
> Jason
>=20
> From 32bafdef61a9e571ef1457f7f1966a7372d1b8d7 Mon Sep 17 00:00:00 2001
> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Date: Tue, 4 Aug 2015 15:11:41 -0600
> Subject: [PATCH] IB/core: Make ib_alloc_device initialize the kobject
>=20
> This gets rid of the weird in-between state where struct ib_device
> was allocated but the kobject didn't work.
>=20
> Consequently ib_device_release is now guaranteed to be called in
> all situations and we can't duplicate its kfrees on error paths.
> Choose to just drop kfree(port_immutable)
>=20
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

I reworded the commit message some, but the patch was good and makes
sense.  I've inserted it into the GID series and, as expected, it caused
failures in the original "IB/core: Add RoCE GID table management" patch.
 However, the fixups for those failures seem pretty obvious to me, so I
made them myself.  When I finally push this, it will be in this branch
on my github repo:

v4.2-rc6-based/gid-table-v7

You and Matan might want to double check that I fixed things up properly
and didn't miss something.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--i1FqVdF6hcwemV8wATXw2dr92O1ikvsTA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzmKEAAoJELgmozMOVy/dd1kP/ApRGyjtKMo9kjzIAswA0qRP
g6zFFCJwNU8wc/WaoS47UDDliEj6DwZ1rLeSfmWEKK5YqeR8vR4wZQ7/Jqpy+7r+
UbmV1Kyl7zu9qFkKmaeawMKnXQD8M4MulhXVeQWiHLe9accc6cR8UA/xnp8njq1H
kvmUWNeGNzcKiKAu9rPGUyTVp9GS/EpK8zhaS1cQmK5b9rdxMqMsksCV7ZFz/Bj+
yoWo40UAZSrb0YaBKpMQHV3Erb1NTN+YR55HsHbrlsLL2mhN56KGjxhaSq5CimhZ
OIgyHwfIz1XZBsma2WCzgL7J6Cxj5l/2XScDixEyYZzuDJ9Aj/F4hl5TfFGGtdTE
K4dawPsi5kGIgesvMKtdQ9/evj0sOIBeBusiX2Jg9BYGWJ+DWCZXRAjxynW9hxsT
Wx3kX1/1mXw4bih9bmjo6kGTDD96oHrpl/Y4hrwSfAAu9jbDWhUHCiOY4hLwFV9v
IXT/ouLMgGWHj6NS0Nt/a9fVuLUjQ4HwKhyuusLDlgS9oF5blOk401pNgyxmlTGi
i2LqMsxQwOLvN9xM0mwfyyAYx5fnPdlQlH05jV31Ic0zwM9AbV6gpaMxbUjcOXwL
ftz/RM5ou94FrD6E0tiCjRQ/5PEawZv2Br4U9Ts2urKU+o+vMQH433u878EFkdVp
aPFuIrEefKkFHlveQU3I
=x1+0
-----END PGP SIGNATURE-----

--i1FqVdF6hcwemV8wATXw2dr92O1ikvsTA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
