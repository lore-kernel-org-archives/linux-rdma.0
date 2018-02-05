From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v3] RDS: IB: Fix null pointer issue
Date: Mon, 05 Feb 2018 12:40:04 -0500
Message-ID: <1517852404.3936.77.camel@redhat.com>
References: <1517797622-6870-1-git-send-email-guanglei.li@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-yOBcMkAK/fYzqgTwxf9w"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1517797622-6870-1-git-send-email-guanglei.li@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: Guanglei Li <guanglei.li@oracle.com>, santosh.shilimkar@oracle.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc: honglei.wang@oracle.com, junxiao.bi@oracle.com, yanjun.zhu@oracle.com
List-Id: linux-rdma@vger.kernel.org


--=-yOBcMkAK/fYzqgTwxf9w
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-02-05 at 10:27 +0800, Guanglei Li wrote:
> Scenario:
> 1. Port down and do fail over
> 2. Ap do rds_bind syscall
>=20
> PID: 47039  TASK: ffff89887e2fe640  CPU: 47  COMMAND: "kworker/u:6"
>  #0 [ffff898e35f159f0] machine_kexec at ffffffff8103abf9
>  #1 [ffff898e35f15a60] crash_kexec at ffffffff810b96e3
>  #2 [ffff898e35f15b30] oops_end at ffffffff8150f518
>  #3 [ffff898e35f15b60] no_context at ffffffff8104854c
>  #4 [ffff898e35f15ba0] __bad_area_nosemaphore at ffffffff81048675
>  #5 [ffff898e35f15bf0] bad_area_nosemaphore at ffffffff810487d3
>  #6 [ffff898e35f15c00] do_page_fault at ffffffff815120b8
>  #7 [ffff898e35f15d10] page_fault at ffffffff8150ea95
>     [exception RIP: unknown or invalid address]
>     RIP: 0000000000000000  RSP: ffff898e35f15dc8  RFLAGS: 00010282
>     RAX: 00000000fffffffe  RBX: ffff889b77f6fc00  RCX:ffffffff81c99d88
>     RDX: 0000000000000000  RSI: ffff896019ee08e8  RDI:ffff889b77f6fc00
>     RBP: ffff898e35f15df0   R8: ffff896019ee08c8  R9:0000000000000000
>     R10: 0000000000000400  R11: 0000000000000000  R12:ffff896019ee08c0
>     R13: ffff889b77f6fe68  R14: ffffffff81c99d80  R15: ffffffffa022a1e0
>     ORIG_RAX: ffffffffffffffff  CS: 0010 SS: 0018
>  #8 [ffff898e35f15dc8] cma_ndev_work_handler at ffffffffa022a228 [rdma_cm=
]
>  #9 [ffff898e35f15df8] process_one_work at ffffffff8108a7c6
>  #10 [ffff898e35f15e58] worker_thread at ffffffff8108bda0
>  #11 [ffff898e35f15ee8] kthread at ffffffff81090fe6
>=20
> PID: 45659  TASK: ffff880d313d2500  CPU: 31  COMMAND: "oracle_45659_ap"
>  #0 [ffff881024ccfc98] __schedule at ffffffff8150bac4
>  #1 [ffff881024ccfd40] schedule at ffffffff8150c2cf
>  #2 [ffff881024ccfd50] __mutex_lock_slowpath at ffffffff8150cee7
>  #3 [ffff881024ccfdc0] mutex_lock at ffffffff8150cdeb
>  #4 [ffff881024ccfde0] rdma_destroy_id at ffffffffa022a027 [rdma_cm]
>  #5 [ffff881024ccfe10] rds_ib_laddr_check at ffffffffa0357857 [rds_rdma]
>  #6 [ffff881024ccfe50] rds_trans_get_preferred at ffffffffa0324c2a [rds]
>  #7 [ffff881024ccfe80] rds_bind at ffffffffa031d690 [rds]
>  #8 [ffff881024ccfeb0] sys_bind at ffffffff8142a670
>=20
> PID: 45659                          PID: 47039
> rds_ib_laddr_check
>   /* create id_priv with a null event_handler */
>   rdma_create_id
>   rdma_bind_addr
>     cma_acquire_dev
>       /* add id_priv to cma_dev->id_list */
>       cma_attach_to_dev
>                                     cma_ndev_work_handler
>                                       /* event_hanlder is null */
>                                       id_priv->id.event_handler
>=20
> Signed-off-by: Guanglei Li <guanglei.li@oracle.com>
> Signed-off-by: Honglei Wang <honglei.wang@oracle.com>
> Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
> Reviewed-by: Yanjun Zhu <yanjun.zhu@oracle.com>
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

RDS patches normally go through Dave's tree, so for the RDMA aspects of
this patch:

Acked-by: Doug Ledford <dledford@redhat.com>

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-yOBcMkAK/fYzqgTwxf9w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlp4lvQACgkQuCajMw5X
L91pgg/7Blzr4X4pGVY2zNZH+BVcxijzZLEX0a3PPZqNvR0a3FCppa0vlenLh0PZ
UVaOlIMvYvx3q/sh73cqvHFkHDijyKV2PcP8lxBsftMbSz6g1AtPgABz57gWyEpo
YyVTauCp0afPMVraxGLFFo8QgKhEJfsF6tJEKyxosylFfEH6Kf7TRzN4XFn5M/ol
9cEZuZM/7LYNl92/8Au8rm7kXS14uM0NiuZYWQCF+mDYvgbH0GWVBp7qqsWuWaqh
W4+s35RcT3WgOnNrYMCbtFzJAQgPhwlE0fJqwy6dPasQvQgB+lXBxLrYyhZlQPhJ
kBIPEk865X9AgcHqCIG3lAk5XMzVSJDjNUhmw5gkxb8bnFW2QhQtmIqXWntHRPg5
akIBS7/PUza7RsnzbJogGsH1r5F2E4gPaUgjKdLz3E/h+RjHaSdUrgNEiCxLP3fA
Ro1jCCnllH9wxa8lll9YOZm0SosX+00YzQPZBB0uo3dbl7Byt00wsSVdyrXuak2W
2ySpuwMQQvvLCxypEWum5/6MneYZMUAlu3tpg9HYTJaDHB7p4qi86LRgDkpKmqG0
e1sXJa81YQNEW9AH8P94e6YJq/IWNEAicEB8qIt+RV/CI1ZY/ZgvWzqhqqlQujwd
Zq3qTryBOrmTAy5+OQuVyGN4B57i8lO2D2a+Hiu7godFInCSXWs=
=1vh1
-----END PGP SIGNATURE-----

--=-yOBcMkAK/fYzqgTwxf9w--
