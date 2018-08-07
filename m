From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: possible deadlock in rds_wake_sk_sleep
Date: Tue, 7 Aug 2018 17:07:54 -0400
Message-ID: <20180807210754.GE23593@oracle.com>
References: <000000000000fb5cd90572de7ebd@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <000000000000fb5cd90572de7ebd@google.com>
Sender: netdev-owner@vger.kernel.org
To: syzbot <syzbot+52140d69ac6dc6b927a9@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On (08/07/18 13:47), syzbot wrote:
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&(&rm->m_rs_lock)->rlock);
>                                lock(&rs->rs_recv_lock);
>                                lock(&(&rm->m_rs_lock)->rlock);
>   lock(&rs->rs_recv_lock);
> 
>  *** DEADLOCK ***

looks like a valid find, I think the deadlock should be avoided
by having rds_clear_recv_queue do something like

 get rs_recv_lock
 un-tether the rs_recv_queue into a temporary list 
 releease rs_recv_lock
 purge the rds_incoming  temporary list

I can give this a shot later this week.

--Sowmini
