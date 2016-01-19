From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv3 for-4.5 0/2] iw_cxgb4: Fixes static checker warnings
Date: Tue, 19 Jan 2016 15:53:23 -0500
Message-ID: <569EA243.3000902@redhat.com>
References: <1452596602-9952-1-git-send-email-hariprasad@chelsio.com>
 <004701d14e10$969fe6c0$c3dfb440$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9kGlpPkt3DD1aVBVLv4glvuCH9aTggBlQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <004701d14e10$969fe6c0$c3dfb440$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9kGlpPkt3DD1aVBVLv4glvuCH9aTggBlQ
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/13/2016 09:42 AM, Steve Wise wrote:
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner@vger.k=
ernel.org] On Behalf Of Hariprasad Shenai
>> Sent: Tuesday, January 12, 2016 5:03 AM
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org; leedom@chelsio.c=
om; nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; Hariprasad Shenai
>> Subject: [PATCHv3 for-4.5 0/2] iw_cxgb4: Fixes static checker warnings=

>>
>> Hi,
>>
>> This series fixes static checker warning's and fixes GW-Basic name lab=
els
>> to meaningful ones.
>>
>> This patch series has been created against Doug's linux tree and inclu=
des
>> patches on iw_cxgb4 driver.
>>
>> We have included all the maintainers of respective drivers. Kindly rev=
iew
>> the change and let us know in case of any review comments.
>>
>> Thanks
>>
>> V3: Add the 'Fixes:' tag with the first 12 characters of the SHA-1 ID,=
 and
>>     the one line summary for Patch 1/2
>>
>> V2: Dropped an error message in Patch 1/2 ("iw_cxgb4: Fixes static che=
cker
>>     warning in c4iw_rdev_open()"), and updated commit message to be
>>     consistent. Based on review comments by Leon Romanovsky <leon@leon=
=2Enu
>>
>> Hariprasad Shenai (2):
>>   iw_cxgb4: Fixes static checker warning in c4iw_rdev_open()
>>   iw_cxgb4: Fixes GW-Basic labels to meaningful error names
>>
>>  drivers/infiniband/hw/cxgb4/device.c | 53 ++++++++++++++-------------=
---------
>>  1 file changed, 21 insertions(+), 32 deletions(-)
>>
>> --
>> 2.3.4
>>
>=20
>=20
> Series looks ok.
>=20
> Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>=20
>=20
>=20


Series applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--9kGlpPkt3DD1aVBVLv4glvuCH9aTggBlQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqJDAAoJELgmozMOVy/dWyQP/j85bobhX0tTNslZ0pOUcby1
Qha3C74qXJzzmavkBp12A33FWO1wYPTU/1OLlfBmXysdOeGIed11ComGYUve6hQK
YWjg+OFwTgE4UbbWZ6PgM1LgdvmO14ojYdqWZLh4hpq3LkfmTuGvTrnV03WdXQ9m
VaqpxXn/sQKis3xbrjox6JBkvpGxCyMDX4vvKomIuwwiYQSPaf8oryWHfyza3eyN
U5MK7AnWgUHCg71ML1TlysiqtS8L7oVvOB+8ih3153XB3xXRiW50DMQrWgfeUV8Z
9ipcPo5fiZrrYYktEsW7nb+54qrGx3Sc3P3Lv2hGRSdoRFyj/oKcX9LRQ2t+3/JH
3MBdTd6L2yZosDv9mvENcEY0Z/YJOuhJly6LMcw4c1hUay6N5w4VyD/vDPsg/dMk
OTz9R4dUF8RToWkXv6nNJCZ4/UvYmGD6neNMtvJabcXFygKKG3kifu08tCCY8YkF
0PZGoNooMpo2YPQAYzdDi1sMmMlEPuuFF0boRhhvtBYqsSxVSonRD8gEvrzS0G6/
/7lfc90p+3V557rFbvK83HVbiG7oEt8+Y0GarJ0VKvqwJhmIDTytTxE8edlMcbP/
HipAID4ESsvS7FIXr9YWAPK2vXaHpqZz31ypwWfyYHnF279M2q5crU6r4Uo7JAPK
XwUJ62569AKCTIanqyPF
=nVWf
-----END PGP SIGNATURE-----

--9kGlpPkt3DD1aVBVLv4glvuCH9aTggBlQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
