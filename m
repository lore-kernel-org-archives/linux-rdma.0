From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next] rdma: Move RDMA UAPI header file to be
 under RDMA responsibility
Date: Mon, 26 Mar 2018 08:03:04 -0600
Message-ID: <c1cd4d27-dce6-84d0-344d-86ff7223add8@gmail.com>
References: <20180325063856.31709-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180325063856.31709-1-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

On 3/25/18 12:38 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> In iproute2 package, the updates of UAPIs files are performed
> after the needed feature lands in kernel's net-next tree.
> 
> Such development flow created delays to the rdma tool developers,
> who uses rdma-next tree as a basis for their work.
> 
> Move RDMA UAPI file to be under rdma/ folder, so whole responsibility
> of syncing this file will be on them.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  rdma/Makefile                                      | 1 +
>  {include => rdma/include}/uapi/rdma/rdma_netlink.h | 0
>  2 files changed, 1 insertion(+)
>  rename {include => rdma/include}/uapi/rdma/rdma_netlink.h (100%)

applied to iproute2-next
