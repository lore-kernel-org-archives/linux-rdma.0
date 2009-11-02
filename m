From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [Fwd: Crash in bonding]
Date: Mon, 02 Nov 2009 14:43:56 -0800
Message-ID: <4AEF60AC.6030508@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000900060004000308040807"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------000900060004000308040807
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Typo in email address. Resending.

Pradeep

--------------000900060004000308040807
Content-Type: message/rfc822;
 name="Crash in bonding.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Crash in bonding.eml"

Message-ID: <4AEF6020.7000806-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date: Mon, 02 Nov 2009 14:41:36 -0800
From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: monis-smomgflXvOZWk0Htik3J/w@public.gmane.org
CC: EWG <Openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TZpP82i2CBTzA@public.gmane.org,
 fubar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Subject: Crash in bonding 
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This crash was originally reported against Rhel5.4. However, one can recreate this crash quite easily in OFED-1.5 too. 
The steps to recreate the crash are as follows:

1. Run traffic (I used ping) on the IB interfaces through the bond master
2. ifdown ib0
3. ifdown ib1
4. modprobe -r ib_ipoib

Quite often, the crash stack trace seen is as follows:

ID: 0      TASK: ffff81087fc11820  CPU: 13  COMMAND: "swapper"
 #0 [ffff81010ff07ab0] crash_kexec at ffffffff800ac5b9
 #1 [ffff81010ff07b70] __die at ffffffff80065127
 #2 [ffff81010ff07bb0] do_page_fault at ffffffff80066da7
 #3 [ffff81010ff07ca0] error_exit at ffffffff8005dde9
 #4 [ffff81010ff07d58] neigh_connected_output at ffffffff8022cb87
 #5 [ffff81010ff07d88] ip_output at ffffffff800320ac
 #6 [ffff81010ff07db8] ip_queue_xmit at ffffffff8003464d
 #7 [ffff81010ff07e78] tcp_transmit_skb at ffffffff80021d73
 #8 [ffff81010ff07ec8] tcp_retransmit_skb at ffffffff80250ccd
 #9 [ffff81010ff07f08] tcp_write_timer at ffffffff80252652
#10 [ffff81010ff07f28] run_timer_softirq at ffffffff800968be
#11 [ffff81010ff07f58] __do_softirq at ffffffff8001235a
#12 [ffff81010ff07f88] call_softirq at ffffffff8005e2fc
#13 [ffff81010ff07fa0] do_softirq at ffffffff8006cb14
#14 [ffff81010ff07fb0] apic_timer_interrupt at ffffffff8005dc8e
--- <IRQ stack> ---
#15 [ffff81010ff03e48] apic_timer_interrupt at ffffffff8005dc8e
    [exception RIP: mwait_idle+54]
    RIP: ffffffff800571f4  RSP: ffff81010ff03ef0  RFLAGS: 00000246
    RAX: 0000000000000000  RBX: 000000000000000d  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: 0000000000000001  RDI: ffffffff80301698
    RBP: ffff81087fc11a10   R8: ffff81010ff02000   R9: 0000000000000032
    R10: ffff81048e0cc4f0  R11: ffff8103ebafcd18  R12: 0000000005f33f4d
    R13: 00000d12e63d7223  R14: ffff81047fe797a0  R15: ffff81087fc11820
    ORIG_RAX: ffffffffffffff10  CS: 0010  SS: 0018
#16 [ffff81010ff03ef0] cpu_idle at ffffffff8004939e



I was able to set up some break points and the analysis follows.

cpu 0x1 stopped at breakpoint 0x1 (d000000000ec4214 .bond_release+0x0/0x4d0 [bonding])
        mflr    r0
enter ? for help
1:mon> t
[link register   ] d000000000ecdf80 .bonding_store_slaves+0x304/0x3f0 [bonding]
[c00000000fd97b00] d000000000ecdf70 .bonding_store_slaves+0x2f4/0x3f0 [bonding] (unreliable)
[c00000000fd97bd0] c00000000029a660 .class_device_attr_store+0x44/0x60
[c00000000fd97c40] c00000000015df9c .sysfs_write_file+0x134/0x1b8
[c00000000fd97cf0] c0000000000f8ec4 .vfs_write+0x118/0x200
[c00000000fd97d90] c0000000000f9634 .sys_write+0x4c/0x8c
[c00000000fd97e30] c0000000000086a4 syscall_exit+0x0/0x40
--- Exception: c00 (System Call) at 000000000ff11138
SP (ffd1f300) is in userspace

Did some basic sanity checks and confirmed that we hit a couple of breakpoints and
the bond master was indeed bond0 as expected and the slave device being released was ib1.
After the breakpoints, we crashed 


Faulting instruction address: 0xc00000000034bddc
cpu 0x1: Vector: 300 (Data Access) at [c0000000e025b2b0]
    pc: c00000000034bddc: .neigh_resolve_output+0x28c/0x34c
    lr: c00000000034bdc0: .neigh_resolve_output+0x270/0x34c
    sp: c0000000e025b530
   msr: 8000000000009032
   dar: d000000000c6fe58
 dsisr: 40000000
  current = 0xc0000000e25f1aa0
  paca    = 0xc00000000053e280
    pid   = 3591, comm = ping
enter ? for help
1:mon> e
cpu 0x1: Vector: 300 (Data Access) at [c0000000e025b2b0]
    pc: c00000000034bddc: .neigh_resolve_output+0x28c/0x34c
    lr: c00000000034bdc0: .neigh_resolve_output+0x270/0x34c
    sp: c0000000e025b530
   msr: 8000000000009032
   dar: d000000000c6fe58
 dsisr: 40000000
  current = 0xc0000000e25f1aa0
  paca    = 0xc00000000053e280
    pid   = 3591, comm = ping
1:mon> t
[c0000000e025b5e0] c000000000376934 .ip_output+0x358/0x3c0
[c0000000e025b670] c000000000374a04 .ip_push_pending_frames+0x440/0x558
[c0000000e025b720] c000000000397f10 .raw_sendmsg+0x770/0x860
[c0000000e025b860] c0000000003a24f8 .inet_sendmsg+0x7c/0xa8
[c0000000e025b900] c00000000033031c .sock_sendmsg+0x114/0x1b8
[c0000000e025bb00] c000000000331878 .sys_sendmsg+0x218/0x2ac
[c0000000e025bd20] c000000000356314 .compat_sys_sendmsg+0x14/0x28
[c0000000e025bd90] c000000000357914 .compat_sys_socketcall+0x1e4/0x214
[c0000000e025be30] c0000000000086a4 syscall_exit+0x0/0x40
--- Exception: c00 (System Call) at 0000000007f03c98
SP (ffb6e570) is in userspace
1:mon>

I looked at the skb and confirmed that this was indeed against bond0.

One thing is apparent at this point. ping is continuing even though bond_release()
for ib1 (and of course ib0) occurred way back!

This is the reason for the crash. Any suggestions as to how to fix this?

Pradeep




--------------000900060004000308040807--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
