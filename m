From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v4] nvmet,rxe: defer ip datagram sending to tasklet
Date: Wed, 09 May 2018 10:43:15 -0400
Message-ID: <1525876995.11756.376.camel@redhat.com>
References: <20180508090202.GA1690@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-NBPUWTrLUdamQ/N8zfss"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180508090202.GA1690@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexandru Moise <00moses.alexander00@gmail.com>, monis@mellanox.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, yanjun.zhu@oracle.com
List-Id: linux-rdma@vger.kernel.org


--=-NBPUWTrLUdamQ/N8zfss
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-05-08 at 11:02 +0200, Alexandru Moise wrote:
> This addresses 3 separate problems:
>=20
> 1. When using NVME over Fabrics we may end up sending IP
> packets in interrupt context, we should defer this work
> to a tasklet.
>=20
> [   50.939957] WARNING: CPU: 3 PID: 0 at kernel/softirq.c:161 __local_bh_=
enable_ip+0x1f/0xa0
> [   50.942602] CPU: 3 PID: 0 Comm: swapper/3 Kdump: loaded Tainted: G    =
    W         4.17.0-rc3-ARCH+ #104
> [   50.945466] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S 1.11.0-20171110_100015-anatol 04/01/2014
> [   50.948163] RIP: 0010:__local_bh_enable_ip+0x1f/0xa0
> [   50.949631] RSP: 0018:ffff88009c183900 EFLAGS: 00010006
> [   50.951029] RAX: 0000000080010403 RBX: 0000000000000200 RCX: 000000000=
0000001
> [   50.952636] RDX: 0000000000000000 RSI: 0000000000000200 RDI: ffffffff8=
17e04ec
> [   50.954278] RBP: ffff88009c183910 R08: 0000000000000001 R09: 000000000=
0000614
> [   50.956000] R10: ffffea00021d5500 R11: 0000000000000001 R12: ffffffff8=
17e04ec
> [   50.957779] R13: 0000000000000000 R14: ffff88009566f400 R15: ffff88009=
56c7000
> [   50.959402] FS:  0000000000000000(0000) GS:ffff88009c180000(0000) knlG=
S:0000000000000000
> [   50.961552] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   50.963798] CR2: 000055c4ec0ccac0 CR3: 0000000002209001 CR4: 000000000=
00606e0
> [   50.966121] Call Trace:
> [   50.966845]  <IRQ>
> [   50.967497]  __dev_queue_xmit+0x62d/0x690
> [   50.968722]  dev_queue_xmit+0x10/0x20
> [   50.969894]  neigh_resolve_output+0x173/0x190
> [   50.971244]  ip_finish_output2+0x2b8/0x370
> [   50.972527]  ip_finish_output+0x1d2/0x220
> [   50.973785]  ? ip_finish_output+0x1d2/0x220
> [   50.975010]  ip_output+0xd4/0x100
> [   50.975903]  ip_local_out+0x3b/0x50
> [   50.976823]  rxe_send+0x74/0x120
> [   50.977702]  rxe_requester+0xe3b/0x10b0
> [   50.978881]  ? ip_local_deliver_finish+0xd1/0xe0
> [   50.980260]  rxe_do_task+0x85/0x100
> [   50.981386]  rxe_run_task+0x2f/0x40
> [   50.982470]  rxe_post_send+0x51a/0x550
> [   50.983591]  nvmet_rdma_queue_response+0x10a/0x170
> [   50.985024]  __nvmet_req_complete+0x95/0xa0
> [   50.986287]  nvmet_req_complete+0x15/0x60
> [   50.987469]  nvmet_bio_done+0x2d/0x40
> [   50.988564]  bio_endio+0x12c/0x140
> [   50.989654]  blk_update_request+0x185/0x2a0
> [   50.990947]  blk_mq_end_request+0x1e/0x80
> [   50.991997]  nvme_complete_rq+0x1cc/0x1e0
> [   50.993171]  nvme_pci_complete_rq+0x117/0x120
> [   50.994355]  __blk_mq_complete_request+0x15e/0x180
> [   50.995988]  blk_mq_complete_request+0x6f/0xa0
> [   50.997304]  nvme_process_cq+0xe0/0x1b0
> [   50.998494]  nvme_irq+0x28/0x50
> [   50.999572]  __handle_irq_event_percpu+0xa2/0x1c0
> [   51.000986]  handle_irq_event_percpu+0x32/0x80
> [   51.002356]  handle_irq_event+0x3c/0x60
> [   51.003463]  handle_edge_irq+0x1c9/0x200
> [   51.004473]  handle_irq+0x23/0x30
> [   51.005363]  do_IRQ+0x46/0xd0
> [   51.006182]  common_interrupt+0xf/0xf
> [   51.007129]  </IRQ>
>=20
> 2. Work must always be offloaded to tasklet for rxe_post_send_kernel()
> when using NVMEoF in order to solve lock ordering between neigh->ha_lock
> seqlock and the nvme queue lock:
>=20
> [   77.833783]  Possible interrupt unsafe locking scenario:
> [   77.833783]
> [   77.835831]        CPU0                    CPU1
> [   77.837129]        ----                    ----
> [   77.838313]   lock(&(&n->ha_lock)->seqcount);
> [   77.839550]                                local_irq_disable();
> [   77.841377]                                lock(&(&nvmeq->q_lock)->rlo=
ck);
> [   77.843222]                                lock(&(&n->ha_lock)->seqcou=
nt);
> [   77.845178]   <Interrupt>
> [   77.846298]     lock(&(&nvmeq->q_lock)->rlock);
> [   77.847986]
> [   77.847986]  *** DEADLOCK ***
>=20
> 3. Same goes for the lock ordering between sch->q.lock and nvme queue loc=
k:
>=20
> [   47.634271]  Possible interrupt unsafe locking scenario:
> [   47.634271]
> [   47.636452]        CPU0                    CPU1
> [   47.637861]        ----                    ----
> [   47.639285]   lock(&(&sch->q.lock)->rlock);
> [   47.640654]                                local_irq_disable();
> [   47.642451]                                lock(&(&nvmeq->q_lock)->rlo=
ck);
> [   47.644521]                                lock(&(&sch->q.lock)->rlock=
);
> [   47.646480]   <Interrupt>
> [   47.647263]     lock(&(&nvmeq->q_lock)->rlock);
> [   47.648492]
> [   47.648492]  *** DEADLOCK ***
>=20
> Using NVMEoF after this patch seems to finally be stable, without it,
> rxe eventually deadlocks the whole system and causes RCU stalls.
>=20
> Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>

