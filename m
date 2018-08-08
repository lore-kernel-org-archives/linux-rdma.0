From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: KASAN: use-after-free Read in __rhashtable_lookup
Date: Wed, 8 Aug 2018 05:26:52 -0400
Message-ID: <20180808092652.GB15195@oracle.com>
References: <00000000000097dba80572e7931d@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <00000000000097dba80572e7931d@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+c6369755db236fb370e7@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org


#syz dup: KASAN: use-after-free Read in rds_find_bound
