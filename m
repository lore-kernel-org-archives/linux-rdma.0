From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb3: fail get_dma_mr if the memory footprint can
 exceed 32b
Date: Fri, 24 Jul 2015 10:55:42 -0400
Message-ID: <55B251EE.3030806@redhat.com>
References: <20150722191417.9306.17387.stgit@build2.ogc.int>
 <55B15D7D.3090601@redhat.com>
 <00d501d0c599$84afdb50$8e0f91f0$@opengridcomputing.com>
 <55B24F65.5040103@redhat.com>
 <008b01d0c620$05dce480$1196ad80$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wNQhHAGsIQbRIASecIHTKoLdB3HNloNPa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <008b01d0c620$05dce480$1196ad80$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wNQhHAGsIQbRIASecIHTKoLdB3HNloNPa
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 07/24/2015 10:50 AM, Steve Wise wrote:
>=20
>=20
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner@vger.k=
ernel.org] On Behalf Of Doug Ledford
>> Sent: Friday, July 24, 2015 9:45 AM
>> To: Steve Wise
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: [PATCH] RDMA/cxgb3: fail get_dma_mr if the memory footpri=
nt can exceed 32b
>>
>> On 07/23/2015 06:47 PM, Steve Wise wrote:
>>>> -----Original Message----- From: Doug Ledford
>>>> Should this be a static check of the pointer size versus installed
>>>> memory?  Would it be possible to have this work for machines with
>>>> less than 4GB of physical memory even if they have 64bit pointers,
>>>> or are you concerned that hotplug memory could take us over the
>>>> limit after registration and cause problems?
>>>
>>> NFSRDMA doesn't need dma-mrs for T3 since it has FRMR + local dma
>>> lkey support.  And since the deficiency really can cause problems on
>>> 64b systems if the memory grows > 4GB after dma-mr allocation, I
>>> decided to just not allow them for potential large memory systems.
>>
>> Ok.  I've pulled this for 4.2-rc then.
>>
>=20
> The problem has been there since day one, so it doesn't represent a reg=
ression.  It is your call, but I think 4.3 is fine.

It's a long standing problem, but it's a potential memory wrap issue, so
might as well fix it (especially given the simple nature of the fix).
I've got a few other things heading in for 4.2-rc, so no biggie.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--wNQhHAGsIQbRIASecIHTKoLdB3HNloNPa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVslHuAAoJELgmozMOVy/dfPkQAMD2z25Jk9KsjISdspXsRMRR
TG7iQq54XUh+oR4TyFvi0kjwZGb5s7EBQjHcI35/s3ngS8vv6iNcA/cZmxTeOXTP
nOetX4hBl0k15pQXdhBP5tbgbmqCx9Jjxippiv20p9QuFWUUJz6TWkcBXvlIIYtX
lK6wIsZra7IGen79bXfpkpKBqjxwzhemciGdYN3a8oa5JXlK7CwgCNLBLr+jL6AM
QS2eMB7joz9ruwnald1ZISR85oS5PMnm8OKdvSvcd3Tokkmr5lMuDfG3VXhewyYF
s5+2l8rVIvZFwB/jWoCa27+aDVl+6gm0me6awm/0h2k5Vg9FTIz/F8DdlfY+Tstg
SmRSp+VmKfWGmmmpt/EIfET43d/TSUr+eH3Lz8ZdQXYjiioVpd9Mnl7C38XXgizD
/R5Wq5/WIoHN+5m/ab0450hjjxv3iC7J6a68UcnMjR57/gjoq0v1+tZVnYoUxrTC
+AIk2E23YkuOzVCWh5jXgpkhiZn1RFHjIWdpAtHSmmllT2th9+DTdOpJ3n2yh4wl
ch3W23NG3ACbj6Jx4vEIbX+Jzun1BIgpbb8sq3hmU3sS0sAwRdNqzwtQ6rFFeYhL
uGXOjIe2rurDJEeWUBQ6aXoamZ2C2leEbjN8EDV5TMJiLUAQQrI3lv5ELcEkjQ9n
hGSTMvo6N5hNTWjqoOJR
=FVUV
-----END PGP SIGNATURE-----

--wNQhHAGsIQbRIASecIHTKoLdB3HNloNPa--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
