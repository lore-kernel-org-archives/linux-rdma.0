From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next 05/19] rdma: Move resource PD logic to
 separate file
Date: Fri, 25 Jan 2019 10:19:22 -0700
Message-ID: <0ad0319f-194c-d574-e7f7-eca71c7a008a@gmail.com>
References: <20190122183125.15920-1-leon@kernel.org>
 <20190122183125.15920-6-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190122183125.15920-6-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

On 1/22/19 11:31 AM, Leon Romanovsky wrote:
> +static const
> +struct filters pd_valid_filters[MAX_NUMBER_OF_FILTERS] = {
> +	{ .name = "dev", .is_number = false },
> +	{ .name = "users", .is_number = true },
> +	{ .name = "pid", .is_number = true },
> +	{ .name = "ctxn", .is_number = true },
> +	{ .name = "pdn", .is_number = true },
> +	{ .name = "ctxn", .is_number = true }
> +};

These should not be in a header file. Looks like you have done this in
other patches as well.
