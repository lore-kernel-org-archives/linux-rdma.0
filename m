From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH iproute2-next] rdma: Move RDMA UAPI header file to be under RDMA responsibility
Date: Sun, 25 Mar 2018 08:52:20 -0500
Message-ID: <008701d3c440$7f6eb870$7e4c2950$@opengridcomputing.com>
References: <20180325063856.31709-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180325063856.31709-1-leon@kernel.org>
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
To: 'Leon Romanovsky' <leon@kernel.org>, 'David Ahern' <dsahern@gmail.com>
Cc: 'Leon Romanovsky' <leonro@mellanox.com>, 'netdev' <netdev@vger.kernel.org>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Stephen Hemminger' <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH iproute2-next] rdma: Move RDMA UAPI header file to be
> under RDMA responsibility
> 
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

Reviewed-by: Steve Wise <swise@opengridcomputing.com>
