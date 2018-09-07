From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 3/3] IB/ipoib: Log sysfs 'dev_id' accesses from
 userspace
Date: Fri, 7 Sep 2018 09:43:59 -0600
Message-ID: <20180907154359.GA14627@ziepe.ca>
References: <20180906145112.29245-1-ar@cs.msu.ru>
 <20180906145112.29245-4-ar@cs.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180906145112.29245-4-ar@cs.msu.ru>
Sender: netdev-owner@vger.kernel.org
To: Arseny Maslennikov <ar@cs.msu.ru>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 06, 2018 at 05:51:12PM +0300, Arseny Maslennikov wrote:
> Some tools may currently be using only the deprecated attribute;
> let's print an elaborate and clear deprecation notice to kmsg.
> 
> To do that, we have to replace the whole sysfs file, since we inherit
> the original one from netdev.
> 
> Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 31 +++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 30f840f874b3..74732726ec6f 100644
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -2386,6 +2386,35 @@ int ipoib_add_pkey_attr(struct net_device *dev)
>  	return device_create_file(&dev->dev, &dev_attr_pkey);
>  }
>  
> +/*
> + * We erroneously exposed the iface's port number in the dev_id
> + * sysfs field long after dev_port was introduced for that purpose[1],
> + * and we need to stop everyone from relying on that.
> + * Let's overload the shower routine for the dev_id file here
> + * to gently bring the issue up.
> + *
> + * [1] https://www.spinics.net/lists/netdev/msg272123.html
> + */
> +static ssize_t dev_id_show(struct device *dev,
> +			   struct device_attribute *attr, char *buf)
> +{
> +	struct net_device *ndev = to_net_dev(dev);
> +
> +	if (ndev->dev_id == ndev->dev_port)
> +		netdev_info_once(ndev,
> +			"\"%s\" wants to know my dev_id. Should it look at dev_port instead? See Documentation/ABI/testing/sysfs-class-net for more info.\n",
> +			current->comm);
> +
> +	return sprintf(buf, "%#x\n", ndev->dev_id);
> +}
> +static DEVICE_ATTR_RO(dev_id);
> +
> +int ipoib_intercept_dev_id_attr(struct net_device *dev)
> +{
> +	device_remove_file(&dev->dev, &dev_attr_dev_id);
> +	return device_create_file(&dev->dev, &dev_attr_dev_id);
> +}

Isn't this racey with userspace? Ie what happens if udev is querying
the dev_id right here?

Do we know there is no userspace doing this?

>  static struct net_device *ipoib_add_port(const char *format,
>  					 struct ib_device *hca, u8 port)
>  {
> @@ -2427,6 +2456,8 @@ static struct net_device *ipoib_add_port(const char *format,
>  	 */
>  	ndev->priv_destructor = ipoib_intf_free;
>  
> +	if (ipoib_intercept_dev_id_attr(ndev))
> +		goto sysfs_failed;

No device_remove_file needed?

Jason
