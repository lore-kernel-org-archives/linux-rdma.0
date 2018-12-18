From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH rds linux-next v4 0/2] WARNING in rds_message_alloc_sgs
Date: Tue, 18 Dec 2018 14:57:53 -0800 (PST)
Message-ID: <20181218.145753.1550590342570044648.davem@davemloft.net>
References: <20181216070109.6758-1-shamir.rabinovitch@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181216070109.6758-1-shamir.rabinovitch@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: shamir.rabinovitch@oracle.com
Cc: linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, netdev@vger.kernel.org, gerd.rausch@oracle.com, santosh.shilimkar@oracle.com, haakon.bugge@oracle.com
List-Id: linux-rdma@vger.kernel.org

From: Shamir Rabinovitch <shamir.rabinovitch@oracle.com>
Date: Sun, 16 Dec 2018 09:01:07 +0200

> From: shamir rabinovitch <shamir.rabinovitch@oracle.com>
> 
> This patch set fix google syzbot rds bug found in linux-next.
> The first patch solve the syzbot issue.
> The second patch fix issue mentioned by Leon Romanovsky that
> drivers should not call WARN_ON as result from user input.
> 
> syzbot bug report can be foud here: https://lkml.org/lkml/2018/10/31/28
> 
> v1->v2:
> - patch 1: make rds_iov_vector fields name more descriptive (Hakon)
> - patch 1: fix potential mem leak in rds_rm_size if krealloc fail
>   (Hakon)
> v2->v3:
> - patch 2: harden rds_sendmsg for invalid number of sgs (Gerd)
> v3->v4
> - Santosh a.b. on both patches + repost to net-dev

Does this bug exist in 'net' too?  It really should target the 'net'
tree if so, and then we can queue these fixes up for -stable too.

Thank you.
