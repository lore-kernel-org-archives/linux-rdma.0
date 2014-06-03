From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 4/5] ib/mad: add new ioctl to user space to support
 new registration options
Date: Tue, 3 Jun 2014 18:28:27 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823739930E028@ORSMSX109.amr.corp.intel.com>
References: <1401158393-1477-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401158393-1477-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Registrations options are specified through flags.  Definitions of flags
> will
> be in subsequent patches.
> 
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

with two minor comments below

> 
> Changes since V1:
> 	1) convert oui to 32 bits and host byte order
> 	2) pad struct to 64bits for easier 32/64bit compatibility
> 	3) convert pr_notice to dev_notice

This needs to come after the "---" in order to remove it from the patch description.

> ---
>  Documentation/infiniband/user_mad.txt   |  13 ++--
>  drivers/infiniband/core/agent.c         |   4 +-
>  drivers/infiniband/core/cm.c            |   5 +-
>  drivers/infiniband/core/mad.c           |   4 +-
>  drivers/infiniband/core/sa_query.c      |   2 +-
>  drivers/infiniband/core/user_mad.c      | 120
> +++++++++++++++++++++++++++++++-
>  drivers/infiniband/hw/mlx4/mad.c        |   2 +-
>  drivers/infiniband/hw/mthca/mthca_mad.c |   2 +-
>  drivers/infiniband/hw/qib/qib_mad.c     |   2 +-
>  drivers/infiniband/ulp/srpt/ib_srpt.c   |   2 +-
>  include/rdma/ib_mad.h                   |   7 +-
>  include/uapi/rdma/ib_user_mad.h         |  39 +++++++++++
>  12 files changed, 186 insertions(+), 16 deletions(-)
> 
> diff --git a/Documentation/infiniband/user_mad.txt
> b/Documentation/infiniband/user_mad.txt
> index 8a36695..bf24958 100644
> --- a/Documentation/infiniband/user_mad.txt
> +++ b/Documentation/infiniband/user_mad.txt
> @@ -26,6 +26,11 @@ Creating MAD agents
>    ioctl.  Also, all agents registered through a file descriptor will
>    be unregistered when the descriptor is closed.
> 
> +  2013 -- a new registration ioctl is now provided which allows additional

year typo

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
