From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: WARNING in __local_bh_enable_ip (2)
Date: Wed, 14 Mar 2018 17:33:54 -0400
Message-ID: <20180314213354.GH24557@oracle.com>
References: <001a113de654ad181e056764f936@google.com>
 <1686ceff-9b7e-592e-8607-b3b8add6a6a3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1686ceff-9b7e-592e-8607-b3b8add6a6a3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: syzbot <syzbot+c68e51bb5e699d3f8d91@syzkaller.appspotmail.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On (03/14/18 14:28), Eric Dumazet wrote:
> 
> 
> spin_lock_bh(&rds_tcp_conn_lock);/spin_unlock_bh(&rds_tcp_conn_lock); in
> rds_tcp_conn_free()
> 
> is in conflict with the spin_lock_irqsave(&rds_conn_lock, flags);
> in __rds_conn_create()

yes I was going to look into this and fix it later.

> Hard to understand why RDS is messing with hard irqs really.

some of it comes from the rds_rdma history: some parts of
the common rds and rds_rdma module get called in various
driver contexts for infiniband.

--Sowmini
