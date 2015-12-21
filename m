From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: RoCE passive side failures on 4.4-rc5
Date: Mon, 21 Dec 2015 11:56:19 -0500
Message-ID: <56782F33.4070902@redhat.com>
References: <5672BF85.6080005@mellanox.com> <567658E4.6040508@mellanox.com>
 <CAAKD3BBhjP+fO6TPPTXRhtQKmUv2Tz6RJosrn4=o2s=0by5acQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UcaE3UgU8nuROjsmrM8Km8LaqSasVWqfT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BBhjP+fO6TPPTXRhtQKmUv2Tz6RJosrn4=o2s=0by5acQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UcaE3UgU8nuROjsmrM8Km8LaqSasVWqfT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/21/2015 10:08 AM, Matan Barak wrote:
> On Sun, Dec 20, 2015 at 9:29 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wro=
te:
>> On 12/17/2015 3:58 PM, Or Gerlitz wrote:
>>>
>>> Using 4.4-rc5+ [1] and **not** applying any of the patches I sent tod=
ay,
>>> I noted that RoCE passive side isn't working (rdma-cm, ibv_rc_pingpon=
g
>>> works).
>>>
>>> I have two nodes in ConnectX3 VPI config (port1 IB and port2 Eth), th=
e one
>>> with the 4.4-rc5 kernel can act as both (rping) client/server for IB =
links
>>> but only (rping) client for RoCE.
>>>
>>> I tried both inter-node and loopback runs, in all cases, the client s=
ide
>>> getsCM
>>> reject with reason 28, see [2], tried both iser and rping. Eth (ICMP,=
 TCP)
>>> works OK.
>>
>>
>> OK, small progress, when the force Eth link type on my IB port (using =
mlx4
>> sysfs), things work.
>>
>> You should be able to reproduce it on your non-VPI systems the other w=
ay
>> around, by
>> forcing IB link type on one of the Eth ports and see the failure.
>>
>> I Saw the same behavior with both 4.4-rc2 and 4.4-rc5
>>
>> Or.
>=20
> I've posted a patch that fixes that, please take a look at [1].
>=20
> Regards,
> Matan
>=20
> [1] https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg30777.ht=
ml

I've been seeing this too in my 4.4-rc testing, so I'll have test
results today.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--UcaE3UgU8nuROjsmrM8Km8LaqSasVWqfT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWeC8zAAoJELgmozMOVy/dkKkP/iJ5nczilWnGpyKIPIygex93
hi5Yif/GK7ROH3wykkqxJq0m8lwRSl6pvqTwueyQjm1PJBvif7OFYGTonmgW9u6T
9MaGKNQ2s5YMYRx+SRDL0S/kaQkNdwQXvKX/Fb4yH4+wpLPHmz28tiN0TQ9vGHbB
fXgLXpjFDmITkm1G6vOaXfsjlUSbSX2TINQU6eul4pJgHj1hu7RMy8BDT6ArZp6q
dzz3kqbA6xzXb+HIuISv69XKUIv5C6MLJC1tzk5kLF8emYdVHgytAwJC5x0/WnIm
24ccWP1IsFezTHbEkh2EkqLsnld73R9PmKbCH3QQr6Sr0Wu+anYRm1VVnFUuJfyr
tx6IFVslCa/DyxmSIHpr4NCBAfl1E6nqgvdpCw2s9Ajk61Cewnp+/yt0hqjipWTg
nIh7/eUmD01pMs9MkbxeRnespiorrj3LGIY/Obx7RbePQEoi91yzNeC8so9TGvjm
3UjZyhNScrj35w3tfattS/RhJcUxvlTfTV50EL4312BWClttzkNondEqwL/OqPz2
ZEnHwUP46XcWe5pg3XaqapvwbwEagnIeZghtm9eDVxrXhI04RQrpiCUrz4I6gSNj
Wrx8WlUM2Cm35+pXW+m/FNp1cXqHy2tqJnl+ricVcJV5tjsWE0oUZkTuu/QoybSb
sWVUh+rOAfEf5NtozZpk
=JaLd
-----END PGP SIGNATURE-----

--UcaE3UgU8nuROjsmrM8Km8LaqSasVWqfT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
