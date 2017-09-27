From: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Enable pkey and device name decoupling
Date: Wed, 27 Sep 2017 10:20:20 -0700
Message-ID: <78f7983f-dc6b-a42a-0b29-adb69777fa75@oracle.com>
References: <20170927093248.3819-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170927093248.3819-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kernel-6AxghH7DbtA@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Please do retain original author name from UEK4 and that should be me! 
:-)  [ can be fixed by editing with "git commit --amend 
--author="<string>" ]

-Mukesh Kacker


On 09/27/2017 02:32 AM, Yuval Shaia wrote:
> The sysfs "create_child" interface creates pkey based child interface but
> derives the name from parent device name and pkey value.
> This makes administration difficult where pkey values can change but
> policies encoded with device names do not.
> 
> We add ability to create a child interface with a user specified name and a
> specified pkey with a new sysfs "create_named_child" interface (and also
> add a corresponding "delete_named_child" interface).
> 
> We also add a new module api interface to query pkey from a netdevice so
> any kernel users of pkey based child interfaces can query it - since with
> device name decoupled from pkey, it can no longer be deduced from parsing
> the device name by other kernel users.
> 
> Signed-off-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Chien-Hua Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>   Documentation/infiniband/ipoib.txt        |  12 ++
>   drivers/infiniband/ulp/ipoib/ipoib.h      |   3 +
>   drivers/infiniband/ulp/ipoib/ipoib_main.c | 187 ++++++++++++++++++++++++++++++
>   drivers/infiniband/ulp/ipoib/ipoib_vlan.c |  76 +++++++++++-
>   4 files changed, 272 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/infiniband/ipoib.txt b/Documentation/infiniband/ipoib.txt
> index 47c1dd9818f2..1db53c9b2906 100644
> --- a/Documentation/infiniband/ipoib.txt
> +++ b/Documentation/infiniband/ipoib.txt
> @@ -21,6 +21,18 @@ Partitions and P_Keys
>   
>       echo 0x8001 > /sys/class/net/ib0/delete_child
>   
> +  Interfaces with a user chosen name can be created in a similar
> +  manner with a different name and P_Key, by writing them into the
> +  main interface's /sys/class/net/<intf name>/create_named_child
> +  For example:
> +     echo "epart2 0x8002" > /sys/class/net/ib1/create_named_child
> +
> +   This will create an interfaces named epart2 with P_Key 0x8002 and
> +   parent ib1. To remove a named subinterface, use the
> +   "delete_named_child" file:
> +
> +     echo epart2 > /sys/class/net/ib1/delete_named_child
> +
>     The P_Key for any interface is given by the "pkey" file, and the
>     main interface for a subinterface is in "parent."
>   
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
> index 4a5c7a07a631..9d0010f9b324 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -589,6 +589,9 @@ void ipoib_event(struct ib_event_handler *handler,
>   
>   int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey);
>   int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey);
> +int ipoib_named_vlan_add(struct net_device *pdev, unsigned short pkey,
> +			 char *child_name_buf);
> +int ipoib_named_vlan_delete(struct net_device *pdev, char *child_name_buf);
>   
>   int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv, struct ipoib_dev_priv *priv,
>   		     u16 pkey, int child_type);
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index bac95b509a9b..2bdd4055d69f 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -34,6 +34,7 @@
>   
>   #include "ipoib.h"
>   
> +#include <linux/ctype.h>
>   #include <linux/module.h>
>   
>   #include <linux/init.h>
> @@ -136,6 +137,13 @@ static int ipoib_netdev_event(struct notifier_block *this,
>   }
>   #endif
>   
> +/*
> + * PKEY_HEXSTRING_MAXWIDTH - number of hex
> + *   digits needed to represent max width of
> + *   pkey value.
> + */
> +#define PKEY_HEXSTRING_MAXWIDTH 4
> +
>   int ipoib_open(struct net_device *dev)
>   {
>   	struct ipoib_dev_priv *priv = ipoib_priv(dev);
> @@ -2111,6 +2119,121 @@ static int ipoib_set_mac(struct net_device *dev, void *addr)
>   	return 0;
>   }
>   
> +/*
> + * Check if a buffer has name of the format
> + *
> + * <network-device-name>.<4hexcharacters>
> + * e.g. ib1.8004 etc.
> + *
> + * Such names are generated by create_child() by
> + * concatenating parent device with 16-bit pkey
> + * in hex, and disallowed from usage with
> + * create_named_child() interface.
> + *
> + */
> +static bool ipoib_disallowed_named_child_namespace(const char *buf)
> +{
> +	char localbuf[IFNAMSIZ];
> +	char *dotp = NULL;
> +	char *buf_before_dot = NULL;
> +	char *buf_after_dot = NULL;
> +	unsigned int ii;
> +
> +	memcpy(localbuf, buf, IFNAMSIZ);
> +	localbuf[IFNAMSIZ-1] = '\0'; /* paranoia! */
> +
> +	dotp = strnchr(localbuf, IFNAMSIZ, '.');
> +	/* no dot or dot at end! */
> +	if (dotp == NULL || dotp == localbuf+IFNAMSIZ-2)
> +		return false;
> +
> +	*dotp = '\0';		/* split buffer at "dot"  */
> +	buf_before_dot = localbuf;
> +	buf_after_dot = dotp + 1;
> +
> +	/*
> +	 * Check if buf_after_dot is hexstring of width
> +	 * that could be a pkey!
> +	 */
> +	if (strlen(buf_after_dot) != PKEY_HEXSTRING_MAXWIDTH)
> +		return false;
> +
> +	for (ii = 0; ii < PKEY_HEXSTRING_MAXWIDTH; ii++) {
> +		if (!isxdigit(buf_after_dot[ii]))
> +			return false;
> +	}
> +
> +	/*
> +	 * (1) buf_after_dot check above makes it valid hexdigit .XXXX format
> +	 *
> +	 * Now verify if buf_before_dot is a valid net device name -
> +	 * (if it is not, then we are not in disallowed namespace)
> +	 */
> +	if (__dev_get_by_name(&init_net, buf_before_dot) == NULL)
> +		return false;
> +
> +	/*
> +	 * (2) buf_before_dot is valid net device name
> +	 *    - reserved namespace is being used!
> +	 *
> +	 * Note: No check on netdev->type to be ARPHRD_INFINIBAND etc
> +	 *       We implicitly treat even misleading names such as eth1.XXXX
> +	 *       (ethernet device prefix) for child interface name of an
> +	 *       infiniband device as intrusion of reserved namespace!
> +	 */
> +	return true;
> +}
> +
> +static int parse_named_child(struct device *dev, const char *buf,
> +			     char *child_name_buf, int *pkeyp)
> +{
> +	int ret;
> +	struct ipoib_dev_priv *priv = ipoib_priv(to_net_dev(dev));
> +
> +	if (pkeyp)
> +		*pkeyp = -1;
> +
> +	/*
> +	 * First parameter is child interface name, after that
> +	 * 'pkey' is required if we were passed a pkey buffer
> +	 * (Note: From create_named_child, we are passed a pkey
> +	 * buffer to parse input, from delete_named_child we are
> +	 * not!)
> +	 * Note: IFNAMSIZ is 16, allowing for tail null
> +	 * we only scan 15 characters for name.
> +	 */
> +	if (pkeyp) {
> +		ret = sscanf(buf, "%15s %i", child_name_buf, pkeyp);
> +		if (ret != 2)
> +			return -EINVAL;
> +	} else {
> +		ret = sscanf(buf, "%15s", child_name_buf);
> +		if (ret != 1)
> +			return -EINVAL;
> +	}
> +
> +	if (strlen(child_name_buf) <= 0 || !dev_valid_name(child_name_buf))
> +		return -EINVAL;
> +
> +	if (pkeyp && (*pkeyp <= 0 || *pkeyp > 0xffff || *pkeyp == 0x8000))
> +		return -EINVAL;
> +
> +	if (ipoib_disallowed_named_child_namespace(child_name_buf)) {
> +		pr_warn("child name %s not allowed  to be used with create_named_child as it uses <network-device-name>.XXXX format reserved for create_child/delete_child interfaces!\n",
> +			child_name_buf);
> +		return -EINVAL;
> +	}
> +
> +	if (pkeyp)
> +		ipoib_dbg(priv, "%s inp %s out child_name_buf %s, pkey %04x\n",
> +			  __func__, buf, child_name_buf, *pkeyp);
> +	else
> +		ipoib_dbg(priv, "%s inp %s out child_name_buf %s\n", __func__,
> +			  buf, child_name_buf);
> +	return 0;
> +}
> +
> +
>   static ssize_t create_child(struct device *dev,
>   			    struct device_attribute *attr,
>   			    const char *buf, size_t count)
> @@ -2156,6 +2279,44 @@ static ssize_t delete_child(struct device *dev,
>   }
>   static DEVICE_ATTR(delete_child, S_IWUSR, NULL, delete_child);
>   
> +static ssize_t create_named_child(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t count)
> +{
> +	int pkey;
> +	char child_name[IFNAMSIZ];
> +	int ret = 0;
> +
> +	child_name[0] = '\0';
> +
> +	if (parse_named_child(dev, buf, child_name, &pkey))
> +		return -EINVAL;
> +
> +	ret = ipoib_named_vlan_add(to_net_dev(dev), pkey, child_name);
> +	return ret ? ret : count;
> +}
> +static DEVICE_ATTR(create_named_child, S_IWUSR, NULL, create_named_child);
> +
> +static ssize_t delete_named_child(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t count)
> +{
> +	char child_name[IFNAMSIZ];
> +	int ret = 0;
> +
> +	child_name[0] = '\0';
> +
> +	if (parse_named_child(dev, buf, child_name, NULL))
> +		return -EINVAL;
> +
> +	ret = ipoib_named_vlan_delete(to_net_dev(dev), child_name);
> +
> +	return ret ? ret : count;
> +
> +}
> +static DEVICE_ATTR(delete_named_child, S_IWUSR, NULL, delete_named_child);
> +
> +
>   int ipoib_add_pkey_attr(struct net_device *dev)
>   {
>   	return device_create_file(&dev->dev, &dev_attr_pkey);
> @@ -2263,6 +2424,11 @@ static struct net_device *ipoib_add_port(const char *format,
>   		goto sysfs_failed;
>   	if (device_create_file(&priv->dev->dev, &dev_attr_delete_child))
>   		goto sysfs_failed;
> +	if (device_create_file(&priv->dev->dev, &dev_attr_create_named_child))
> +		goto sysfs_failed;
> +	if (device_create_file(&priv->dev->dev, &dev_attr_delete_named_child))
> +		goto sysfs_failed;
> +
>   
>   	return priv->dev;
>   
> @@ -2367,6 +2533,27 @@ static struct notifier_block ipoib_netdev_notifier = {
>   };
>   #endif
>   
> +int
> +ipoib_get_netdev_pkey(struct net_device *dev, u16 *pkey)
> +{
> +	struct ipoib_dev_priv *priv;
> +
> +	if (dev->type != ARPHRD_INFINIBAND)
> +		return -EINVAL;
> +
> +	/* only for ipoib net devices! */
> +	if ((dev->netdev_ops != &ipoib_netdev_ops_pf) &&
> +	    (dev->netdev_ops != &ipoib_netdev_ops_vf))
> +		return -EINVAL;
> +
> +	priv = ipoib_priv(dev);
> +
> +	*pkey = priv->pkey;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ipoib_get_netdev_pkey);
> +
>   static int __init ipoib_init_module(void)
>   {
>   	int ret;
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> index 9927cd6b7082..f5ae55f4f845 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> @@ -115,7 +115,9 @@ int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv, struct ipoib_dev_priv *priv,
>   	return result;
>   }
>   
> -int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
> +int ipoib_vlan_add_common(struct net_device *pdev,
> +			  unsigned short pkey,
> +			  char *child_name_buf)
>   {
>   	struct ipoib_dev_priv *ppriv, *priv;
>   	char intf_name[IFNAMSIZ];
> @@ -130,8 +132,21 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
>   	if (test_bit(IPOIB_FLAG_GOING_DOWN, &ppriv->flags))
>   		return -EPERM;
>   
> -	snprintf(intf_name, sizeof intf_name, "%s.%04x",
> -		 ppriv->dev->name, pkey);
> +	if (child_name_buf == NULL) {
> +		/*
> +		 * If child name is not provided, we generated
> +		 * one using name of parent and pkey.
> +		 */
> +		snprintf(intf_name, sizeof(intf_name), "%s.%04x",
> +			 ppriv->dev->name, pkey);
> +	} else {
> +		/*
> +		 * Note: Duplicate intf_name will be detected later in the code
> +		 * by register_netdevice() (inside __ipoib_vlan_add() call
> +		 * below) returning EEXIST!
> +		 */
> +		strncpy(intf_name, child_name_buf, IFNAMSIZ);
> +	}
>   
>   	if (!mutex_trylock(&ppriv->sysfs_mutex))
>   		return restart_syscall();
> @@ -183,10 +198,27 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
>   	return result;
>   }
>   
> -int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
> +int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
> +{
> +	return ipoib_vlan_add_common(pdev, pkey, NULL);
> +}
> +
> +int ipoib_named_vlan_add(struct net_device *pdev,
> +			 unsigned short pkey,
> +			 char *child_name_buf)
> +{
> +	return ipoib_vlan_add_common(pdev, pkey, child_name_buf);
> +}
> +
> +int ipoib_vlan_delete_common(struct net_device *pdev,
> +			     unsigned short pkey,
> +			     char *child_name_buf)
>   {
>   	struct ipoib_dev_priv *ppriv, *priv, *tpriv;
>   	struct net_device *dev = NULL;
> +	char gen_intf_name[IFNAMSIZ];
> +
> +	gen_intf_name[0] = '\0'; /* initialize - paranoia! */
>   
>   	if (!capable(CAP_NET_ADMIN))
>   		return -EPERM;
> @@ -205,9 +237,30 @@ int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
>   	}
>   
>   	down_write(&ppriv->vlan_rwsem);
> +	if (child_name_buf == NULL && ppriv->dev) {
> +		/*
> +		 * If child name is not provided, we generate the
> +		 * expected one using name of parent and pkey
> +		 * and use it in addition to pkey value
> +		 * (other children with same pkey may exist that have
> +		 * created by create_named_child() - we do not allow
> +		 * delete_child() to delete them - delete_named_child()
> +		 * has to be used!)
> +		 */
> +		snprintf(gen_intf_name, sizeof(gen_intf_name),
> +			 "%s.%04x", ppriv->dev->name, pkey);
> +	}
>   	list_for_each_entry_safe(priv, tpriv, &ppriv->child_intfs, list) {
> -		if (priv->pkey == pkey &&
> -		    priv->child_type == IPOIB_LEGACY_CHILD) {
> +		if ((priv->child_type == IPOIB_LEGACY_CHILD) &&
> +		    /* user named child (match by name) OR */
> +		    ((child_name_buf && priv->dev &&
> +		      !strcmp(child_name_buf, priv->dev->name)) ||
> +		     /*
> +		      * OR classic (devname.hexpkey generated name) child
> +		      * (match by pkey and generated name)
> +		      */
> +		     (!child_name_buf && priv->pkey == pkey &&
> +		      priv->dev && !strcmp(gen_intf_name, priv->dev->name)))) {
>   			list_del(&priv->list);
>   			dev = priv->dev;
>   			break;
> @@ -231,3 +284,14 @@ int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
>   
>   	return -ENODEV;
>   }
> +
> +int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
> +{
> +
> +	return ipoib_vlan_delete_common(pdev, pkey, NULL);
> +}
> +
> +int ipoib_named_vlan_delete(struct net_device *pdev, char *child_name_buf)
> +{
> +	return ipoib_vlan_delete_common(pdev, 0, child_name_buf);
> +}
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
