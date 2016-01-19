From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB/core: sysfs.c: Fix PerfMgt ClassPortInfo handling
Date: Tue, 19 Jan 2016 16:20:50 -0500
Message-ID: <569EA8B2.80607@redhat.com>
References: <568263DF.6020505@dev.mellanox.co.il>
 <56827AB7.50508@mellanox.com> <568280BE.8030005@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="76U59TjKOm1MbDvGIBKs0R8BLCnUcKwVW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <568280BE.8030005-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--76U59TjKOm1MbDvGIBKs0R8BLCnUcKwVW
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/29/2015 07:46 AM, Hal Rosenstock wrote:
> On 12/29/2015 7:21 AM, Or Gerlitz wrote:
>> On 12/29/2015 12:43 PM, Hal Rosenstock wrote:
>>> This handles issue pointed out by Matan Barak <matanb-LDSdmyG8hGUWn1LaSxwUnA@public.gmane.org=
=2Eil>
>>>
>>> Fixes: 145d9c541032 ('IB/core: Display extended counter set if
>>> available')
>>>
>>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> again, remove the blank line after the fixes tag.
>>
>> Also,  I am not that the way Doug is setting the branch for pull would=

>> preserve commit IDs when
>> the offending patch landed in Linus tree. If this is the case, we shou=
ld
>> put your patch in 2nd pull
>> request and have the right commit ID there. Please check with Doug.
>=20
> Doug ?
>=20

The commit id should be preserved as long as the commit ID you reference
is from my k.o tree and a k.o/ branch.  It only changes if I rebase, and
I don't do that on k.o branches that I've pushed to k.o (I have,
however, once rebased a k.o/ branch that I had only pushed to
github...and I try not to do that and will try even harder in the future
not to, but I did do it once).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--76U59TjKOm1MbDvGIBKs0R8BLCnUcKwVW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqiyAAoJELgmozMOVy/diycQAK0jQyRH8PrZgXvsKW0u+STR
D2FjeHtZm9m8ShugDibL5zMM9IEkwsSq+222SWpJRnMiXrVxqo/MS7z6fQKFGQ2k
Tt8xNazFQHLOksAlDSGMbq8T/pehAm5kNoVkJT4MRGqM/CePW5Cyja7vdIZundqD
0KEYrUfP1msAec0LSDmenNGfAHVRKjCVwt6vBw9qEqJPBD0y/VkaA5f1yTFYyXmn
5Cvys5itUm9s6y6RlQuAz1BMzVHiZcmkFQrPQTNmZuDYL7VvyEklvELOLZrd20Rf
b9cnxOVkCgaa2W3RIJ/JjM2S3+daNoWYwwF6bt2IgHaRRGMaFxrYOdc6DDGFCO9M
On9PD3RGsNQG02iBXiIkLcOt+Gz5k6nDXunSn2amDyzh1HHnc/gGVScHuY6ivT0n
TK2spq49o5EyLTtGhAizH4PnEOoSErAkWdZgORfyfj2Efa2gkbFzsk0K0rBYOYag
yAkmrVsmnKNHJ6XhkrepP6Vj9Q+/Yp64aELXFpKel3MBVXcJKcdlA99Dptj3ZGbn
JCl3bRJADKN1uLSTRkJyzqBr5+AvdRkVG7y3GY1PKiwvCC3N/ynrUO2B0egfDdLf
jMAszLWv9iEJqkWeKtUVjvZTou6KGdjMC4iVQ+FSSsuvWIO4VkECtFMQ/JfRQMI5
7cQRA1lbrhU9ATEjV0o0
=zN/7
-----END PGP SIGNATURE-----

--76U59TjKOm1MbDvGIBKs0R8BLCnUcKwVW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
