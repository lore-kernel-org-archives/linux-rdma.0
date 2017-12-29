From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 4/6] IB/mlx5: Handle type IB_QPT_DRIVER when
 creating a QP
Date: Fri, 29 Dec 2017 17:23:27 +0200
Message-ID: <CAJ3xEMhPZfyTZ1Hr8Mwq9xeqV6UKkkVfXNDrx625qoWzAHr6qg@mail.gmail.com>
References: <20171227171540.1646-1-leon@kernel.org> <20171227171540.1646-5-leon@kernel.org>
 <CAJ3xEMiExjjVUOYQsdMiHLNOjB+MOkz4c1TT9AT_inkfGfMuKA@mail.gmail.com>
 <20171227220227.GL31310@mellanox.com> <30a35dd5-3046-d7bb-e61f-7d18501fd06c@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <30a35dd5-3046-d7bb-e61f-7d18501fd06c-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 28, 2017 at 12:02 PM, Yishai Hadas
<yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 12/28/2017 12:02 AM, Jason Gunthorpe wrote:

>> +       if (ucmd->flags & MLX5_QP_FLAG_TYPE_DCI)
>> +               init_attr->qp_type = MLX5_IB_QPT_DCI;
>> +       else
>> +               init_attr->qp_type = MLX5_IB_QPT_DCT;

>> Which is a bad ABI design, check flags explicitly never use else.

> We can drop this 'else' as few lines above there was a check that both can't
> be set together. However, not sure that this change worth V2.

Yishai,

if something should be fixed lets just do that, why not?

validate_driver_qp() deals @ 95% of it's contents with DC but has no
DC in it's name, also it does assignment which goes beyond validation.

There are bunch of things to consider fixing here. The patch spaghettizes
the driver code w.r.t where the qp type is stored, in the ib qp or the mlx5 qp
struct in a new field. Why not do a refactoring patch that uses always the
type from the mlx5 qp or do a conversion at the code that parses the UAPI
and step over the user space provided  DRIVER type with the RES3 (DCI)
or RES4 (DCT)
that you defined, or any other idea which will keep us with less
branching across
the place on where the qp type is stored.

Also you added a "is qp ok" self function which AFAIK uses a different practice
from the IB core copy, did you consider to refactor the core code and allow
a re-use from the driver? did you consider to use a similar practice
for your "is ok" function?

You served as the reviewer here, I will be happy to get your op on
these matters.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
