From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next] clang-format: add configuration file
Date: Thu, 17 Jan 2019 14:42:46 -0700
Message-ID: <a424ecb7-2e04-5e5a-cdea-7f7e1f07aa6e@gmail.com>
References: <20190117150801.25191-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190117150801.25191-1-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

On 1/17/19 8:08 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> The codebase of iproute2 follows Linux kernel coding style,
> so it will be very helpful to reuse existing clang configuration
> file to reliably format code.
> 
> For more information see kernel commit d4ef8d3ff005
> ("clang-format: add configuration file").
> 
> Updated upto commit v5.0-rc1 with small number of ForEachMacros.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  .clang-format | 130 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 130 insertions(+)
>  create mode 100644 .clang-format
> 

applied to iproute2-next. Thanks
