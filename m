From: Myungho Jung <mhjungk@gmail.com>
Subject: Re: [PATCH] RDMA/cma: Rollback source IP address if failing to
 acquire device
Date: Wed, 9 Jan 2019 22:03:25 -0800
Message-ID: <20190110060324.GA25523@myunghoj-Precision-5530>
References: <20190104064537.GA352@myunghoj-Precision-5530>
 <VI1PR0501MB2271AA04707AE880E8362933D18B0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0501MB2271AA04707AE880E8362933D18B0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Parav Pandit <parav@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 09, 2019 at 01:28:34PM +0000, Parav Pandit wrote:
> 
> 
> > -----Original Message-----
> > From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> > owner@vger.kernel.org> On Behalf Of Myungho Jung
> > Sent: Friday, January 4, 2019 12:46 AM
> > To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: [PATCH] RDMA/cma: Rollback source IP address if failing to acquire
> > device
> > 
> > If cma_acquire_dev_by_src_ip() returns error in addr_handler(), the device
> > state changes back to RDMA_CM_ADDR_BOUND but the resolved source IP
> > address is still left. After that, if rdma_destroy_id() is called after
> > rdma_listen(), the device is freed without removed from listen_any_list in
> > cma_cancel_operation(). Revert to the previous IP address if acquiring device
> > fails.
> > 
> > Reported-by: syzbot+f3ce716af730c8f96637@syzkaller.appspotmail.com
> > Signed-off-by: Myungho Jung <mhjungk@gmail.com>
> > ---
> >  drivers/infiniband/core/cma.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> > index 63a7cc00bae0..d27c3b154e71 100644
> > --- a/drivers/infiniband/core/cma.c
> > +++ b/drivers/infiniband/core/cma.c
> > @@ -2963,13 +2963,17 @@ static void addr_handler(int status, struct
> > sockaddr *src_addr,  {
> >  	struct rdma_id_private *id_priv = context;
> >  	struct rdma_cm_event event = {};
> > +	struct sockaddr *addr;
> > +	struct sockaddr_storage old_addr;
> > 
> >  	mutex_lock(&id_priv->handler_mutex);
> >  	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_QUERY,
> >  			   RDMA_CM_ADDR_RESOLVED))
> >  		goto out;
> > 
> > -	memcpy(cma_src_addr(id_priv), src_addr,
> > rdma_addr_size(src_addr));
> > +	addr = cma_src_addr(id_priv);
> > +	memcpy(&old_addr, addr, rdma_addr_size(addr));
> Please add a comment here in the patch, why we need to store the old src address and restore back.
> /*
>   * Store the previous src address, so that if we fail to acquire matching rdma device,
>   * old address can be restored back, which helps to cancel the cma listen operation
>   * correctly.
>   */
> > +	memcpy(addr, src_addr, rdma_addr_size(src_addr));
> >  	if (!status && !id_priv->cma_dev) {
> >  		status = cma_acquire_dev_by_src_ip(id_priv);
> >  		if (status)
> > @@ -2980,6 +2984,8 @@ static void addr_handler(int status, struct sockaddr
> > *src_addr,
> >  	}
> > 
> >  	if (status) {
> > +		memcpy(addr, &old_addr,
> > +		       rdma_addr_size((struct sockaddr *)&old_addr));
> >  		if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_RESOLVED,
> >  				   RDMA_CM_ADDR_BOUND))
> >  			goto out;
> > --
> > 2.17.1
> 
> Reviewed-by: Parav Pandit <parav@mellanox.com>

Hi Parav,

Thanks for review. Let me update and resubmit patch.

Thanks,
Myungho
