From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: [rds-devel] BUG: unable to handle kernel NULL pointer
 dereference in rds_send_xmit
Date: Mon, 18 Dec 2017 12:22:51 -0500
Message-ID: <20171218172251.GD26203@oracle.com>
References: <001a1145ac5480242305609956b3@google.com>
 <5ba83a68-0103-d514-1b22-900f755f5aa4@oracle.com>
 <20171218.121213.289437104214632276.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171218.121213.289437104214632276.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: santosh.shilimkar@oracle.com, rds-devel@oss.oracle.com, bot+aaf54a8c644d559d34dedcf3126aac68a20c9e63@syzkaller.appspotmail.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> Date: Mon, 18 Dec 2017 08:28:05 -0800
  :
> > Looks like another one tripping on empty transport. Mostly below
> > should
> > address it but we will test it if it does.

that was my first thought, but it cannot be the case here: rds_sendmsg
etc itself would have bombed if that were the case, and the packet
would never have gotten queued.

This is unlike f3069c6d33, where an applications skips the transport
binding (either misses the explicit bind, or gets the wrong transport
due to an implicit bind) before it triggers the setsockopt.

I suspect that the problems is that the conn (and thus c_trans)
have gotten destroyed, but the cp_send_w work got incorrectly 
re-queued. For example, rds_cong_queue_updates() (because the
peer sent a congestion update) can happen in softirq context, 
and would end up requeing work in the middle of rds_conn_destroy, 
after we have assumed that everything is quisced.

On (12/18/17 12:12), David Miller wrote:
> 
> We're seeming to accumulate a lot of checks like this, maybe there
> is a more general way to deal with this problem?

Yeah, I was thinking about this..  let me try to reprodcue this in-house
and get back with a patchset.  

--Sowmini
