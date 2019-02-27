From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next] rdma: Add the prefix for driver attributes
Date: Wed, 27 Feb 2019 09:26:14 -0700
Message-ID: <d6a5cd69-4d27-eec4-e7c9-99090c4dd854@gmail.com>
References: <20190227064151.25445-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190227064151.25445-1-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Lijun Ou <oulijun@huawei.com>, Steve Wise <swise@opengridcomputing.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

On 2/26/19 11:41 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> There is a need to distinguish between driver vs. general exposed
> attributes. The most common use case is to expose some internal
> garbage under extremely common and sexy name, e.g. pi, ci e.t.c
> 
> In order to achieve that, we will add "drv_" prefix to all strings
> which were received through RDMA_NLDEV_ATTR_DRIVER_* attributes.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>a
> ---
>  rdma/utils.c | 34 ++++++++++++++++++++++------------
>  1 file changed, 22 insertions(+), 12 deletions(-)
> 

applied to iproute2-next. Thanks
