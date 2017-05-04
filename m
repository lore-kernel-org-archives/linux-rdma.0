From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC 01/10] IB/core: Add a generic way to execute an
 operation on a uobject
Date: Thu, 4 May 2017 21:17:23 +0300
Message-ID: <20170504181723.GC22833@mtr-leonro.local>
References: <1492615225-55118-1-git-send-email-matanb@mellanox.com>
 <1492615225-55118-2-git-send-email-matanb@mellanox.com>
 <20170504102303.GR22833@mtr-leonro.local>
 <CAAKD3BALCSD=N90gFa+R64QAyuiuJLFmZzsvRz1roq5x-0s3Jw@mail.gmail.com>
 <20170504122851.GS22833@mtr-leonro.local>
 <CAAKD3BCz8+aT7hKzoxL__0iU_rzW_zv6FWHMhmgD7tnbwv3big@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="e9fMjeYs+GPci+mg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BCz8+aT7hKzoxL__0iU_rzW_zv6FWHMhmgD7tnbwv3big-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--e9fMjeYs+GPci+mg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 04, 2017 at 06:43:49PM +0300, Matan Barak wrote:
> On Thu, May 4, 2017 at 3:28 PM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> > On Thu, May 04, 2017 at 01:37:33PM +0300, Matan Barak wrote:
> >> On Thu, May 4, 2017 at 1:23 PM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> >> > On Wed, Apr 19, 2017 at 06:20:16PM +0300, Matan Barak wrote:
> >> >> The ioctl infrastructure treats all user-objects in the same manner.
> >> >> It gets an id from the user-space and by using the object type and
> >> >> operation mentioned in the action specification, it executes this
> >> >> operation. An operation is split to two stages. The first one is
> >> >> carried out before executing the handler and the second one is
> >> >> executed afterwards.
> >> >>
> >> >> In order to abstract these details from the ioctl infrastructure
> >> >> layer, we add uverbs_get_uobject_from_context and
> >> >> uverbs_finalize_object functions which corresponds to the first
> >> >> and second stages respectively.
> >> >>
> >> >> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> >> ---
> >> >>  drivers/infiniband/core/rdma_core.c | 51 ++++++++++++++++++++++++++++++++++++
> >> >>  drivers/infiniband/core/rdma_core.h | 16 ++++++++++++
> >> >>  include/rdma/uverbs_ioctl.h         | 52 +++++++++++++++++++++++++++++++++++++
> >> >>  3 files changed, 119 insertions(+)
> >> >>  create mode 100644 include/rdma/uverbs_ioctl.h
> >> >>
> >> >> diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
> >> >> index 41c31a2..269fa7f 100644
> >> >> --- a/drivers/infiniband/core/rdma_core.c
> >> >> +++ b/drivers/infiniband/core/rdma_core.c
> >> >> @@ -35,6 +35,7 @@
> >> >>  #include <rdma/ib_verbs.h>
> >> >>  #include <rdma/uverbs_types.h>
> >> >>  #include <linux/rcupdate.h>
> >> >> +#include <rdma/uverbs_ioctl.h>
> >> >>  #include "uverbs.h"
> >> >>  #include "core_priv.h"
> >> >>  #include "rdma_core.h"
> >> >> @@ -625,3 +626,53 @@ void uverbs_initialize_ucontext(struct ib_ucontext *ucontext)
> >> >>       .needs_kfree_rcu = false,
> >> >>  };
> >> >>
> >> >> +struct ib_uobject *uverbs_get_uobject_from_context(const struct uverbs_obj_type *type_attrs,
> >> >> +                                                struct ib_ucontext *ucontext,
> >> >> +                                                enum uverbs_idr_access access,
> >> >> +                                                int id)
> >> >> +{
> >> >> +     switch (access) {
> >> >> +     case UVERBS_ACCESS_READ:
> >> >> +             return rdma_lookup_get_uobject(type_attrs, ucontext, id, false);
> >> >> +     case UVERBS_ACCESS_DESTROY:
> >> >> +     case UVERBS_ACCESS_WRITE:
> >> >> +             return rdma_lookup_get_uobject(type_attrs, ucontext, id, true);
> >> >> +     case UVERBS_ACCESS_NEW:
> >> >> +             return rdma_alloc_begin_uobject(type_attrs, ucontext);
> >> >> +     default:
> >> >> +             WARN_ON(true);
> >> >> +             return ERR_PTR(-EOPNOTSUPP);
> >> >> +     }
> >> >> +}
> >> >> +
> >> >> +int uverbs_finalize_object(struct ib_uobject *uobj,
> >> >> +                        enum uverbs_idr_access access,
> >> >> +                        bool commit)
> >> >> +{
> >> >> +     int ret = 0;
> >> >> +
> >> >> +     switch (access) {
> >> >> +     case UVERBS_ACCESS_READ:
> >> >> +             rdma_lookup_put_uobject(uobj, false);
> >> >> +             break;
> >> >> +     case UVERBS_ACCESS_WRITE:
> >> >> +             rdma_lookup_put_uobject(uobj, true);
> >> >> +             break;
> >> >> +     case UVERBS_ACCESS_DESTROY:
> >> >> +             if (commit)
> >> >> +                     ret = rdma_remove_commit_uobject(uobj);
> >> >> +             else
> >> >> +                     rdma_lookup_put_uobject(uobj, true);
> >> >> +             break;
> >> >> +     case UVERBS_ACCESS_NEW:
> >> >> +             if (commit)
> >> >> +                     ret = rdma_alloc_commit_uobject(uobj);
> >> >> +             else
> >> >> +                     rdma_alloc_abort_uobject(uobj);
> >> >> +             break;
> >> >> +     default:
> >> >> +             WARN_ON(true);
> >> >> +     }
> >> >> +
> >> >> +     return ret;
> >> >> +}
> >> >> diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
> >> >> index 1b82e7f..5a1da24 100644
> >> >> --- a/drivers/infiniband/core/rdma_core.h
> >> >> +++ b/drivers/infiniband/core/rdma_core.h
> >> >> @@ -39,6 +39,7 @@
> >> >>
> >> >>  #include <linux/idr.h>
> >> >>  #include <rdma/uverbs_types.h>
> >> >> +#include <rdma/uverbs_ioctl.h>
> >> >>  #include <rdma/ib_verbs.h>
> >> >>  #include <linux/mutex.h>
> >> >>
> >> >> @@ -75,4 +76,19 @@
> >> >>   */
> >> >>  void uverbs_close_fd(struct file *f);
> >> >>
> >> >> +/*
> >> >> + * Get an ib_uobject that corresponds to the given id from ucontext, assuming
> >> >> + * the object is from the given type. Lock it to the required access.
> >> >> + * This function could create (access == NEW) or destroy (access == DESTROY)
> >> >> + * objects if required. The action will be finalized only when
> >> >> + * uverbs_finalize_object is called.
> >> >> + */
> >> >> +struct ib_uobject *uverbs_get_uobject_from_context(const struct uverbs_obj_type *type_attrs,
> >> >> +                                                struct ib_ucontext *ucontext,
> >> >> +                                                enum uverbs_idr_access access,
> >> >> +                                                int id);
> >> >> +int uverbs_finalize_object(struct ib_uobject *uobj,
> >> >> +                        enum uverbs_idr_access access,
> >> >> +                        bool commit);
> >> >> +
> >> >>  #endif /* RDMA_CORE_H */
> >> >> diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
> >> >> new file mode 100644
> >> >> index 0000000..a18468e
> >> >> --- /dev/null
> >> >> +++ b/include/rdma/uverbs_ioctl.h
> >> >> @@ -0,0 +1,52 @@
> >> >> +/*
> >> >> + * Copyright (c) 2016, Mellanox Technologies inc.  All rights reserved.
> >> >> + *
> >> >> + * This software is available to you under a choice of one of two
> >> >> + * licenses.  You may choose to be licensed under the terms of the GNU
> >> >> + * General Public License (GPL) Version 2, available from the file
> >> >> + * COPYING in the main directory of this source tree, or the
> >> >> + * OpenIB.org BSD license below:
> >> >> + *
> >> >> + *     Redistribution and use in source and binary forms, with or
> >> >> + *     without modification, are permitted provided that the following
> >> >> + *     conditions are met:
> >> >> + *
> >> >> + *      - Redistributions of source code must retain the above
> >> >> + *        copyright notice, this list of conditions and the following
> >> >> + *        disclaimer.
> >> >> + *
> >> >> + *      - Redistributions in binary form must reproduce the above
> >> >> + *        copyright notice, this list of conditions and the following
> >> >> + *        disclaimer in the documentation and/or other materials
> >> >> + *        provided with the distribution.
> >> >> + *
> >> >> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> >> >> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> >> >> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> >> >> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> >> >> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> >> >> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> >> >> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> >> >> + * SOFTWARE.
> >> >> + */
> >> >> +
> >> >> +#ifndef _UVERBS_IOCTL_
> >> >> +#define _UVERBS_IOCTL_
> >> >> +
> >> >> +#include <rdma/uverbs_types.h>
> >> >> +
> >> >> +/*
> >> >> + * =======================================
> >> >> + *   Verbs action specifications
> >> >> + * =======================================
> >> >> + */
> >> >> +
> >> >> +enum uverbs_idr_access {
> >> >> +     UVERBS_ACCESS_READ,
> >> >> +     UVERBS_ACCESS_WRITE,
> >> >> +     UVERBS_ACCESS_NEW,
> >> >> +     UVERBS_ACCESS_DESTROY
> >> >> +};
> >> >
> >> > Does it make sense to have MODIFY too?
> >> >
> >>
> >> No, this just set the locking schema for the uobject. When the uobject
> >> is locked for write (i.e. exclusive lock), you're free to modify the
> >> underlying object.
> >
> > So why do you need NEW and DESTROY? It can be locked with WRITE.
> >
>
> The whole concept is based on specifications. When you specify a
> command, you need to specify its arguments as well.
> If these arguments are of object type, you need to specify the
> required state of the uobject.
> When your handle is being executed, uobjects are already in the
> correct state as required by the command specification.
> So, if you implement a command that creates a QP, you need to tell the
> infrastructure that you want to allocate a new uobject - this is
> CREATE.
> If you want to destroy an object, you specify a DESTROY command. If
> your handler finishes successfully, both the uobject and the object
> are automatically destroyed by the infrastructure.

