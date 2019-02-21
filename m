From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH iproute2-next v1 11/19] rdma: Simplify code to reuse existing functions
Date: Thu, 21 Feb 2019 14:23:34 -0600
Message-ID: <01fe01d4ca23$522c2d40$f68487c0$@opengridcomputing.com>
References: <20190220072136.3840-1-leon@kernel.org> <20190220072136.3840-12-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190220072136.3840-12-leon@kernel.org>
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
> Subject: [PATCH iproute2-next v1 11/19] rdma: Simplify code to reuse
> existing functions
> 
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Remove duplicated functions in favour general res_print_uint() call.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  rdma/res-cmid.c |  4 ++--
>  rdma/res-cq.c   | 14 +++-----------
>  rdma/res-mr.c   |  2 +-
>  rdma/res-pd.c   |  4 ++--
>  rdma/res-qp.c   | 14 +++-----------
>  rdma/res.c      | 34 ++--------------------------------
>  rdma/res.h      |  3 ---
>  7 files changed, 13 insertions(+), 62 deletions(-)
> 


Reviewed-by: Steve Wise <swise@opengridcomputing.com>
