From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 4/4] IB/core: RoCE GID management separate
 cleanup and release
Date: Sun, 16 Aug 2015 12:48:35 -0400
Message-ID: <55D0BEE3.3040000@redhat.com>
References: <1438881240-22790-1-git-send-email-matanb@mellanox.com>
 <1438881240-22790-5-git-send-email-matanb@mellanox.com>
 <55CF495C.6010708@redhat.com> <55D04785.9070007@mellanox.com>
 <55D0B925.8000504@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OixMipIbMxLXfGfvPOdu2FiRdAnw2O8Lb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55D0B925.8000504-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OixMipIbMxLXfGfvPOdu2FiRdAnw2O8Lb
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/16/2015 12:24 PM, Doug Ledford wrote:
> On 08/16/2015 04:19 AM, Matan Barak wrote:
>>
>>
>> On 8/15/2015 5:14 PM, Doug Ledford wrote:
>>> On 08/06/2015 01:14 PM, Matan Barak wrote:
>>>> Separate the cleanup and release IB cache functions.
>>>> The cleanup function delete all GIDs and unregister the event channe=
l,
>>>> while the release function frees all memory. The cleanup function is=

>>>> called after all clients were removed (in the device un-registration=

>>>> process).
>>>>
>>>> The release function is called after the device was put.
>>>> This is in order to avoid use-after-free errors if ther vendor
>>>> driver's teardown code uses IB cache.
>>>>
>>>> Squash-into: 'IB/core: Add RoCE GID table management'
>>>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>
>>> I had originally used the v1 of this patch instead of v2.  In order t=
o
>>> make sure I didn't miss anything, I hand compared the final results o=
f
>>> the v1 patch to what this patch would have created if I had used it. =
 I
>>> found a few things worth nothing, comments inline below.
>>>
>>>> @@ -903,20 +924,28 @@ int ib_cache_setup_one(struct ib_device *devic=
e)
>>>>                         (rdma_end_port(device) -
>>>>                          rdma_start_port(device) + 1),
>>>>                         GFP_KERNEL);
>>>> -    err =3D gid_table_setup_one(device);
>>>> -
>>>> -    if (!device->cache.pkey_cache || !device->cache.gid_cache ||
>>>> +    if (!device->cache.pkey_cache ||
>>>>           !device->cache.lmc_cache) {
>>>>           printk(KERN_WARNING "Couldn't allocate cache "
>>>>                  "for %s\n", device->name);
>>>> -        err =3D -ENOMEM;
>>>> -        goto err;
>>>> +        /* pkey_cache is freed here because we later access it's
>>>> +         * elements.
>>>> +         */
>>>> +        kfree(device->cache.pkey_cache);
>>>> +        device->cache.pkey_cache =3D NULL;
>>>> +        return -ENOMEM;
>>>
>>> This function is unnecessarily convoluted IMO.  A simple change to us=
ing
>>> kzalloc() for the pkey_cache alloc eliminates part of the issue.  As =
a
>>> result, I fixed this function up to be different than either patch.
>>> Please look over my results and make sure you agree with my changes.
>>>
>>>>       }
>>>>
>>>> -    for (p =3D 0; p <=3D rdma_end_port(device) -
>>>> rdma_start_port(device); ++p) {
>>>> +    for (p =3D 0; p <=3D rdma_end_port(device) -
>>>> rdma_start_port(device); ++p)
>>>>           device->cache.pkey_cache[p] =3D NULL;
>>>
>>> For instance this goes away entirely by using kzalloc().
>>>
>>> The rest looked ok.  I have to fixup the ordering changes between sys=
fs
>>> and cache to make the v1 patch match the v2 patch.
>>>
>>>
>>
>> Thanks for the squashing and re-ordering these patches.
>> I think you're missing if (device->cache.pkey_cache) over the for pkey=

>> free loop in ib_cache_release_one.
>=20
> I think you're right, but I think that particular issue exists in both
> versions of the code (mine and yours).  In particular, a failure during=

> ib_register_device should result in a call to ib_dealloc_device which
> will result in a call to ib_cache_release_one, which will happen whethe=
r
> ib_cache_setup_one returns an error or not.  So, ib_cache_release_one
> must check pkey_cache before releasing the ports because it can't assum=
e
> the original setup succeeded.
>=20
>> Otherwise, the allocation of
>> device->cache.pkey_cache might has failed and you dereference an inval=
id
>> address device->cache.pkey_cache[p].
>>
>> In addition, ib_device_release calls ib_cache_release_one with device
>> instead of dev (which has the wrong type).
>> ib_register_device calls ib_cache_clean_one that I can't really find :=
)
>=20
> Both of these turned up in compile tests.  I've since resolved them.
> Hand merge issues ;-)
>=20

I've pushed what I think is a fixed version to github.  Please feel free
to review.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--OixMipIbMxLXfGfvPOdu2FiRdAnw2O8Lb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV0L7jAAoJELgmozMOVy/dN7QQAIDYZtBz8fN/97RQVvmitLAK
VQPX9oUBlWnxaxT5t2XsKTD2L/Ax5qe72FRY2K392wFRlWUAaEbmNzwZprnikP9k
q5BaipumT6obOKt5Vya08RqoizTfaazWXKVOLkW+tzvYF4uowcIXTC5Nv6/MLd3E
EeYePTHtYOMZvRJzYmhsttK3PSPqEhFDS+F1VJCsUGPcK8wxz3giWrvuZ/wl3CeA
SypuwrKL3qgK5mXClDBODqIQRm9QmdmDOHsNZ2lxdOihiOAIDKOfqZJGUPt2P00i
VnG+3/fQl6NUWUR7Vkq9dIUogj+DTUupR0xa+cCtAemUEOj40dJKCxLq7wvVv8pQ
DOH6eAwwHpCCU3xKtSdjbMjNnu9BVr0OaEMql1rQQSXh9uVch51mNd/CEdOt1Fap
kfMsrNCjbth/I4duxhZ6SGUo1T65DUDz8Qp6O/bTfsrbFvtNFm/9CUIJPkMmtHNn
siNx+N7+aumTe48Bwg1BMkH6t9mx6AwyeDDUB5ZqRSyvO2RYS8l5vVQwzhZD7qC5
+PQHek7lX0x72BGblYXzojy0hSOlKWTSqx1uuueU2uv1/ed7BLS0gR0l0bq3CCtX
MG8na5344qS1KfJ8JY4xRKzwE73RuLjeZS7I5neYvhwLeN+CzauR6C8k2dZIu1tf
5ifnMU5lRX1WZ4yw/AVL
=YE09
-----END PGP SIGNATURE-----

--OixMipIbMxLXfGfvPOdu2FiRdAnw2O8Lb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
