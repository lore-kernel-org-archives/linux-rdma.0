From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 02/13] drivers/infiniband: Remove unnecessary casts of
 private_data
Date: Thu, 23 Sep 2010 13:38:46 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1009231338300.26813@pobox.suse.cz>
References: <cover.1283650107.git.joe@perches.com>  <a13edeb14cc926b71e21daff892acbe2d76313ab.1283650107.git.joe@perches.com> <1283883869.32259.13.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283883869.32259.13.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 7 Sep 2010, Ralph Campbell wrote:

> Acked-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

Applied, thanks.

> > Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/qib/qib_file_ops.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
> > index 6b11645..cef5d67 100644
> > --- a/drivers/infiniband/hw/qib/qib_file_ops.c
> > +++ b/drivers/infiniband/hw/qib/qib_file_ops.c
> > @@ -1722,7 +1722,7 @@ static int qib_close(struct inode *in, struct file *fp)
> >  
> >  	mutex_lock(&qib_mutex);
> >  
> > -	fd = (struct qib_filedata *) fp->private_data;
> > +	fd = fp->private_data;
> >  	fp->private_data = NULL;
> >  	rcd = fd->rcd;
> >  	if (!rcd) {
> > @@ -1808,7 +1808,7 @@ static int qib_ctxt_info(struct file *fp, struct qib_ctxt_info __user *uinfo)
> >  	struct qib_ctxtdata *rcd = ctxt_fp(fp);
> >  	struct qib_filedata *fd;
> >  
> > -	fd = (struct qib_filedata *) fp->private_data;
> > +	fd = fp->private_data;
> >  
> >  	info.num_active = qib_count_active_units();
> >  	info.unit = rcd->dd->unit;

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
