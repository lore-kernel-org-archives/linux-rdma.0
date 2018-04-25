From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] rds: ib: Fix missing call to rds_ib_dev_put in
 rds_ib_setup_qp
Date: Wed, 25 Apr 2018 14:34:30 -0400 (EDT)
Message-ID: <20180425.143430.191813743469618503.davem@davemloft.net>
References: <1524655321-8379-1-git-send-email-dag.moxnes@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1524655321-8379-1-git-send-email-dag.moxnes@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dag.moxnes@oracle.com
Cc: santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Dag Moxnes <dag.moxnes@oracle.com>
Date: Wed, 25 Apr 2018 13:22:01 +0200

> The function rds_ib_setup_qp is calling rds_ib_get_client_data and
> should correspondingly call rds_ib_dev_put. This call was lost in
> the non-error path with the introduction of error handling done in
> commit 3b12f73a5c29 ("rds: ib: add error handle")
> 
> Signed-off-by: Dag Moxnes <dag.moxnes@oracle.com>

Applied, thanks.
