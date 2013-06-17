From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 0/4] Add receive Flow Steering support
Date: Mon, 17 Jun 2013 20:33:09 +0300
Message-ID: <CAJZOPZLwy91C3EpcQDV6yDLz7E5f=Pfo0J9VSJOr78hC+rr3rw@mail.gmail.com>
References: <1370950973-11716-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370950973-11716-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 11, 2013 at 2:42 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
[...]
> V0 has been acknowledged by Steve and Christoph, and was also got positive
> feedback from Sean and Jason over f2f talks we had during the Linux Foundation EU
> summit on last month.

Hi Roland,

So we're @ -rc6 and there's also other goodies on the plate for the
coming merge window ... any comment here, is this safe for 3.11?
taking this? I am asking here, b/c it doesn't seem you update you
patchwork, so no other choice.

Or.

>
> V1 changes:
>
>  - dropped the five pre-patches which were accepted into 3.10
>  - rebased the patches against Roland's for-next / 3.10-rc4
>  - in patch #3, ib_uverbs_destroy_flow was returning too quickly when the
> driver
>    returned failure for ib_destroy_flow, need to free some uverbs
> resources 1st.
>  - in patch #4, check index before accessing the array at
> mlx4_ib_create/destroy_flow
>
>
> Or.
>
> Hadar Hen Zion (3):
>   IB/core: Add receive Flow Steering support
>   IB/core: Export ib_create/destroy_flow through uverbs
>   IB/mlx4: Add receive Flow Steering support
>
> Igor Ivanov (1):
>   IB/core: Infra-structure to support verbs extensions through uverbs
>
>  drivers/infiniband/core/uverbs.h      |    3 +
>  drivers/infiniband/core/uverbs_cmd.c  |  206 +++++++++++++++++++++++++++
>  drivers/infiniband/core/uverbs_main.c |   42 +++++-
>  drivers/infiniband/core/verbs.c       |   30 ++++
>  drivers/infiniband/hw/mlx4/main.c     |  246
> +++++++++++++++++++++++++++++++++
>  include/rdma/ib_verbs.h               |  137 ++++++++++++++++++-
>  include/uapi/rdma/ib_user_verbs.h     |  118 ++++++++++++++++-
>  7 files changed, 773 insertions(+), 9 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
