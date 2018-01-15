From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/cma: use strlcpy() instead of strncpy()
Date: Mon, 15 Jan 2018 16:04:51 -0700
Message-ID: <20180115230451.GA1867@ziepe.ca>
References: <1515743765-116090-1-git-send-email-wangxiongfeng2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515743765-116090-1-git-send-email-wangxiongfeng2@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 12, 2018 at 03:56:05PM +0800, Xiongfeng Wang wrote:
> From: Xiongfeng Wang <xiongfeng.wang@linaro.org>
> 
> gcc-8 reports
> 
> drivers/infiniband/core/cma_configfs.c: In function 'make_cma_dev':
> ./include/linux/string.h:245:9: warning: '__builtin_strncpy' specified
> bound 64 equals destination size [-Wstringop-truncation]
> 
> We need to use strlcpy() to make sure the string is nul-terminated.
> 
> Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/core/cma_configfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to rdma for-next, thanks

Jason
