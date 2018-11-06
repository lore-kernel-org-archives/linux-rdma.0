From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v3] rdma: Document IB device renaming option
Date: Mon, 5 Nov 2018 20:13:46 -0700
Message-ID: <469292eb-2323-1840-469e-102c8a2186be@gmail.com>
References: <20181104191122.11979-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181104191122.11979-1-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

On 11/4/18 12:11 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> [leonro@server /]$ lspci |grep -i Ether
> 00:08.0 Ethernet controller: Red Hat, Inc. Virtio network device
> 00:09.0 Ethernet controller: Mellanox Technologies MT27700 Family [ConnectX-4]
> [leonro@server /]$ sudo rdma dev
> 1: mlx5_0: node_type ca fw 3.8.9999 node_guid 5254:00c0:fe12:3455
> sys_image_guid 5254:00c0:fe12:3455
> [leonro@server /]$ sudo rdma dev set mlx5_0 name hfi1_0
> [leonro@server /]$ sudo rdma dev
> 1: hfi1_0: node_type ca fw 3.8.9999 node_guid 5254:00c0:fe12:3455
> sys_image_guid 5254:00c0:fe12:3455
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
> Changelog:
> v2->v3:
>  * Dropped "to be named" words from example section of man
> ---
>  man/man8/rdma-dev.8 | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)

applied to iproute2-next. Thanks
