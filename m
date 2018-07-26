From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] RDS: RDMA: Fix the NULL-ptr deref in rds_ib_get_mr
Date: Thu, 26 Jul 2018 14:04:31 -0700 (PDT)
Message-ID: <20180726.140431.1980654012533107924.davem@davemloft.net>
References: <1532489518-27042-1-git-send-email-avinash.repaka@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1532489518-27042-1-git-send-email-avinash.repaka@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: avinash.repaka@oracle.com
Cc: santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Avinash Repaka <avinash.repaka@oracle.com>
Date: Tue, 24 Jul 2018 20:31:58 -0700

> Registration of a memory region(MR) through FRMR/fastreg(unlike FMR)
> needs a connection/qp. With a proxy qp, this dependency on connection
> will be removed, but that needs more infrastructure patches, which is a
> work in progress.
> 
> As an intermediate fix, the get_mr returns EOPNOTSUPP when connection
> details are not populated. The MR registration through sendmsg() will
> continue to work even with fast registration, since connection in this
> case is formed upfront.
> 
> This patch fixes the following crash:
 ...
> Reported-by: syzbot+b51c77ef956678a65834@syzkaller.appspotmail.com
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> Signed-off-by: Avinash Repaka <avinash.repaka@oracle.com>

Applied and queued up for -stable, thanks.
