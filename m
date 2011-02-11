From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] IPoIB: fix faulty list maintenance in path and neigh
 list
Date: Fri, 11 Feb 2011 10:09:36 -0800
Message-ID: <4D557B60.1020005@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Resending since this got rejected previously as spam.

Thanks
Pradeep
On 02/10/2011 01:18 PM, Pradeep Satyanarayana wrote:
 > On 02/01/2011 08:12 AM, Mike Marciniszyn wrote:
 >> From: Gary Leshner <gary.leshner-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
 >>
 >> Added list_del to ipoib_mcast_free() and path_free() to remove the 
neigh from
 >> the path's neigh_list link list before freeing the memory it consumes.
 >> This makes the code consistent with ipoib_cm_handle_tx_wc() and 
other locations where the list_del() preceeds the call to 
ipoib_neigh_free().
 >>
 >> Similarly, at list_del() now preceeds path_free() to remove the path 
from
 >> ipoib_dev_priv's path_list.
 >>
 >> Additionally, the fields neigh->ah and neigh->list were not being 
initialized
 >> upon allocation. The patch insures that these two remaining fields are
 >> initialized correctly.
 >>
 >> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
 >> ---
 >> drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 ++++
 >> drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 1 +
 >> 2 files changed, 5 insertions(+), 0 deletions(-)
 >>
 >> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c 
b/drivers/infiniband/ulp/ipoib/ipoib_main.c
 >> index 9ff7bc7..ddd52f6 100644
 >> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
 >> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
 >> @@ -283,6 +283,7 @@ static void path_free(struct net_device *dev, 
struct ipoib_path *path)
 >> if (neigh->ah)
 >> ipoib_put_ah(neigh->ah);
 >>
 >> + list_del(&neigh->list);
 >> ipoib_neigh_free(dev, neigh);
 >> }
 >>
 >> @@ -390,6 +391,7 @@ void ipoib_flush_paths(struct net_device *dev)
 >> spin_unlock_irqrestore(&priv->lock, flags);
 >> netif_tx_unlock_bh(dev);
 >> wait_for_completion(&path->done);
 >> + list_del(&path->list);
 >> path_free(dev, path);
 >> netif_tx_lock_bh(dev);
 >> spin_lock_irqsave(&priv->lock, flags);
 >> @@ -882,12 +884,14 @@ struct ipoib_neigh *ipoib_neigh_alloc(struct 
neighbour *neighbour,
 >> if (!neigh)
 >> return NULL;
 >>
 >> + neigh->ah = NULL;
 >> neigh->neighbour = neighbour;
 >> neigh->dev = dev;
 >> memset(&neigh->dgid.raw, 0, sizeof (union ib_gid));
 >> *to_ipoib_neigh(neighbour) = neigh;
 >> skb_queue_head_init(&neigh->queue);
 >> ipoib_cm_set(neigh, NULL);
 >> + INIT_LIST_HEAD(&neigh->list);
 >>
 >> return neigh;
 >> }
 >> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c 
b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
 >> index 3871ac6..05f4c9a 100644
 >> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
 >> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
 >> @@ -86,6 +86,7 @@ static void ipoib_mcast_free(struct ipoib_mcast 
*mcast)
 >> */
 >> if (neigh->ah)
 >> ipoib_put_ah(neigh->ah);
 >> + list_del(&neigh->list);
 >> ipoib_neigh_free(dev, neigh);
 >> }
 >>
 >>
 >> --
 >
 > Roland,
 >
 > To provide a little more context regarding these patches, I have seen 
some sporadic crashes (shown below) that occur pretty
 > infrequently. I came to a very similar conclusion as the patches 
above to fix my problems. These are rarely occurring races that
 > recreate infrequently on large systems. The test is basically to run 
netperf in a loop from several client machines to a server.
 > The server is unloading and reloading the modules (basically do an 
"openibd restart") at random times. The crashes recreate
 > after several hours of run.
 >
 > There are three types of crashes that we have seen that are described 
below.
 >
 > Crash #1 (fixed by Ralph Campbell's patch)
 >
 > 12:mon> t
 > [link register   ] d00000000ec950a8 .cm_destroy_id+0x3d8/0x520 [ib_cm]
 > [c0000007544d2d40] d00000000ec95098 .cm_destroy_id+0x3c8/0x520 [ib_cm]
 > (unreliable)
 > [c0000007544d2e10] d00000000ef9b590 
.ipoib_cm_free_rx_reap_list+0xc8/0x180
 > [ib_ipoib]
 > [c0000007544d2ed0] d00000000ef9e1cc .ipoib_cm_dev_stop+0x23c/0x360 
