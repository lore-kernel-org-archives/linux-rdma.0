From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc V1 1/4] IB/rxe: Fix kernel panic in
 udp_setup_tunnel
Date: Wed, 7 Sep 2016 12:02:21 -0400
Message-ID: <ae488c26-3747-b2f7-feac-9f2b83c8d4ca@redhat.com>
References: <1473246247-16536-1-git-send-email-leon@kernel.org>
 <1473246247-16536-2-git-send-email-leon@kernel.org>
 <CAJ3xEMhskkpCprziZUZQJWUVvwc_3_MSbJco_bOyuSrwDYXFwQ@mail.gmail.com>
 <20160907121303.GD18398@leon.nu>
 <CAJ3xEMguukA63m0T9VnXxXkWcmEfRsJeuoDn1NG7RDjm9kZL_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HO41WI59h3o1GD3XXBIB3pEfWPM5jvFva"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMguukA63m0T9VnXxXkWcmEfRsJeuoDn1NG7RDjm9kZL_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HO41WI59h3o1GD3XXBIB3pEfWPM5jvFva
Content-Type: multipart/mixed; boundary="VvaTNc367pbDLPNvn94MhUDkChf3EkV96";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <ae488c26-3747-b2f7-feac-9f2b83c8d4ca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc V1 1/4] IB/rxe: Fix kernel panic in
 udp_setup_tunnel
References: <1473246247-16536-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1473246247-16536-2-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <CAJ3xEMhskkpCprziZUZQJWUVvwc_3_MSbJco_bOyuSrwDYXFwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <20160907121303.GD18398-2ukJVAZIZ/Y@public.gmane.org>
 <CAJ3xEMguukA63m0T9VnXxXkWcmEfRsJeuoDn1NG7RDjm9kZL_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAJ3xEMguukA63m0T9VnXxXkWcmEfRsJeuoDn1NG7RDjm9kZL_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--VvaTNc367pbDLPNvn94MhUDkChf3EkV96
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/7/2016 9:19 AM, Or Gerlitz wrote:
> On Wed, Sep 7, 2016 at 3:13 PM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> w=
rote:
>> On Wed, Sep 07, 2016 at 02:20:50PM +0300, Or Gerlitz wrote:
>>> On Wed, Sep 7, 2016 at 2:04 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wro=
te:
>>>> From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>
>>>> Disable creation of a UDP socket for ipv6 when
>>>> CONFIG_IPV6 is not enabeld. Since udp_sock_create6()
>>>> returns 0 when CONFIG_IPV6 is not set
>>>>
>>>> [   46.888632] IP: [<c220705a>] setup_udp_tunnel_sock+0x6/0x4f
>>>> [   46.891355] *pdpt =3D 0000000000000000 *pde =3D f000ff53f000ff53
>>>> [   46.893918] Oops: 0002 [#1] PREEMPT
>>>> [   46.896014] CPU: 0 PID: 1 Comm: swapper Not tainted 4.7.0-rc4-000=
01-g8700e3e #1
>>>> [   46.900280] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)=
, BIOS Debian-1.8.2-1 04/01/2014
>>>> [   46.904905] task: cf06c040 ti: cf05e000 task.ti: cf05e000
>>>> [   46.907854] EIP: 0060:[<c220705a>] EFLAGS: 00210246 CPU: 0
>>>> [   46.911137] EIP is at setup_udp_tunnel_sock+0x6/0x4f
>>>> [   46.914070] EAX: 00000044 EBX: 00000001 ECX: cf05fef0 EDX: ca8142=
e0
>>>> [   46.917236] ESI: c2c4505b EDI: cf05fef0 EBP: cf05fed0 ESP: cf05fe=
d0
>>>> [   46.919836]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
>>>> [   46.922046] CR0: 80050033 CR2: 000001fc CR3: 02cec000 CR4: 000006=
b0
>>>> [   46.924550] Stack:
>>>> [   46.926014]  cf05ff10 c1fd4657 ca8142e0 0000000a 00000000 0000000=
0 0000b712 00000008
>>>> [   46.931274]  00000000 6bb5bd01 c1fd48de 00000000 00000000 cf05ff1=
c 00000000 00000000
>>>> [   46.936122]  cf05ff1c c1fd4bdf 00000000 cf05ff28 c2c4507b fffffff=
f cf05ff88 c2bf1c74
>>>> [   46.942350] Call Trace:
>>>> [   46.944403]  [<c1fd4657>] rxe_setup_udp_tunnel+0x8f/0x99
>>>> [   46.947689]  [<c1fd48de>] ? net_to_rxe+0x4e/0x4e
>>>> [   46.950567]  [<c1fd4bdf>] rxe_net_init+0xe/0xa4
>>>> [   46.953147]  [<c2c4507b>] rxe_module_init+0x20/0x4c
>>>> [   46.955448]  [<c2bf1c74>] do_one_initcall+0x89/0x113
>>>> [   46.957797]  [<c2bf15eb>] ? set_debug_rodata+0xf/0xf
>>>> [   46.959966]  [<c2bf1dbc>] ? kernel_init_freeable+0xbe/0x15b
>>>> [   46.962262]  [<c2bf1ddc>] kernel_init_freeable+0xde/0x15b
>>>> [   46.964418]  [<c232eb54>] kernel_init+0x8/0xd0
>>>> [   46.966618]  [<c2333122>] ret_from_kernel_thread+0xe/0x24
>>>> [   46.969592]  [<c232eb4c>] ? rest_init+0x6f/0x6f
>>>
>>> what an unnice way to settle a review discussion. I replied to all
>>> your arguments explaining
>>> why the change log has to go, and the next step is to ignore this
>>> discussion and do it again
>>> wrong w.o replying? so... again:
>>
>> Or,
>>
>> You didn't like the format of commit message, while I liked - that's
>> all, it is the end of discussion.
>=20
> I made **concrete** **arguments** replying to yours why to my opinion
> the oops stack listing doesn't help anyone

