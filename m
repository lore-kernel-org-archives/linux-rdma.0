From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v5] IB/ipoib: fix dangling pointer references to ipoib_neigh
 and ipoib_path
Date: Thu, 02 Sep 2010 20:41:38 -0700
Message-ID: <4C806E72.6030507@linux.vnet.ibm.com>
References: <20100817203619.22174.62871.stgit@chromite.mv.qlogic.com> <20100817203624.22174.69480.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100817203624.22174.69480.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Ralph,

I see the following crash sporadically (only under stress) with a Sles11SP1 (which is 2.6.32 kernel).
I saw this crash with V4 of your patch and have not yet had a chance to try V5. Have you seen this
in your testing? If this not the crash stack can you please share what your patch fixes?

<4>ib0: RX drain timing out
<4>idr_remove called for id=11491974 which is not allocated.
<4>Call Trace:
<4>[c000000749fe33b0] [c0000000000129e4] .show_stack+0x6c/0x198 (unreliable)
<4>[c000000749fe3460] [c0000000002ea594] .sub_remove+0x1ec/0x1f8
<4>[c000000749fe3520] [c0000000002ea5e0] .idr_remove+0x40/0xf8
<4>[c000000749fe35b0] [d000000012d84d70] .cm_destroy_id+0xa0/0x520 [ib_cm]
<4>[c000000749fe3680] [d00000001b7fb644] .ipoib_cm_free_rx_reap_list+0xd4/0x190 [ib_ipoib]
<4>[c000000749fe3740] [d00000001b7fe404] .ipoib_cm_dev_stop+0x23c/0x360 [ib_ipoib]
<4>[c000000749fe3800] [d00000001b7f4dbc] .ipoib_ib_dev_stop+0xe4/0x4b0 [ib_ipoib]
<4>[c000000749fe3960] [d00000001b7f0f30] .ipoib_stop+0x88/0x178 [ib_ipoib]
<4>[c000000749fe39f0] [c0000000004eacf4] .dev_close+0xdc/0x148
<4>[c000000749fe3a80] [c0000000004ea2b8] .dev_change_flags+0x1f0/0x288
<4>[c000000749fe3b20] [d00000001b7f11b8] .ipoib_remove_one+0xb8/0x140 [ib_ipoib]
<4>[c000000749fe3bc0] [d00000001210425c] .ib_unregister_client+0xb4/0x1b8 [ib_core]
<4>[c000000749fe3c90] [d00000001b7ffde8] .ipoib_cleanup_module+0x20/0x60 [ib_ipoib]
<4>[c000000749fe3d20] [c0000000000ec408] .SyS_delete_module+0x238/0x320
<4>[c000000749fe3e30] [c0000000000085b4] syscall_exit+0x0/0x40
<1>Unable to handle kernel paging request for data at address 0x45000027228d1ffb
<1>Faulting instruction address: 0xc0000000005a8e88
12:mon> e
cpu 0x12: Vector: 300 (Data Access) at [c000000749fe3250]
    pc: c0000000005a8e88: .wait_for_common+0xb8/0x268
    lr: c0000000005a8e20: .wait_for_common+0x50/0x268
    sp: c000000749fe34d0
   msr: 8000000000009032
   dar: 45000027228d1ffb
 dsisr: 42000000
  current = 0xc00000074b4ce0e0
  paca    = 0xc000000000f64a00
    pid   = 13605, comm = modprobe
12:mon>

Thanks
Pradeep

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
