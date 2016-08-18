From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Refactor RDMA IOCTL declarations
Date: Thu, 18 Aug 2016 14:08:20 +0300
Message-ID: <20160818110819.GB8590@yuval-lap.uk.oracle.com>
References: <1471355123-6227-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1471355123-6227-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 16, 2016 at 04:45:17PM +0300, Leon Romanovsky wrote:
> Hi Doug,
> 
> This patch set refactors RDMA IOCTL declarations, unifies their
> location, moves all current IOCTL exporters to one place and renames
> them to fix the differences in coding style.
> 
> IOCTLs commands need to export the size of their data for their transfer
> which is usually declared as a struct defined in relevant submodule.
> These structures should be visible at the linkage stage.

Just for my understanding - this is not an issue only with RDMA-IOCTLs,
right?
(Wondering how other modules approaches this).

> 
> There are number of possible solutions to overcome this limitations.
> 
> One of the options is to declare anonymous variable which will be visible
> during the linkage. As a downside, such option won't allow direct use of
> this header by other parts of code without their specific includes of
> other logically unrelated submodules.
> 
> Another possible option will be to move declarations of that structures
> to that common header file. Such move will cause to bloat this file
> with different submodules declarations.
> 
> Our decision was to choose direct include of other exported files with
> declarations of such structures to simplify future usage of this file.
> There is no change for legacy applications and libraries.
> 
> Available in the "topic/ioctl-header" topic branch of this git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
> 
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/ioctl-header
> 
> Thanks
> 
> Leon Romanovsky (6):
>   RDMA/core: Commonize RDMA IOCTL declarations location
>   RDMA/core: Move legacy MAD IOCTL declarations to common file
>   RDMA/hfi1: Avoid redeclaration error
>   RDMA/core: Move HFI1 IOCTL declarations to common file
>   RDMA/core: Rename RDMA magic number
>   RDMA/core: Unify style of IOCTL commands
> 
>  include/uapi/rdma/Kbuild            |   1 +
>  include/uapi/rdma/hfi/Kbuild        |   1 +
>  include/uapi/rdma/hfi/hfi1_ioctl.h  | 173 +++++++++++++++++++++++++++++++++++
>  include/uapi/rdma/hfi/hfi1_user.h   | 175 +-----------------------------------
>  include/uapi/rdma/ib_user_mad.h     |  14 +--
>  include/uapi/rdma/rdma_user_ioctl.h | 127 ++++++++++++++++++++++++++
>  6 files changed, 304 insertions(+), 187 deletions(-)
>  create mode 100644 include/uapi/rdma/hfi/hfi1_ioctl.h
>  create mode 100644 include/uapi/rdma/rdma_user_ioctl.h
> 
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
