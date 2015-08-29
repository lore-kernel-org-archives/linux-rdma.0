From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: mlx4 problems with 4.2-rc8
Date: Sat, 29 Aug 2015 01:27:56 -0400
Message-ID: <55E142DC.8060205@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iPrRJekXr1Qb9Bjo5C0BM6qgPG2gT0hKq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iPrRJekXr1Qb9Bjo5C0BM6qgPG2gT0hKq
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I'm seeing this with rc8 on a dual port mlx4 adapter set to IB/Eth mode:

[   77.883513] IPv6: ADDRCONF(NETDEV_UP): mlx4_roce: link is not ready
[   77.892044] mlx4_en: mlx4_roce:   frag:0 - size:1518 prefix:0 stride:1=
536
[   77.903129] genirq: Flags mismatch irq 135. 00000000
(mlx4-65@0000:05:00.0) vs. 00000000 (mlx4-65@0000:05:00.0)
[   77.914965] CPU: 0 PID: 1541 Comm: NetworkManager Not tainted
4.2.0-rc8 #58
[   77.923292] Hardware name: Dell Inc. PowerEdge R820/04K5X5, BIOS
2.2.3 07/09/2014
[   77.932205]  0000000000000000 00000000c16e3ce1 ffff8820365ab498
ffffffff8167e6ff
[   77.941072]  0000000000000000 ffff8820339e9a00 ffff8820365ab4f8
ffffffff810d2b6e
[   77.949938]  0000000000000246 ffff881032e67aa4 ffff881035e10ba0
00000000c16e3ce1
[   77.958812] Call Trace:
[   77.962109]  [<ffffffff8167e6ff>] dump_stack+0x45/0x57
[   77.968412]  [<ffffffff810d2b6e>] __setup_irq+0x51e/0x590
[   77.975018]  [<ffffffffc03870a0>] ? mlx4_interrupt+0x80/0x80 [mlx4_cor=
e]
[   77.983072]  [<ffffffff810d2d64>] request_threaded_irq+0xf4/0x1a0
[   77.990468]  [<ffffffffc0385d55>] mlx4_assign_eq+0x135/0x360 [mlx4_cor=
e]
[   77.998513]  [<ffffffffc0537537>] mlx4_en_activate_cq+0x2a7/0x310
[mlx4_en]
[   78.006853]  [<ffffffff8130a2c8>] ? alloc_cpumask_var_node+0x28/0x40
[   78.014542]  [<ffffffff8131e8b9>] ? find_next_bit+0x19/0x20
[   78.021334]  [<ffffffff8130a284>] ? cpumask_next_and+0x34/0x50
[   78.028425]  [<ffffffffc053ae6b>] mlx4_en_start_port+0x1bb/0xb60
[mlx4_en]
[   78.036689]  [<ffffffffc037fe01>] ? mlx4_free_cmd_mailbox+0x31/0x40
[mlx4_core]
[   78.045435]  [<ffffffffc053bb59>] mlx4_en_open+0x349/0x630 [mlx4_en]
[   78.053107]  [<ffffffff815732f9>] __dev_open+0xc9/0x140
[   78.059538]  [<ffffffff81573621>] __dev_change_flags+0xa1/0x160
[   78.066718]  [<ffffffff81573709>] dev_change_flags+0x29/0x60
[   78.073602]  [<ffffffff81580dbe>] do_setlink+0x5be/0xa70
[   78.080097]  [<ffffffffc01b158f>] ? mga_imageblit+0x2f/0x40 [mgag200]
[   78.087859]  [<ffffffffc01b1456>] ? mga_dirty_update+0x1e6/0x2f0
[mgag200]
[   78.096112]  [<ffffffffc01b158f>] ? mga_imageblit+0x2f/0x40 [mgag200]
[   78.103873]  [<ffffffff81582470>] rtnl_newlink+0x4f0/0x880
[   78.110586]  [<ffffffff81582073>] ? rtnl_newlink+0xf3/0x880
[   78.117372]  [<ffffffff81294238>] ? security_capable+0x48/0x60
[   78.124452]  [<ffffffff81081b1d>] ? ns_capable+0x2d/0x60
[   78.130950]  [<ffffffff8157f8c4>] rtnetlink_rcv_msg+0xa4/0x250
[   78.138028]  [<ffffffff812987c0>] ? sock_has_perm+0x70/0x90
[   78.144824]  [<ffffffff8157f820>] ? rtnetlink_rcv+0x40/0x40
[   78.151615]  [<ffffffff815a2bdf>] netlink_rcv_skb+0xaf/0xc0
[   78.158425]  [<ffffffff8157f80c>] rtnetlink_rcv+0x2c/0x40
[   78.164997]  [<ffffffff815a22d1>] netlink_unicast+0x101/0x1f0
[   78.171937]  [<ffffffff815a27c1>] netlink_sendmsg+0x401/0x660
[   78.178867]  [<ffffffff81553e78>] sock_sendmsg+0x38/0x50
[   78.185335]  [<ffffffff815547d5>] ___sys_sendmsg+0x275/0x290
[   78.192176]  [<ffffffff81262c56>] ? sysctl_head_finish+0x46/0x50
[   78.199411]  [<ffffffff81262e08>] ? proc_sys_call_handler+0x88/0xe0
[   78.206946]  [<ffffffff8131854c>] ? lockref_put_or_lock+0x4c/0x80
[   78.214296]  [<ffffffff81555197>] __sys_sendmsg+0x57/0xa0
[   78.220878]  [<ffffffff815551f2>] SyS_sendmsg+0x12/0x20
[   78.227283]  [<ffffffff8168536e>] entry_SYSCALL_64_fastpath+0x12/0x71
[   78.235114] mlx4_en 0000:05:00.0: Failed assigning an EQ to
\xfffffff\xffffffb6Z6
\xffffff88\xffffffff\xffffffff\xffffff84\xffffffa20\xffffff81\xffffffff\x=
ffffffff\xffffffff\xffffffff
[   78.243732] mlx4_en: mlx4_roce: Failed activating Rx CQ
[   78.319027] mlx4_en: mlx4_roce: Failed starting port:2

