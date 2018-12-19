From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH rds linux-next v4 0/2] WARNING in rds_message_alloc_sgs
Date: Wed, 19 Dec 2018 10:30:25 -0800 (PST)
Message-ID: <20181219.103025.1046477396609315097.davem@davemloft.net>
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

Series applied to 'net' and queued up for -stable.

Thanks.
