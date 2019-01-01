From: David Miller <davem@redhat.com>
Subject: Re: [PATCH 1/1] net: rds: remove unnecessary NULL check
Date: Tue, 01 Jan 2019 09:54:30 -0800 (PST)
Message-ID: <20190101.095430.1126296045667586004.davem@redhat.com>
References: <20181230152411.15096-1-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181230152411.15096-1-yanjun.zhu@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: yanjun.zhu@oracle.com
Cc: santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Sun, 30 Dec 2018 23:24:11 +0800

> In kfree, the NULL check is done.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Applied.
