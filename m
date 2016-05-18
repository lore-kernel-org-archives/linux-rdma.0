From: Kamal Mostafa <kamal@canonical.com>
Subject: Re: [PATCH] IB/security: restrict use of the write() interface
Date: Wed, 18 May 2016 13:42:03 -0700
Message-ID: <20160518204203.GB4268@whence.com>
References: <1b7a157f0f701f65ee8de1c208df256e860d7b93.1463589719.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1b7a157f0f701f65ee8de1c208df256e860d7b93.1463589719.git.dledford@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: stable@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 18, 2016 at 12:41:59PM -0400, Doug Ledford wrote:
> Upstream commit e6bd18f57aad (IB/security: Restrict use of the write()
> interface) handled the cases for all drivers in the current upstream
> kernel.  The ipath driver had recently been deprecated and moved to
> staging, and then removed entirely.  It had the same security flaw as
> the qib driver.  Fix that up with this separate patch.
> 
> Note: The ipath driver only supports hardware that ended production
> over 10 years ago, so there should be none of this hardware still
> present in the wild.
> 
> Cc: stable@vger.kernel.org # <= 4.2.x
> Signed-off-by: Doug Ledford <dledford@redhat.com>
> ---
>  drivers/infiniband/hw/ipath/ipath_file_ops.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
> index 450d15965005..1f94b560d749 100644
> --- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
> +++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
> @@ -45,6 +45,8 @@
>  #include <linux/uio.h>
>  #include <asm/pgtable.h>
>  
> +#include <rdma/ib.h>
> +
>  #include "ipath_kernel.h"
>  #include "ipath_common.h"
>  #include "ipath_user_sdma.h"
> @@ -2244,6 +2246,9 @@ static ssize_t ipath_write(struct file *fp, const char __user *data,
>  	ssize_t ret = 0;
>  	void *dest;
>  
> +	if (WARN_ON_ONCE(!ib_safe_file_access(fp)))
> +		return -EACCESS;

(Same as for the 4.4.x patch)...

This needs to be "EACCES" (one fewer 'S').

Thanks, Doug.  Queued up (with one fewer 'S') for 4.2 and 3.19 -stable.

 -Kamal

> +
>  	if (count < sizeof(cmd.type)) {
>  		ret = -EINVAL;
>  		goto bail;
> -- 
> 2.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
