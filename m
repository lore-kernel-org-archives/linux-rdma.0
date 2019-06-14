From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: Re: [PATCH] RDMA/ucma: Use struct_size() helper
Date: Fri, 14 Jun 2019 15:39:14 +0200
Message-ID: <f8d5dcb8-b665-b34e-3869-a720fd6f6899@metux.net>
References: <20190604154222.GA8938@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190604154222.GA8938@embeddedor>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 04.06.19 17:42, Gustavo A. R. Silva wrote:

Hi,

<snip>

> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> index 140a338a135f..cbe460076611 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -951,8 +951,7 @@ static ssize_t ucma_query_path(struct ucma_context *ctx,
>  		}
>  	}
>  
> -	if (copy_to_user(response, resp,
> -			 sizeof(*resp) + (i * sizeof(struct ib_path_rec_data))))
> +	if (copy_to_user(response, resp, struct_size(resp, path_data, i)))
>  		ret = -EFAULT;

have you already considered further reducing the boilerplate by putting
this into it's own helper macro, so it finally would look like this ?

+	if (copy_to_user_structs(response, resp, resp, path_data, i)))
>  		ret = -EFAULT;

You've posted similar patches that also affected things like kzalloc().
Maybe for those it would be better candidates for putting everything
into its own helper macro ? (I've already got that on my 2do list, but
not sure whether maintainers really like to be bothered with those
kind of patches ;-)).


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
