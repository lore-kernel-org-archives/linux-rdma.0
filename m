From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v1 2/4] rdma: Introduce command execution
 helper with required device name
Date: Fri, 2 Nov 2018 10:43:38 -0600
Message-ID: <d6ef5712-6ef2-93b8-ef30-0dd106e984aa@gmail.com>
References: <20181031071758.6178-1-leon@kernel.org>
 <20181031071758.6178-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181031071758.6178-3-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

On 10/31/18 1:17 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> In contradiction to various show commands, the set command explicitly
> requires to use device name as an argument. Provide new command
> execution helper which enforces it.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> Reviewed-by: Steve Wise <swise@opengridcomputing.com>
> ---
>  rdma/rdma.h  |  1 +
>  rdma/utils.c | 10 ++++++++++
>  2 files changed, 11 insertions(+)
> 

applied to iproute2-next. Thanks
