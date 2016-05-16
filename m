From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address resolution
 module into core
Date: Mon, 16 May 2016 13:42:34 -0400
Message-ID: <298657b0-6e57-745b-5eb3-001984bffbc3@redhat.com>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
 <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
 <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
 <20160516163048.GB4662@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MWPenGE2H42MFAxhCpK9vPBD0r6pfwM30"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160516163048.GB4662-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MWPenGE2H42MFAxhCpK9vPBD0r6pfwM30
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/16/2016 12:30 PM, Leon Romanovsky wrote:
> On Mon, May 16, 2016 at 11:09:44AM -0400, Doug Ledford wrote:
>> On 05/15/2016 06:51 AM, Mark Bloch wrote:
>>
>>>> But, just as importantly, after reading addr.c to see how it uses th=
e ibnl
>>>> infrastructure, I don't even see what the original problem can be.
>>> As it stands today:
>>> - ibnl is part of ib_core.
>>> - ib_core needs ib_addr.
>>>
>>> So if we add ibnl usage to ib_addr it means ib_addr will need ib_core=
,
>>> which causes a dependency cycle.
>>
>> Right, but in that case, this patch needs to be part of the series tha=
t
>> adds the ibnl support into the ib_addr functionality.  Because you spl=
it
>> them into separate series, this was a patch looking for a problem to
>> solve and it wasn't clear what it was.  If I had taken the other serie=
s
>> and not this series, it would have broken things.  So please keep
>> patches like this together with the other patches that depend on it.
>>
>> That said, I also don't want to redo modules if we don't have to.  As =
my
>> previous email points out, changing modules breaks init scripts and
>> systemd unit files.  It is to be avoided when possible.
>=20
> Sorry,
> I was in the mood of fixing things when I wrote and sent this patch.
> The question is which version will you more likely to accept: this one
> (remove ib_addr module) or previous one (add ib_netlink module)?

Can you build netlink in and then init the ib_addr module after the
netlink init is complete?  Wouldn't that resolve the dependency ordering
issue without changing the module names?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--MWPenGE2H42MFAxhCpK9vPBD0r6pfwM30
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXOgaKAAoJELgmozMOVy/dUhAQAKTz1dnKq1qLbineKZuaw2oZ
vSDgCAcw0rQPTbR1ZmkOs9GuRwHWmhsUGvTQD+M8zMUUpOOUGl81wrr9Iu3VjUmj
sIhWiC3mkz8zWjGssF2PF496gIQ47RwiPFjRVhcgCWA8FAq25fEdBsEApsUzUFLS
XGxFVTAtjaCyyAXcWZa/KMEUKkBh9vikIvSQ7eBiYx4+142NhYXE6CE93IMdg/fK
zLDYRhOov9+Or8NYlSv6DF+ZKbhQLF0JI4IamC0YzRtOK9ObxJ8wlPyypG43eLgC
pGpDMNmdZOQiA663gdlgB5UrBKyOKjskt+4ht20CETTVYXIP7iliMzPHna6MC4yL
0AuuKq3b4LbUUaN7JioeryhUKU1N0wH87W7ntVR7kx7hqtBlPgHilTW51/HKMh5j
yE1OsJlYXRAuINufVehVVyLJOlxsM2A7OFDnw2AuLz1fU7R6xEmXf4Z1f73iydqH
msitgQlcZwGqvuai07nG0MSFUFaOU2b804cQODXqu4G1FBSBOkX67ibZxcp1VBkL
O6Z4JQ2sfw11NDKoUdyQgLiih8l5StPw2Fn25sQGfrpbPQ+seguuly8cvAw0ogDy
LePFVHmhcD+D/MeTg3NCnU+322v5duf8E8ghbFrmDinO9si1Z6ke7O5hIsiuUQ+x
MypfPr3AVKQ+JVIvX4G8
=iHhh
-----END PGP SIGNATURE-----

--MWPenGE2H42MFAxhCpK9vPBD0r6pfwM30--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
