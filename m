From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH rdma-next 1/5] RDMA/core: Provide getter and setter to
 access IB device name
Date: Thu, 20 Sep 2018 09:32:44 -0500
Message-ID: <1e8ef729-8b77-7a35-4b52-11254c12343c@opengridcomputing.com>
References: <20180920112202.9181-1-leon@kernel.org>
 <20180920112202.9181-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180920112202.9181-2-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, linux-s390@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>, Steve Wise <swise@chelsio.com>, Lijun Ou <oulijun@huawei.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Ariel Elior <Ariel.Elior@cavium.com>, Christian Benvenuti <benve@cisco.com>, Adit Ranadive <aditr@vmware.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org



On 9/20/2018 6:21 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Prepare IB device name field to rename operation by ensuring that all
> accesses to it are protected with lock and users don't see part of name.
> 
> The protection is done with global device_lock because it is used in
> allocation and deallocation phases. At this stage, this lock is not
> busy and easily can be moved to be per-device, once it will be needed.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/core/device.c | 24 +++++++++++++++++++++++-
>  include/rdma/ib_verbs.h          |  8 +++++++-
>  2 files changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 5a680a88aa87..3270cde6d806 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -170,6 +170,14 @@ static struct ib_device *__ib_device_get_by_name(const char *name)
>  	return NULL;
>  }
> 
> +void ib_device_get_name(struct ib_device *ibdev, char *name)
> +{
> +	down_read(&lists_rwsem);
> +	strlcpy(name, ibdev->name, IB_DEVICE_NAME_MAX);
> +	up_read(&lists_rwsem);
> +}
> +EXPORT_SYMBOL(ib_device_get_name);
> +
>  static int alloc_name(char *name)
>  {
>  	unsigned long *inuse;
> @@ -202,6 +210,21 @@ static int alloc_name(char *name)
>  	return 0;
>  }
> 
> +int ib_device_alloc_name(struct ib_device *ibdev, const char *pattern)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&device_mutex);
> +	strlcpy(ibdev->name, pattern, IB_DEVICE_NAME_MAX);
> +	if (strchr(ibdev->name, '%'))
> +		ret = alloc_name(ibdev->name);
> +
> +	mutex_unlock(&device_mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ib_device_alloc_name);
> +
>  static void ib_device_release(struct device *device)
>  {
>  	struct ib_device *dev = container_of(device, struct ib_device, dev);
> @@ -499,7 +522,6 @@ int ib_register_device(struct ib_device *device,
>  		ret = alloc_name(device->name);
>  		if (ret)
>  			goto out;
> -	}

I don't think this is correct...


> 
>  	if (ib_device_check_mandatory(device)) {
>  		ret = -EINVAL;
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index e764ed1f6025..66660e7b9854 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -2260,6 +2260,11 @@ struct ib_device {
>  	/* Do not access @dma_device directly from ULP nor from HW drivers. */
>  	struct device                *dma_device;
> 
> +	/*
> +	 * Do not access @name directly,
> +	 * use ib_device_get_name()/ib_device_alloc_name()
> +	 * and don't assume that it can't change after access.
> +	 */
>  	char                          name[IB_DEVICE_NAME_MAX];
> 
>  	struct list_head              event_handler_list;
> @@ -2638,7 +2643,8 @@ struct ib_device *ib_alloc_device(size_t size);
>  void ib_dealloc_device(struct ib_device *device);
> 
>  void ib_get_device_fw_str(struct ib_device *device, char *str);
> -
> +int ib_device_alloc_name(struct ib_device *ibdev, const char *pattern);
> +void ib_device_get_name(struct ib_device *ibdev, char *name);
>  int ib_register_device(struct ib_device *device,
>  		       int (*port_callback)(struct ib_device *,
>  					    u8, struct kobject *));
> --
> 2.14.4
> 
