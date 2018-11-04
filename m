From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v2] rdma: Document IB device renaming option
Date: Sun, 4 Nov 2018 07:26:24 -0700
Message-ID: <07ffbccc-916c-25d3-654e-7e457be3c133@gmail.com>
References: <20181104115405.9455-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181104115405.9455-1-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

On 11/4/18 4:54 AM, Leon Romanovsky wrote:
> @@ -45,6 +53,11 @@ rdma dev show mlx5_3
>  Shows the state of specified RDMA device.
>  .RE
>  .PP
> +rdma dev set mlx5_3 name rdma_0
> +.RS 4
> +Renames the mlx5_3 device to be named rdma_0.
> +.RE
> +.PP

You missed my other comment: Fix the "Renames .... to be named ..."
