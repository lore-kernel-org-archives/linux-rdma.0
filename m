From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 01/11] libbnxtre: introduce bnxtre user space
 RDMA provider
Date: Sun, 29 Jan 2017 16:05:46 -0700
Message-ID: <20170129230546.GB24051@obsidianresearch.com>
References: <1485641622-30015-1-git-send-email-devesh.sharma@broadcom.com>
 <1485641622-30015-2-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485641622-30015-2-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 28, 2017 at 05:13:32PM -0500, Devesh Sharma wrote:
>  add_subdirectory(providers/ocrdma)
>  add_subdirectory(providers/qedr)
>  add_subdirectory(providers/vmw_pvrdma)
> +add_subdirectory(providers/bnxtre)
>  endif()

Keep list sorted

>
>  add_subdirectory(providers/hfi1verbs)
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2ae504c..f52da1c 100644
> +++ b/MAINTAINERS
> @@ -166,3 +166,8 @@ M:	Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>  L:	pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
>  S:	Supported
>  F:	providers/vmw_pvrdma/
> +
> +BNXTRE USERSPACE PROVIDER (for bnxtre.ko)
> +M:	Devesh Sharma  <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> +S:	Supported
> +F:	providers/bnxtre

Keep list sorted

> diff --git a/providers/bnxtre/bnxtre.driver b/providers/bnxtre/bnxtre.driver
> new file mode 100644
> index 0000000..5ce796f
> +++ b/providers/bnxtre/bnxtre.driver
> @@ -0,0 +1 @@
> +driver	bnxtre

No, delete this file

> +#if HAVE_CONFIG_H
> +#include <config.h>
> +#endif                          /* HAVE_CONFIG_H */

HAVE_CONFIG_H is not defined in our builds, do not use config.h if we
don't need it. Ditto everywhere

> +struct {
> +	unsigned int vendor;
> +	unsigned int device;
> +} cna_table[] = {

static const?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
