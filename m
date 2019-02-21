From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH iproute2-next v1 19/19] rdma: Provide and reuse filter functions
Date: Thu, 21 Feb 2019 14:39:51 -0600
Message-ID: <021f01d4ca25$984115f0$c8c341d0$@opengridcomputing.com>
References: <20190220072136.3840-1-leon@kernel.org> <20190220072136.3840-20-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190220072136.3840-20-leon@kernel.org>
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
To: 'Leon Romanovsky' <leon@kernel.org>, 'David Ahern' <dsahern@gmail.com>
Cc: 'Leon Romanovsky' <leonro@mellanox.com>, 'netdev' <netdev@vger.kernel.org>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Stephen Hemminger' <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> owner@vger.kernel.org> On Behalf Of Leon Romanovsky
> Sent: Wednesday, February 20, 2019 1:22 AM
> To: David Ahern <dsahern@gmail.com>
> Cc: Leon Romanovsky <leonro@mellanox.com>; netdev
> <netdev@vger.kernel.org>; RDMA mailing list <linux-
> rdma@vger.kernel.org>; Stephen Hemminger
> <stephen@networkplumber.org>
> Subject: [PATCH iproute2-next v1 19/19] rdma: Provide and reuse filter
> functions
> 
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Globally replace all filter function in safer variants of those
> is_filterred functions, which take into account the availability/lack

"is_filterred" -> "is_filtered"

> of netlink attributes.
> 
> Such conversion allowed to fix a number of places in the code, where
> the previous implementation didn't honor filter requests if netlink
> attribute wasn't present.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  rdma/rdma.h     |  7 +++---
>  rdma/res-cmid.c | 57 +++++++++++++++++++++++++++----------------------
>  rdma/res-cq.c   | 22 +++++++++++--------
>  rdma/res-mr.c   | 12 +++++++----
>  rdma/res-pd.c   | 12 +++++++----
>  rdma/res-qp.c   | 53 ++++++++++++++++++++++-----------------------
>  rdma/utils.c    | 26 ++++++++++++++++++----
>  7 files changed, 112 insertions(+), 77 deletions(-)

Reviewed-by: Steve Wise <swise@opengridcomputing.com>
