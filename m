From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/cma: cma_match_net_dev needs to take into account
 port_num
Date: Tue, 22 Dec 2015 15:01:28 -0500
Message-ID: <5679AC18.4070002@redhat.com>
References: <1450710084-22547-1-git-send-email-matanb@mellanox.com>
 <56792A4B.8060101@mellanox.com> <56799D61.9010206@redhat.com>
 <CAAKD3BDmenFsiZTDiw8OEW-F0GqK62+zJ-TVywyYd4YDtzxrCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CKCkrIHpDRqX8ighXEPKEUO759gWLkfEj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BDmenFsiZTDiw8OEW-F0GqK62+zJ-TVywyYd4YDtzxrCA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CKCkrIHpDRqX8ighXEPKEUO759gWLkfEj
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/22/2015 02:26 PM, Matan Barak wrote:
> On Tue, Dec 22, 2015 at 8:58 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> On 12/22/2015 05:47 AM, Or Gerlitz wrote:
>>> On 12/21/2015 5:01 PM, Matan Barak wrote:
>>>> Previously, cma_match_net_dev called cma_protocol_roce which
>>>> tried to verify that the IB device uses RoCE protocol. However,
>>>> if rdma_id didn't have a bounded port, it used the first port
>>>> of the device.
>>>>
>>>> In VPI systems, the first port might be an IB port while the second
>>>> one could be an Ethernet port. This made requests for unbounded rdma=
_ids
>>>> that come from the Ethernet port fail.
>>>> Fixing this by passing the port of the request and checking this por=
t
>>>> of the device.
>>>>
>>>> Fixes: b8cab5dab15f ('IB/cma: Accept connection without a valid netd=
ev
>>>> on RoCE')
>>>> Signed-off-by: Matan Barak<matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>
>>> seems that the patch is missing from patchworks, I can't explain that=
=2E
>>
>> I've already downloaded it and marked it accepted.
>>
>=20
> Thanks Doug. Would you like that I'll repost the patch with the commit
> message changed as Or suggested or is the current version good enough?

I rewrote most of the commit message myself.  It now reads as such:

commit b00a1609f845df4c75bc62f56d0d71a01fe87cc6
Author: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Mon Dec 21 17:01:24 2015 +0200

    IB/cma: cma_match_net_dev needs to take into account port_num

    Previously, cma_match_net_dev called cma_protocol_roce which
    tried to verify that the IB device uses RoCE protocol. However,
    if rdma_id wasn't bound to a port, then the check would occur
    against the first port of the device without regard to whether
    that port was even of the same type as the type of port the
    incoming packet was received on.

    Fix this by passing the port of the request and only checking
    against the same port of the device.

    Fixes: b8cab5dab15f ('IB/cma: Accept connection without a valid
netdev on RoCE')
    Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


> Regarding the Ethernet loopback issue, I started looking into that,
> but as Or stated, it's broken even before the RoCE patches.

Sure, let me know if you root cause it, I'd like to get it into 4.5 if
possible.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--CKCkrIHpDRqX8ighXEPKEUO759gWLkfEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWeawYAAoJELgmozMOVy/dlroP/j8BvYS8xtCnEtjEAgTrJRsK
bWlyhIn4iIhr58NuiAJHND5orCfR1Dngaj1sOsUXl7vFB6mtnnn+zM48c3ekoBNB
7Wwn6D/oYefqW8oRQZC5FXSBNajzRGLvAYXqFe4lnThZ7BNbs9JhVNqTL3VDAsTY
nU/jsPP0rz7wK6rpFM2L3d0/CnLt4/LnxAxxR43P+YZ2hdCmrnsogE4Cp6fdl9SJ
uJV9mdJpHVMqOxGXTnxLGVTpS+woWZWlhMeDMrLuWB1I8HGjSOId6uost1rFahWS
7qbKdnhDNuCbj20FDCmWNx5zptExlDzmVk5gmPstB7WgdwOipmBERyXlf67Wvu+J
1wKeKbqf30NjKzggdX7TK21wEWNTy/6FRX4CDxpHoart4tZKZ3/fLV68L3AmnGk/
Vy6r0GY/wNgzJTgKpSx+0sdkwiiPr0BRjOt+eEtFlyNn+UA/xAkfVvkBtuuu/V2E
VPo5YJY5iSrTR7IKeg5ftXIekZCXevFrQTBskXRP+W2KoKiHU6Lz6in07hXkO3z7
wWhKenRfPJBTYohuH+iWcUsAxJaWy4GgglB2P7/6i9Y5KsU3J/zsxEJYsQeazFPy
hktpS6Q7w5n/ysAo4jmUXkGbYwGcdWK9HHeKnwz0eR8Ki/2CmogRvHPqOZ3VomcB
p3c4atS+G5NvB+vANWII
=iF3r
-----END PGP SIGNATURE-----

--CKCkrIHpDRqX8ighXEPKEUO759gWLkfEj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
