From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: KASAN: use-after-free Read in __rhashtable_lookup (2)
Date: Fri, 24 Aug 2018 19:04:46 -0400
Message-ID: <20180824230446.GA16891@oracle.com>
References: <00000000000027a1e605741b2afa@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <00000000000027a1e605741b2afa@google.com>
Sender: netdev-owner@vger.kernel.org
To: syzbot <syzbot+8967084bcac563795dc6@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org



#syz dup KASAN: use-after-free Read in rds_find_bound

The problem is a missing synchronize_net() in rds_release.
References:
  https://www.spinics.net/lists/netdev/msg475074.html
  https://www.spinics.net/lists/netdev/msg507908.html
