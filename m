From: Gal Pressman <galpress@amazon.com>
Subject: Re: [PATCH] [v2]RDMA: add checks for the status of nla_put in
 ib_nl_send_msg
Date: Tue, 8 Jan 2019 12:25:56 +0200
Message-ID: <018c208a-9bcb-0c4c-7001-5447b06b1d84@amazon.com>
References: <20190105170928.4086-1-pakki001@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190105170928.4086-1-pakki001@umn.edu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 05-Jan-19 19:09, Aditya Pakki wrote:
>  
>  static int ib_nl_get_path_rec_attrs_len(ib_sa_comp_mask comp_mask)
> @@ -856,7 +873,10 @@ static int ib_nl_send_msg(struct ib_sa_query *query, gfp_t gfp_mask)
>  	}
>  
>  	/* Add attributes */
> -	ib_nl_set_path_rec_attrs(skb, query);
> +	if (ib_nl_set_path_rec_attrs(skb, query, nlh)) {
> +		nlmsg_free(skb);
> +		return -EMSGSIZE;
> +	}

IMO, it's better to return the error code of ib_nl_set_path_rec_attrs instead of
an explicit -EMSGSIZE.
