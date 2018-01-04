From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] RDS: null pointer dereference in rds_atomic_free_op
Date: Thu, 04 Jan 2018 14:20:10 -0500 (EST)
Message-ID: <20180104.142010.1390953877615339581.davem@davemloft.net>
References: <5a4d45ce.8b8a1c0a.1d072.e5e1@mx.google.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <5a4d45ce.8b8a1c0a.1d072.e5e1@mx.google.com>
Sender: netdev-owner@vger.kernel.org
To: simo.ghannam@gmail.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, santosh.shilimkar@oracle.com, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

From: simo.ghannam@gmail.com
Date: Wed,  3 Jan 2018 21:06:06 +0000

> From: Mohamed Ghannam <simo.ghannam@gmail.com>
> 
> set rm->atomic.op_active to 0 when rds_pin_pages() fails
> or the user supplied address is invalid,
> this prevents a NULL pointer usage in rds_atomic_free_op()
> 
> Signed-off-by: Mohamed Ghannam <simo.ghannam@gmail.com>

Applied and queued up for -stable, thanks.