[ib_ipoib]
 > [c0000007544d2f90] d00000000ef94d94 .ipoib_ib_dev_stop+0xe4/0x4b0 
[ib_ipoib]
 > [c0000007544d30f0] d00000000ef91d68 .ipoib_stop+0x88/0x178 [ib_ipoib]
 > [c0000007544d3180] c0000000004ea1cc .dev_close+0xdc/0x148
 > [c0000007544d3210] c0000000004e9790 .dev_change_flags+0x1f0/0x288
 > [c0000007544d32b0] c0000000004f6a0c .do_setlink+0x2d4/0x498
 > [c0000007544d3390] c0000000004f8b20 .rtnl_newlink+0x520/0x5f0
 > [c0000007544d35a0] c0000000004f853c .rtnetlink_rcv_msg+0x24c/0x310
 > [c0000007544d3650] c000000000513a38 .netlink_rcv_skb+0xf0/0x128
 > [c0000007544d36e0] c0000000004f82cc .rtnetlink_rcv+0x34/0x58
 > [c0000007544d3770] c0000000005134c0 .netlink_unicast+0x498/0x4b0
 > [c0000007544d3840] c000000000514218 .netlink_sendmsg+0x288/0x390
 > [c0000007544d3920] c0000000004cf538 .sock_sendmsg+0x118/0x158
 > [c0000007544d3b30] c0000000004cf720 .SyS_sendmsg+0x1a8/0x348
 > [c0000007544d3d70] c0000000004cdbdc .SyS_socketcall+0x174/0x338
 > [c0000007544d3e30] c0000000000085b4 syscall_exit+0x0/0x40
 > --- Exception: c01 (System Call) at 00000fffa25c35d0
 > SP (fffc5a12fe0) is in userspace
 > 12:mon> e
 > cpu 0x12: Vector: 300 (Data Access) at [c0000007544d2ac0]
 >     pc: c0000000002ef854: .rb_erase+0x64/0x180
 >     lr: d00000000ec950a8: .cm_destroy_id+0x3d8/0x520 [ib_cm]
 >     sp: c0000007544d2d40
 >    msr: 8000000000001432
 >    dar: 10000000100
 >  dsisr: 40000000
 >   current = 0xc0000006948dc240
 >   paca    = 0xc000000000f64a00
 >     pid   = 21593, comm = ip
 > 12:mon>
 >
 > My inference is that the above crash is indeed fixed by Ralph 
Campbell's patch described in :
 > http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg05842.html
 >
 > and for the reasons that he ascribes.
 >
 > IB/ipoib: fix race when handling IPOIB_CM_RX_DRAIN_WRID
 >
 > From: Ralph Campbell <ralph.campb...-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
 >
 > ipoib_cm_start_rx_drain() calls ib_post_send() and *then* moves the
 > struct ipoib_cm_rx onto the rx_drain_list. The ib_post_send() will
 > trigger a completion callback to ipoib_cm_handle_rx_wc() which
 > tries to move the rx_drain_list to the rx_reap_list but if the
 > callback happens before ipoib_cm_start_rx_drain() has moved the
 > structure, it is left in limbo. The fix is to change
 > ipoib_cm_start_rx_drain() to put the struct on the rx_drain_list and
 > then call ib_post_send().
 > Also, only move one struct from rx_flush_list to rx_drain_list since
 > concurrent IPOIB_CM_RX_DRAIN_WRID events on different QPs could put
 > multiple ipoib_cm_rx structs on rx_flush_list.
 >
 > Signed-off-by: Ralph Campbell <ralph.campb...-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
 > ---
 >
 > drivers/infiniband/ulp/ipoib/ipoib_cm.c | 12 +++++++++---
 > 1 files changed, 9 insertions(+), 3 deletions(-)
 >
 >
 > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c 
b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
 > index bb10041..dfff159 100644
 > --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
 > +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
 > @@ -216,15 +216,21 @@ static void ipoib_cm_start_rx_drain(struct 
ipoib_dev_priv *priv)
 > !list_empty(&priv->cm.rx_drain_list))
 > return;
 >
 > + p = list_entry(priv->cm.rx_flush_list.next, typeof(*p), list);
 > +
 > + /*
 > + * Put p on rx_drain_list before calling ib_post_send() or there
 > + * is a race with the ipoib_cm_handle_rx_wc() completion handler
 > + * trying to remove it from rx_drain_list.
 > + */
 > + list_move(&p->list, &priv->cm.rx_drain_list);
 > +
 > /*
 > * QPs on flush list are error state. This way, a "flush
 > * error" WC will be immediately generated for each WR we post.
 > */
 > - p = list_entry(priv->cm.rx_flush_list.next, typeof(*p), list);
 > if (ib_post_send(p->qp, &ipoib_cm_rx_drain_wr, &bad_wr))
 > ipoib_warn(priv, "failed to post drain wr\n");
 > -
 > - list_splice_init(&priv->cm.rx_flush_list, &priv->cm.rx_drain_list);
 > }
 >
 > static void ipoib_cm_rx_event_handler(struct ib_event *event, void *ctx)
 >
 > Once I applied the above patch, the following crash showed up after 
