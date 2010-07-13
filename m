From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: IB/ipoib: fix dangling pointer reference to ipoib_neigh and ipoib_path
 -when will it go upstream?
Date: Mon, 12 Jul 2010 23:07:46 -0700
Message-ID: <4C3C02B2.9040408@linux.vnet.ibm.com>
References: <4C3AA0A2.3090406@linux.vnet.ibm.com> <adapqysxup6.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adapqysxup6.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > I realize that the following patch: 
>  > 
>  > https://patchwork.kernel.org/patch/97243/
>  > 
>  > is queued in your backlog of patches and unlikely that it will go into 2.6.35.
>  > What are the chances that it will make it into 2.6.36? This patch has fixed a
>  > a rarely seen crash and we would like it to go upstream ASAP.
> 
> How much testing and/or review have you done for this patch?  What is
> the impact of the bug in the cases you have seen?

I guess I came to a premature conclusion. One set of tests ran fine and I made that
conclusion. Another set of tests caused the following crash:

12:mon> t
[link register   ] d00000000ec950a8 .cm_destroy_id+0x3d8/0x520 [ib_cm]
[c0000007544d2d40] d00000000ec95098 .cm_destroy_id+0x3c8/0x520 [ib_cm] (unreliable)
[c0000007544d2e10] d00000000ef9b590 .ipoib_cm_free_rx_reap_list+0xc8/0x180 [ib_ipoib]
[c0000007544d2ed0] d00000000ef9e1cc .ipoib_cm_dev_stop+0x23c/0x360 [ib_ipoib]
[c0000007544d2f90] d00000000ef94d94 .ipoib_ib_dev_stop+0xe4/0x4b0 [ib_ipoib]
[c0000007544d30f0] d00000000ef91d68 .ipoib_stop+0x88/0x178 [ib_ipoib]
[c0000007544d3180] c0000000004ea1cc .dev_close+0xdc/0x148
[c0000007544d3210] c0000000004e9790 .dev_change_flags+0x1f0/0x288
[c0000007544d32b0] c0000000004f6a0c .do_setlink+0x2d4/0x498
[c0000007544d3390] c0000000004f8b20 .rtnl_newlink+0x520/0x5f0
[c0000007544d35a0] c0000000004f853c .rtnetlink_rcv_msg+0x24c/0x310
[c0000007544d3650] c000000000513a38 .netlink_rcv_skb+0xf0/0x128
[c0000007544d36e0] c0000000004f82cc .rtnetlink_rcv+0x34/0x58
[c0000007544d3770] c0000000005134c0 .netlink_unicast+0x498/0x4b0
[c0000007544d3840] c000000000514218 .netlink_sendmsg+0x288/0x390
[c0000007544d3920] c0000000004cf538 .sock_sendmsg+0x118/0x158
[c0000007544d3b30] c0000000004cf720 .SyS_sendmsg+0x1a8/0x348
[c0000007544d3d70] c0000000004cdbdc .SyS_socketcall+0x174/0x338
[c0000007544d3e30] c0000000000085b4 syscall_exit+0x0/0x40
--- Exception: c01 (System Call) at 00000fffa25c35d0
SP (fffc5a12fe0) is in userspace
12:mon> e
cpu 0x12: Vector: 300 (Data Access) at [c0000007544d2ac0]
    pc: c0000000002ef854: .rb_erase+0x64/0x180
    lr: d00000000ec950a8: .cm_destroy_id+0x3d8/0x520 [ib_cm]
    sp: c0000007544d2d40
   msr: 8000000000001432
   dar: 10000000100
 dsisr: 40000000
  current = 0xc0000006948dc240
  paca    = 0xc000000000f64a00
    pid   = 21593, comm = ip
12:mon>

Thanks
Pradeep

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
