From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: mlx4 problems with 4.2-rc8
Date: Mon, 31 Aug 2015 09:02:16 -0400
Message-ID: <55E45058.1070105@redhat.com>
References: <55E142DC.8060205@redhat.com>
 <CAJ3xEMj5By11L3qbSKxcEiMarB6CeyeERMnuK_vvH11VLLFypw@mail.gmail.com>
 <55E385DB.2@redhat.com> <55E3FDAB.10706@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bFL896PWv8rVOU4OhEAGcofMpXjI9Q4i4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55E3FDAB.10706-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bFL896PWv8rVOU4OhEAGcofMpXjI9Q4i4
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/31/2015 03:09 AM, Matan Barak wrote:
>=20
>=20
> On 8/31/2015 1:38 AM, Doug Ledford wrote:
>> On 08/29/2015 09:13 PM, Or Gerlitz wrote:
>>> On Fri, Aug 28, 2015 at 10:27 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> wrote:
>>>> I'm seeing this with rc8 on a dual port mlx4 adapter set to IB/Eth
>>>> mode:
>>>
>>> mmm, both Amir and myself are just finishing vacations... so WB notes=

>>> are not always lovely as you want them to be, life
>>>>
>>>> [   77.883513] IPv6: ADDRCONF(NETDEV_UP): mlx4_roce: link is not rea=
dy
>>>> [   77.892044] mlx4_en: mlx4_roce:   frag:0 - size:1518 prefix:0
>>>> stride:1536
>>>> [   77.903129] genirq: Flags mismatch irq 135. 00000000
>>>> (mlx4-65@0000:05:00.0) vs. 00000000 (mlx4-65@0000:05:00.0)
>>>
>>> is this strict regression from some known point in the past on this
>>> system/config -- i.e 4.1 or 4.2-rc1?!
>>
>> Yes.  When I was submitting the 4.2-rc changes this machine worked.
>> This is one of my IB/Eth SRIOV machines.  I tested with SRIOV disabled=

>> and it didn't effect things.
>>
>>> Can you please send the mlx4 driver output when you load it with debu=
g
>>> prints on? also do things work if you set the ports type to be ib/ib
>>> or eth/eth?
>>
>> It should work as ib/ib given that in ib/eth mode the ib port works.  =
I
>> doubt eth/eth would work, but I'll try and see.  OK, Eth/Eth mode fail=
s
>> too (at least on the second port, I can say on the first port for
>> certain as I can't bring it up, it's still plugged into an IB switch).=

>> However, now in Eth/Eth mode, attempts to bring up the interface
>> manually at the command line have hung, which it didn't do in IB/Eth
>> mode.
>>
>> I'll try to ping things down further, but that's what I have so far.
>>
>> And as requested, the config is attached.
>>
>>>
>>> send us your compressed .config
>>>
>>> Matan, any idea what goes wrong here?
>>>
>>> Or.
>>>
>>>
>>>
>>>> [   77.914965] CPU: 0 PID: 1541 Comm: NetworkManager Not tainted
>>>> 4.2.0-rc8 #58
>>>> [   77.923292] Hardware name: Dell Inc. PowerEdge R820/04K5X5, BIOS
>>>> 2.2.3 07/09/2014
>>>> [   77.932205]  0000000000000000 00000000c16e3ce1 ffff8820365ab498
>>>> ffffffff8167e6ff
>>>> [   77.941072]  0000000000000000 ffff8820339e9a00 ffff8820365ab4f8
>>>> ffffffff810d2b6e
>>>> [   77.949938]  0000000000000246 ffff881032e67aa4 ffff881035e10ba0
>>>> 00000000c16e3ce1
>>>> [   77.958812] Call Trace:
>>>> [   77.962109]  [<ffffffff8167e6ff>] dump_stack+0x45/0x57
>>>> [   77.968412]  [<ffffffff810d2b6e>] __setup_irq+0x51e/0x590
>>>> [   77.975018]  [<ffffffffc03870a0>] ? mlx4_interrupt+0x80/0x80
>>>> [mlx4_core]
>>>> [   77.983072]  [<ffffffff810d2d64>] request_threaded_irq+0xf4/0x1a0=

>>>> [   77.990468]  [<ffffffffc0385d55>] mlx4_assign_eq+0x135/0x360
>>>> [mlx4_core]
>>>> [   77.998513]  [<ffffffffc0537537>] mlx4_en_activate_cq+0x2a7/0x310=

