From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: RDS: TCP: Delete an error message for a failed memory allocation
 in rds_tcp_init_net()
Date: Mon, 22 May 2017 10:46:19 -0400
Message-ID: <20170522144619.GB29434@oracle.com>
References: <44b46c51-3665-5f14-dd3b-6e6f230258a7@users.sourceforge.net>
 <5d523cf8-1540-e704-2301-a5e0205cb536@users.sourceforge.net>
 <20170522142651.GA29434@oracle.com>
 <1e1a5d08-34a7-1b88-80ac-c650c4ae76cf@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1e1a5d08-34a7-1b88-80ac-c650c4ae76cf@users.sourceforge.net>
Sender: netdev-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> Do you find information from a Linux allocation failure report sufficient
> for such an use case?

yes, I suppose that would cover the needed cases. 
Your change looks good to me.

Acked-by: Sowmini Varadhan <sowmini.varadhan@oracle.com>
