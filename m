From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/4] IB/rxe: Fix kernel panic in udp_setup_tunnel
Date: Tue, 6 Sep 2016 08:05:18 +0300
Message-ID: <20160906050518.GJ21847@leon.nu>
References: <1473077359-11546-1-git-send-email-leon@kernel.org>
 <1473077359-11546-2-git-send-email-leon@kernel.org>
 <CAJ3xEMiBpGRy-JGuJ=P4eUF5zyz+2bm43F-jqPHtwm=3Uz9YYA@mail.gmail.com>
 <CAJ3xEMidqQRMqP6u+SJSJVbq0weREAtAJN=eXsA_zzS0KnQ_7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aNVUg3Xo9UgCa1D+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMidqQRMqP6u+SJSJVbq0weREAtAJN=eXsA_zzS0KnQ_7Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--aNVUg3Xo9UgCa1D+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 05, 2016 at 10:21:15PM +0300, Or Gerlitz wrote:
> > On Mon, Sep 5, 2016 at 3:09 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >>
> >> From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>
> >> Disable creation of a UDP socket for ipv6
> >> when CONFIG_IPV6 is not enabeld.
> >> Since udp_sock_create6() returns 0 when CONFIG_IPV6 is not set
> >>
> >> [   46.888632] IP: [<c220705a>] setup_udp_tunnel_sock+0x6/0x4f
> >> [   46.891355] *pdpt = 0000000000000000 *pde = f000ff53f000ff53
> >> [   46.893918] Oops: 0002 [#1] PREEMPT
> >> [   46.896014] CPU: 0 PID: 1 Comm: swapper Not tainted
> >> 4.7.0-rc4-00001-g8700e3e #1
> >> [   46.900280] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> >> Debian-1.8.2-1 04/01/2014
> >> [   46.904905] task: cf06c040 ti: cf05e000 task.ti: cf05e000
> >> [   46.907854] EIP: 0060:[<c220705a>] EFLAGS: 00210246 CPU: 0
> >> [   46.911137] EIP is at setup_udp_tunnel_sock+0x6/0x4f
> >> [   46.914070] EAX: 00000044 EBX: 00000001 ECX: cf05fef0 EDX: ca8142e0
> >> [   46.917236] ESI: c2c4505b EDI: cf05fef0 EBP: cf05fed0 ESP: cf05fed0
> >> [   46.919836]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> >> [   46.922046] CR0: 80050033 CR2: 000001fc CR3: 02cec000 CR4: 000006b0
> >> [   46.924550] Stack:
> >> [   46.926014]  cf05ff10 c1fd4657 ca8142e0 0000000a 00000000 00000000
> >> 0000b712 00000008
> >> [   46.931274]  00000000 6bb5bd01 c1fd48de 00000000 00000000 cf05ff1c
> >> 00000000 00000000
> >> [   46.936122]  cf05ff1c c1fd4bdf 00000000 cf05ff28 c2c4507b ffffffff
> >> cf05ff88 c2bf1c74
> >> [   46.942350] Call Trace:
> >> [   46.944403]  [<c1fd4657>] rxe_setup_udp_tunnel+0x8f/0x99
> >> [   46.947689]  [<c1fd48de>] ? net_to_rxe+0x4e/0x4e
> >> [   46.950567]  [<c1fd4bdf>] rxe_net_init+0xe/0xa4
> >> [   46.953147]  [<c2c4507b>] rxe_module_init+0x20/0x4c
> >> [   46.955448]  [<c2bf1c74>] do_one_initcall+0x89/0x113
> >> [   46.957797]  [<c2bf15eb>] ? set_debug_rodata+0xf/0xf
> >> [   46.959966]  [<c2bf1dbc>] ? kernel_init_freeable+0xbe/0x15b
> >> [   46.962262]  [<c2bf1ddc>] kernel_init_freeable+0xde/0x15b
> >> [   46.964418]  [<c232eb54>] kernel_init+0x8/0xd0
> >> [   46.966618]  [<c2333122>] ret_from_kernel_thread+0xe/0x24
> >> [   46.969592]  [<c232eb4c>] ? rest_init+0x6f/0x6f
>
> Hi Yoni, in this case, the trace contributes practically nothing to the
> driver and kernel maintainers, please remove it.

Hi Or,

I like your self-confident.

In this case, I asked from Yoni to add this call trace for a number of
reasons:
1. We got this call stack from external user and he wants to know that
it is fixed.
2. I'm looking on the oops posted to the list to get better
understanding if such cases exist in other places too.
3. We are in late -rc stage and kernel trace shows that it is real issue
which justifies late acceptance/pull request.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--aNVUg3Xo9UgCa1D+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXzk6OAAoJEORje4g2clinPloQANCC9cFW+w+TWsbqbc2Deb0v
dzCLLo03b1PTYaUXqzpiu0Og0kbjuwRUH4QazS0Y1Hd0WVEX8SMiUpVsTmITLmGh
4hT6vK+vHtymnlnDxaDJO7h19zTkMNYHBYdfNcR0MTFxmBtK9HABbylxxxR5dpFn
u8jSncu2J8xNZjOgwQH/M4ugLY/MBx1DEVcyzt/j/HITkaNJaD4jZ5dqKrHjDWXg
Bwsd66DCsKR7uoTOPbZuaGPdh975W//VFzUfxXLJVotzh6z9wYSs1o4nQ+nJS380
I53Y/ScXjschVNMJq7cnc0U0vU8J63IqelbpMIGp6Cd9XP+wQoDhuyDbt7B+a284
MpQa7HWNL/LgT+cBliX0TBQlWXK36nw/CxZI8gBfIaOh9MR+lDP/vLhwM6fWrwpT
R3cPCGIFtwW07UOFWeW9edwV0QIXJj8pRo4oQzzxjLiw00uz/HJ8BlepXCwWpjKT
3QuXOnZ+gIzAgpDbYDxFDhNOfaPxJhVsRUgaR95FGwqkbmwjR3goVHPDxCa6ACw8
Jn3l1S6EQ2/wrUhXexb5cc9aLzO9yQUb/C9u6J3kXCqJF6nn88Qim6SE5/pHhDQL
B0MpjszlO1ZidOmsg5U9Y4Njhw1QULp5BDEzDfzp6+cUmhdHIVCWWfsZpE+Kt3Kz
QqPMr+DqzFylm6PoK8kK
=MUSq
-----END PGP SIGNATURE-----

--aNVUg3Xo9UgCa1D+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