>>>> [mlx4_en]
>>>> [   78.006853]  [<ffffffff8130a2c8>] ? alloc_cpumask_var_node+0x28/0=
x40
>>>> [   78.014542]  [<ffffffff8131e8b9>] ? find_next_bit+0x19/0x20
>>>> [   78.021334]  [<ffffffff8130a284>] ? cpumask_next_and+0x34/0x50
>>>> [   78.028425]  [<ffffffffc053ae6b>] mlx4_en_start_port+0x1bb/0xb60
>>>> [mlx4_en]
>>>> [   78.036689]  [<ffffffffc037fe01>] ? mlx4_free_cmd_mailbox+0x31/0x=
40
>>>> [mlx4_core]
>>>> [   78.045435]  [<ffffffffc053bb59>] mlx4_en_open+0x349/0x630 [mlx4_=
en]
>>>> [   78.053107]  [<ffffffff815732f9>] __dev_open+0xc9/0x140
>>>> [   78.059538]  [<ffffffff81573621>] __dev_change_flags+0xa1/0x160
>>>> [   78.066718]  [<ffffffff81573709>] dev_change_flags+0x29/0x60
>>>> [   78.073602]  [<ffffffff81580dbe>] do_setlink+0x5be/0xa70
>>>> [   78.080097]  [<ffffffffc01b158f>] ? mga_imageblit+0x2f/0x40
>>>> [mgag200]
>>>> [   78.087859]  [<ffffffffc01b1456>] ? mga_dirty_update+0x1e6/0x2f0
>>>> [mgag200]
>>>> [   78.096112]  [<ffffffffc01b158f>] ? mga_imageblit+0x2f/0x40
>>>> [mgag200]
>>>> [   78.103873]  [<ffffffff81582470>] rtnl_newlink+0x4f0/0x880
>>>> [   78.110586]  [<ffffffff81582073>] ? rtnl_newlink+0xf3/0x880
>>>> [   78.117372]  [<ffffffff81294238>] ? security_capable+0x48/0x60
>>>> [   78.124452]  [<ffffffff81081b1d>] ? ns_capable+0x2d/0x60
>>>> [   78.130950]  [<ffffffff8157f8c4>] rtnetlink_rcv_msg+0xa4/0x250
>>>> [   78.138028]  [<ffffffff812987c0>] ? sock_has_perm+0x70/0x90
>>>> [   78.144824]  [<ffffffff8157f820>] ? rtnetlink_rcv+0x40/0x40
>>>> [   78.151615]  [<ffffffff815a2bdf>] netlink_rcv_skb+0xaf/0xc0
>>>> [   78.158425]  [<ffffffff8157f80c>] rtnetlink_rcv+0x2c/0x40
>>>> [   78.164997]  [<ffffffff815a22d1>] netlink_unicast+0x101/0x1f0
>>>> [   78.171937]  [<ffffffff815a27c1>] netlink_sendmsg+0x401/0x660
>>>> [   78.178867]  [<ffffffff81553e78>] sock_sendmsg+0x38/0x50
>>>> [   78.185335]  [<ffffffff815547d5>] ___sys_sendmsg+0x275/0x290
>>>> [   78.192176]  [<ffffffff81262c56>] ? sysctl_head_finish+0x46/0x50
>>>> [   78.199411]  [<ffffffff81262e08>] ? proc_sys_call_handler+0x88/0x=
e0
>>>> [   78.206946]  [<ffffffff8131854c>] ? lockref_put_or_lock+0x4c/0x80=

>>>> [   78.214296]  [<ffffffff81555197>] __sys_sendmsg+0x57/0xa0
>>>> [   78.220878]  [<ffffffff815551f2>] SyS_sendmsg+0x12/0x20
>>>> [   78.227283]  [<ffffffff8168536e>]
>>>> entry_SYSCALL_64_fastpath+0x12/0x71
>>>> [   78.235114] mlx4_en 0000:05:00.0: Failed assigning an EQ to
>>>> \xfffffff\xffffffb6Z6
>>>> \xffffff88\xffffffff\xffffffff\xffffff84\xffffffa20\xffffff81\xfffff=
fff\xffffffff\xffffffff\xffffffff
>>>>
>>>> [   78.243732] mlx4_en: mlx4_roce: Failed activating Rx CQ
>>>> [   78.319027] mlx4_en: mlx4_roce: Failed starting port:2
>>>>
>>>> The interface in question is unusable.
>>>>
>>>> --=20
>>>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>                GPG KeyID: 0E572FDD
>>>>
>>>>
>>
>>
>=20
> Actually, it looks like the dump stack we've got before [1] was fixed.
> This happens when the mlx4 driver is used in setups where number of
> cores >=3D 32.
> Doug, is that the case?

Indeed, 48 cores on this machine.

> [1] http://www.spinics.net/lists/netdev/msg341171.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--bFL896PWv8rVOU4OhEAGcofMpXjI9Q4i4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV5FBYAAoJELgmozMOVy/dxE4QAIQQDXOI+qpyNRhkP/N5Fa72
UzzNc4Np3ihLhY1uQ6P+xAMWqUMUIwCzr6y/MW1PeB8zyhorzUkDBE8U9wiAr+xW
d+EITeb2nxYTT6Du0K+cD1zvyisEKN+ZXN7AghJ1X4THtZ/PqZ9V0oYrwvEQq9Jk
Ord3AAEG3N7VF1xy1NYvCkZGskRuABEtYrZyvBpCamMPms+/njMAxXu5hw7TpOGe
ZrIPiG/jc7eaO8qV8O2QNYLGxY+oZbl7Ynnwrz42eM6uao7Ca4okvSKCauK0IgMf
7yiUU9lMf//zkB1fbM8+aejIYg9Ub7Ldq0d6LvssKrn9IKCpcplVCk9V/8IX9yoP
ElbXDTT3EJMSkuI5Lznx4p+7YPPmq/B3gw87MmRN2IyslcbHe8yQKMiOoczaCZdp
u4uZh5Po6JWBkRZp7b+8mU4V1B3XwcPsKykXBcJY7koD5StOVozeCo+PJb3UkDSY
yZKzqd3Oihs4CIWdeF/rtgYuCRgJDODI01tSdtyzB/K1hxeBg/zdcmUC64wcxkka
4zuNElD5zzLWAjrqwVWKizhCzf0RX68a/5WnaG8Qh5DS7gSGwterLpshEjZLV0IJ
2s/z63NrAy6ye6HmDGZAZGKzc4+y3iEkPUXg66rv7+ACgIe2/yILfHglGmnipFcj
1jDWMh3JV7EDFyY62MHH
=Nq4q
-----END PGP SIGNATURE-----

--bFL896PWv8rVOU4OhEAGcofMpXjI9Q4i4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
