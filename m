From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: [rds-devel] [PATCH][rds-next] rds: remove redundant variable
 'sg_off'
Date: Sun, 11 Mar 2018 12:48:14 -0400
Message-ID: <20180311164814.GA7812@oracle.com>
References: <20180311162756.26950-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180311162756.26950-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On (03/11/18 17:27), Colin King wrote:
> Variable sg_off is assigned a value but it is never read, hence it is
> redundant and can be removed.
> 

Acked-by: Sowmini Varadhan <sowmini.varadhan@oracle.com>
