From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: insight into a WARNING from softROCE
Date: Thu, 21 Dec 2017 10:19:26 +0200
Message-ID: <CAG9sBKM2qTSrB2sZnrLsUxAhL+ADursUTyPojd8HY5PF4Nf9Zg@mail.gmail.com>
References: <CAN-5tyFENoK6f20zjeUEbXNQh-bZAaH-iBf4Q6G8uLjz0eHnqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN-5tyFENoK6f20zjeUEbXNQh-bZAaH-iBf4Q6G8uLjz0eHnqA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Olga Kornievskaia <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Olga
As far as I can tell the warning in
drivers/infiniband/sw/rxe/rxe_comp.c:741 went through check_psn() ->
COMPST_ERROR_RETRY -> COMPST_ERROR. In that case the wqe_status should
have been IB_WC_RETRY_EXC_ERR and not IB_WC_SUCCESS.
Can you please be more specific and explain how did you get to this conclusion?
BTW, what was the test you were running?

Second, packets drops can lead to hiccups in performance. I'm not sure
if you are reporting a bug that makes RXE assume that packets were
drop or actual drops happened.

thanks


On Fri, Dec 8, 2017 at 9:50 PM, Olga Kornievskaia <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org> wrote:
> Hi folks,
>
> Can somebody give me an insight into to following WARNING (at the end
> of the message)  that I see logged in var log messages while using
> softROCE (NFSoRDMA)? This is typically associated with a hiccup in
> communication I see happening over RDMA (long delays).
>
> It's coming form the WARN here in rxe_comp.c:
>
>                 case COMPST_ERROR:
>                         WARN_ON_ONCE(wqe->status == IB_WC_SUCCESS);
>                         do_complete(qp, wqe);
>                         rxe_qp_error(qp);
>
>                         if (pkt) {
>                                 rxe_drop_ref(pkt->qp);
>
> With a little bit of printks I tracked it to:
> COMPST_ERROR is coming from "retrying counter exceeding"
> (RXE_CNT_RETRY_EXCEEDED)  in COMPST_ERROR_RETRY. COMPST_ERROR_RETRY is
> coming from check_psn(). I see that packet psn is greater then the wqe
> psn. I have noticed that can happen (but not always) after
> update_wqe_psn() has number of packets left to send some number larger
> than 1.
>
> Goal is to figure out why the hiccups are happening and I think this is a clue.
>
> Thank you for any info.
>
> Dec  5 16:42:16 localhost kernel: ------------[ cut here ]------------
> Dec  5 16:42:16 localhost kernel: WARNING: CPU: 0 PID: 0 at
> drivers/infiniband/sw/rxe/rxe_comp.c:741 rxe_completer+0xd84/0xe30
> [rdma_rxe]
> Dec  5 16:42:16 localhost kernel: Modules linked in: rpcrdma ib_ucm
> ib_umad rdma_rxe ip6_udp_tunnel udp_tunnel rdma_ucm rdma_cm iw_cm
> ib_cm ib_uverbs ib_core rfcomm fuse ip6t_rpfilter ipt_REJECT
> nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_nat
> ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6
> nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security
> ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
> nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw
> ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter bnep
> snd_seq_midi snd_seq_midi_event coretemp crc32_pclmul ext4
> ghash_clmulni_intel mbcache jbd2 aesni_intel snd_ens1371
> snd_ac97_codec glue_helper ppdev lrw ac97_bus snd_seq gf128mul
> uvcvideo ablk_helper cryptd vmw_balloon videobuf2_vmalloc
> videobuf2_memops
> Dec  5 16:42:16 localhost kernel: btusb snd_pcm videobuf2_core pcspkr
> btrtl videodev btbcm btintel snd_timer snd_rawmidi bluetooth
> snd_seq_device snd vmw_vmci rfkill shpchp i2c_piix4 soundcore
> parport_pc parport nfsd auth_rpcgss nfs_acl lockd grace sunrpc
> ip_tables xfs libcrc32c sr_mod cdrom vmwgfx sd_mod crc_t10dif
> crct10dif_generic drm_kms_helper ata_generic syscopyarea sysfillrect
> sysimgblt fb_sys_fops ttm drm pata_acpi crct10dif_pclmul ahci
> crct10dif_common mptspi crc32c_intel libahci scsi_transport_spi
> mptscsih serio_raw ata_piix libata mptbase e1000 i2c_core dm_mirror
> dm_region_hash dm_log dm_mod
> Dec  5 16:42:16 localhost kernel: CPU: 0 PID: 0 Comm: swapper/0 Not
> tainted 3.10.0 #2
> Dec  5 16:42:16 localhost kernel: Hardware name: VMware, Inc. VMware
> Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00
> 07/02/2015
> Dec  5 16:42:16 localhost kernel: Call Trace:
> Dec  5 16:42:16 localhost kernel: <IRQ>  [<ffffffff94cb9865>]
> dump_stack+0x19/0x1b
> Dec  5 16:42:16 localhost kernel: [<ffffffff94686968>] __warn+0xd8/0x100
> Dec  5 16:42:16 localhost kernel: [<ffffffff94686aad>]
> warn_slowpath_null+0x1d/0x20
> Dec  5 16:42:16 localhost kernel: [<ffffffffc0a73734>]
> rxe_completer+0xd84/0xe30 [rdma_rxe]
> Dec  5 16:42:16 localhost kernel: [<ffffffffc0a7f24f>]
> rxe_do_task+0x9f/0x110 [rdma_rxe]
> Dec  5 16:42:16 localhost kernel: [<ffffffffc0a7f3b8>]
> rxe_run_task+0x18/0x40 [rdma_rxe]
> Dec  5 16:42:16 localhost kernel: [<ffffffffc0a729a5>]
> rxe_comp_queue_pkt+0x45/0x50 [rdma_rxe]
> Dec  5 16:42:16 localhost kernel: [<ffffffffc0a77bf8>]
> rxe_rcv+0x2a8/0x920 [rdma_rxe]
> Dec  5 16:42:16 localhost kernel: [<ffffffffc03bcc5f>] ?
> ipt_do_table+0x31f/0x4f0 [ip_tables]
> Dec  5 16:42:16 localhost kernel: [<ffffffffc0a7fa10>] ?
> net_to_rxe+0x80/0x80 [rdma_rxe]
> Dec  5 16:42:16 localhost kernel: [<ffffffffc0a7fa73>]
> rxe_udp_encap_recv+0x63/0xa0 [rdma_rxe]
> Dec  5 16:42:16 localhost kernel: [<ffffffffc0a7fa73>] ?
> rxe_udp_encap_recv+0x63/0xa0 [rdma_rxe]
> Dec  5 16:42:16 localhost kernel: [<ffffffff94c148bb>]
> udp_queue_rcv_skb+0x1bb/0x4a0
> Dec  5 16:42:16 localhost kernel: [<ffffffff94c15108>]
> __udp4_lib_rcv+0x568/0xb90
> Dec  5 16:42:16 localhost kernel: [<ffffffffc09281de>] ?
> ipv4_confirm+0x4e/0x100 [nf_conntrack_ipv4]
> Dec  5 16:42:16 localhost kernel: [<ffffffff94c15b9a>] udp_rcv+0x1a/0x20
> Dec  5 16:42:16 localhost kernel: [<ffffffff94be30ce>]
> ip_local_deliver_finish+0x8e/0x1d0
> Dec  5 16:42:16 localhost kernel: [<ffffffff94be33b9>]
> ip_local_deliver+0x59/0xd0
> Dec  5 16:42:16 localhost kernel: [<ffffffff94be3040>] ?
> ip_rcv_finish+0x300/0x300
> Dec  5 16:42:16 localhost kernel: [<ffffffff94be2db8>] ip_rcv_finish+0x78/0x300
> Dec  5 16:42:16 localhost kernel: [<ffffffff94be36e6>] ip_rcv+0x2b6/0x410
> Dec  5 16:42:16 localhost kernel: [<ffffffff94be2d40>] ?
> inet_del_offload+0x40/0x40
> Dec  5 16:42:16 localhost kernel: [<ffffffff94b9f9d4>]
> __netif_receive_skb_core+0x2e4/0x820
> Dec  5 16:42:16 localhost kernel: [<ffffffff94b9ff28>]
> __netif_receive_skb+0x18/0x60
> Dec  5 16:42:16 localhost kernel: [<ffffffff94b9ffb0>]
> netif_receive_skb_internal+0x40/0xc0
> Dec  5 16:42:16 localhost kernel: [<ffffffff94ba0b58>]
> napi_gro_receive+0xd8/0x100
> Dec  5 16:42:16 localhost kernel: [<ffffffffc01f33e8>]
> e1000_clean_rx_irq+0x2b8/0x510 [e1000]
> Dec  5 16:42:16 localhost kernel: [<ffffffffc01f4078>]
> e1000_clean+0x278/0x8d0 [e1000]
> Dec  5 16:42:16 localhost kernel: [<ffffffff94ba0483>] net_rx_action+0x123/0x320
> Dec  5 16:42:16 localhost kernel: [<ffffffff9468fb4f>] __do_softirq+0xef/0x280
> Dec  5 16:42:16 localhost kernel: [<ffffffff94ccc51c>] call_softirq+0x1c/0x30
> Dec  5 16:42:16 localhost kernel: [<ffffffff9462c4c5>] do_softirq+0x65/0xa0
> Dec  5 16:42:16 localhost kernel: [<ffffffff9468fed5>] irq_exit+0x105/0x110
> Dec  5 16:42:16 localhost kernel: [<ffffffff94ccd036>] do_IRQ+0x56/0xe0
> Dec  5 16:42:16 localhost kernel: [<ffffffff94cc1b2d>]
> common_interrupt+0x6d/0x6d
> Dec  5 16:42:16 localhost kernel: <EOI>  [<ffffffff94cc0dd6>] ?
> native_safe_halt+0x6/0x10
> Dec  5 16:42:16 localhost kernel: [<ffffffff94cc0c6e>] ? default_idle+0x1e/0xc0
> Dec  5 16:42:16 localhost kernel: [<ffffffff94633f86>] ? arch_cpu_idle+0x26/0x30
> Dec  5 16:42:16 localhost kernel: [<ffffffff946e6efa>] ?
> cpu_startup_entry+0x14a/0x1c0
> Dec  5 16:42:16 localhost kernel: [<ffffffff94ca8e17>] ? rest_init+0x77/0x80
> Dec  5 16:42:16 localhost kernel: [<ffffffff9516c05a>] ?
> start_kernel+0x433/0x454
> Dec  5 16:42:16 localhost kernel: [<ffffffff9516ba30>] ?
> repair_env_string+0x5c/0x5c
> Dec  5 16:42:16 localhost kernel: [<ffffffff9516b120>] ?
> early_idt_handler_array+0x120/0x120
> Dec  5 16:42:16 localhost kernel: [<ffffffff9516b5ef>] ?
> x86_64_start_reservations+0x24/0x26
> Dec  5 16:42:16 localhost kernel: [<ffffffff9516b740>] ?
> x86_64_start_kernel+0x14f/0x172
> Dec  5 16:42:16 localhost kernel: [<ffffffff946001a5>] ? start_cpu+0x5/0x14
> Dec  5 16:42:16 localhost kernel: ---[ end trace c96ed928ed9503ca ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
