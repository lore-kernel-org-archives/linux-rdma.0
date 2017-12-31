From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 4/6] IB/mlx5: Handle type IB_QPT_DRIVER when
 creating a QP
Date: Sun, 31 Dec 2017 13:45:41 +0200
Message-ID: <1e827f07-f8a1-ffa3-7c8b-e90b1107e843@dev.mellanox.co.il>
References: <20171227171540.1646-1-leon@kernel.org>
 <20171227171540.1646-5-leon@kernel.org>
 <CAJ3xEMiExjjVUOYQsdMiHLNOjB+MOkz4c1TT9AT_inkfGfMuKA@mail.gmail.com>
 <20171227220227.GL31310@mellanox.com>
 <30a35dd5-3046-d7bb-e61f-7d18501fd06c@dev.mellanox.co.il>
 <CAJ3xEMhPZfyTZ1Hr8Mwq9xeqV6UKkkVfXNDrx625qoWzAHr6qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhPZfyTZ1Hr8Mwq9xeqV6UKkkVfXNDrx625qoWzAHr6qg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/29/2017 5:23 PM, Or Gerlitz wrote:
> validate_driver_qp() deals @ 95% of it's contents with DC but has no
> DC in it's name, also it does assignment which goes beyond validation.
> 

OK, will rename it to be prepare_driver_qp().

The function name follows the input QP type (i.e. IB_QPT_DRIVER) and 
what it does on. Specifically, its purpose is to prepare the input data 
(ucmd, init_attr) to be used later on. Similar name and logic is used as 
part of RQ creation as part of this file. (i.e. prepare_user_rq()).

> There are bunch of things to consider fixing here. The patch spaghettizes
> the driver code w.r.t where the qp type is stored, in the ib qp

It doesn't make sense to overwrite the input QP type (i.e. 
IB_QPT_DRIVER) which was supplied by the core layer to some internal 
sub-type.

> or the mlx5 qp

The sub type is from type enum ib_qp_type (MLX5_IB_QPT_DCI 
<->IB_QPT_RESERVED3) and not an internal mlx5 PRM QP type.

However, to make the code more clearer and accurate, we'll change as 
part of V2 'u32 driver_qp_type' to be 'enum ib_qp_type sub_qp_type' and 
clean some redundant checks when applicable. (e.g. in 
mlx5_ib_query_qp()).

> Also you added a "is qp ok" self function which AFAIK uses a different practice
> from the IB core copy, did you consider to refactor the core code and allow
> a re-use from the driver?

Yes, we considered that, however, as this QP type has some specific 
driver behavior we found it better to stay with that specific logic for 
DCI QP in the driver code, no reason to refactor the core layer as of 
that. As part of V2 will rename 'mlx5_ib_modify_qp_is_ok()' to be 
'modify_dc_qp_is_ok()' to better represent the specific use case around.


> did you consider to use a similar practice
> for your "is ok" function?

Yes, however, we found it more clearer and simple to use current code 
for the specific DCI case instead of introducing some general mapping 
table without any real use.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
