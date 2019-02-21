From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH iproute2-next v1 18/19] rdma: Perform single .doit call to query specific objects
Date: Thu, 21 Feb 2019 14:35:59 -0600
Message-ID: <021c01d4ca25$0e310000$2a930000$@opengridcomputing.com>
References: <20190220072136.3840-1-leon@kernel.org> <20190220072136.3840-19-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190220072136.3840-19-leon@kernel.org>
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
> Subject: [PATCH iproute2-next v1 18/19] rdma: Perform single .doit call to
> query specific objects
> 
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> If user provides specific index, we can speedup query
> by using .doit callback and save full dump and filtering
> after that.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  rdma/rdma.h     | 10 +++++-
>  rdma/res-cmid.c | 33 +++++++++++++------
>  rdma/res-cq.c   | 34 ++++++++++++++------
>  rdma/res-mr.c   | 33 ++++++++++++++-----
>  rdma/res-pd.c   | 32 ++++++++++++++-----
>  rdma/res-qp.c   | 32 ++++++++++++++-----
>  rdma/res.c      | 34 +++++++++++++++++++-
>  rdma/res.h      | 84 ++++++++++++++++++++++++++++++++-----------------
>  rdma/utils.c    | 20 ++++++++++++
>  9 files changed, 239 insertions(+), 73 deletions(-)
> 


Reviewed-by: Steve Wise <swise@opengridcomputing.com>
