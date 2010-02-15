From: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Problems with rnfs
Date: Mon, 15 Feb 2010 13:44:07 -0800
Message-ID: <1266270247.5779.21.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

I am having an issue getting nfs over rdma working on sles11 on ppc64.
I see the same results with both OFED 1.5 and 1.5.1, I have also tried
both the a 2.6.30 kernel and the 2.6.27 kernel provided with SLES11.
(using kernel modules from OFED).

I can create the remote mount, run ls on it, but when I try to cp a file
to the remote mount I get the following Oops:

Any ideas?

: Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=1024 NUMA pSeries
Modules linked in: nfsd lockd exportfs auth_rpcgss nfs_acl svcrdma
sunrpc ib_ise
r iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi rdma_ucm
qlgc_vnic ib_sdp
 rdma_cm ib_addr iw_cm ib_ipoib ib_cm ib_sa ipv6 ib_uverbs ib_umad
iw_nes crc32c
 libcrc32c iw_cxgb3 cxgb3 ib_ehca mlx4_en mlx4_ib mlx4_core fuse loop
ib_mthca i
b_mad ses sr_mod ib_core cdrom enclosure sg e1000 evbug uhci_hcd
pata_pdc2027x s
d_mod crc_t10dif ipr libata scsi_mod dm_region_hash dm_log dm_mod
NIP: d0000000062bcf64 LR: d000000006eb0c94 CTR: d0000000062bcf00
REGS: c0000000fb787b20 TRAP: 0300   Not tainted  (2.6.30-5-ppc64)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 22000024  XER: 00000010
DAR: 0000000000000000, DSISR: 0000000040000000
TASK = c0000000ef624260[3005] 'nfsd' THREAD: c0000000fb784000 CPU: 0
GPR00: 0000000000000001 c0000000fb787da0 d0000000062f9f08
c0000000fcef8d80 
GPR04: 0000000000000001 0000000000000070 0000000000000000
0000000000000000 
GPR08: 0000000000000000 0000000000000000 0000000000000001
c000000000e5e700 
GPR12: d000000006eda9c8 c000000000a82400 c000000000794408
c0000000006b3bc1 
GPR16: 0000000002394340 0000000000000000 c000000000794340
00000000019df9c0 
GPR20: c000000000794358 c0000000006d08ff 0000000000916400
c0000000fb563780 
GPR24: 0000000000000001 0000000000000000 c0000000008c7640
0000000000000000 
GPR28: 0000000000000000 c0000000fcef8d80 d0000000062f6a88
c0000000fcef8d80 
NIP [d0000000062bcf64] .svc_process+0x64/0x864 [sunrpc]
LR [d000000006eb0c94] .nfsd+0x150/0x1b8 [nfsd]
Call Trace:
[c0000000fb787da0] [0000000000000001] 0x1 (unreliable)
[c0000000fb787e70] [d000000006eb0c94] .nfsd+0x150/0x1b8 [nfsd]
[c0000000fb787f00] [c0000000000a0b20] .kthread+0x84/0xd0
[c0000000fb787f90] [c00000000002a464] .kernel_thread+0x54/0x70
Instruction dump:
fba1ffe8 f821ff31 e8a30110 eae300b0 2ba50017 409d05d0 e9230220 38000001 
e97e8048 39000000 90030228 e9290000 <e8090000> 780aa320 7940aac2
78001f24 
---[ end trace b2c0889cfad5bbdf ]---

Here are the steps I am using.

On the server.
/etc/exports ..
192.168.0.34/255.255.255.0(fsid=0,rw,async,insecure,no_root_squash)

modprobe svcrdma
/etc/init.d/nfsserver start
echo rdma 20049 > /proc/fs/nfsd/portlist

On the client:
modprobe xprtrdma
/sbin/mount.rnfs 192.168.0.64:/home /mnt  -o rdma,port=20049,nolock

ls /mnt   (works)
cp vmlinux /mnt  (fails)

Dave...


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