Thanks, applied to for-rc.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-NBPUWTrLUdamQ/N8zfss
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrzCQMACgkQuCajMw5X
L90i1A//b3pol2XK2r/yA6WR3qV42v7UCXlq9TqW2GoVtKYaGAob017JRToAoo2F
BMwG7di04DDcrVStX6f/SucJu+8hxsSIYWKtfyS4UPgpgYUfSYJQ9iG9fu7UWnXC
I3z48QSOizWxwQNYkgVMg4YGsECkiBQdLmm5DMRbHY2dpSGIcDEwd0wmKZsx62VB
+604hcUTsNYi3+YYtp+IeQs2E5N53YcotjSXVXpFj7cJsu4TLOcRNRh4Q+qEfOiq
5e6ALZLfp3U+hj9AqlYMpdTeZlIx7uIIlruyi/p8QGGDb4MJMfuFuYtJenZj4jII
0uMb4UyJwtAvWFq4NQ3Y5LUdxRkubOI8OYzbua7DYiiyihZnRy3o2TWr+FVsVNjk
sIB5bKKOUHHa0dCclUPQvHloGIj0RSADm0GbMOb+3oB8nfu9iAI9ac3PegrokdlN
YU38MZRzABbueYyfq2hb9aCwBGVaamtHL2CQe9MYvWuQLHWJkk0UhShVYGALb0s0
fRHZy7VvOiVuYCb/80Id2Qs6dSqoSDKPxV1W8EpXwaib9tYlH1btpiItFYakaaUn
Z+zNT2r5CsGr6Ja63kAhaJExh4CHmVggSaJTS3RiiX6OdewoZu7NHl+jD3o8hMl4
WAy5mUhJU6Y4SCUtcUFh1r8EL18LhXYB77v0W9JZhWzps/mzm0g=
=XHxY
-----END PGP SIGNATURE-----

--=-NBPUWTrLUdamQ/N8zfss--
