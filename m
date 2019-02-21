From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH iproute2-next v1 10/19] rdma: Properly mark RDMAtool license
Date: Thu, 21 Feb 2019 14:22:06 -0600
Message-ID: <01f901d4ca23$1d9d2110$58d76330$@opengridcomputing.com>
References: <20190220072136.3840-1-leon@kernel.org> <20190220072136.3840-11-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190220072136.3840-11-leon@kernel.org>
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
To: 'Leon Romanovsky' <leon@kernel.org>, 'David Ahern' <dsahern@gmail.com>
Cc: 'Leon Romanovsky' <leonro@mellanox.com>, 'netdev' <netdev@vger.kernel.org>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Stephen Hemminger' <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> owner@vger.kernel.org> On Behalf Of Leon Romanovsky
> Sent: Wednesday, February 20, 2019 1:21 AM
> To: David Ahern <dsahern@gmail.com>
> Cc: Leon Romanovsky <leonro@mellanox.com>; netdev
> <netdev@vger.kernel.org>; RDMA mailing list <linux-
> rdma@vger.kernel.org>; Stephen Hemminger
> <stephen@networkplumber.org>
> Subject: [PATCH iproute2-next v1 10/19] rdma: Properly mark RDMAtool
> license
> 
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> RDMA subsystem is dual-licensed with "GPL-2.0 OR Linux-OpenIB" proper
> license and Mellanox submission are supposed to have this type of license.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  rdma/Makefile | 2 +-
>  rdma/dev.c    | 7 +------
>  rdma/link.c   | 7 +------
>  rdma/rdma.c   | 7 +------
>  rdma/rdma.h   | 7 +------
>  rdma/res.c    | 7 +------
>  rdma/utils.c  | 7 +------
>  7 files changed, 7 insertions(+), 37 deletions(-)


Reviewed-by: Steve Wise <swise@opengridcomputing.com>
