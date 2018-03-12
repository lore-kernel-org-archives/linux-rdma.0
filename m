From: "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH][rds-next] rds: remove redundant variable 'sg_off'
Date: Sun, 11 Mar 2018 23:54:27 -0700
Message-ID: <cd3c782b-0d54-21e5-43e7-f2120bfb6348@oracle.com>
References: <20180311162756.26950-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180311162756.26950-1-colin.king@canonical.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 3/11/18 9:27 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable sg_off is assigned a value but it is never read, hence it is
> redundant and can be removed.
> 
> Cleans up clang warning:
> net/rds/message.c:373:2: warning: Value stored to 'sg_off' is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   net/rds/message.c | 2 --
>   1 file changed, 2 deletions(-)
> 
Thanks Colin !!

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
