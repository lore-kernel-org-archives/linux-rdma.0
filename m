From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 1/4] IB/core: introduce ->release() callback
Date: Tue, 18 Sep 2018 08:44:41 -0600
Message-ID: <20180918144441.GH11367@ziepe.ca>
References: <1537275826-27247-1-git-send-email-jan.dakinevich@virtuozzo.com>
 <1537275826-27247-2-git-send-email-jan.dakinevich@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1537275826-27247-2-git-send-email-jan.dakinevich@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Cc: Doug Ledford <dledford@redhat.com>, Yishai Hadas <yishaih@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Mark Bloch <markb@mellanox.com>, Daniel Jurgens <danielj@mellanox.com>, Kees Cook <keescook@chromium.org>, Kamal Heib <kamalheib1@gmail.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Denis Lunev <den@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 18, 2018 at 04:03:43PM +0300, Jan Dakinevich wrote:
> IB infrastructure shares common device instance constructor with
> reference counting, and it uses kzalloc() to allocate memory
> for device specific instance with incapsulated ib_device field as one
> contigous memory block.
> 
> The issue is that the device specific instances tend to be too large
> and require high page order memory allocation. Unfortunately, kzalloc()
> in ib_alloc_device() can not be replaced with kvzalloc() since it would
> require a lot of review in all IB driver to prove correctness of the
> replacement.
> 
> The driver can allocate some heavy partes of their instance for itself
> and keep pointers for them in own instance. For this it is important
> that the alocated parts have the same life time as ib_device, thus
> their deallocation should be based on the same reference counting.
> 
> Let suppose:
> 
> struct foo_ib_device {
> 	struct ib_device device;
> 
> 	void *part;
> 
> 	...
> };
> 
> To properly free memory from .foo_ib_part the driver should provide
> function for ->release() callback:
> 
> void foo_ib_release(struct ib_device *device)
> {
> 	struct foo_ib_device *foo = container_of(device,  struct foo_ib_device,
> 						 device);
> 
> 	kvfree(foo->part);
> }
> 
> ...and initialiaze this callback immediately after foo_ib_device
> instance allocation.
> 
> 	struct foo_ib_device *foo;
> 
> 	foo = ib_alloc_device(sizeof(struct foo_ib_device));
> 
> 	foo->device.release = foo_ib_release;
> 
> 	/* allocate parts */
> 	foo->part = kvmalloc(65536, GFP_KERNEL);
> 
> Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
>  drivers/infiniband/core/device.c | 2 ++
>  include/rdma/ib_verbs.h          | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index db3b627..a8c8b0d 100644
> +++ b/drivers/infiniband/core/device.c
> @@ -215,6 +215,8 @@ static void ib_device_release(struct device *device)
>  		ib_cache_release_one(dev);
>  		kfree(dev->port_immutable);
>  	}
> +	if (dev->release)
> +		dev->release(dev);
>  	kfree(dev);
>  }

Nope, the driver module could be unloaded at this point.

The driver should free memory after its call to ib_unregister_device
returns.

Jason
