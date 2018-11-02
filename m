From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v1 1/4] rdma: Update kernel include file to
 support IB device renaming
Date: Fri, 2 Nov 2018 10:43:29 -0600
Message-ID: <41d84b6a-25d3-e81c-fb7e-582a363566da@gmail.com>
References: <20181031071758.6178-1-leon@kernel.org>
 <20181031071758.6178-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181031071758.6178-2-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

On 10/31/18 1:17 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Bring kernel header file changes upto commit 05d940d3a3ec
> ("RDMA/nldev: Allow IB device rename through RDMA netlink")
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> Reviewed-by: Steve Wise <swise@opengridcomputing.com>
> ---
>  rdma/include/uapi/rdma/rdma_netlink.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

applied to iproute2-next. Thanks
