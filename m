From: "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from misinterpreted
 flag
Date: Thu, 19 Oct 2017 17:40:59 -0400
Message-ID: <20171019213859.26124.37851.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I was playing with the ibacm service and discovered an issue
the other day.

If no provider library is present (I removed libacmp.so, and the
provider keyword in the opts.cfg file is libacmp), when a resolve
request is posted, the kernel will crash with the following Oops:

BUG: unable to handle kernel NULL pointer dereference at (null)
IP:           (null)
PGD 10543f1067 P4D 10543f1067 PUD 1033f93067 PMD 0
Oops: 0010 [#1] SMP
Modules linked in: rpcrdma ib_isert iscsi_target_mod
 target_core_mod ib_iser libiscsi scsi_transport_iscsi ib_ipoib rdma_ucm ib_u
 ib_uverbs ib_umad rdma_cm ib_cm iw_cm dm_mirror dm_region_hash dm_log dm_mod
 dax sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm irqbypass
 crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel crypto_si
 glue_helper cryptd hfi1 rdmavt iTCO_wdt iTCO_vendor_support ib_core mei_me
 lpc_ich pcspkr mei ioatdma sg shpchp i2c_i801 mfd_core wmi ipmi_si ipmi_devi
 ipmi_msghandler acpi_power_meter acpi_pad nfsd auth_rpcgss nfs_acl lockd gra
 sunrpc ip_tables ext4 mbcache jbd2 sd_mod mgag200 drm_kms_helper syscopyarea
 sysfillrect sysimgblt fb_sys_fops ttm igb ahci crc32c_intel ptp libahci
 pps_core drm dca libata i2c_algo_bit i2c_core
CPU: 54 PID: 9841 Comm: ibacm Tainted: G          I    4.14.0-rc2+ #6
Hardware name: Intel Corporation S2600WT2/S2600WT2, BIOS     SE5C610.86B.01.01.0008.021120151325 02/11/2015
task: ffff880855f42d00 task.stack: ffffc900246b4000
RIP: 0010:          (null)
RSP: 0018:ffffc900246b7bc8 EFLAGS: 00010246
RAX: ffffffff81dbe9e0 RBX: ffff881058bb1000 RCX: 0000000000000000
RDX: 0000000000001100 RSI: ffff881058bb1320 RDI: ffff881056362000
RBP: ffffc900246b7bf8 R08: 0000000000000ec0 R09: 0000000000001100
R10: ffff8810573a5000 R11: 0000000000000000 R12: ffff881056362000
R13: 0000000000000ec0 R14: ffff881058bb1320 R15: 0000000000000ec0
FS:  00007fe0ba5a38c0(0000) GS:ffff88105f080000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000001056f5d003 CR4: 00000000001606e0
Call Trace:
 ? netlink_dump+0x12c/0x290
 __netlink_dump_start+0x186/0x1f0
 rdma_nl_rcv_msg+0x193/0x1b0 [ib_core]
 rdma_nl_rcv+0xdc/0x130 [ib_core]
 netlink_unicast+0x181/0x240
 netlink_sendmsg+0x2c2/0x3b0
 sock_sendmsg+0x38/0x50
 SYSC_sendto+0x102/0x190
 ? __audit_syscall_entry+0xaf/0x100
 ? syscall_trace_enter+0x1d0/0x2b0
 ? __audit_syscall_exit+0x209/0x290
 SyS_sendto+0xe/0x10
 do_syscall_64+0x67/0x1b0
 entry_SYSCALL64_slow_path+0x25/0x25
RIP: 0033:0x7fe0b9db2a63
RSP: 002b:00007ffc55edc260 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000010 RCX: 00007fe0b9db2a63
RDX: 0000000000000010 RSI: 00007ffc55edc280 RDI: 000000000000000d
RBP: 00007ffc55edc670 R08: 00007ffc55edc270 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 00007ffc55edc280
R13: 000000000260b400 R14: 000000000000000d R15: 0000000000000001
Code:  Bad RIP value.
RIP:           (null) RSP: ffffc900246b7bc8
CR2: 0000000000000000
---[ end trace 8d67abcfd10ec209 ]---
Kernel panic - not syncing: Fatal exception
Kernel Offset: disabled
---[ end Kernel panic - not syncing: Fatal exception
------------[ cut here ]------------

The issue is that in rdma_nl_rcv_msg(), the check
'if (flags & NLM_F_DUMP)' is not completely correct.
    
NLM_F_DUMP is two bits NLM_F_ROOT | NLM_F_MATCH.

ibacm sends a RDMA_NL_LS response with the RDMA_NL_LS_F_ERR bit set
if an error occurs in the service (like no provider being available,
or ACM_STATUS_ENODATA, etc.).

NLM_F_ROOT == (0x100) == RDMA_NL_LS_F_ERR.
    
The current code thinks that it sees a NLM_F_DUMP flag and incorrectly calls
the .dump() callback.

The included patch is an atempt to fix this issue.  This patch fixes the
issue that I am seeing, but I am not sure how to test the messages for
RDMA_NL_RDMA_CM or RDMA_NL_IWCM (or any message that uses the
NLM_F_DUMP bits).

If anyone has some knowledge of these services, any extra testing would
be welcomed.

If the patch has no issues or comments, I will formally re-submit it
(through my usual channel Denny).

Thanks,

Mike


---

Michael J. Ruhl (1):
      RDMA/netlink: OOPs in rdma_nl_rcv_msg() from misinterpreted flag


 drivers/infiniband/core/netlink.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