The interface in question is unusable.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--iPrRJekXr1Qb9Bjo5C0BM6qgPG2gT0hKq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV4ULdAAoJELgmozMOVy/d5LIP/iz0jq7HZpp0+lB18NVb/wJL
foBzoTRlyXgw1wWYDFjCxESwGGS3d0IB52twvwwC9xu0ioC39G6gk89CfuQd2abx
GG+EcFLpsif2Pda6l2iIYpwAy2V45jE4tpkHQrO/mnbk0Ntdh3J06aC/RjO03Gct
uBaIDe3cdGlgvda0rYUDm0lP7K+i76Qazbe2dwKABYKIs34pnPv+sDvOeZUfR8cZ
BwUixzUGCLsKya5DS35DwblO4r6r9wIL1+c+e2fVzqHYfaXsXsEGMHzbtTW2ew3x
2L7L8Cj+mWOCoyaQU5nvAThUB2rdT9Emc0n1KAQsfbPNSkqbW99Bi8UE6XYmP8Xx
7YUCA5NfavAblRZ5WVeAamrBAVrAnw1Xi2IA97Y5wY9sF9nj2t8RixFI3qwIwkNe
VU7ViFrqCFg8j3/Tqy6PR82L64ll//3SQjuyOa+jG8F1/cwojj1g1WIAZxFNaVT7
8fFFjrF2rLx/5pAekuvRpG0C/jtA3IuAvgXbeF35Ea573LnAgdu05eyFCgWECrrz
G5rnOK5KKqjiMRbPhXHAsALRViViHvV3xtkf0eYRKzeotKNpGGfTEg0136bc3g3v
1WIRvQi8YWK90Ws8Rav6sGRjgQlQqx0FdIKpBqVoIyQQJpjiCRpJrT4wzcPEzjKk
lIYWMuSpF6BsaZjtmu/a
=ZX7f
-----END PGP SIGNATURE-----

--iPrRJekXr1Qb9Bjo5C0BM6qgPG2gT0hKq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
