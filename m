From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Testing for RDMA with ib_srp: Failed to map data (-12) with
 max_sectors_kb=4096 and buffered I/O with 4MB writes
Date: Wed, 20 Apr 2016 22:57:52 -0400 (EDT)
Message-ID: <559411025.30902774.1461207472544.JavaMail.zimbra@redhat.com>
References: <222947733.30902382.1461207053808.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <222947733.30902382.1461207053808.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello

I am still on my quest for getting 4MB buffered writes to be stable to RDMA SRP targets.
Lots of testing has been performed here with EDR 100 back to back connections using
mellanox ConnectX-4 with mlx5_ib, an dthe ib_srp* drivers on target server and client.

In summary:
 setting max_sectors_kb=4096 and running DIRECT_IO is solid as a rock
 setting max_sectors_kb=2048 and running buffered 4MB writes to an FS on a multipath is rock solid

 However:
 setting max_sectors_kb=4096 and running buffered I/O sees serious mapping issues.


I have isolated the failure and call flow to this 

srp_queuecommand 
    srp_map_data(scmnd, ch, req);
	  srp_map_idb
	      ret = srp_map_finish_fr(&state, req, ch, 1);	


The -12 is returned by srp_map_finish_fr() and fed back to fail with 
ib_srp: Failed to map data (-12)

>From this stub of code I added the debug to track this.

ifdef CONFIG_NEED_SG_DMA_LENGTH
                idb_sg->dma_length = idb_sg->length;          /* hack^2 */
