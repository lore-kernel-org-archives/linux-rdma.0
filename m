From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 4/6] IB/mlx5: Handle type IB_QPT_DRIVER when
 creating a QP
Date: Mon, 1 Jan 2018 14:53:29 +0200
Message-ID: <CAJ3xEMjQQhJ+ZVDDmSRKKrXbaTWzp9JJ_dYtjjRqrNP0rr+BDQ@mail.gmail.com>
References: <20171227171540.1646-1-leon@kernel.org> <20171227171540.1646-5-leon@kernel.org>
 <CAJ3xEMiExjjVUOYQsdMiHLNOjB+MOkz4c1TT9AT_inkfGfMuKA@mail.gmail.com>
 <20171227220227.GL31310@mellanox.com> <30a35dd5-3046-d7bb-e61f-7d18501fd06c@dev.mellanox.co.il>
 <CAJ3xEMhPZfyTZ1Hr8Mwq9xeqV6UKkkVfXNDrx625qoWzAHr6qg@mail.gmail.com>
 <1e827f07-f8a1-ffa3-7c8b-e90b1107e843@dev.mellanox.co.il> <CAJ3xEMhNN4Vz7zxssOhgZzj4yfrC-h7tWn71AvJun29ZHL3wDQ@mail.gmail.com>
 <ad933caf-4246-1bb0-2d6e-3d3795f2a9c5@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ad933caf-4246-1bb0-2d6e-3d3795f2a9c5-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 31, 2017 at 3:05 PM, Yishai Hadas
<yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 12/31/2017 2:37 PM, Or Gerlitz wrote:

>>> It doesn't make sense to overwrite the input QP type (i.e. IB_QPT_DRIVER)
>>> which was supplied by the core layer to some internal sub-type.

>> why?

> A driver code doesn't expect to change an input IB core property (i.e
> qp_type). Specifically the DC QP type does not expect to be recognized out
> of the mlx5 driver, for that reason a sub qp type will be used as part of V2
> in the mlx5 driver code.

sub qp type sound better from qp type stored in two places... I think we should
still strongly aim to have the qp type in one place... I guess it
would be correct
for this to be a driver maintainer decision.

>> So what you are saying is the core logic being good for all
>> QP types X all drivers X all transports and only mlx5/DC needs this
>> different treatment? interesting, so what is the source for this misalignment?

> We believe that it doesn't justify a core refactoring for that specific mask
> checking.

ok, just remember that C&Ps have the tendency to add bugs, so look
carefully on the code..
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
