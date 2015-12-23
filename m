From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/cma: cma_match_net_dev needs to take into account
 port_num
Date: Wed, 23 Dec 2015 11:08:04 -0500
Message-ID: <567AC6E4.3030100@redhat.com>
References: <1450710084-22547-1-git-send-email-matanb@mellanox.com>
 <56792A4B.8060101@mellanox.com> <56799D61.9010206@redhat.com>
 <CAAKD3BDmenFsiZTDiw8OEW-F0GqK62+zJ-TVywyYd4YDtzxrCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9i1MsBFK2asHnM8DfkQc7gMFQvbC4i259"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BDmenFsiZTDiw8OEW-F0GqK62+zJ-TVywyYd4YDtzxrCA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9i1MsBFK2asHnM8DfkQc7gMFQvbC4i259
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
>=20
> Regarding the Ethernet loopback issue, I started looking into that,
> but as Or stated, it's broken even before the RoCE patches.

Ping.  Any progress on this?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--9i1MsBFK2asHnM8DfkQc7gMFQvbC4i259
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWesbkAAoJELgmozMOVy/dQgQQAJWwxOqPhMhYsVuMdjbvvtAw
RAMwgpN6sry6Ylz124/Y8c1kwwpoG5DO10fpWE2dJbIq2EKvXsRevLXSww0ju8sm
O/UL81Kfd1B9DgAU5bQDOrMuzPco7A27OpZvKn7G4tsDAnGRXaF0QnIgtK/lhWFH
l6x4d8xRqfDQVL2DLst2u5bK5bKFEWUdrSGU/4ndBggnqLVv+6Mog+SR/Qq8ublh
5xlmlYaiBawY8nRrzjI4ZXZsD2Tz83vxekUZ9jc2sB20ohn+9F9ayeGyXfSjvwNE
hQLzvtwk+EWPZwAtLeWkllMKKp9hos8++BQ7iSYGsX76Wl1a0aDfriZ1fv1oI1ph
KbxMXAYwEwzNfNVAzKwiCeY8KT/TLrXjlufIOiyLQocbWkCTUzCIs5FWrSN4i16W
x7lPKq2clg13f5ELs1v2njUEmuAEuSc8T3bs44EIB0xR+OJ2TjP+Uw74GB2PVzY1
idC2WkkoCERbmHkBtv3DuyzrDnyqWk3DWWKPs4bhug2oFgaZQCUT7XPv4t6mpL02
ukhB/j83KNHI4eoap0RAk1FFUqIeqKjzTtuts1xOICv3RTdiO/1YweNXR2LsdyiP
I6eoLvj6E2rVPNo0yag/JCC8T2/fDRX8xfJSo5c1AfhwZYoQiVBCpheNbjm3aE1L
ieKqsaXQmjhyHIah7O0U
=zFpp
-----END PGP SIGNATURE-----

--9i1MsBFK2asHnM8DfkQc7gMFQvbC4i259--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
