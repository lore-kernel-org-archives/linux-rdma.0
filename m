From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH iproute2-next v1 05/19] rdma: Move resource PD logic to separate file
Date: Thu, 21 Feb 2019 14:15:16 -0600
Message-ID: <01d601d4ca22$28f83140$7ae893c0$@opengridcomputing.com>
References: <20190220072136.3840-1-leon@kernel.org> <20190220072136.3840-6-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190220072136.3840-6-leon@kernel.org>
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
> Subject: [PATCH iproute2-next v1 05/19] rdma: Move resource PD logic to
> separate file
> 
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Logically separate resource PD logic to separate file,
> in order to make PD specific logic self-contained.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---

Why does it need to be self contained?

Reviewed-by: Steve Wise <swise@opengridcomputing.com>
