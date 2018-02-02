From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] RDS: IB: Fix null pointer issue
Date: Fri, 2 Feb 2018 18:57:06 +0200
Message-ID: <20180202165706.GC27780@mtr-leonro.local>
References: <1517569856-17673-1-git-send-email-guanglei.li@oracle.com>
 <b525a22a-2193-7036-1f6d-01e59ca77362@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b525a22a-2193-7036-1f6d-01e59ca77362-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Guanglei Li <guanglei.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, honglei.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 02, 2018 at 08:15:22AM -0800, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org wrote:
> On 2/2/18 3:10 AM, Guanglei Li wrote:
> > Scenario:
> > 1. Port down and do fail over
> > 2. Ap do rds_bind syscall
> >
> > PID: 47039  TASK: ffff89887e2fe640  CPU: 47  COMMAND: "kworker/u:6"
> >   #0 [ffff898e35f159f0] machine_kexec at ffffffff8103abf9
> >   #1 [ffff898e35f15a60] crash_kexec at ffffffff810b96e3
> >   #2 [ffff898e35f15b30] oops_end at ffffffff8150f518
> >   #3 [ffff898e35f15b60] no_context at ffffffff8104854c
> >   #4 [ffff898e35f15ba0] __bad_area_nosemaphore at ffffffff81048675
> >   #5 [ffff898e35f15bf0] bad_area_nosemaphore at ffffffff810487d3
> >   #6 [ffff898e35f15c00] do_page_fault at ffffffff815120b8
> >   #7 [ffff898e35f15d10] page_fault at ffffffff8150ea95
> >      [exception RIP: unknown or invalid address]
> >      RIP: 0000000000000000  RSP: ffff898e35f15dc8  RFLAGS: 00010282
> >      RAX: 00000000fffffffe  RBX: ffff889b77f6fc00  RCX:ffffffff81c99d88
> >      RDX: 0000000000000000  RSI: ffff896019ee08e8  RDI:ffff889b77f6fc00
> >      RBP: ffff898e35f15df0   R8: ffff896019ee08c8  R9:0000000000000000
> >      R10: 0000000000000400  R11: 0000000000000000  R12:ffff896019ee08c0
> >      R13: ffff889b77f6fe68  R14: ffffffff81c99d80  R15: ffffffffa022a1e0
> >      ORIG_RAX: ffffffffffffffff  CS: 0010 SS: 0018
> >   #8 [ffff898e35f15dc8] cma_ndev_work_handler at ffffffffa022a228 [rdma_cm]
> >   #9 [ffff898e35f15df8] process_one_work at ffffffff8108a7c6
> >   #10 [ffff898e35f15e58] worker_thread at ffffffff8108bda0
> >   #11 [ffff898e35f15ee8] kthread at ffffffff81090fe6
> >
> > PID: 45659  TASK: ffff880d313d2500  CPU: 31  COMMAND: "oracle_45659_ap"
> >   #0 [ffff881024ccfc98] __schedule at ffffffff8150bac4
> >   #1 [ffff881024ccfd40] schedule at ffffffff8150c2cf
> >   #2 [ffff881024ccfd50] __mutex_lock_slowpath at ffffffff8150cee7
> >   #3 [ffff881024ccfdc0] mutex_lock at ffffffff8150cdeb
> >   #4 [ffff881024ccfde0] rdma_destroy_id at ffffffffa022a027 [rdma_cm]
> >   #5 [ffff881024ccfe10] rds_ib_laddr_check at ffffffffa0357857 [rds_rdma]
> >   #6 [ffff881024ccfe50] rds_trans_get_preferred at ffffffffa0324c2a [rds]
> >   #7 [ffff881024ccfe80] rds_bind at ffffffffa031d690 [rds]
> >   #8 [ffff881024ccfeb0] sys_bind at ffffffff8142a670
> >
> > PID: 45659                          PID: 47039
> > rds_ib_laddr_check
> >    /* create id_priv with a null event_handler */
> >    rdma_create_id
> >    rdma_bind_addr
> >      cma_acquire_dev
> >        /* add id_priv to cma_dev->id_list */
> >        cma_attach_to_dev
> >                                      cma_ndev_work_handler
> >                                        /* event_hanlder is null */
> >                                        id_priv->id.event_handler
> >
> > Signed-off-by: Guanglei Li <guanglei.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Honglei Wang <honglei.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Yanjun Zhu <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >   net/rds/ib.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
>
> Patch looks fine. You should send the patch on netdev.
> Please repost it copying netdev.
>
> Acked-by: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlp0mGIACgkQ5GN7iDZy
WKd6sRAAv96aTLCp7bXDy9fRlLVq6ID3ilU+97qEQyC1HHJCda1y222bzbh4JhRp
HdDUIU+iTSzW/6Di6da6cGFVIRYthoyeehfewsbGhqrIgicWlzCwEyReWVp4/Q4X
EniCSK/JgM06tNAa0Z9vdx/aDK+MR2+tvFuHxSOqz5xrOZ/A11yfYVJEkkr0OZYM
lVbFNqeLm6aLKg1ev3rDnc8P9Jt6u+830YBR4Ypdr5PN/ekgWTIJmPxEUikEEHFj
op40CmI24JL6LiUtJG33PL0HZtAYm6WgpPmmeN/1TXhtY4N+i637lA+JHJZCROKz
3TSCgJmm79MpUxOM/+2J8DfK+CoJpZj4W/iBR8Rxy4BcXyy3tO+rqMe1OrE7x8U1
BGV3cH5vADCkzMCpo7H4SY6YaQt7AH06YmGqn0YAsQU/5nepRnLfq1z7z34Vbrbr
DMKjkfyTx5R7H930eei+R/e53EnCATqgWZ6BRhFQP6gfSNMBb6qEFL7vgLm4ZGu0
HaEseItxGCwQX2QnEQ0XjBu69Yf8un1AIUs+PPREa+M+Px6juxpgpWjlPyQjpxSk
Ffq2g7En7iUK41hdvJzNKHc63umcM+vQJC990qAQDWm5kET6K1eaAwew3SWZJOe5
OlwnKhZKcVNbzuVveS+J5i6eDnHNTCqDj/X4b4GW7ePB5SB2sC0=
=pNNL
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
