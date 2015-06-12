From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ucm: ib_ucm_release_dev clears wrong bit if devnum
 is greater than IB_UCM_MAX_DEVICES
Date: Fri, 12 Jun 2015 16:31:31 -0400
Message-ID: <557B41A3.8060409@redhat.com>
References: <1434038801-6513-1-git-send-email-clsoto@linux.vnet.ibm.com> <557B3C23.9090403@redhat.com> <557B4007.7020301@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1Bo0uqTR8Tp9avLkLi2BKd708M0QSo84s"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <557B4007.7020301-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carol Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1Bo0uqTR8Tp9avLkLi2BKd708M0QSo84s
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/12/2015 04:24 PM, Carol Soto wrote:
>=20
>=20
> On 6/12/2015 3:08 PM, Doug Ledford wrote:
>> On 06/11/2015 12:06 PM, clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org wrote:
>>> From: Carol L Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>>
>>> ib_ucm_release_dev clears wrong bit if devnum is greater than
>>> IB_UCM_MAX_DEVICES.
>>>
>>> Signed-off-by: Carol L Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>> ---
>>>   drivers/infiniband/core/ucm.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/core/ucm.c
>>> b/drivers/infiniband/core/ucm.c
>>> index f2f6393..e2fd085 100644
>>> --- a/drivers/infiniband/core/ucm.c
>>> +++ b/drivers/infiniband/core/ucm.c
>>> @@ -1193,6 +1193,7 @@ static int ib_ucm_close(struct inode *inode,
>>> struct file *filp)
>>>       return 0;
>>>   }
>>>   +static DECLARE_BITMAP(overflow_map, IB_UCM_MAX_DEVICES);
>>>   static void ib_ucm_release_dev(struct device *dev)
>>>   {
>>>       struct ib_ucm_device *ucm_dev;
>>> @@ -1202,7 +1203,7 @@ static void ib_ucm_release_dev(struct device *d=
ev)
>>>       if (ucm_dev->devnum < IB_UCM_MAX_DEVICES)
>>>           clear_bit(ucm_dev->devnum, dev_map);
>>>       else
>>> -        clear_bit(ucm_dev->devnum - IB_UCM_MAX_DEVICES, dev_map);
>>> +        clear_bit(ucm_dev->devnum - IB_UCM_MAX_DEVICES, overflow_map=
);
>>>       kfree(ucm_dev);
>>>   }
>>>   @@ -1226,7 +1227,6 @@ static ssize_t show_ibdev(struct device *dev,=

>>> struct device_attribute *attr,
>>>   static DEVICE_ATTR(ibdev, S_IRUGO, show_ibdev, NULL);
>>>     static dev_t overflow_maj;
>>> -static DECLARE_BITMAP(overflow_map, IB_UCM_MAX_DEVICES);
>>>   static int find_overflow_devnum(void)
>>>   {
>>>       int ret;
>>>
>> This doesn't look right to me.  In particular, you are creating a bitm=
ap
>> and clearing bits, but I never see that bitmap get any bits set.  So,
>> are you overflowing on the set routine and you just didn't bother to f=
ix
>> that?
> I just moved the declaration of the bitmap before ib_ucm_release_dev to=

> be able to compile. This bitmap is used in ib_ucm_add_one
> in the case of devnum > IB_UCM_MAX_DEVICES. The error path in
> ib_ucm_add_one did the clear bit correctly but not the
> ib_ucm_release_dev function. We saw an issue when using SRIOV. The case=

> was that user has 2 Mellanox SRIOV cards and just did an
> unbind/bind a VF that was using a ib ucm device with devnum greater tha=
n
> 32. We saw this warning

Got it.  For some reason I saw the add of the bitmap but missed the
removal of the original.



--1Bo0uqTR8Tp9avLkLi2BKd708M0QSo84s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVe0GjAAoJELgmozMOVy/dQHkP/0AEpxXDr4Yb/r5zwWxHq1FW
pUu7DLQHEHVuQVEqi6azuSBEhOMl1tjy/NS0usZsxPg4G//dsx1WQcdWCIjptXFy
6Hm7t+725ymHPnAUeTpo654zVcoBFVdY13wWafnigtlbbZIu1RdI9BtQKo6wSgXs
cN5HLSjZnUcXNh2+Vkt7QzVOemg1naDybOE9t1E16nRkp64K1LbGo2bestVmsicQ
FCfratT2GfHVw96xWbBoRClosIJJKYJ4sMraoVF/g3czokoHFiQJvI40XMfsgrgz
uZ/Rdu40O7ouRwFSHjAIAUYlRl1extnsfdhD6jEMKEAvGOycvBcLJBxtzCbhxaJO
ODxUDqwYR9lsVN2/IKXIyB+CDE+c9Q3g7Udx84oTtJD4cSh6XLjQCyNLOYsYq+7v
HctjAGbGmstUkHpJfDM65QO5mGKkT5N0RWJxbzE6uOhcJ29yNm3xBh2kHn6bAK4q
sMVj2lnzUNl7ilcv1A4nzCToykiwZrB2+dpGFwFtanUvTY/rd+Ahe72Oz9a5pUwU
8k5wNVHqbNRZGUa40VSG/HGqcaGxm7DlGwK5bUZHz+3w+ReMm94DHattffpndWok
qjrQpeE36QwH3jDWEST+tNBDW6CfwLNUD4lf306fbyS83AdxDQXbcYWpybNXBeUg
rGMiapee+FEaku6n+Fp0
=1wn9
-----END PGP SIGNATURE-----

--1Bo0uqTR8Tp9avLkLi2BKd708M0QSo84s--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