almost a
 > 24 hour run:
 >
 > Crash #2 (fixed by Mike Marciniszn's patch)
 >
 > c957f1ec01 login: cpu 0x26: Vector: 300 (Data Access) at 
[c0000016b8f4f3e0]
 >     pc: d000000018c919c8: .ipoib_neigh_free+0x30/0xe0 [ib_ipoib]
 >     lr: d000000018c96e0c: .ipoib_mcast_free+0xac/0x300 [ib_ipoib]
 >     sp: c0000016b8f4f660
 >    msr: 8000000000009032
 >    dar: 58
 >  dsisr: 42000000
 >   current = 0xc0000016b7958900
 >   paca    = 0xc000000000f67200
 >     pid   = 16926, comm = modprobe
 > enter ? for help
 > [c0000016b8f4f700] d000000018c96e0c .ipoib_mcast_free+0xac/0x300 
[ib_ipoib]
 > [c0000016b8f4f7d0] d000000018c971e8 
.ipoib_mcast_dev_flush+0x188/0x1f8 [ib_ipoib]
 > [c0000016b8f4f8b0] d000000018c9521c .ipoib_ib_dev_down+0x94/0x160 
[ib_ipoib]
 > [c0000016b8f4f960] d000000018c90f20 .ipoib_stop+0x78/0x178 [ib_ipoib]
 > [c0000016b8f4f9f0] c0000000004eacf4 .dev_close+0xdc/0x148
 > [c0000016b8f4fa80] c0000000004ea2b8 .dev_change_flags+0x1f0/0x288
 > [c0000016b8f4fb20] d000000018c911b8 .ipoib_remove_one+0xb8/0x140 
[ib_ipoib]
 > [c0000016b8f4fbc0] d00000000d52425c .ib_unregister_client+0xb4/0x1b8 
[ib_core]
 > [c0000016b8f4fc90] d000000018c9fdb8 .ipoib_cleanup_module+0x20/0x60 
[ib_ipoib]
 > [c0000016b8f4fd20] c0000000000ec408 .SyS_delete_module+0x238/0x320
 > [c0000016b8f4fe30] c0000000000085b4 syscall_exit+0x0/0x40
 > --- Exception: c01 (System Call) at 00000fff983128e0
 > SP (fffe9636ad0) is in userspace
 > 26:mon
 >
 > This crash is caused by the following two threads, both of which are 
trying to delete
 > the same ipoib_neigh structure:
 >
 > .ipoib_mcast_free+0x48/0x308 [ib_ipoib]
 > .ipoib_mcast_restart_task+0x3d0/0x560 [ib_ipoib]
 > .worker_thread+0x1b4/0x330
 > .kthread+0xc4/0xd0
 > .kernel_thread+0x54/0x70
 >
 >
 > .ipoib_mcast_free+0x48/0x308 [ib_ipoib]
 > .ipoib_mcast_dev_flush+0x188/0x1f8 [ib_ipoib]
 > .ipoib_ib_dev_down+0x94/0x160 [ib_ipoib]
 > .ipoib_stop+0x78/0x178 [ib_ipoib]
 > .dev_close+0xdc/0x148
 >
 > This is because there is a list_del() missing which does not delete 
the ipoib_neigh structure from
 > the ipoib_mcast structure, resulting in a double free. And so Mike's 
patch fixed this issue.
 >
 > After I applied both the above patches I was able to run the tests 
