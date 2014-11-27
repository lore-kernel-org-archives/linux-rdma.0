From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/2] Adding support for RoCE V2 specification
Date: Thu, 27 Nov 2014 11:56:08 +0200
Message-ID: <CAG9sBKPGbHc49rLx+z3N+bgzMakFks2ihvgAkZpmjUz==2ZYDQ@mail.gmail.com>
References: <51dd1341-8216-494f-9574-120634cad8e7@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51dd1341-8216-494f-9574-120634cad8e7-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 27, 2014 at 2:56 AM, Somnath Kotur <somnath.kotur-laKkSmNT4hZhl2p70BpVqQ@public.gmane.org=
m> wrote:
> Please apply.
>
> Somnath Kotur (2):
>   IB/Core: Changes to the IB Core infrastructure for RoCE V2.
>   IB/ocrdma: Changes to comply with RoCEv2 Specification changes
>
>  drivers/infiniband/core/addr.c              |   13 +++++-
>  drivers/infiniband/core/cm.c                |   15 ++++---
>  drivers/infiniband/core/cma.c               |    4 +-
>  drivers/infiniband/core/sa_query.c          |    1 +
>  drivers/infiniband/core/verbs.c             |   47 +++++++++++++++++=
---
>  drivers/infiniband/hw/ocrdma/ocrdma.h       |    2 +
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |   64 +++++++++++++++++=
++++-----
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   26 +++++++++++
>  drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |   16 ++++++-
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   11 ++++-
>  include/rdma/ib_addr.h                      |    3 +-
>  include/rdma/ib_sa.h                        |    1 +
>  include/rdma/ib_verbs.h                     |   15 ++++++
>  13 files changed, 187 insertions(+), 31 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

=46ew comments to the IB/core part

1.       RoCEv2 spec (Annex A17) sees RoCE type (or as the patch name
it - network_hdr_type) as an attribute of the source GID. If so, there
is no point to for address structures (ib_ah_attr, ib_sa_path_rec, =E2=80=
=A6)
to have both sgid and RoCE type. The alternative is to keep an extra
info in each GID table entry about the RoCE header (IPv4/IPv6 or GRH)
and use it when modifying QP from INIT to RTR (RC/UC) or creating AH
(UD).

2.       Population of  table in for RoCE should be a common code to
all drivers and needs to be moved to IB/core (unlike today when it is
specific to a vendor). We plan to push such a change soon.

3.       If I get it right, the purpose of the change in ib_addr is to
that determine RoCE type based on the resolution of address from OS.
If gateway is used (dest address is not in the subnet of source
address) then the protocol will be V2, otherwise it will be V1. This
means that IB over UDP is not possible on the same network. I don't
think that this is acceptable.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
