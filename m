From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 09/36] drivers/infiniband: Remove unnecessary casts of
 private_data
Date: Tue, 20 Jul 2010 17:24:19 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1007201724010.4741@pobox.suse.cz>
References: <cover.1278967120.git.joe@perches.com>  <0074ff36bc27b141d3639e2d516cc6cd48364df6.1278967120.git.joe@perches.com> <1279046497.2296.170.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1279046497.2296.170.camel@chromite.mv.qlogic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ralph Campbell <ralph.campbell@qlogic.com>
Cc: Joe Perches <joe@perches.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Infinipath <Infinipath@qlogic.com>, Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 13 Jul 2010, Ralph Campbell wrote:

> Acked-by: Ralph Campbell <ralph.campbell@qlogic.com>
> 
> On Mon, 2010-07-12 at 13:50 -0700, Joe Perches wrote:
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  drivers/infiniband/hw/ipath/ipath_file_ops.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
> > index 9c5c66d..65eb892 100644
> > --- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
> > +++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
> > @@ -2055,7 +2055,7 @@ static int ipath_close(struct inode *in, struct file *fp)
> >  
> >  	mutex_lock(&ipath_mutex);
> >  
> > -	fd = (struct ipath_filedata *) fp->private_data;
> > +	fd = fp->private_data;
> >  	fp->private_data = NULL;
> >  	pd = fd->pd;
> >  	if (!pd) {

As the patch is not present in linux-next as of today, I have applied it. 
Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