for more than 24 hours and
 > here was the crash that was observed:
 >
 > Crash #3 (still to be resolved)
 >
 > <1>Unable to handle kernel paging request for data at address 0x00100108
 > <1>Faulting instruction address: 0xd000000012bd1b0c
 > 22:mon> e
 > cpu 0x22: Vector: 300 (Data Access) at [c000000e68636eb0]
 >     pc: d000000012bd1b0c: .ipoib_neigh_cleanup+0x84/0x178 [ib_ipoib]
 >     lr: d000000012bd1ae0: .ipoib_neigh_cleanup+0x58/0x178 [ib_ipoib]
 >     sp: c000000e68637130
 >    msr: 8000000000009032
 >    dar: 100108
 >  dsisr: 42000000
 >   current = 0xc000000f0590a820
 >   paca    = 0xc000000000f66a00
 >     pid   = 59548, comm = ip
 > 22:mon> t
 > [c000000e686371d0] c0000000004f4784 .neigh_cleanup_and_release+0x3c/0xa0
 > [c000000e68637250] c0000000004f55cc .neigh_flush_dev+0x14c/0x158
 > [c000000e68637310] c0000000004f5630 .neigh_ifdown+0x58/0x158
 > [c000000e686373c0] d00000000e92ed3c .addrconf_ifdown+0x7c/0x520 [ipv6]
 > [c000000e68637480] d00000000e92f470 .inet6_addr_del+0x148/0x168 [ipv6]
 > [c000000e68637520] d00000000e92f544 .inet6_rtm_deladdr+0xb4/0xb8 [ipv6]
 > [c000000e686375f0] c0000000004f9064 .rtnetlink_rcv_msg+0x24c/0x310
 > [c000000e686376a0] c000000000514580 .netlink_rcv_skb+0xf0/0x128
 > [c000000e68637730] c0000000004f8df4 .rtnetlink_rcv+0x34/0x58
 > [c000000e686377c0] c000000000514008 .netlink_unicast+0x498/0x4b0
 > [c000000e68637890] c000000000514d80 .netlink_sendmsg+0x288/0x390
 > [c000000e68637970] c0000000004d0060 .sock_sendmsg+0x118/0x158
 > [c000000e68637b80] c0000000004d12d8 .SyS_sendto+0xe8/0x138
 > [c000000e68637d00] c0000000004ce548 .SyS_send+0x20/0x38
 > [c000000e68637d70] c0000000004ce7fc .SyS_socketcall+0x26c/0x338
 > [c000000e68637e30] c0000000000085b4 syscall_exit+0x0/0x40
 > --- Exception: c01 (System Call) at 00000fffb3cc3524
 > SP (fffec5b9fc0) is in userspace
 >
 > The suspicion is that this is again a case of double free. Again, the 
double free
 > does not happen all the time, but is a race. The two suspected 
threads are:
 >
 > ipoib_neigh_free()
 > path_free()
 > ipoib_flush_paths()
 > ipoib_ib_dev_down()
 > ....
 >
 >
 > ipoib_neigh_free()
 > ipoib_neigh_cleanup()
 > neigh_cleanup_and_release()
 > neigh_ifdown()
 > ....
 >
 > In order to confirm this, I wanted to write a pattern in 
ipoib_neigh_free() that we could
 > look in ipoib_neigh_cleanup(). Also made some small changes in 
