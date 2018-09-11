From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] infiniband: remove redundant condition check before
 debugfs_remove
Date: Tue, 11 Sep 2018 09:39:00 -0600
Message-ID: <20180911153900.GA18253@ziepe.ca>
References: <1536414571-32675-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1536414571-32675-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>
Cc: dledford@redhat.com, benve@cisco.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Sep 08, 2018 at 09:49:31PM +0800, zhong jiang wrote:
> debugfs_remove has taken the IS_ERR_OR_NULL into account. Just
> remove the unnecessary condition.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/infiniband/hw/usnic/usnic_debugfs.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied to for-next, thanks

Jason
