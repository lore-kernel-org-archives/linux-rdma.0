From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: KASAN: use-after-free Read in rds_tcp_tune
Date: Fri, 12 Jan 2018 13:30:46 -0500
Message-ID: <20180112183046.GA26098@oracle.com>
References: <001a1141a524c513ca05628d8ad4@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001a1141a524c513ca05628d8ad4@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+bbd8e9a06452cc48059b@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On (01/11/18 21:29), syzbot wrote:
> ==================================================================
> BUG: KASAN: use-after-free in rds_tcp_tune+0x491/0x520 net/rds/tcp.c:397
> Read of size 4 at addr ffff8801cd5f6c58 by task kworker/u4:4/4954

Just had an offline discussion with santosh around this, here's a summary
of that discussion for the archives:

Looks like an rds_connect_worker workq got scheduled after the 
netns was deleted. This could happen if an an rds_connection got
added between lines 528 and 529 of 

  506 static void rds_tcp_kill_sock(struct net *net)
  :
  /* code to pull out all the rds_connections that should be destroyed */
  :
  528         spin_unlock_irq(&rds_tcp_conn_lock);
  529         list_for_each_entry_safe(tc, _tc, &tmp_list, t_tcp_node)
  530                 rds_conn_destroy(tc->t_cpath->cp_conn);

Such an rds_connection would miss out the rds_conn_destroy() 
loop (that cancels all pending work) and (if it was scheduled
after netns deletion) could trigger the use-after-free.

Evaluating various fixes for this (including using _bh instead of _irq
as suggested by santosh), I'll get back with a patch soon.

--Sowmini
