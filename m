From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/cma: Fix null pointer issue
Date: Thu, 1 Feb 2018 09:47:20 +0200
Message-ID: <20180201074720.GF2055@mtr-leonro.local>
References: <1517467842-2437-1-git-send-email-guanglei.li@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nbhonbzV/xpXxmuC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517467842-2437-1-git-send-email-guanglei.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guanglei Li <guanglei.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, honglei.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--nbhonbzV/xpXxmuC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 01, 2018 at 02:50:42PM +0800, Guanglei Li wrote:
> Scenario:
> 1. Port down and do fail over
> 2. Ap do rds_bind syscall
>
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
>  #8 [ffff898e35f15dc8] cma_ndev_work_handler at ffffffffa022a228 [rdma_cm]
>  #9 [ffff898e35f15df8] process_one_work at ffffffff8108a7c6
>  #10 [ffff898e35f15e58] worker_thread at ffffffff8108bda0
>  #11 [ffff898e35f15ee8] kthread at ffffffff81090fe6
>
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
>
> Race condition:
> PID: 45659                          PID: 47039
> rds_ib_laddr_check
>   /*create id_priv with a null event_handler*/
>   rdma_create_id
>   rdma_bind_addr
>     cma_acquire_dev
>       /*add id_priv to cma_dev->id_list*/
>       cma_attach_to_dev
>                                     cma_ndev_work_handler
>                                       /*event_hanlder is null*/
>                                       id_priv->id.event_handler
>
> Signed-off-by: Guanglei Li <guanglei.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Honglei Wang <honglei.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index e66963c..d9ca943 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -2431,9 +2431,12 @@ static void cma_ndev_work_handler(struct work_struct *_work)
>  	    id_priv->state == RDMA_CM_DEVICE_REMOVAL)
>  		goto out;
>
> -	if (id_priv->id.event_handler(&id_priv->id, &work->event)) {
> -		cma_exch(id_priv, RDMA_CM_DESTROYING);
> -		destroy = 1;
> +	/*event_handler is null when create cm id by calling rds_ib_laddr_check*/
> +	if (id_priv->id.event_handler) {
> +		if (id_priv->id.event_handler(&id_priv->id, &work->event)) {
> +			cma_exch(id_priv, RDMA_CM_DESTROYING);
> +			destroy = 1;
> +		}
>  	}

The analysis looks correct to me, but the solution is less.

339 static int rds_ib_laddr_check(struct net *net, __be32 addr)
<...>
348         cm_id = rdma_create_id(&init_net, NULL, NULL, RDMA_PS_TCP, IB_QPT_RC);
                                              ^^^^ this part looks suspicious

I would say that it is misuse of API and not CMA "issue", especially
given the fact that you have rds_rdma_cm_event_handler() with all proper
locking.

Thanks

>
>  out:
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--nbhonbzV/xpXxmuC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpyxggACgkQ5GN7iDZy
WKfe4g//TV4t7FsSMih13cn9aT3VtT4tVmXcyERYDKIGiG1WZioKmynKNXZQN85T
ZYXJT74rVTug7lEFAnd1BJqY2IubJUPtM/4rBGuy//qolcnOeR+whg0eTPU3wh0L
F2K8s44nd4SIkvTVY/ItVabuBJ2DhlzA4JakDPvbTZZZHDiuZ0j4EyOl5UOkWBPS
wHMjxyXpEariqDtq3f66ErRTL1L0uE/0g+D9Uy9+HupQ6RsmhSXLdNYuiGd55H18
fnexKhZuzXYqy6Rg2Zei+BL6KhE1/ARUQWLvwe1Nu2mcRdxS290zOUX82WVHF0ju
xRGaweawNC+hHfA6gPP00XEstO2K1hF+YaReClJZE0G0kNfio2I5/W1OzC4tz8OL
+GDSzs930JH41srIefuu54Gmp5x06kSQxT1p5L1l1KOB6tvxklwTjjD9trfTVp4S
c+MOXZDtavzDwoN6sm8ggYpZNF6GR1JiJlus6TpGFC4yZBHyrh3LCLDmf2TkCwal
awcQwJ/UXG4aiSpTdQ3WgYEfP40GkPRWR+AZICZNTh1DC7YMLwH4NReIx55313lU
1Dm5rzRYc23AA7xBoYOhxZq0tmEJ8sObBssfktUhOOk9zOYJiBwU88xTRtR66zZo
74Xvc0asf3sDmpO27eWMphWrGUo9t01b7cWO7O1Zq/rpJFz63fs=
=9LfB
-----END PGP SIGNATURE-----

--nbhonbzV/xpXxmuC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
