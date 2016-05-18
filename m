From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address resolution
 module into core
Date: Wed, 18 May 2016 10:20:45 -0400
Message-ID: <5e55ee8b-7cc2-84d4-af1e-d995aecc8ff5@redhat.com>
References: <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
 <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
 <20160516163048.GB4662@leon.nu>
 <298657b0-6e57-745b-5eb3-001984bffbc3@redhat.com>
 <20160516185434.GC4662@leon.nu>
 <82b21da8-8bec-a7ed-fc48-b7570c0aa4ce@redhat.com>
 <20160517054834.GD4662@leon.nu>
 <910c3e4c-2427-34c4-cc42-f8e951c7d157@redhat.com>
 <20160518044709.GI4662@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2UJBht5pfCtKmbnaVDhvI9WEecECRJTpx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160518044709.GI4662-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2UJBht5pfCtKmbnaVDhvI9WEecECRJTpx
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/18/2016 12:47 AM, Leon Romanovsky wrote:
> On Tue, May 17, 2016 at 10:58:19AM -0400, Doug Ledford wrote:
>> On 05/17/2016 01:48 AM, Leon Romanovsky wrote:
>>> On Mon, May 16, 2016 at 04:27:05PM -0400, Doug Ledford wrote:
>>
>>>> It's not removing two lines.  If someone wants to be able to boot bo=
th
>>>> kernels prior to this change and kernel post this change, they have =
to
>>>> now write their script to handle both conditions sanely.  And they h=
ave
>>>> to know to do so, where as very often they simply get caught off gua=
rd
>>>> and things are broken for some period of time.  If the change to ib_=
addr
>>>> actually solved a problem that couldn't be solved otherwise, that wo=
uld
>>>> be one thing.  But it doesn't.  It's a complete no-op.
>>>
>>> I think that your position is too tight for not allowing modules
>>> restructure. It looks like that this complexity doesn't exist outside=

>>> testing scripts.
>>
>> No, they were/are production scripts.
>>
>>> For my testings, I'm using Debian Sid with inbox scripts/packages and=
 it handles
>>> correctly IB stack with different kernels and different set of module=
s.
>>
>> Does it support reloading the stack and have you tried it if it does?
>=20
> It is RedHat specific, from my understanding in other distribution ther=
e is no
> special script to reload RDMA, I wrote for myself module reload script
> for debug.

Then I guess I was just nice to developers back in the day.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--2UJBht5pfCtKmbnaVDhvI9WEecECRJTpx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPHo9AAoJELgmozMOVy/dCqgP/26FJYr5XdIaTeHVNNFh+e8B
secoRp1akmEEWtqarEv5ZJmLaO+57w4/B+Niu003yTWEPhPeaxtliqgui39WUL29
6O3TiNQmc51T+UVPq6f/m+Yr9pQyTKI4vLGRZ17Vy87Kcodkux+ZhrFZ625zXo7r
YjKrLsmknaKJIxpuHFzy89FGuyeIHkcBNykGVMy3w8qblMweNOsg6dASKk4VqYoQ
SFdBsuy0+iUaTUQ1aL+DPJgbDrPGsXpYSDjb2eC+eLXGNHSmGpUwy/LALoRxQruL
VLyQAomMTac26EXM+0emEfbAaiLV9/s72SRUkSyk0hsfokkyjNUUiNDMELLuBWdh
GvoiT7vXuFDVT2IejV8uFdalx+Ch9JALgAZikQAlTtd/nIICUVafUhGJhymGidiq
lW/ZN+difH+PbgS1/5DDWGXkkD33onqrXyeSOsPkNqCxeh5kMstWW/8ikHLlU1Yd
MvtoGMdlmShreraAmdG/PjunzMZ55o6WvP5OcSYtWkX4L3rnDK9GMieeD7ozWb8H
or/5opluA/25kDmDcj5C6YW9XtWOJ7C0etFDB0Dhab3qBazwEp1ieXYKcqFIsfvW
8kJx9dd3deuPECKzGMpgHsPJ11hXYHv9A0GnVc2Tmp87FgyiRuXC26wT43YulNC7
tYzXBFsfV1FWc/S/zIy4
=0eYN
-----END PGP SIGNATURE-----

--2UJBht5pfCtKmbnaVDhvI9WEecECRJTpx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