ipoib_start_xmit() too.
 >
 > void ipoib_neigh_free(struct net_device *dev, struct ipoib_neigh *neigh)
 > {
 >         struct sk_buff *skb;
 >         *to_ipoib_neigh(neigh->neighbour) = 0xdeaddeed;
 >         dump_stack();
 > #if 0
 >         *to_ipoib_neigh(neigh->neighbour) = NULL;
 > #endif
 >         while ((skb = __skb_dequeue(&neigh->queue))) {
 >                 ++dev->stats.tx_dropped;
 >                 dev_kfree_skb_any(skb);
 >         }
 >         if (ipoib_cm_get(neigh))
 >                 ipoib_cm_destroy_tx(ipoib_cm_get(neigh));
 >         kfree(neigh);
 > }
 >
 > I changed ipoib_neigh_cleanup() as follows:
 >
 > static void ipoib_neigh_cleanup(struct neighbour *n)
 > {
 >         struct ipoib_neigh *neigh;
 >         struct ipoib_dev_priv *priv = netdev_priv(n->dev);
 >         unsigned long flags;
 >         struct ipoib_ah *ah = NULL;
 >
 >         neigh = *to_ipoib_neigh(n);
 >         if ((neigh == 0xdeaddeed ) || (neigh == NULL)) { /* in that 
case ipoib_neigh has been freed and we need to crash */
 >                 printk(KERN_WARNING "ipoib_neigh_cleanup(): for 
neigh=0x%p %06x %pI6\n", neigh,
 >                         IPOIB_QPN(n->ha), n->ha + 4);
 >                 BUG();
 >         }
 >
 > ...
 >
 > The primary problem is that access to *to_ipoib_neigh(n) is 
unprotected. Hence the race between the two threads since
 > ipoib_neigh_cleanup() may have a stale pointer to the ipoib_neigh 
structure and hence the crash.
 >
 > With the above changes here is what is seen in the crash dump:
 >
 >
 > <4>Call Trace:
 > <4>[c000000001eff6b0] [c0000000000129e4] .show_stack+0x6c/0x198 
(unreliable)
 > <4>[c000000001eff760] [d0000000139019f0] .ipoib_neigh_free+0x48/0x100 
[ib_ipoib]
 > <4>[c000000001eff800] [d0000000139028c8] 
.ipoib_start_xmit+0x1a8/0x590 [ib_ipoib]
 > <4>[c000000001eff8c0] [c0000000004e9228] .dev_hard_start_xmit+0x210/0x2b0
 > <4>[c000000001eff970] [c000000000506ff8] .sch_direct_xmit+0x260/0x2d0
 > <4>[c000000001effa20] [c0000000004e98ec] .dev_queue_xmit+0x484/0x648
 > <4>[c000000001effad0] [c0000000004f26e4] 
.neigh_connected_output+0x10c/0x158
 > <4>[c000000001effb70] [d00000000e9233c0] 
.ip6_output_finish+0xe0/0x1a0 [ipv6]
 > <4>[c000000001effc10] [d00000000e94bbd4] .mld_sendpack+0x5b4/0x610 [ipv6]
 > <4>[c000000001effd30] [d00000000e94d1e8] 
.mld_ifc_timer_expire+0x18/0x98 [ipv6]
 > <4>[c000000001effdb0] [c0000000000bd424] .run_timer_softirq+0x214/0x348
 > <4>[c000000001effeb0] [c0000000000b6b8c] .__do_softirq+0x13c/0x240
 > <4>[c000000001efff90] [c000000000030afc] .call_do_softirq+0x14/0x24
 > <4>[c0000007580278e0] [c00000000000ed38] .do_softirq+0xe8/0x108
 > <4>[c000000758027980] [c0000000000b6854] .irq_exit+0xb4/0xe8
 > <4>[c000000758027a00] [c00000000002d03c] .timer_interrupt+0x104/0x138
 > <4>[c000000758027a90] [c000000000003718] decrementer_common+0x118/0x180
 > <4>--- Exception: 901 at .raw_local_irq_restore+0x70/0xc8
 > <4>    LR = .cpu_idle+0x98/0x1e0
 > <4>[c000000758027d80] [0000000000000014] 0x14 (unreliable)
 > <4>[c000000758027e10] [c000000000014b60] .cpu_idle+0x98/0x1e0
 > <4>[c000000758027ec0] [c0000000005b7bd4] .start_secondary+0x394/0x3dc
 > <4>[c000000758027f90] [c0000000000082d4] 
.start_secondary_prolog+0x10/0x14
 > <7>ib0: no IPv6 routers present
 > <7>ib3: no IPv6 routers present
 > <7>ib2: no IPv6 routers present
 > <7>ib1: no IPv6 routers present
 > <4>created rx qp=0x6d4
 > <4>ipoib_neigh_cleanup(): for neigh=0x00000000deaddeed ffffff 
ff12:601b:ffff:0000:0000:0000:0000:0016
 > <0>------------[ cut here ]------------
 > <2>kernel BUG at drivers/infiniband/ulp/ipoib/ipoib_main.c:863!
 > 22:mon> e
 > cpu 0x22: Vector: 700 (Program Check) at [c0000007585238e0]
 >     pc: d000000013901bd4: .ipoib_neigh_cleanup+0x12c/0x1d0 [ib_ipoib]
 >     lr: d000000013901bd0: .ipoib_neigh_cleanup+0x128/0x1d0 [ib_ipoib]
 >     sp: c000000758523b60
 >    msr: 8000000000029032
 >   current = 0xc0000007585009e0
 >   paca    = 0xc000000000f66a00
 >     pid   = 165, comm = events/34
 > kernel BUG at drivers/infiniband/ulp/ipoib/ipoib_main.c:863!
 > 22:mon> t
 > [c000000758523c00] c0000000004f4784 .neigh_cleanup_and_release+0x3c/0xa0
 > [c000000758523c80] c0000000004f4a34 .neigh_periodic_work+0x144/0x210
 > [c000000758523d40] c0000000000c7704 .run_workqueue+0xf4/0x1e0
 > [c000000758523e00] c0000000000c78b0 .worker_thread+0xc0/0x180
 > [c000000758523ed0] c0000000000cd6ac .kthread+0xc4/0xd0
 > [c000000758523f90] c000000000030e04 .kernel_thread+0x54/0x70
 > 22:mon>
 >
 >
 > My question is do we need to do any cleanup at all in 
ipoib_neigh_cleanup() or can it simply return,
 > since the ipoib_neigh_free() does it, or at best just call 
ipoib_put_ah()?
 >
 > Thanks
 > Pradeep

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
