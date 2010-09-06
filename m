From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: hang when exiting opensm or diagnet
Date: Mon, 6 Sep 2010 18:38:13 +0300
Message-ID: <201009061838.13362.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, erezc-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We have a situation where ibdiagnet does not succeed in exiting.  (OpenSM displays the same behavior).
Performing a sysrq_trigger generates the following stack trace for ibdiagnet:

kernel: ibdiagnet     D ffff810001004420     0  7004   6854
kernel:  ffff81066899fbc8 0000000000000046 ffff810367160000 ffff810367160310
kernel:  ffff81066899fbb8 0000000000000009 ffff81066dfac860 ffffffff80301ae0
kernel:  0000008a75579daa 0000000000008686 ffff81066dfaca48 0000000000000000
kernel: Call Trace:
kernel:  [<ffffffff80063167>] wait_for_completion+0x79/0xa2
kernel:  [<ffffffff8008cabc>] default_wake_function+0x0/0xe
kernel:  [<ffffffff8839034d>] :ib_mad:ib_cancel_rmpp_recvs+0xd0/0x113
kernel:  [<ffffffff8838d52e>] :ib_mad:ib_unregister_mad_agent+0x30d/0x424
kernel:  [<ffffffff8022296d>] sk_free+0xc3/0x105
kernel:  [<ffffffff883d63fd>] :ib_umad:ib_umad_close+0x9d/0xd6
kernel:  [<ffffffff800129df>] __fput+0xae/0x198
kernel:  [<ffffffff80023a17>] filp_close+0x5c/0x64
kernel:  [<ffffffff80038f1a>] put_files_struct+0x63/0xae

Does anyone have any ideas as to what could be causing this?

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
