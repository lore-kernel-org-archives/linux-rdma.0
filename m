From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v1 02/19] rdma: Remove duplicated print code
Date: Thu, 21 Feb 2019 10:23:01 -0500
Message-ID: <c6f27ca0-55d6-4d3b-e498-ed700eb00844@gmail.com>
References: <20190220072136.3840-1-leon@kernel.org>
 <20190220072136.3840-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190220072136.3840-3-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

On 2/20/19 2:21 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> There is no need to keep same print functions for
> uint32_t and uint64_t, unify them into one function.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  rdma/res.c | 22 +++++++---------------
>  1 file changed, 7 insertions(+), 15 deletions(-)
> 
> diff --git a/rdma/res.c b/rdma/res.c
> index 6b0f5fe3..87865ec8 100644
> --- a/rdma/res.c
> +++ b/rdma/res.c
> @@ -808,28 +808,20 @@ static int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
>  	return MNL_CB_OK;
>  }
>  
> -static void print_key(struct rd *rd, const char *name, uint32_t val)
> +static void print_key(struct rd *rd, const char *name, uint64_t val)
>  {
>  	if (rd->json_output)
>  		jsonw_xint_field(rd->jw, name, val);
>  	else
> -		pr_out("%s 0x%x ", name, val);
> +		pr_out("%s 0x%" PRIx64 " ", name, val);
>  }

what's the plan to move rdma tool to iproute2's json functions?

I realize rdma tool inherited this from devlink, but this command does
not need to continue managing this.
