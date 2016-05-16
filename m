From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address resolution
 module into core
Date: Mon, 16 May 2016 16:27:05 -0400
Message-ID: <82b21da8-8bec-a7ed-fc48-b7570c0aa4ce@redhat.com>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
 <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
 <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
 <20160516163048.GB4662@leon.nu>
 <298657b0-6e57-745b-5eb3-001984bffbc3@redhat.com>
 <20160516185434.GC4662@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9qreQSbgcBOn994FLhNXOQlxxtVBLNMBW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160516185434.GC4662-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9qreQSbgcBOn994FLhNXOQlxxtVBLNMBW
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/16/2016 02:54 PM, Leon Romanovsky wrote:
> On Mon, May 16, 2016 at 01:42:34PM -0400, Doug Ledford wrote:
>> On 05/16/2016 12:30 PM, Leon Romanovsky wrote:
>>> On Mon, May 16, 2016 at 11:09:44AM -0400, Doug Ledford wrote:
>>>> On 05/15/2016 06:51 AM, Mark Bloch wrote:
>>>>
>>>>>> But, just as importantly, after reading addr.c to see how it uses =
the ibnl
>>>>>> infrastructure, I don't even see what the original problem can be.=

>>>>> As it stands today:
>>>>> - ibnl is part of ib_core.
>>>>> - ib_core needs ib_addr.
>>>>>
>>>>> So if we add ibnl usage to ib_addr it means ib_addr will need ib_co=
re,
>>>>> which causes a dependency cycle.
>>>>
>>>> Right, but in that case, this patch needs to be part of the series t=
hat
>>>> adds the ibnl support into the ib_addr functionality.  Because you s=
plit
>>>> them into separate series, this was a patch looking for a problem to=

>>>> solve and it wasn't clear what it was.  If I had taken the other ser=
ies
>>>> and not this series, it would have broken things.  So please keep
>>>> patches like this together with the other patches that depend on it.=

>>>>
>>>> That said, I also don't want to redo modules if we don't have to.  A=
s my
>>>> previous email points out, changing modules breaks init scripts and
>>>> systemd unit files.  It is to be avoided when possible.
>>>
>>> Sorry,
>>> I was in the mood of fixing things when I wrote and sent this patch.
>>> The question is which version will you more likely to accept: this on=
e
>>> (remove ib_addr module) or previous one (add ib_netlink module)?
>>
>> Can you build netlink in and then init the ib_addr module after the
>> netlink init is complete?  Wouldn't that resolve the dependency orderi=
ng
>> issue without changing the module names?
>=20
> It seems reasonable and we will test it, before reposting.

Thanks.

> However generally speaking, I agree with Jason and Ira that this module=

> (ib_addr.ko) is useless as module and can be part of ib_core.ko.
>=20
> It doesn't seem as a big deal to fix all that init scripts (remove two
> lines).

It's not removing two lines.  If someone wants to be able to boot both
kernels prior to this change and kernel post this change, they have to
now write their script to handle both conditions sanely.  And they have
to know to do so, where as very often they simply get caught off guard
and things are broken for some period of time.  If the change to ib_addr
actually solved a problem that couldn't be solved otherwise, that would
be one thing.  But it doesn't.  It's a complete no-op.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--9qreQSbgcBOn994FLhNXOQlxxtVBLNMBW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXOi0ZAAoJELgmozMOVy/dKhQP/R1R3zqSkYtuBR56Q9xL/DM2
cMrkSdo2K5fLo5926IxD62NgDdPJhetkzQkvhbuCfk+tDehWxozKuX2ydhe8ZloB
OFb7MzqlADmnWngmESYXXvtxretQxqYHLdUw4OaQEJCOEliuOr0NVCUXy9w0BzPd
5gWjMenNMfKFUd7xOiLn+2UyLh6TYR2R3ZDg879HLaISRNalC2Buw2gEfch25LLp
eYyt0GDbqg4MK1YSkrHsBDDOd3tFDWPjVZkpHHqL1YM3Lr7Zw8wIEIOEbxiCe/xB
RFb220upVrFQNv0gfj85wvewG3KXHQtva+gCPplS1wuqF9OKW8lpXGfaBzeVTKwc
Cu/b5K5ocEKvTbdHZJob7gZyxndhVm1ZnB4sSCbsgjgJHfwZxwjqFsfPJaOR2RPb
gzvym4uXhL6Fsl0dlm/JhmCyG8YQ119BWq85XUwmXM6fxtPkTdM+n3gCE7y5q2Ab
bqSQxYofXSIwysndR+wmOYje+O0EbS+7vVt+LR83JEzdKoFdIYcOuI3JgbUwbvsQ
MirwUqDvwQJaT3m5gdkUpJNSrMKpwwbUfaoXIHne6eU5hFkzLX+wx2FwqmpRyc9p
29JaZsqb1wbulXyxKQ2DamOqINQ9IPk1002BHMR9va+UPi3x1UTg1UPvEstnuEH/
kCYe30Grm/qgdYa4lp4u
=NI7T
-----END PGP SIGNATURE-----

--9qreQSbgcBOn994FLhNXOQlxxtVBLNMBW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
