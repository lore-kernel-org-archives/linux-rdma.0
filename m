From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 0/3] RFC: common API for displaying status codes
Date: Mon, 17 Nov 2014 11:55:03 +0200
Message-ID: <CAJ3xEMju=3PZefy1veTNCuA03hqMfdZOReYE_4Hb9enBJMev3w@mail.gmail.com>
References: <20141117022038.4079.66922.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141117022038.4079.66922.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 17, 2014 at 4:29 AM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Sagi and Or suggested developing a common API for displaying status
> and event codes that can be shared among consumers of ib_core. The
> first patch is a stab at that. The last two patches are examples of
> how the new APIs are used. Lightly tested.
>
> If acceptable, I'll submit 1/3 via the IB tree. 3/3 will go through
> Anna's tree after 1/3 is merged. Does 2/3 need to go through netdev?

no please.

Let's avoid asking the kernel maintainers to conduct three-way merge
just for IB str-ing... all three patches can go through one tree, I
vote for q tree with an active maintainer... choose one.

Or.


>
> ---
>
> Chuck Lever (3):
>       ib_core: API for deriving common display strings
>       RDS: Replace event/status display helpers with generic helpers
>       xprtrdma: Replace array of connection strings
>
>
>  drivers/infiniband/core/Makefile |    3 -
>  drivers/infiniband/core/str.c    |  167 ++++++++++++++++++++++++++++++++++++++
>  include/rdma/ib_str.h            |   54 ++++++++++++
>  net/rds/af_rds.c                 |    9 --
>  net/rds/ib.h                     |    1
>  net/rds/ib_cm.c                  |   36 +-------
>  net/rds/ib_recv.c                |    4 -
>  net/rds/ib_send.c                |   38 ---------
>  net/rds/rdma_transport.c         |   34 +-------
>  net/rds/rds.h                    |    2
>  net/sunrpc/xprtrdma/verbs.c      |   27 ------
>  net/sunrpc/xprtrdma/xprt_rdma.h  |    1
>  12 files changed, 236 insertions(+), 140 deletions(-)
>  create mode 100644 drivers/infiniband/core/str.c
>  create mode 100644 include/rdma/ib_str.h
>
> --
> Chuck Lever
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
