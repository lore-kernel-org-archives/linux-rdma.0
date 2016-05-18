From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/security: Restrict use of the write() interface
Date: Wed, 18 May 2016 10:20:12 -0700
Message-ID: <20160518172012.GA6879@kroah.com>
References: <02bf2ebafbc5d757c0d250d8e5fba3ebdc7393fd.1463590718.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <02bf2ebafbc5d757c0d250d8e5fba3ebdc7393fd.1463590718.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 18, 2016 at 12:58:38PM -0400, Doug Ledford wrote:
> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> 
> The drivers/infiniband stack uses write() as a replacement for
> bi-directional ioctl().  This is not safe. There are ways to
> trigger write calls that result in the return structure that
> is normally written to user space being shunted off to user
> specified kernel memory instead.
> 
> For the immediate repair, detect and deny suspicious accesses to
> the write API.
> 
> For long term, update the user space libraries and the kernel API
> to something that doesn't present the same security vulnerabilities
> (likely a structured ioctl() interface).
> 
> The impacted uAPI interfaces are generally only available if
> hardware from drivers/infiniband is installed in the system.
> 
> Reported-by: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
> Signed-off-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> [ Expanded check to all known write() entry points ]
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 3.14.x
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> [ Expanded to include removed ipath driver, and dropped non-existent
>   hfi1 driver ]
> ---
>  drivers/infiniband/core/ucm.c                |  4 ++++
>  drivers/infiniband/core/ucma.c               |  3 +++
>  drivers/infiniband/core/uverbs_main.c        |  5 +++++
>  drivers/infiniband/hw/ipath/ipath_file_ops.c |  5 +++++
>  drivers/infiniband/hw/qib/qib_file_ops.c     |  5 +++++
>  include/rdma/ib.h                            | 16 ++++++++++++++++
>  6 files changed, 38 insertions(+)

I don't understand, is this only for 3.14.x?  If so, what is the git
commit id in Linus's tree for this?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
