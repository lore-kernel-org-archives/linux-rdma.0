From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/cma: cma_match_net_dev needs to take into account
 port_num
Date: Tue, 22 Dec 2015 13:58:41 -0500
Message-ID: <56799D61.9010206@redhat.com>
References: <1450710084-22547-1-git-send-email-matanb@mellanox.com>
 <56792A4B.8060101@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5Dvb8UE1koBlh8FEnlOU5Ob7hbnAUs3D4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56792A4B.8060101-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5Dvb8UE1koBlh8FEnlOU5Ob7hbnAUs3D4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/2015 05:47 AM, Or Gerlitz wrote:
> On 12/21/2015 5:01 PM, Matan Barak wrote:
>> Previously, cma_match_net_dev called cma_protocol_roce which
>> tried to verify that the IB device uses RoCE protocol. However,
>> if rdma_id didn't have a bounded port, it used the first port
>> of the device.
>>
>> In VPI systems, the first port might be an IB port while the second
>> one could be an Ethernet port. This made requests for unbounded rdma_i=
ds
>> that come from the Ethernet port fail.
>> Fixing this by passing the port of the request and checking this port
>> of the device.
>>
>> Fixes: b8cab5dab15f ('IB/cma: Accept connection without a valid netdev=

>> on RoCE')
>> Signed-off-by: Matan Barak<matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> seems that the patch is missing from patchworks, I can't explain that.

I've already downloaded it and marked it accepted.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--5Dvb8UE1koBlh8FEnlOU5Ob7hbnAUs3D4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWeZ1hAAoJELgmozMOVy/daSYQAJQi4Htm/hEuEe+yIgoK49TA
+40JO7BdCgzjXPg1XXhD2n+uuOFOFAvXea7DN6O4+OSDZ/pxfVnPh/xjfbPvCOpr
eJ6A2fGMleFM6Ea6J9x09KylPCBP6iXNSMkM98WDRTWdEmysS3abzD7iRgVZ+oOB
9pD1fHdoYUjNa0v3zjSpqF6vShybY4Z+srNHHyA/o+SMnBofFSWC1DEN+vb2llaJ
PXb2HBbIASYtF3ygDQf6zWYtQywEjvLjP4zWZj40KM0/7VGUh9tta240XgSf9+fS
tVWunDjfu6MpaZPYBLX6rQ8V6yPiWKhIbN0eb3QCshn1C3itNc+wa4lHAzVjA/a2
1nsmx2A5E8hU7v8tV206yPSBk7VdJSZHT3fQcGZSb+KmExoL0wvuyd1U/eCOBkSI
cxI50a0s8+PYQ1/pvmsGY2zoMDvlF0X/Ja4zqRkmdjoejp5lUd2ggziZiRCCVUma
pm6c6fySxK2u6vBySVhreo+P2Mj2mHvuV+//zdGLR+lS3dPxXfSDKIUJU5ds0y7l
8Ebir0sM9rv1PjNurFbX77prQIWI/kn5bkRmqMOOclwe0wn7/N1ocuc96SxFJUmR
soVXicJyE+sOWb2B6xrwh83IiZxbEE2o2MGzdbxgxxNgwm3nKFLio/tA/49UUeM3
HE/FEtyyl+H+hy/Mn2Fo
=a7Xv
-----END PGP SIGNATURE-----

--5Dvb8UE1koBlh8FEnlOU5Ob7hbnAUs3D4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
