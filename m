From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH] IB/core: Avoid crash on pkey enforcement failed in
 received MADs
Date: Fri, 3 Nov 2017 15:46:40 +0000
Message-ID: <VI1PR0502MB3008E61E5EBFA422FAF52674D15D0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <1509463998-49670-1-git-send-email-parav@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509463998-49670-1-git-send-email-parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Leon/Doug,

> -----Original Message-----
> From: Parav Pandit [mailto:parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> Sent: Tuesday, October 31, 2017 10:33 AM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Daniel Jurgens
> <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: [PATCH] IB/core: Avoid crash on pkey enforcement failed in recei=
ved
> MADs
>=20
> Below kernel crash is observed when Pkey security enforcement fails on
> received MADs. This issue is reported in [1].
>=20
> ib_free_recv_mad() accesses the rmpp_list, whose initialization is needed=
 before
> accessing it.
> When security enformcent fails on received MADs, MAD processing avoided d=
ue
> to security checks failed.
>=20
> OpenSM[3770]: SM port is down
> kernel: BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000008
> kernel: IP: ib_free_recv_mad+0x44/0xa0 [ib_core]
> kernel: PGD 0
> kernel: P4D 0
> kernel:
> kernel: Oops: 0002 [#1] SMP
> kernel: CPU: 0 PID: 2833 Comm: kworker/0:1H Tainted: P          IO    4.1=
3.4-1-pve
> #1
> kernel: Hardware name: Dell       XS23-TY3        /9CMP63, BIOS 1.71 09/1=
7/2013
> kernel: Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> kernel: task: ffffa069c6541600 task.stack: ffffb9a729054000
> kernel: RIP: 0010:ib_free_recv_mad+0x44/0xa0 [ib_core]
> kernel: RSP: 0018:ffffb9a729057d38 EFLAGS: 00010286
> kernel: RAX: ffffa069cb138a48 RBX: ffffa069cb138a10 RCX: 0000000000000000
> kernel: RDX: ffffb9a729057d38 RSI: 0000000000000000 RDI: ffffa069cb138a20
> kernel: RBP: ffffb9a729057d60 R08: ffffa072d2d49800 R09: ffffa069cb138ae0
> kernel: R10: ffffa069cb138ae0 R11: ffffa072b3994e00 R12: ffffb9a729057d38
> kernel: R13: ffffa069d1c90000 R14: 0000000000000000 R15: ffffa069d1c90880
> kernel: FS:  0000000000000000(0000) GS:ffffa069dba00000(0000)
> knlGS:0000000000000000
> kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> kernel: CR2: 0000000000000008 CR3: 00000011f51f2000 CR4:
> 00000000000006f0
> kernel: Call Trace:
> kernel:  ib_mad_recv_done+0x5cc/0xb50 [ib_core]
> kernel:  __ib_process_cq+0x5c/0xb0 [ib_core]
> kernel:  ib_cq_poll_work+0x20/0x60 [ib_core]
> kernel:  process_one_work+0x1e9/0x410
> kernel:  worker_thread+0x4b/0x410
> kernel:  kthread+0x109/0x140
> kernel:  ? process_one_work+0x410/0x410
> kernel:  ? kthread_create_on_node+0x70/0x70
> kernel:  ? SyS_exit_group+0x14/0x20
> kernel:  ret_from_fork+0x25/0x30
> kernel: RIP: ib_free_recv_mad+0x44/0xa0 [ib_core] RSP: ffffb9a729057d38
> kernel: CR2: 0000000000000008
>=20
> [1] : https://www.spinics.net/lists/linux-rdma/msg56190.html
>=20
> Fixes: 47a2b338fe63 ("IB/core: Enforce security on management datagrams")
> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reported-by: Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---

I think this is needed for 4.13+. I missed to CC stable in this patch.
Shall I resend with Cc: or?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
