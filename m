From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroying a QP
Date: Sun, 12 Feb 2017 13:02:53 -0500 (EST)
Message-ID: <1041506550.30101266.1486922573298.JavaMail.zimbra@redhat.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com> <20170210235611.3243-9-bart.vanassche@sandisk.com> <20170212171928.GF14015@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170212171928.GF14015-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

----- Original Message -----
> From: "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, "Israel
> Rukshin" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Sent: Sunday, February 12, 2017 12:19:28 PM
> Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroying a QP
> 
> On Fri, Feb 10, 2017 at 03:56:11PM -0800, Bart Van Assche wrote:
> > A quote from the IB spec:
> >
> > However, if the Consumer does not wait for the Affiliated Asynchronous
> > Last WQE Reached Event, then WQE and Data Segment leakage may occur.
> > Therefore, it is good programming practice to tear down a QP that is
> > associated with an SRQ by using the following process:
> > * Put the QP in the Error State;
> > * wait for the Affiliated Asynchronous Last WQE Reached Event;
> > * either:
> >   * drain the CQ by invoking the Poll CQ verb and either wait for CQ
> >     to be empty or the number of Poll CQ operations has exceeded CQ
> >     capacity size; or
> >   * post another WR that completes on the same CQ and wait for this WR to
> >   return as a WC;
> > * and then invoke a Destroy QP or Reset QP.
> >
> > Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> > Cc: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/ulp/srp/ib_srp.c | 19 ++++++++++++++-----
> >  1 file changed, 14 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
> > b/drivers/infiniband/ulp/srp/ib_srp.c
> > index 2f85255d2aca..b50733910f7e 100644
> > --- a/drivers/infiniband/ulp/srp/ib_srp.c
> > +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> > @@ -471,9 +471,13 @@ static struct srp_fr_pool *srp_alloc_fr_pool(struct
> > srp_target_port *target)
> >   * completion handler can access the queue pair while it is
> >   * being destroyed.
> >   */
> > -static void srp_destroy_qp(struct ib_qp *qp)
> > +static void srp_destroy_qp(struct srp_rdma_ch *ch, struct ib_qp *qp)
> >  {
> > -	ib_drain_rq(qp);
> > +	spin_lock_irq(&ch->lock);
> > +	ib_process_cq_direct(ch->send_cq, -1);
> 
> I see that you are already using "-1" in your code, but the comments in the
> ib_process_cq_direct states that no new code should use "-1".
> 
>  61  * Note: for compatibility reasons -1 can be passed in %budget for
>  unlimited
>  62  * polling.  Do not use this feature in new code, it will be removed
>  soon.
>  63  */
>  64 int ib_process_cq_direct(struct ib_cq *cq, int budget)
> 
> Thanks
> 

Hello Bart

I took latest for-next from your git tree and started the fist set of tests.

I bumped into this very quickly, but I only am running the new code on the client.
The server has not been updated.

On the client I see this after starting a single write thread to and XFS on on eof the mpaths.
Given its in ib_strain figured I would let you know now.


[  850.862430] scsi host1: ib_srp: Out of MRs (mr_per_cmd = 1)
[  850.865203] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f3d94a30
[  850.941454] scsi host1: ib_srp: Failed to map data (-12)
[  860.990411] mlx5_0:dump_cqe:262:(pid 1103): dump error cqe
[  861.019162] 00000000 00000000 00000000 00000000
[  861.042085] 00000000 00000000 00000000 00000000
[  861.066567] 00000000 00000000 00000000 00000000
[  861.092164] 00000000 0f007806 2500002a cefe87d1
[  861.117091] ------------[ cut here ]------------
[  861.143141] WARNING: CPU: 27 PID: 1103 at drivers/infiniband/core/verbs.c:1959 __ib_drain_sq+0x1bb/0x1c0 [ib_core]
[  861.202208] IB_POLL_DIRECT poll_ctx not supported for drain
[  861.235179] Modules linked in: dm_service_time xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat rpcrdma nf_conntrack ib_isert iscsi_target_mod iptable_mangle iptable_security iptable_raw ebtable_filter ib_iser ebtables libiscsi ip6table_filter ip6_tables scsi_transport_iscsi iptable_filter target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx5_ib ib_core intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32
 _pclmul ghash_clmulni_intel
[  861.646587]  pcbc aesni_intel crypto_simd ipmi_ssif glue_helper ipmi_si cryptd iTCO_wdt gpio_ich ipmi_devintf iTCO_vendor_support pcspkr hpwdt hpilo pcc_cpufreq sg ipmi_msghandler acpi_power_meter i7core_edac acpi_cpufreq shpchp edac_core lpc_ich nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_multipath ip_tables xfs libcrc32c amdkfd amd_iommu_v2 radeon i2c_algo_bit drm_kms_helper syscopyarea sd_mod sysfillrect sysimgblt fb_sys_fops ttm mlx5_core drm ptp fjes hpsa crc32c_intel serio_raw i2c_core pps_core bnx2 devlink scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ib_srpt]
[  861.943997] CPU: 27 PID: 1103 Comm: kworker/27:2 Tainted: G          I     4.10.0-rc7+ #1
[  861.989476] Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015
[  862.024833] Workqueue: events_long srp_reconnect_work [scsi_transport_srp]
[  862.063004] Call Trace:
[  862.076516]  dump_stack+0x63/0x87
[  862.094841]  __warn+0xd1/0xf0
[  862.112164]  warn_slowpath_fmt+0x5f/0x80
[  862.134013]  ? mlx5_poll_one+0x59/0xa40 [mlx5_ib]
[  862.161124]  __ib_drain_sq+0x1bb/0x1c0 [ib_core]
[  862.187702]  ib_drain_sq+0x25/0x30 [ib_core]
[  862.212168]  ib_drain_qp+0x12/0x30 [ib_core]
[  862.238138]  srp_destroy_qp+0x47/0x60 [ib_srp]
[  862.264155]  srp_create_ch_ib+0x26f/0x5f0 [ib_srp]
[  862.291646]  ? scsi_done+0x21/0x70
[  862.312392]  ? srp_finish_req+0x93/0xb0 [ib_srp]
[  862.338654]  srp_rport_reconnect+0xf0/0x1f0 [ib_srp]
[  862.366274]  srp_reconnect_rport+0xca/0x220 [scsi_transport_srp]
[  862.400756]  srp_reconnect_work+0x44/0xd1 [scsi_transport_srp]
[  862.434277]  process_one_work+0x165/0x410
[  862.456198]  worker_thread+0x137/0x4c0
[  862.476973]  kthread+0x101/0x140
[  862.493935]  ? rescuer_thread+0x3b0/0x3b0
[  862.516800]  ? kthread_park+0x90/0x90
[  862.537396]  ? do_syscall_64+0x67/0x180
[  862.558477]  ret_from_fork+0x2c/0x40
[  862.578161] ---[ end trace 2a6c2779f0a2d28f ]---
[  864.274137] scsi host1: ib_srp: reconnect succeeded
[  864.306836] scsi host1: ib_srp: Out of MRs (mr_per_cmd = 1)
[  864.310916] mlx5_0:dump_cqe:262:(pid 13776): dump error cqe
[  864.310917] 00000000 00000000 00000000 00000000
[  864.310921] 00000000 00000000 00000000 00000000
[  864.310922] 00000000 00000000 00000000 00000000
[  864.310922] 00000000 0f007806 25000032 00044cd0
[  864.310928] scsi host1: ib_srp: failed FAST REG status memory management operation error (6) for CQE ffff880b94268078
[  864.527890] scsi host1: ib_srp: Failed to map data (-12)
[  876.101124] scsi host1: ib_srp: reconnect succeeded
[  876.133923] scsi host1: ib_srp: Out of MRs (mr_per_cmd = 1)
[  876.135014] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff880bf1939130
[  876.210311] scsi host1: ib_srp: Failed to map data (-12)
[  876.239985] mlx5_0:dump_cqe:262:(pid 5945): dump error cqe
[  876.270855] 00000000 00000000 00000000 00000000
[  876.296525] 00000000 00000000 00000000 00000000
[  876.322500] 00000000 00000000 00000000 00000000
[  876.348519] 00000000 0f007806 2500003a 0080e1d0
[  887.784981] scsi host1: ib_srp: reconnect succeeded
[  887.819808] scsi host1: ib_srp: Out of MRs (mr_per_cmd = 1)
[  887.851777] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff880bf1939130
[  887.898850] scsi host1: ib_srp: Failed to map data (-12)
[  887.928647] mlx5_0:dump_cqe:262:(pid 7327): dump error cqe
[  887.959938] 00000000 00000000 00000000 00000000
[  887.985041] 00000000 00000000 00000000 00000000
[  888.010619] 00000000 00000000 00000000 00000000
[  888.035601] 00000000 0f007806 25000042 008099d0
[  899.546781] scsi host1: ib_srp: reconnect succeeded
[  899.580758] scsi host1: ib_srp: Out of MRs (mr_per_cmd = 1)
[  899.611289] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff880bf1939130
[  899.658289] scsi host1: ib_srp: Failed to map data (-12)
[  899.687219] mlx5_0:dump_cqe:262:(pid 7327): dump error cqe
[  899.718736] 00000000 00000000 00000000 00000000
[  899.744137] 00000000 00000000 00000000 00000000
[  899.769206] 00000000 00000000 00000000 00000000
[  899.795217] 00000000 0f007806 2500004a 008091d0
[  911.343869] scsi host1: ib_srp: reconnect succeeded
[  911.376684] scsi host1: ib_srp: Out of MRs (mr_per_cmd = 1)
[  911.407755] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff880bf1939130
[  911.454474] scsi host1: ib_srp: Failed to map data (-12)
[  911.484279] mlx5_0:dump_cqe:262:(pid 7327): dump error cqe
[  911.514784] 00000000 00000000 00000000 00000000
[  911.540251] 00000000 00000000 00000000 00000000
[  911.564841] 00000000 00000000 00000000 00000000
[  911.590743] 00000000 0f007806 25000052 008089d0
[  923.066748] scsi host1: ib_srp: reconnect succeeded
[  923.099656] scsi host1: ib_srp: Out of MRs (mr_per_cmd = 1)
[  923.131825] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff880bf1939130
[  923.179514] scsi host1: ib_srp: Failed to map data (-12)
[  923.209307] mlx5_0:dump_cqe:262:(pid 7327): dump error cqe
[  923.239986] 00000000 00000000 00000000 00000000
[  923.265419] 00000000 00000000 00000000 00000000
[  923.290102] 00000000 00000000 00000000 00000000
[  923.315120] 00000000 0f007806 2500005a 00c4d4d0
[  934.839336] scsi host1: ib_srp: reconnect succeeded
[  934.874582] scsi host1: ib_srp: Out of MRs (mr_per_cmd = 1)
[  934.906298] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff880bf1939130
[  934.953712] scsi host1: ib_srp: Failed to map data (-12)
[  934.983829] mlx5_0:dump_cqe:262:(pid 7327): dump error cqe
[  935.015371] 00000000 00000000 00000000 00000000
[  935.041544] 00000000 00000000 00000000 00000000
[  935.066883] 00000000 00000000 00000000 00000000
[  935.092755] 00000000 0f007806 25000062 00c4ecd0
[  946.610744] scsi host1: ib_srp: reconnect succeeded
[  946.644528] scsi host1: ib_srp: Out of MRs (mr_per_cmd = 1)
[  946.647935] mlx5_0:dump_cqe:262:(pid 752): dump error cqe
[  946.647936] 00000000 00000000 00000000 00000000
[  946.647937] 00000000 00000000 00000000 00000000
[  946.647937] 00000000 00000000 00000000 00000000
[  946.647938] 00000000 0f007806 2500006a 00c4e4d0
[  946.647940] scsi host1: ib_srp: failed FAST REG status memory management operation error (6) for CQE ffff880b94268c78
[  946.869439] scsi host1: ib_srp: Failed to map data (-12)

I will reset and restart to make sure this issue is repeatable.

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
