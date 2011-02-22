From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] Function for improved node descriptions
Date: Tue, 22 Feb 2011 15:44:36 -0500
Message-ID: <AANLkTin6m=-y-jrA1REd4v2=u13gnLhdBTp6DdcYK8vq@mail.gmail.com>
References: <20110218212723.21364.92709.stgit@homer>
	<20110218212913.21364.23411.stgit@homer>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110218212913.21364.23411.stgit@homer>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 18, 2011 at 4:29 PM, Michael Heinz <michael.heinz-h88ZbnxC6KBhl2p70BpVqQ@public.gmane.org=
m> wrote:
> The common practice in IB fabrics is to set the description of an HCA=
 to be
> the hostname of the machine plus a description (i.e., "myhost hca-1",
> "myhost hca-2", etc..)
>
> This has a limitation, however. =C2=A0The first is that if the machin=
e's
> hostname is set via DHCP, the HCA description may be set before the h=
ostname
> is, leading to an incorrect description. This can also occur if the m=
achine's
> hostname changes for some other reason after boot.
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
ns an
> '@' character, the function will substitute the current utsname.
>
> This ensures that even after a fabric has been completely initialized=
, if
> a node's hostname changes, that change will be reflected in the next =
sweep
> of the SM,

This is when the SM reads NodeDescriptions during those sweeps (which
is not a requirement nor intended to be a requirement for SMs in
general). A better way than periodic polling is to only poll it when
there's a trap issued for it changing. I think this is (somewhat)
orthogonal to the patch if this is referring to NodeDescription in the
SMAs in the subnet and not from the perspective of the SM.

As has been mentioned before, issuing the trap for NodeDescription
changed would make this better in terms of SMs in general.

I would also like to see how multiple HCAs in the same host are
handled just to be sure but I think I see what you intend in the
script for that.

-- Hal

> but also maintains compatibility with existing code since the
> behavior is unchanged if the description string does not contain an '=
@'
> character.
>
> Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
>
> ---
> =C2=A0drivers/infiniband/core/mad.c | =C2=A0 19 +++++++++++++++++++
> =C2=A0include/rdma/ib_mad.h =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A0=
9 +++++++++
> =C2=A02 files changed, 28 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/=
mad.c
> index 822cfdc..7ea8556 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -41,6 +41,7 @@
> =C2=A0#include "mad_rmpp.h"
> =C2=A0#include "smi.h"
> =C2=A0#include "agent.h"
> +#include "linux/utsname.h"
>
> =C2=A0MODULE_LICENSE("Dual BSD/GPL");
> =C2=A0MODULE_DESCRIPTION("kernel IB MAD API");
> @@ -932,6 +933,24 @@ int ib_get_mad_data_offset(u8 mgmt_class)
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(ib_get_mad_data_offset);
>
> +void ib_build_node_desc(struct ib_smp *smp, char *src)
> +{
> + =C2=A0 =C2=A0 =C2=A0 char *dest =3D smp->data;
> + =C2=A0 =C2=A0 =C2=A0 int i;
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < IB_SMP_DATA_SIZE;) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (*src =3D=3D '@=
') {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 char *name =3D init_utsname()->nodename;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 for (; *name && (*name !=3D '.') && (i < IB_SMP_DATA_SIZE); ++i=
)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *dest++ =3D *name++;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 src++;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 *dest++ =3D *src++;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 i++;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 }
> +}
> +EXPORT_SYMBOL(ib_build_node_desc);
> +
> =C2=A0int ib_is_mad_class_rmpp(u8 mgmt_class)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((mgmt_class =3D=3D IB_MGMT_CLASS_SUBN_=
ADM) ||
> diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
> index d3b9401..e2ed2db 100644
> --- a/include/rdma/ib_mad.h
> +++ b/include/rdma/ib_mad.h
> @@ -40,6 +40,7 @@
> =C2=A0#include <linux/list.h>
>
> =C2=A0#include <rdma/ib_verbs.h>
> +#include <rdma/ib_smi.h>
>
> =C2=A0/* Management base version */
> =C2=A0#define IB_MGMT_BASE_VERSION =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1
> @@ -637,6 +638,14 @@ int ib_is_mad_class_rmpp(u8 mgmt_class);
> =C2=A0int ib_get_mad_data_offset(u8 mgmt_class);
>
> =C2=A0/**
> + * ib_build_node_desc - copies the node description and replaces
> + * any @ markers with the present system node name.
> + * @dest: destination
> + * @src: source
> + */
> +void ib_build_node_desc(struct ib_smp *smp, char *src);
> +
> +/**
> =C2=A0* ib_get_rmpp_segment - returns the data buffer for a given RMP=
P segment.
> =C2=A0* @send_buf: Previously allocated send data buffer.
> =C2=A0* @seg_num: number of segment to return
>
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