#endif
                ret = srp_map_finish_fr(&state, req, ch, 1);
                if (ret < 0) {
                        printk("RHDEBUG: ib_srp after calling
srp_map_finish_fr\n");
                        return ret;
                }
        } else if (dev->use_fmr) {
                state.pages = idb_pages;
                state.pages[0] = (req->indirect_dma_addr &

     
[  239.954285] RHDEBUG: ib_srp after calling srp_map_finish_fr
[  239.997933] RHDEBUG: ib_srp after srp_map_idb ret=-12
[  240.078294] scsi host4: ib_srp: Failed to map data (-12)

[  240.110379] RHDEBUG: ib_srp after calling srp_map_finish_fr
[  240.141582] RHDEBUG: ib_srp after srp_map_idb ret=-12
[  240.173014] scsi host5: ib_srp: Failed to map data (-12)

Bart and Christoph, I know we have bunch of new patches that recently showed up
on the RDMA list. Some seem to maybe play into this issue but I wanted to get an opinion
first.

Thanks!!

Configuration
--------------
Target Server is running 4.5.0-rc7+ and LIO
Has Mellanox ConnectX-4 using mlx5_ib and ib_srp* drivers

options ib_srp cmd_sg_entries=255 indirect_sg_entries=2048
options ib_srpt srp_max_req_size=8296

LUNS are served as block devices via LIO using tmpfs back-end
This allows me to set max_sectors_kb=4096 on the client for the LUNS.

Client is running 4.6.0-rc3+ and block_mq
Has Mellanox ConnectX-4 using mlx5_ib and ib_srp* drivers
srptools-1.0.2-1.el7.x86_64

options ib_srpt srp_max_req_size=8296
options ib_srp cmd_sg_entries=64 indirect_sg_entries=512

On the client
------------------
Probe for and map 15 mpath devices using 
run_srp_daemon  -f /etc/ddn/srp_daemon.conf -R 30 -T 10 -t 7000 -ance -i
mlx5_0 1p 1

Exhastive testing with max_sectors_kb=4096 and 10 parallel tasks using
DIRECT_IO is stable.

With max_sectors_kb=2048 and 10 parallel fs buffered write tasks I have no
issues whatsovers either.

However:
Set max_sectors_kb to 4096 
[root@srptest ~]# ./set_sectors.sh
Setting max_sectors_kb to 4096
2048
4096
..
..
2048
4096

File systenms mounted using mpath device
/dev/mapper/360014051779fcf42e6c4667bbaa9da79   9948012    22620   9413392
1% /data-1

# 360014051779fcf42e6c4667bbaa9da79 dm-7 LIO-ORG ,block-12        
size=9.8G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=50 status=active
  |- 4:0:0:11 sdf  8:80   active ready running
  `- 5:0:0:3  sdac 65:192 active ready running


Starting a single client FS write after setting max_sectors_kb=4096

[  239.954285] RHDEBUG: ib_srp after calling srp_map_finish_fr
[  239.997933] RHDEBUG: ib_srp after srp_map_idb ret=-12
[  240.078294] scsi host4: ib_srp: Failed to map data (-12)
[  240.110379] RHDEBUG: ib_srp after calling srp_map_finish_fr
[  240.141582] RHDEBUG: ib_srp after srp_map_idb ret=-12
[  240.173014] scsi host5: ib_srp: Failed to map data (-12)
[  240.353439] RHDEBUG: ib_srp after calling srp_map_finish_fr
[  240.384752] RHDEBUG: ib_srp after srp_map_idb ret=-12
[  240.414045] scsi host4: ib_srp: Failed to map data (-12)
[  240.450089] RHDEBUG: ib_srp after calling srp_map_finish_fr
[  240.479523] RHDEBUG: ib_srp after srp_map_idb ret=-12
[  240.507530] scsi host4: ib_srp: Failed to map data (-12)
[  240.550466] sd 4:0:0:11: [sdf] tag#10 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  240.598916] sd 4:0:0:11: [sdf] tag#10 Sense Key : Illegal Request [current]
[  240.638940] sd 4:0:0:11: [sdf] tag#10 Add. Sense: Invalid field in cdb
[  240.675045] sd 4:0:0:11: [sdf] tag#10 CDB: Write(10) 2a 00 00 5a 19 c8 00
20 00 00
[  240.717007] blk_update_request: critical target error, dev sdf, sector
5904840
[  240.757581] blk_update_request: critical target error, dev dm-7, sector
5904840
[  240.798756] EXT4-fs warning (device dm-7): ext4_end_bio:315: I/O error -121
writing to inode 12 (offset 0 size 0 starting block 738361)
[  240.866296] Buffer I/O error on device dm-7, logical block 738105
[  240.900218] Buffer I/O error on device dm-7, logical block 738106
[  240.934851] Buffer I/O error on device dm-7, logical block 738107
[  240.970060] Buffer I/O error on device dm-7, logical block 738108
[  241.005382] Buffer I/O error on device dm-7, logical block 738109
[  241.040365] Buffer I/O error on device dm-7, logical block 738110
[  241.074322] Buffer I/O error on device dm-7, logical block 738111
[  241.108310] Buffer I/O error on device dm-7, logical block 738112
[  241.143035] Buffer I/O error on device dm-7, logical block 738113
[  241.177360] Buffer I/O error on device dm-7, logical block 738114
[  241.211258] EXT4-fs warning (device dm-7): ext4_end_bio:315: I/O error -121
writing to inode 12 (offset 0 size 0 starting block 738617)

After a while also get the list_del corruption

[  243.017767] ------------[ cut here ]------------
[  243.017774] WARNING: CPU: 10 PID: 3581 at lib/list_debug.c:62
__list_del_entry+0x82/0xd0
[  243.017775] list_del corruption. next->prev should be ffff8823cfde0ab8, but
was dead000000000200
[  243.017803] Modules linked in: ext4 jbd2 mbcache dm_round_robin xt_CHECKSUM
ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter ip6t_REJECT
nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ebtable_nat
ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security
ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security
iptable_raw iptable_filter rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi
scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp
ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_sa ib_mad
intel_powerclamp coretemp kvm_intel kvm dm_service_time irqbypass
crct10dif_pclmul
[  243.017829]  crc32_pclmul ipmi_ssif ghash_clmulni_intel aesni_intel lrw
gf128mul glue_helper iTCO_wdt ipmi_si iTCO_vendor_support ablk_helper
i7core_edac sg hpwdt hpilo pcspkr shpchp cryptd ipmi_msghandler lpc_ich
edac_core acpi_power_meter mfd_core pcc_cpufreq acpi_cpufreq nfsd auth_rpcgss
nfs_acl lockd grace sunrpc dm_multipath ip_tables xfs libcrc32c sd_mod mlx5_ib
ib_core ib_addr mlx5_core radeon i2c_algo_bit drm_kms_helper syscopyarea
sysfillrect sysimgblt fb_sys_fops ttm vxlan ip6_udp_tunnel lpfc udp_tunnel drm
qla2xxx hpsa crc32c_intel ptp serio_raw i2c_core bnx2 scsi_transport_fc
scsi_transport_sas pps_core dm_mirror dm_region_hash dm_log dm_mod
[  243.017831] CPU: 10 PID: 3581 Comm: kdmwork-253:7 Tainted: G          I
4.6.0-rc3+ #1
[  243.017832] Hardware name: HP ProLiant DL380 G7, BIOS P67 07/02/2013
[  243.017834]  0000000000000086 00000000a56b2b69 ffff88119796b9f8
ffffffff8134421f
[  243.017835]  ffff88119796ba48 0000000000000000 ffff88119796ba38
ffffffff810895d1
[  243.017836]  0000003e9796bad0 ffff8823cfde0ab8 ffff8823cfde0ab8
ffff8823c76f7900
[  243.017836] Call Trace:
[  243.017841]  [<ffffffff8134421f>] dump_stack+0x63/0x84
[  243.017844]  [<ffffffff810895d1>] __warn+0xd1/0xf0
[  243.017845]  [<ffffffff8108964f>] warn_slowpath_fmt+0x5f/0x80
[  243.017846]  [<ffffffff81360d12>] __list_del_entry+0x82/0xd0
[  243.017848]  [<ffffffff81360d6d>] list_del+0xd/0x30
[  243.017853]  [<ffffffffa039b9c9>] srp_map_finish_fr+0xa9/0x230 [ib_srp]
[  243.017855]  [<ffffffff8136d4b3>] ? swiotlb_map_sg_attrs+0x73/0x140
[  243.017857]  [<ffffffffa039e7c0>] srp_queuecommand+0x9b0/0xcf0 [ib_srp]
[  243.017860]  [<ffffffff8149fbeb>] scsi_dispatch_cmd+0xab/0x250
[  243.017861]  [<ffffffff814a2556>] scsi_queue_rq+0x646/0x760
[  243.017864]  [<ffffffff81322672>] __blk_mq_run_hw_queue+0x1f2/0x370
[  243.017865]  [<ffffffff81322465>] blk_mq_run_hw_queue+0x95/0xb0
[  243.017866]  [<ffffffff81323d33>] blk_mq_insert_request+0xa3/0xc0
[  243.017868]  [<ffffffff81318a82>] blk_insert_cloned_request+0x92/0x1b0
[  243.017875]  [<ffffffffa0002311>] map_request+0x1a1/0x240 [dm_mod]
[  243.017878]  [<ffffffffa00023d2>] map_tio_request+0x22/0x40 [dm_mod]
[  243.017880]  [<ffffffff810a92e2>] kthread_worker_fn+0x52/0x170
[  243.017881]  [<ffffffff810a9290>] ? kthread_create_on_node+0x1a0/0x1a0
[  243.017882]  [<ffffffff810a8d08>] kthread+0xd8/0xf0
[  243.017886]  [<ffffffff816bbe82>] ret_from_fork+0x22/0x40
[  243.017887]  [<ffffffff810a8c30>] ? kthread_park+0x60/0x60
[  243.017888] ---[ end trace 34340fe67759d95c ]---
[  243.017894] ------------[ cut here ]------------

Array side
-----------

Apr 20 20:10:40 fedstorage kernel: TARGET_CORE[srpt]: Expected Transfer Length:
1564672 does not match SCSI CDB Length: 4194304 for SAM Opcode: 0x2a
Apr 20 20:10:40 fedstorage kernel: TARGET_CORE[srpt]: Expected Transfer
Length: 1785856 does not match SCSI CDB Length: 4194304 for SAM Opcode: 0x2a
Apr 20 20:10:40 fedstorage kernel: TARGET_CORE[srpt]: Expected Transfer
Length: 1638400 does not match SCSI CDB Length: 4194304 for SAM Opcode: 0x2a
Apr 20 20:10:40 fedstorage kernel: TARGET_CORE[srpt]: Expected Transfer
Length: 1634304 does not match SCSI CDB Length: 4194304 for SAM Opcode: 0x2a
Apr 20 20:10:40 fedstorage kernel: TARGET_CORE[srpt]: Expected Transfer
Length: 1630208 does not match SCSI CDB Length: 4194304 for SAM Opcode: 0x2a


Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
