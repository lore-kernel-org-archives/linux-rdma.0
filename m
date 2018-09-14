From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH 1/1] net: rds: use memset to optimize the recv
Date: Fri, 14 Sep 2018 09:51:00 -0700
Message-ID: <4fdaff2b-ee94-c3bb-5b63-ea1aa1bca20d@oracle.com>
References: <20180914084538.11666-1-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180914084538.11666-1-yanjun.zhu@oracle.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Zhu Yanjun <yanjun.zhu@oracle.com>, davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

On 9/14/2018 1:45 AM, Zhu Yanjun wrote:
> The function rds_inc_init is in recv process. To use memset can optimize
> the function rds_inc_init.
> The test result:
> 
>      Before:
>      1) + 24.950 us   |        rds_inc_init [rds]();
>      After:
>      1) + 10.990 us   |        rds_inc_init [rds]();
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> ---
Looks good. Thanks !!

Acked-by: Santosh Shilimkar<santosh.shilimkar@oracle.com>
