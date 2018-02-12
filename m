From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: BUG: sleeping function called from invalid context at
 mm/slab.h:LINE (3)
Date: Mon, 12 Feb 2018 11:14:47 -0500
Message-ID: <20180212161447.GB21125@oracle.com>
References: <001a113fd4489d4510056505ffb6@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001a113fd4489d4510056505ffb6@google.com>
Sender: netdev-owner@vger.kernel.org
To: syzbot <syzbot+f8af40b8331eed0c4ada@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

#syz dup: WARNING: suspicious RCU usage in rds_loop_conn_alloc
