From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/8] infiniband: cxgb4: no need to check return value of
 debugfs_create functions
Date: Tue, 22 Jan 2019 17:30:57 +0100
Message-ID: <20190122163057.GA23510@kroah.com>
References: <20190122151800.15092-1-gregkh@linuxfoundation.org>
 <20190122151800.15092-2-gregkh@linuxfoundation.org>
 <dbf27d3d-ff19-4054-9495-80bcb5a10485@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dbf27d3d-ff19-4054-9495-80bcb5a10485@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 22, 2019 at 10:22:59AM -0600, Steve Wise wrote:
> Hey Greg,
> 
> On 1/22/2019 9:17 AM, Greg Kroah-Hartman wrote:
> > When calling debugfs functions, there is no need to ever check the
> > return value.  The function can work or not, but the code logic should
> > never do something different based on this.
> > 
> > Cc: Steve Wise <swise@chelsio.com>
> > Cc: Doug Ledford <dledford@redhat.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: linux-rdma@vger.kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/infiniband/hw/cxgb4/device.c | 8 +-------
> >  1 file changed, 1 insertion(+), 7 deletions(-)
> > 
> > diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
> > index c13c0ba30f63..9c10fff6dcfb 100644
> > --- a/drivers/infiniband/hw/cxgb4/device.c
> > +++ b/drivers/infiniband/hw/cxgb4/device.c
> > @@ -720,11 +720,8 @@ static const struct file_operations ep_debugfs_fops = {
> >  	.read    = debugfs_read,
> >  };
> >  
> > -static int setup_debugfs(struct c4iw_dev *devp)
> > +static void setup_debugfs(struct c4iw_dev *devp)
> >  {
> > -	if (!devp->debugfs_root)
> > -		return -1;
> > -
> >  	debugfs_create_file_size("qps", S_IWUSR, devp->debugfs_root,
> >  				 (void *)devp, &qp_debugfs_fops, 4096);
> >  
> > @@ -740,7 +737,6 @@ static int setup_debugfs(struct c4iw_dev *devp)
> >  	if (c4iw_wr_log)
> >  		debugfs_create_file_size("wr_log", S_IWUSR, devp->debugfs_root,
> >  					 (void *)devp, &wr_log_debugfs_fops, 4096);
> > -	return 0;
> >  }
> >  
> >  void c4iw_release_dev_ucontext(struct c4iw_rdev *rdev,
> > @@ -1553,8 +1549,6 @@ static int __init c4iw_init_module(void)
> >  		return err;
> >  
> >  	c4iw_debugfs_root = debugfs_create_dir(DRV_NAME, NULL);
> > -	if (!c4iw_debugfs_root)
> > -		pr_warn("could not create debugfs entry, continuing\n");
> >  
> >  	reg_workq = create_singlethread_workqueue("Register_iWARP_device");
> >  	if (!reg_workq) {
> > 
> 
> So it is not a problem to call debugfs_create_file_size() when
> devp->debugfs_root is NULL?

Nope!

> 
> Acked-by: Steve Wise <swise@opengridcomputing.com>

Thanks,

greg k-h
