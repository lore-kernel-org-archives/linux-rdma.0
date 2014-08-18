From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH] infiniband: hw: cxgb3: cxio_hal.c:  Cleaning up missing null-terminate after strncpy call
Date: Mon, 18 Aug 2014 09:27:16 -0500
Message-ID: <000001cfbaf0$829ba6f0$87d2f4d0$@opengridcomputing.com>
References: <1408315225-16807-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1408315225-16807-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Rickard Strandqvist' <rickard_strandqvist@spectrumdigital.se>, 'Steve Wise' <swise@chelsio.com>, 'Roland Dreier' <roland@kernel.org>
Cc: 'Sean Hefty' <sean.hefty@intel.com>, 'Hal Rosenstock' <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org]
> On Behalf Of Rickard Strandqvist
> Sent: Sunday, August 17, 2014 5:40 PM
> To: Steve Wise; Roland Dreier
> Cc: Rickard Strandqvist; Sean Hefty; Hal Rosenstock; linux-rdma@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] infiniband: hw: cxgb3: cxio_hal.c: Cleaning up missing null-terminate
after
> strncpy call
> 
> Added a guaranteed null-terminate after call to strncpy.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/infiniband/hw/cxgb3/cxio_hal.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c
> b/drivers/infiniband/hw/cxgb3/cxio_hal.c
> index de1c61b4..5fc04e4 100644
> --- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
> +++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
> @@ -933,6 +933,7 @@ int cxio_rdev_open(struct cxio_rdev *rdev_p)
>  		netdev_p = rdev_p->t3cdev_p->lldev;
>  		strncpy(rdev_p->dev_name, rdev_p->t3cdev_p->name,
>  			T3_MAX_DEV_NAME_LEN);
> +		rdev_p->dev_name[T3_MAX_DEV_NAME_LEN - 1] = '\0';
>  	} else {
>  		PDBG("%s t3cdev_p or dev_name must be set\n", __func__);
>  		return -EINVAL;

cxio_rdev_open() is called only by open_rnic_dev() which allocates the device structure by
calling ib_alloc_device() which uses kzalloc().  So this change really isn't needed, is
it?

Steve.