Your arguments were wrong though.  I myself have gone flipping through
git commit messages looking for a fix for a specific issue.  Having at
least the signature call trace in the commit message is very useful to
someone in that position.  *I* want the trace in the commit message.  I
may trim it down to just the relevant signature backtrace, but I would
still like it there.  So let's please drop this and move on.

 and hence doesn't belong to
> the kernel logs and need not be there forever. This is not liking thing=
, this
> is technical talking thing.
>=20
>=20
>> We are not in debate club here and while commit messages are
>> important, the code and bug fixes are much more.
>=20
> so strip this stupid stack trace which helps no one and set the patch f=
ree.
>=20
>> Do you think that there is something in the code which needs to be
>> addressed before Doug's take this patchset and releases RXE with
>> less unaddressed issues?
>=20
> yes, see my comments to the rest of the patches of the series, some
> small fixes are needed.
>=20
>=20
>>> Moni, can you please put your maintainer say here.
>=20
>> You are sitting next to him and you can freely ask him if he reviewed =
it.
>=20
> Your assumption is (1) wrong and (2) irrelevant to this discussion
>=20
>> The answer will be YES. Moni reviewed first version and I reviewed
>> the second one.
>=20
> There's a reviewer discussion on a patch for a driver he (and not you)
> maintain,
> he has to put his maintainer say.
>=20
> Or.
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--VvaTNc367pbDLPNvn94MhUDkChf3EkV96--

--HO41WI59h3o1GD3XXBIB3pEfWPM5jvFva
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIbBAEBCAAGBQJX0DoNAAoJELgmozMOVy/deGQP+OPttFq6kRRXm9BsuCxT2Uoo
iJYe1MqThXyPEgNPA46Ck9kYG0Q0D2iYNlNv1YrSgvbjDQA3zbGlI00a4Q7h0B9p
0TnCk/q0tcnVr6tW/hLKoel/syxXoUPhOuCBYN5GxXub6Qhe3eBd1TX/Ki/ihPUh
KoG4hAVNHUhPsZSu+w9DFGDmWX//7jxEpIxkfM2xQ+F6VL0a859HHLTicdTDbxLo
v7cqXxQctB01X9drrvgoEcFuaWuIeF7unT/M5bI6z2Wf8RFrr+cDHfORCJQUKDzn
bHXcgb+8337hFVoEAFFaIJvMgaB7XhkNqwo5RdceQcb7nIhNJZEBGfPXxHoNLD0I
cG2CH9jhdSPk9fddOns9dGFk6jTBd8FqmaoDfk5FHsnO74Ib3wRgSHKFb2gHWXSk
uoFpB1sI+uykEAuNyNWJn3X4aCzMjaeRKMz5FtRJX7ZwWUfCLAmvgtkk9u8h0ByD
D1ZUDIb+Q8oewTnIvNuv0s93yz8La5/iAHEM2yGpT/uCZ1GFi8VBJF75Kg8vPw1u
0RCk1JYuj9U8j/MhVgAhEPF1AnH3r1cTGmZJbnMdPLsHoeETNOsf/XoZ6EO6W5DE
tv+RyoeSaBkueZF1WdCnNZoBElkOBqz7g/AKHM5EBmafukphVPgDDtbblIIb8NlP
ADg5pfQ5kdg+HXSfvo0=
=FU1O
-----END PGP SIGNATURE-----

--HO41WI59h3o1GD3XXBIB3pEfWPM5jvFva--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
