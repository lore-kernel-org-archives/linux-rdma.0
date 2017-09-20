From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: crash in 4.14-rc1 with IPoIB
Date: Wed, 20 Sep 2017 11:53:39 +0200
Message-ID: <20170920095339.zhfymeyfbhiyepz5@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi folks,

I wanted to try out Christoph's NVMe multipathing patchset on my NVMe OmniPath
setup and merged it into 4.14-rc1. On bootup I stumbled upon that splat and no
RDMA operation was possible:


hfi1 0000:ff:00.0: hfi1_1: send_idle_message: sending idle message 0x203
hfi1 0000:ff:00.0: hfi1_1: Switching to NO_DMA_RTAIL
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP:           (null)
PGD 0 P4D 0
Oops: 0010 [#1] SMP
Modules linked in: iptable_filter(E) af_packet(E) xt_nat(E) xt_tcpudp(E) iscsi_ibft(E) iscsi_boot_sysfs(E) iptable_nat(E) nf_conntrack_ipv4(E) nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E) libcrc32c(E) ip_tables(E) x_tables(E) rpcrdma(E) ib_isert(E) iscsi_target_mod(E) ib_iser(E) libiscsi(E) scsi_transport_iscsi(E) ib_srpt(E) target_core_mod(E) nls_iso8859_1(E) nls_cp437(E) vfat(E) fat(E) ib_srp(E) scsi_transport_srp(E) ib_ipoib(E) rdma_ucm(E) ib_ucm(E) ib_uverbs(E) ib_umad(E) rdma_cm(E) configfs(E) ib_cm(E) iw_cm(E) mlx5_ib(E) intel_rapl(E) sha512_ssse3(E) skx_edac(E) sha512_generic(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm_intel(E) kvm(E) irqbypass(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E) ipmi_ssif(E) pcbc(E) aesni_intel(E) mlx5_core
 (E)
 qat_c62x(E) aes_x86_64(E) intel_qat(E) mlxfw(E) joydev(E) hfi1(E) i40e(E) crypto_simd(E) devlink(E) rdmavt(E) ipmi_si(E) ptp(E) iTCO_wdt(E) dh_generic(E) glue_helper(E) iTCO_vendor_support(E) authenc(E) ib_core(E) pps_core(E) ipmi_devintf(E) mei_me(E) ioatdma(E) cryptd(E) lpc_ich(E) pcspkr(E) mfd_core(E) i2c_i801(E) shpchp(E) mei(E) dca(E) ipmi_msghandler(E) tpm_crb(E) nfit(E) libnvdimm(E) acpi_pad(E) sunrpc(E) btrfs(E) xor(E) zstd_decompress(E) zstd_compress(E) xxhash(E) hid_generic(E) usbhid(E) raid6_pq(E) sd_mod(E) sr_mod(E) cdrom(E) crc32c_intel(E) ast(E) i2c_algo_bit(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E) sysimgblt(E) fb_sys_fops(E) ttm(E) xhci_pci(E) ahci(E) xhci_hcd(E) libahci(E) drm(E) usbcore(E) libata(E) wmi(E) button(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E
 )
 scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E) efivarfs(E) autofs4(E)
CPU: 20 PID: 950 Comm: kworker/20:1H Tainted: G            E   4.14.0-rc1-6.3-default-nvme-mpath #773
 Hardware name: Intel Corporation S2600WFD/S2600WFD, BIOS SE5C620.86B.01.00.0412.020920172159 02/09/2017
 Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
 task: ffff882fce3f4b00 task.stack: ffffc9002422c000
 RIP: 0010:          (null)
 RSP: 0018:ffffc9002422f990 EFLAGS: 00010206
 RAX: ffff882fd0078000 RBX: ffff882fa0263000 RCX: ffffc9002422f998
 RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff882fd0078000
 RBP: ffffc9002422fad0 R08: 0000000000000000 R09: ffff882fa0263080
 R10: ffffffffa0964ca0 R11: 0000000000000000 R12: ffff8817dcea3700
 R13: ffff882fa0263000 R14: 000000000000c000 R15: 000000000000c000
 FS:  0000000000000000(0000) GS:ffff882fdd000000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000000 CR3: 00000017db346004 CR4: 00000000007606e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  ? is_valid_mcast_lid.isra.23+0xfb/0x110 [ib_core]
  ib_attach_mcast+0x6f/0xa0 [ib_core]
  ipoib_mcast_attach+0x72/0x160 [ib_ipoib]
  ipoib_mcast_join_complete+0x354/0xb40 [ib_ipoib]
  mcast_work_handler+0x2ff/0x630 [ib_core]
  join_handler+0xf0/0x1e0 [ib_core]
  ib_sa_mcmember_rec_callback+0x54/0x80 [ib_core]
  recv_handler+0x3a/0x60 [ib_core]
  ib_mad_recv_done+0x43d/0xa20 [ib_core]
  __ib_process_cq+0x5d/0xb0 [ib_core]
  ib_cq_poll_work+0x20/0x60 [ib_core]
  process_one_work+0x138/0x370
  worker_thread+0x4d/0x3b0
  kthread+0x109/0x140
  ? rescuer_thread+0x320/0x320
  ? kthread_park+0x60/0x60
  ret_from_fork+0x25/0x30
 Code:  Bad RIP value.
 RIP:           (null) RSP: ffffc9002422f990
 CR2: 0000000000000000
 ---[ end trace f3c2d0cdf0ebfb9c ]---

is_valid_mcast_lid.isra.23+0xfb/0x110

(gdb) l *(is_valid_mcast_lid+0xfb)
0x229b is in is_valid_mcast_lid (drivers/infiniband/core/verbs.c:1649).
1644		/* If QP state >= init, it is assigned to a port and we can check this
1645		 * port only.
1646		 */
1647		if (!ib_query_qp(qp, &attr, IB_QP_STATE | IB_QP_PORT, &init_attr)) {
1648			if (attr.qp_state >= IB_QPS_INIT) {
1649				if (qp->device->get_link_layer(qp->device, attr.port_num) !=
1650				    IB_LINK_LAYER_INFINIBAND)
1651					return true;
1652				goto lid_check;
1653			}
(gdb) 

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
