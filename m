From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH iproute2-next v1 17/19] rdma: Unify netlink attribute checks prior to prints
Date: Thu, 21 Feb 2019 14:31:03 -0600
Message-ID: <021a01d4ca24$5dbd7dc0$19387940$@opengridcomputing.com>
References: <20190220072136.3840-1-leon@kernel.org> <20190220072136.3840-18-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190220072136.3840-18-leon@kernel.org>
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
> Subject: [PATCH iproute2-next v1 17/19] rdma: Unify netlink attribute
checks
> prior to prints
> 
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Place check if netlink attribute available in general place,
> instead of doing the same check in many paces.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  rdma/res-cmid.c |  9 ++++-----
>  rdma/res-cq.c   | 22 +++++++++++-----------
>  rdma/res-mr.c   | 21 +++++++--------------
>  rdma/res-pd.c   | 20 +++++++++-----------
>  rdma/res-qp.c   | 10 +++++-----
>  rdma/res.c      | 16 +++++++++++++---
>  rdma/res.h      |  6 ++++--
>  7 files changed, 53 insertions(+), 51 deletions(-)


Reviewed-by: Steve Wise <swise@opengridcomputing.com>
