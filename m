From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address resolution
 module into core
Date: Wed, 18 May 2016 10:20:15 -0400
Message-ID: <011bd101-0a00-d9b2-b261-48783ea1bfbe@redhat.com>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
 <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
 <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
 <20160516163048.GB4662@leon.nu>
 <298657b0-6e57-745b-5eb3-001984bffbc3@redhat.com>
 <20160516182743.GF7248@obsidianresearch.com>
 <5045d314-e2f5-bda6-5583-2212335593fd@redhat.com>
 <20160518044119.GH4662@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="C9qtV0uAhEwsvPi65uI8wQQ6W8iC5sv0N"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160518044119.GH4662-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C9qtV0uAhEwsvPi65uI8wQQ6W8iC5sv0N
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/18/2016 12:41 AM, Leon Romanovsky wrote:
> On Mon, May 16, 2016 at 02:39:10PM -0400, Doug Ledford wrote:
>> On 05/16/2016 02:27 PM, Jason Gunthorpe wrote:
>>> On Mon, May 16, 2016 at 01:42:34PM -0400, Doug Ledford wrote:
>>>> Can you build netlink in and then init the ib_addr module after the
>>>> netlink init is complete?  Wouldn't that resolve the dependency orde=
ring
>>>> issue without changing the module names?
>>>
>>> Why are you so worried about ib_addr's module name? Is that actually
>>> hand loaded instead of relying in the implicit dependencies???
>>
>> It's hand unloaded.  Depending on the release of software you are
>> talking about, the init script has the ability to unload/reload the IB=

>> stack.  In that case, it has to know about ib_addr so that it can unlo=
ad
>> after ib_core.  I should know, when the order changed from ib_core fir=
st
>> and ib_addr second to the opposite it broke the Red Hat init script fo=
r
>> a release, including all the bug reports about the rdma stack failing =
to
>> shut down properly because it was unloading modules in the wrong order=
=2E
>> This falls in the same category of a lot of other things: you don't
>> break user space if you don't have to.
>=20
> I think the reason that this thread fails to die is our trouble to
> understand if code refactoring is enough justification to get rid of al=
l
> these modules.
>=20
> All guides/scripts which I saw, instructs to load all these ib_...
> modules together and it looks redundant to have such large number of
> them [1].
>=20
> [1]
> http://www.rdmamojo.com/2014/11/08/working-rdma-ubuntu/#Starting_the_RD=
MA_services

I've never heard of rdmamojo before...interesting.

Anyway, it probably is true that the number of modules is superfluous.
I'm not arguing against that.

>>
>>> Is failure to load a module going to break any existing scripts?
>>>
>>> Worse comes to worse, just make dummy empty ib_addr.ko, but
>>> I've never seen that in-kernel before.
>>>
>>> Jason
>>>
>>
>>
>> --=20
>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>               GPG KeyID: 0E572FDD
>>
>>
>=20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--C9qtV0uAhEwsvPi65uI8wQQ6W8iC5sv0N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPHofAAoJELgmozMOVy/dCXcP/AmP+k7Ok050VLgghA4fftia
AUmHqqFxrxlg/LIoP8qloA2pQ5CVryK72xAAu0zYX5HaD+A082BbRgA1N8nqRe6w
bhxx1w98Wh7ZQadO57UALUeMHf2FlyGe3lvNybPbJ1xkYrslLJontkFiCNvVoe80
cqR/7gSyGE7Jb+VObAXTkFXw+GqGty/gWmVJm5P8tGAc4hjY8YSIWZyKwIk7TGXz
9Eg0oMycZCtZIBlugqXgtkw8i3sO+BuV9Bq3uyYdciEGVnDSdoPQdCwagqBJmb5b
jex/u+yyusw15XoWnmxstZWmLIh0855fC96Dtv/g8V0QCQhMxSxCwlrGhDvwdqV8
2i+Q9uATBM/HWpNqRA7RHwWQmnfyvfyKRplsoHRvnD9VDk1g2xlxQ7/0jqpZn7tX
5dTST/YB0Wqc2+pxcvgDwgDmFG+66WTcD9Iu2f5N5MkEy32xSmkXtRr/JWsFPhXG
P0J2omom8bMSVabGwI2UH68QdFs03X55880vRyLvIwm2dh1cN3doQU/+8DcbWIPp
v/f9PdUlPv6SarU0/CQsPVpstWkbLKog2tF8azGgJ4isXko4Vtb4DZbPLs+fP+AP
cWdcRNwOgbLxhgLA3qE9Fd31dADDolYoYzgewm+4CxWn7eBN7yj0tbqMdfe1ahFN
eI5GoXwaTx4oWWEvjOnD
=6njJ
-----END PGP SIGNATURE-----

--C9qtV0uAhEwsvPi65uI8wQQ6W8iC5sv0N--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