Thanks for the explanations.

>
> Matan
>
> >>
> >> >> +
> >> >> +#endif
> >> >> +
> >> >> --
> >> >> 1.8.3.1
> >> >>
> >> >> --
> >> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> >> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--e9fMjeYs+GPci+mg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkLcDMACgkQ5GN7iDZy
WKd5DxAAmlM3yVqPuq4Fj5PwKLAcCauLTpn2+BjsAGg93OL3ACuQELaqm2HXNSXX
kq342L7o3/sjmfwi7MnEZeuLN/Zbnw/ZXRLk4x7uN2pu9QJKQ1lkLj2Df7SLV7B7
KtFwNGOoTBQT7hOmGwIhlAG3BWn/++cdJcO12EK67ze0l3hNIE9O8IVGXi3mhgcT
mIw4G+j8Z9NX4dS1QoURHOQpOT1yQbtz/swpAQKrtj3EgnQNPQlbP/1b5HixoDaz
rGI5TpxNtKjgsLrSjQ9TkTZ7NoUMd8gD8oRZ3NxoE+fTdj30tpEyC1Io5jJS4Bum
yljhLR9Wvw8MTXq8+oifTUnPTMDusYJRDJC2lp0TaTrx6u9uLF5gwjvt1fmbNA3g
88hLK/gm5LKYjKveLDXs4AUeUtfeJvllqaDqZ0bBzLW/QBYqj2XeE1iYb+c4yThP
W2quL+B4B9epGWakc4+M2c6JbBkRp+LPqsZe7WiyZGud+Y5vPJLQ7BvWIul5dQwd
iHIH8roCl2b5lTPY1ni/TalNLxo4xD/M4aqkWI6eAVcASRzWrWq14f+m35hDrZwZ
uG3ONLgEChYoPz5eblERhWwGyh/jdlRDWmgJqVFN7pA+dASCwaBFd53BsLyrDgFm
gim4WDHHi1q8V15kvpZN9GMFZYlTFrTJEop2g5Lu058cCsf+Tuw=
=YMqI
-----END PGP SIGNATURE-----

--e9fMjeYs+GPci+mg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
