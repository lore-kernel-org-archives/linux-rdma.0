From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH iproute2-next v1 12/19] rdma: Simplify CM_ID print code
Date: Thu, 21 Feb 2019 14:26:26 -0600
Message-ID: <020201d4ca23$b879e790$296db6b0$@opengridcomputing.com>
References: <20190220072136.3840-1-leon@kernel.org> <20190220072136.3840-13-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190220072136.3840-13-leon@kernel.org>
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
> Subject: [PATCH iproute2-next v1 12/19] rdma: Simplify CM_ID print code
> 
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Refactor our the CM_ID print code.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  rdma/res-cmid.c | 246 ++++++++++++++++++++++++------------------------
>  1 file changed, 124 insertions(+), 122 deletions(-)

Not sure why you refactored, but ok.

Reviewed-by: Steve Wise <swise@opengridcomputing.com>
