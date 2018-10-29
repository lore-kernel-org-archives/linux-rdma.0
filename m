From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next 3/3] rdma: Add an option to rename IB device
 interface
Date: Mon, 29 Oct 2018 11:07:06 -0600
Message-ID: <b7151495-d8ab-209b-a86e-575fc2f4ed53@gmail.com>
References: <20181018115120.17893-1-leon@kernel.org>
 <20181018115120.17893-4-leon@kernel.org>
 <c1896e09-2081-858a-70fd-6fe9c998efa0@gmail.com>
 <20181029103046.GQ3974@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181029103046.GQ3974@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

On 10/29/18 4:30 AM, Leon Romanovsky wrote:
> 
> Sorry for being slow in response, I was on vacation.
> ----------
> 
> This print is intended to warn about missing "new name" and it is not
> checked by rd_exec_require_dev()
> 
> To emphasize it:
> 
> diff --git a/rdma/dev.c b/rdma/dev.c
> index 760b7fb3..468ae686 100644
> --- a/rdma/dev.c
> +++ b/rdma/dev.c
> @@ -246,6 +246,7 @@ static int dev_set_name(struct rd *rd)
>         uint32_t seq;
> 
> 	if (rd_no_arg(rd)) {
> +               pr_err("hello world\n");
>                 pr_err("Please provide device new  name.\n");
> 		return -EINVAL;
> 	}
> 
> Produces the following output:
> [leonro@server iproute2]$ ./rdma/rdma dev set mlx5_0 name
> hello world
> Please provide device new name.
> 
> So how will we progress from here? Should I respin?

ok, thanks for the explanation.

Steve mentioned an update to the man page is needed as well. Please do
that in the respin.

Thanks,
