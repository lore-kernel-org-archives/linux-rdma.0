From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 iproute2-next 2/4] rdma: add helper rd_sendrecv_msg()
Date: Sun, 31 Mar 2019 20:06:19 -0600
Message-ID: <105e6c3c-859a-ab9b-fe91-80e1c06638f7@gmail.com>
References: <cover.1553627811.git.larrystevenwise@gmail.com>
 <06a2302a1dc575a0829a5b789bb7a412adb2ce95.1553627811.git.larrystevenwise@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <06a2302a1dc575a0829a5b789bb7a412adb2ce95.1553627811.git.larrystevenwise@gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <larrystevenwise@gmail.com>, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 3/26/19 1:18 PM, Steve Wise wrote:
> This function sends the constructed netlink message and then
> receives the response.
> 
> Change rd_recv_msg() to display any error messages.
> 
> Change 'rdma dev set' to use rd_sendrecv_msg().
> 
> Signed-off-by: Steve Wise <larrystevenwise@gmail.com>
> ---
>  rdma/dev.c   |  2 +-
>  rdma/rdma.h  |  2 ++
>  rdma/res.h   |  1 +
>  rdma/utils.c | 18 ++++++++++++++++++
>  4 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/rdma/dev.c b/rdma/dev.c
> index 954e0015..33962520 100644
> --- a/rdma/dev.c
> +++ b/rdma/dev.c
> @@ -268,7 +268,7 @@ static int dev_set_name(struct rd *rd)
>  	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
>  	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_DEV_NAME, rd_argv(rd));
>  
> -	return rd_send_msg(rd);
> +	return rd_sendrecv_msg(rd, seq);
>  }
>  
>  static int dev_one_set(struct rd *rd)
> diff --git a/rdma/rdma.h b/rdma/rdma.h
> index 1022e9a2..6c7f7d15 100644
> --- a/rdma/rdma.h
> +++ b/rdma/rdma.h
> @@ -68,6 +68,7 @@ struct rd {
>  	json_writer_t *jw;
>  	bool json_output;
>  	bool pretty_output;
> +	bool suppress_errors;
>  	struct list_head filter_list;
>  };
>  

All of the suppress_errors seems like an unrelated change.
