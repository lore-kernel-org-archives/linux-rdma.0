From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next v2] IB/core: Fix for core panic
Date: Thu, 31 Aug 2017 21:20:55 +0300
Message-ID: <20170831182055.GG10539@mtr-leonro.local>
References: <20170831163032.32161.90807.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bO4vSxwwZtUjUWHo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170831163032.32161.90807.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--bO4vSxwwZtUjUWHo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 31, 2017 at 09:30:34AM -0700, Dennis Dalessandro wrote:
> From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Build with the latest patches resulted in panic:
> 11384.486289] BUG: unable to handle kernel NULL pointer dereference at
>          (null)
> [11384.486293] IP:           (null)
> [11384.486295] PGD 0
> [11384.486295] P4D 0
> [11384.486296]
> [11384.486299] Oops: 0010 [#1] SMP
> ......... snip ......
> [11384.486401] CPU: 0 PID: 968 Comm: kworker/0:1H Tainted: G        W  O
>     4.13.0-a-stream-20170825 #1
> [11384.486402] Hardware name: Intel Corporation S2600WT2R/S2600WT2R,
> BIOS SE5C610.86B.01.01.0014.121820151719 12/18/2015
> [11384.486418] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> [11384.486419] task: ffff880850579680 task.stack: ffffc90007fec000
> [11384.486420] RIP: 0010:          (null)
> [11384.486420] RSP: 0018:ffffc90007fef970 EFLAGS: 00010206
> [11384.486421] RAX: ffff88084cfe8000 RBX: ffff88084dce4000 RCX:
> ffffc90007fef978
> [11384.486422] RDX: 0000000000000000 RSI: 0000000000000001 RDI:
> ffff88084cfe8000
> [11384.486422] RBP: ffffc90007fefab0 R08: 0000000000000000 R09:
> ffff88084dce4080
> [11384.486423] R10: ffffffffa02d7f60 R11: 0000000000000000 R12:
> ffff88105af65a00
> [11384.486423] R13: ffff88084dce4000 R14: 000000000000c000 R15:
> 000000000000c000
> [11384.486424] FS:  0000000000000000(0000) GS:ffff88085f400000(0000)
> knlGS:0000000000000000
> [11384.486425] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [11384.486425] CR2: 0000000000000000 CR3: 0000000001c09000 CR4:
> 00000000001406f0
> [11384.486426] Call Trace:
> [11384.486431]  ? is_valid_mcast_lid.isra.21+0xfb/0x110 [ib_core]
> [11384.486436]  ib_attach_mcast+0x6f/0xa0 [ib_core]
> [11384.486441]  ipoib_mcast_attach+0x81/0x190 [ib_ipoib]
> [11384.486443]  ipoib_mcast_join_complete+0x354/0xb40 [ib_ipoib]
> [11384.486448]  mcast_work_handler+0x330/0x6c0 [ib_core]
> [11384.486452]  join_handler+0x101/0x220 [ib_core]
> [11384.486455]  ib_sa_mcmember_rec_callback+0x54/0x80 [ib_core]
> [11384.486459]  recv_handler+0x3a/0x60 [ib_core]
> [11384.486462]  ib_mad_recv_done+0x423/0x9b0 [ib_core]
> [11384.486466]  __ib_process_cq+0x5d/0xb0 [ib_core]
> [11384.486469]  ib_cq_poll_work+0x20/0x60 [ib_core]
> [11384.486472]  process_one_work+0x149/0x360
> [11384.486474]  worker_thread+0x4d/0x3c0
> [11384.486487]  kthread+0x109/0x140
> [11384.486488]  ? rescuer_thread+0x380/0x380
> [11384.486489]  ? kthread_park+0x60/0x60
> [11384.486490]  ? kthread_park+0x60/0x60
> [11384.486493]  ret_from_fork+0x25/0x30
> [11384.486493] Code:  Bad RIP value.
> [11384.486493] Code:  Bad RIP value.
> [11384.486496] RIP:           (null) RSP: ffffc90007fef970
> [11384.486497] CR2: 0000000000000000
> [11384.486531] ---[ end trace b1acec6fb4ff6e75 ]---
> [11384.532133] Kernel panic - not syncing: Fatal exception
> [11384.536541] Kernel Offset: disabled
> [11384.969491] ---[ end Kernel panic - not syncing: Fatal exception
> [11384.976875] sched: Unexpected reschedule of offline CPU#1!
> [11384.983646] ------------[ cut here ]------------
>
> Rdma device driver may not have implemented (*get_link_layer)()
> so it can not be called directly. Should use appropriate helper function.
>
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Fixes: 523633359224 ("IB/core: Fix the validations of a multicast LID in attach or detach operations")
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> ---
> changes from v1:
> 	* Incorporate Leon's comment
> 	* Update commit message with Yuval review-by
> 	* Add panic trace to commit message
> ---
>  drivers/infiniband/core/verbs.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--bO4vSxwwZtUjUWHo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmoU3wACgkQ5GN7iDZy
WKdReg/9FuZAmTt6FiTFgDmVbpV9TBwiANdj7kVvi49BosK4WiEEVLp4XdJ+shk1
+XCKDjtCeqZKfwhIv9gwqVlsbMylRIm6LW83irThCvXv/MFuy6eyTpen0e0Bp/Lu
noYB7OexAum+8zLIErKep8/6DmefidDtVhFN87/LLu5F1wHW6RcX5d8lRLGuGNsm
IaQ6yK8FAPhHSR0FnRm+8vr6Q3q7aV/8eYSnjtDQIjI6HZjuy8np9JG2EKI1PRDb
zhKcXI8AQluOzMHiUfYl3UXVYDMtz954f9r5koajp1WcZhzhi78tiZq+dkdO+7Gv
gdy+17drUR/5Z2ZXk+/5wBGsy7Vtf2J2aYPbKqr0JZqkx+h+8t4kkNWhY/jjvwD7
KtK6bhOuR1H5u3jzFb8L3rWsGkir/PgelE7FLA2lt/wL5EDhlqmRbSkWuA3qT8lN
vlG3sohZRtJXQz38QNWaX4It9zUYrhzYKim7TxMNsCuxZkU59sSnKLbK7l6YIJ2x
TJryIrGnNRDXh2D4jqC8z7VXMp/9K61fROaGNVRbFGtJdMbC4Acx5pz+wHOH/uzk
YZlhWSUQn+AgZSf4WEv62NZJyHtmKgeqIy8ODfsM0C+upqaQlnBnnEaZ2d45WUAe
A42yf9QU8XfXTNyY8tALF5oRsi9lFEv5MndKnjODgvHW6WkVpaQ=
=Ey4T
-----END PGP SIGNATURE-----

--bO4vSxwwZtUjUWHo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
