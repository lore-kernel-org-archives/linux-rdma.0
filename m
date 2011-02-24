From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/2] Improved Node Descriptions
Date: Thu, 24 Feb 2011 11:08:13 -0500
Message-ID: <AANLkTi=c1A_RWR3S8c0g2iH2L84F7UCo9ojWcO2NjDLn@mail.gmail.com>
References: <20110224022124.26808.62012.stgit@homer>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110224022124.26808.62012.stgit@homer>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 23, 2011 at 9:24 PM, Michael Heinz <michael.heinz-h88ZbnxC6KBhl2p70BpVqQ@public.gmane.org=
m> wrote:
> The common practice in IB fabrics is to set the description of an HCA=
 to be
> the hostname of the machine plus a description (i.e., "myhost hca-1",=
 "myhost
> hca-2", etc..)
>
> This has a limitation, however. =C2=A0The first is that if the machin=
e's hostname
> is set via DHCP, the HCA description may be set before the hostname i=
s, leading
> to an incorrect description. This can also occur if the machine's hos=
tname
> changes for some other reason after boot.
>
> This can cause difficulties and confusion when trying to maintain a l=
arge
> fabric - if all your nodes are described as "localhost HCA-1" it can =
be very
> difficult to figure out which node is suffering from symbol errors.
>
> This patch addresses the problem by providing a function to build the=
 node
> description. If the provided source string for the description contai=
ns a '%h'
> it will be replaced at read time with the hostname of the node. If th=
e provided
> source string contains a '%d' it will be replaced at read time with t=
he name of
> the HCA. =C2=A0For example, the first Mellanox HCA on a node called "=
homer" would
> have the default description:
>
> homer: mthca0 MT25208 InfiniHostEx Mellanox Technologies
>
> While the default description for the second QLogic HCA on node-a13 w=
ould be:
>
> node-a2: qib0 QLogic kernel.org driver
>
> This ensures that even after a fabric has been completely initialized=
, if a
> node's hostname changes, that change will be reflected in the next sw=
eep of the
> SM,

assuming the SM sweep reads the NodeDescription, right ?

-- Hal

> but also maintains compatibility with existing code since the behavio=
r is
> unchanged if the description string does not contain a '%' character.
>
> Changes from Version 1:
>
> Replaced the original substitution of the hostname for '@' with an
> implementation of the '%h' and '%d' fields, and changed the default n=
ode
> description for Mellanox and QLogic HCA types to default to
> "%h: %d <description>" where '<description>' is the old default messa=
ge.
>
> ---
>
> Michael Heinz (2):
> =C2=A0 =C2=A0 =C2=A0Function for improved node descriptions
> =C2=A0 =C2=A0 =C2=A0Add support for ib_build_node_desc() to the HCAs.
>
>
> =C2=A0drivers/infiniband/core/mad.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0| =C2=A0 33 ++++++++++++++++++++++++++
> =C2=A0drivers/infiniband/hw/ipath/ipath_mad.c =C2=A0 =C2=A0 =C2=A0| =C2=
=A0 =C2=A02 +-
> =C2=A0drivers/infiniband/hw/ipath/ipath_verbs.c =C2=A0 =C2=A0| =C2=A0=
 =C2=A04 ++-
> =C2=A0drivers/infiniband/hw/mlx4/mad.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 | =C2=A0 =C2=A02 +-
> =C2=A0drivers/infiniband/hw/mlx4/main.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0| =C2=A0 =C2=A03 ++
> =C2=A0drivers/infiniband/hw/mthca/mthca_mad.c =C2=A0 =C2=A0 =C2=A0| =C2=
=A0 =C2=A02 +-
> =C2=A0drivers/infiniband/hw/mthca/mthca_provider.c | =C2=A0 =C2=A03 +=
+
> =C2=A0drivers/infiniband/hw/qib/qib_mad.c =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0| =C2=A0 =C2=A02 +-
> =C2=A0drivers/infiniband/hw/qib/qib_verbs.c =C2=A0 =C2=A0 =C2=A0 =C2=A0=
| =C2=A0 =C2=A02 +-
> =C2=A0include/rdma/ib_mad.h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A09 +++++++
> =C2=A010 files changed, 53 insertions(+), 9 deletions(-)
>
> --
> Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
