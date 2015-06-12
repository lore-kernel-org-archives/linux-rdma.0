From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ucm: ib_ucm_release_dev clears wrong bit if devnum
 is greater than IB_UCM_MAX_DEVICES
Date: Fri, 12 Jun 2015 16:08:03 -0400
Message-ID: <557B3C23.9090403@redhat.com>
References: <1434038801-6513-1-git-send-email-clsoto@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TEa6N4VuTM5UTtJxX4q7gwIjlbGnM4VQx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434038801-6513-1-git-send-email-clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TEa6N4VuTM5UTtJxX4q7gwIjlbGnM4VQx
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/11/2015 12:06 PM, clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org wrote:
> From: Carol L Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>=20
> ib_ucm_release_dev clears wrong bit if devnum is greater than IB_UCM_MA=
X_DEVICES.
>=20
> Signed-off-by: Carol L Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  drivers/infiniband/core/ucm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/uc=
m.c
> index f2f6393..e2fd085 100644
> --- a/drivers/infiniband/core/ucm.c
> +++ b/drivers/infiniband/core/ucm.c
> @@ -1193,6 +1193,7 @@ static int ib_ucm_close(struct inode *inode, stru=
ct file *filp)
>  	return 0;
>  }
> =20
> +static DECLARE_BITMAP(overflow_map, IB_UCM_MAX_DEVICES);
>  static void ib_ucm_release_dev(struct device *dev)
>  {
>  	struct ib_ucm_device *ucm_dev;
> @@ -1202,7 +1203,7 @@ static void ib_ucm_release_dev(struct device *dev=
)
>  	if (ucm_dev->devnum < IB_UCM_MAX_DEVICES)
>  		clear_bit(ucm_dev->devnum, dev_map);
>  	else
> -		clear_bit(ucm_dev->devnum - IB_UCM_MAX_DEVICES, dev_map);
> +		clear_bit(ucm_dev->devnum - IB_UCM_MAX_DEVICES, overflow_map);
>  	kfree(ucm_dev);
>  }
> =20
> @@ -1226,7 +1227,6 @@ static ssize_t show_ibdev(struct device *dev, str=
uct device_attribute *attr,
>  static DEVICE_ATTR(ibdev, S_IRUGO, show_ibdev, NULL);
> =20
>  static dev_t overflow_maj;
> -static DECLARE_BITMAP(overflow_map, IB_UCM_MAX_DEVICES);
>  static int find_overflow_devnum(void)
>  {
>  	int ret;
>=20

This doesn't look right to me.  In particular, you are creating a bitmap
and clearing bits, but I never see that bitmap get any bits set.  So,
are you overflowing on the set routine and you just didn't bother to fix
that?


--TEa6N4VuTM5UTtJxX4q7gwIjlbGnM4VQx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVezwjAAoJELgmozMOVy/deIMP/1AH5SjZv1mkTQYbFtUCcMxg
qNeVjPUtYPk2cf19ALy9SaUxu6se7w8BGHXN5jYLFCh3L3qQbKSkRfScxqGIJxLq
xijQimAqAo3/hWsPMuqItXfnFIXLOIKGj5PoQTb0UgJ/qR2YA1KZQjQcU4IH9Czv
mIrIAL2WlFClXSE7gwFp+I2N6+KlXF2FCeX+9GPtTpa7UWV9Kdc3EMWIRCxnDTWO
/WHFlo90XMMdgkLEDRuNfSSCbRo5DYBVIT29tKHvA+XP3fQJBb15tiYQlE9Zn87y
8rAVmteGabUv3/lUQuPYOZDIUeFO0MYIAV77gAWjHjN4hl8h6ZyBVsfrI2/WjDGx
VSlL07r4m7v4ZWCOa9/awhMcVajU/p1teB9ooIwF8J6IS5dh7//BvlOWey0NG4ls
A42h0cBA1s9ltAEuEBjXXGJesHoaOzjr3BuGRf94QDL92YbKyYodFRdgAXxA5a+z
aIyEUYtTf3rvFdZlJT6VfTmHnXFAFhFvnfkbKGNnK+0GGXgRlPIXxKAJeZr4MbgT
nlW4EAZ7Wu+2AJN6NF2BY3eq+GVX8OiRHCTiFx6B5NrvjI0B0JIKSg6/51d2XVQ2
pfgWL/NWNHdkSiDxabbfq8H5c6T4RuhkHjOkqq+sbzxIpIYNXRV7v6ozRcOhWA/I
VA6tEZgJSOaMI4IStjd1
=j6CU
-----END PGP SIGNATURE-----

--TEa6N4VuTM5UTtJxX4q7gwIjlbGnM4VQx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
