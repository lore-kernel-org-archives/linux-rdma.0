From: Girish Moodalbail <girish.moodalbail@oracle.com>
Subject: Re: KASAN: use-after-free Read in rds_tcp_dev_event
Date: Mon, 13 Nov 2017 19:30:39 -0800
Message-ID: <9e71dff9-7ba8-a3c2-6862-fb8557546a54@oracle.com>
References: <001a1148d244ade0aa055d6a69b9@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <001a1148d244ade0aa055d6a69b9@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <bot+643ecad3f5bb49700e839363b608c4928f6db8f0@syzkaller.appspotmail.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On 11/7/17 12:28 PM, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on 287683d027a3ff83feb6c7044430c79881664ecf
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> 
> 
> 
> 
> ==================================================================
> BUG: KASAN: use-after-free in rds_tcp_kill_sock net/rds/tcp.c:530 [inline]
> BUG: KASAN: use-after-free in rds_tcp_dev_event+0xc01/0xc90 net/rds/tcp.c:568
> Read of size 8 at addr ffff8801cd879200 by task kworker/u4:3/147
> 
> CPU: 0 PID: 147 Comm: kworker/u4:3 Not tainted 4.14.0-rc7+ #156
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 
> 01/01/2011
> Workqueue: netns cleanup_net
> Call Trace:
>   __dump_stack lib/dump_stack.c:16 [inline]
>   dump_stack+0x194/0x257 lib/dump_stack.c:52
>   print_address_description+0x73/0x250 mm/kasan/report.c:252
>   kasan_report_error mm/kasan/report.c:351 [inline]
>   kasan_report+0x25b/0x340 mm/kasan/report.c:409
>   __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:430
>   rds_tcp_kill_sock net/rds/tcp.c:530 [inline]
>   rds_tcp_dev_event+0xc01/0xc90 net/rds/tcp.c:568

The issue here is that we are trying to reference a network namespace (struct 
net *) that is long gone (i.e., L532 below -- c_net is the culprit).

     528         spin_lock_irq(&rds_tcp_conn_lock);
     529         list_for_each_entry_safe(tc, _tc, &rds_tcp_conn_list,
                      t_tcp_node) {
     530                 struct net *c_net = tc->t_cpath->cp_conn->c_net;
     531
     532                 if (net != c_net || !tc->t_sock)
     533                         continue;
     534                 if (!list_has_conn(&tmp_list, tc->t_cpath->cp_conn))
     535                         list_move_tail(&tc->t_tcp_node, &tmp_list);
     536         }
     537         spin_unlock_irq(&rds_tcp_conn_lock);
     538         list_for_each_entry_safe(tc, _tc, &tmp_list, t_tcp_node) {
     539                 rds_tcp_conn_paths_destroy(tc->t_cpath->cp_conn);
     540                 rds_conn_destroy(tc->t_cpath->cp_conn);
     541         }

When a network namespace is deleted, devices within that namespace are 
unregistered and removed one by one. RDS is notified about this event through 
rds_tcp_dev_event() callback. When the loopback device is removed from the 
namespace, the above RDS callback function destroys all the RDS connections in 
that namespace.

The loop@L529 above walks through each of the rds_tcp connection in the global 
list (rds_tcp_conn_list) to see if that connection belongs to the namespace in 
question. It collects all such connections and destroys them (L538-540). 
However, it leaves behind some of the rds_tcp connections that shared the same 
underlying RDS connection (L534 and 535). These connections with pointer to 
stale network namespace are left behind in the global list. When the 2nd network 
namespace is deleted, we will hit the above stale pointer and hit UAF panic.

I think we should move away from global list to a per-namespace list. The global 
list are used only in two places (both of which are per-namespace operations):

  - to destroy all the RDS connections belonging to a namespace when the
    network namespace is being deleted.
  - to reset all the RDS connections  when socket parameters for a namespace are
    modified using sysctl

Thanks,
~Girish
