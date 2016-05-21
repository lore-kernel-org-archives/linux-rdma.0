From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] IB/security: restrict use of the write() interface
Date: Fri, 20 May 2016 22:32:21 -0700
Message-ID: <20160521053221.GA4771@kroah.com>
References: <616598d79c0b8750d74e50cf22f8b61a9ef55c1d.1463589971.git.dledford@redhat.com>
 <20160518204012.GA4268@whence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160518204012.GA4268@whence.com>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, stable@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Kamal Mostafa <kamal@canonical.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 18, 2016 at 01:40:13PM -0700, Kamal Mostafa wrote:
> On Wed, May 18, 2016 at 12:46:11PM -0400, Doug Ledford wrote:
> > Upstream commit e6bd18f57aad (IB/security: Restrict use of the write()
> > interface) handled the cases for all drivers in the current upstream
> > kernel.  The ipath driver had recently been deprecated and moved to
> > staging, and then removed entirely.  It had the same security flaw as
> > the qib driver.  Fix that up with this separate patch.
> > 
> > Note: The ipath driver only supports hardware that ended production
> > over 10 years ago, so there should be none of this hardware still
> > present in the wild.
> > 
> > Cc: stable@vger.kernel.org # 4.4.x
> > Signed-off-by: Doug Ledford <dledford@redhat.com>
> > ---
> >  drivers/staging/rdma/ipath/ipath_file_ops.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/staging/rdma/ipath/ipath_file_ops.c b/drivers/staging/rdma/ipath/ipath_file_ops.c
> > index 13c3cd11ab92..f237a2e2a086 100644
> > --- a/drivers/staging/rdma/ipath/ipath_file_ops.c
> > +++ b/drivers/staging/rdma/ipath/ipath_file_ops.c
> > @@ -45,6 +45,8 @@
> >  #include <linux/uio.h>
> >  #include <asm/pgtable.h>
> >  
> > +#include <rdma/ib.h>
> > +
> >  #include "ipath_kernel.h"
> >  #include "ipath_common.h"
> >  #include "ipath_user_sdma.h"
> > @@ -2243,6 +2245,9 @@ static ssize_t ipath_write(struct file *fp, const char __user *data,
> >  	ssize_t ret = 0;
> >  	void *dest;
> >  
> > +	if (WARN_ON_ONCE(!ib_safe_file_access(fp)))
> > +		return -EACCESS;
> 
> This needs to be "EACCES" (one fewer 'S').

And so goes the "if it isn't in Linus's tree, and it is asked to be
merged into -stable, it is almost always wrong" proof :(

Doug, why did you send these if you didn't even build them?  Because of
that, I _know_ you didn't test them, how do I know these are safe to
apply?

ugh.

greg k-h
