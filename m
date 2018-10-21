From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next 3/3] rdma: Add an option to rename IB device
 interface
Date: Sun, 21 Oct 2018 10:02:43 -0600
Message-ID: <c1896e09-2081-858a-70fd-6fe9c998efa0@gmail.com>
References: <20181018115120.17893-1-leon@kernel.org>
 <20181018115120.17893-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181018115120.17893-4-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

On 10/18/18 5:51 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Enrich rdmatool with an option to rename IB devices,
> the command interface follows Iproute2 convention:
> "rdma dev set [OLD-DEVNAME] name NEW-DEVNAME"
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  rdma/dev.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/rdma/dev.c b/rdma/dev.c
> index e2eafe47..760b7fb3 100644
> --- a/rdma/dev.c
> +++ b/rdma/dev.c
> @@ -14,6 +14,7 @@
>  static int dev_help(struct rd *rd)
>  {
>  	pr_out("Usage: %s dev show [DEV]\n", rd->filename);
> +	pr_out("       %s dev set [DEV] name DEVNAME\n", rd->filename);
>  	return 0;
>  }
>  
> @@ -240,17 +241,51 @@ static int dev_one_show(struct rd *rd)
>  	return rd_exec_cmd(rd, cmds, "parameter");
>  }
>  
> +static int dev_set_name(struct rd *rd)
> +{
> +	uint32_t seq;
> +
> +	if (rd_no_arg(rd)) {
> +		pr_err("Please provide device new name.\n");
> +		return -EINVAL;
> +	}

This is redundant with rd_exec_require_dev which is the required path to
get to this point.
