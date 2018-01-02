From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 6/7] RDMA/netlink: Protect device and port
 queries from device removal
Date: Tue, 2 Jan 2018 14:14:28 -0700
Message-ID: <20180102211428.GA7831@ziepe.ca>
References: <20180101110717.29686-1-leon@kernel.org>
 <20180101110717.29686-7-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180101110717.29686-7-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 01, 2018 at 01:07:16PM +0200, Leon Romanovsky wrote:

> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 34c6cb2a0977..a0ea3dca479d 100644
> +++ b/drivers/infiniband/core/device.c
> @@ -134,7 +134,10 @@ static int ib_device_check_mandatory(struct ib_device *device)
>  	return 0;
>  }
>  
> -struct ib_device *__ib_device_get_by_index(u32 index)
> +/*
> + * Caller to this function should hold lists_rwsem
> + */

This comment isn't 100% right, the device mutex is also OK to hold, I
dropped it.

> @@ -141,36 +141,41 @@ static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	struct ib_device *device;
>  	struct sk_buff *msg;
>  	u32 index;
> -	int err;
> +	int ret = -ENOMEM;
>  
> -	err = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
> +	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
>  			  nldev_policy, extack);

Initializing ret, then overwriting it with nlmsg_parse is silly, and
leads to this bug:

>  	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>  	if (!msg)
> -		return -ENOMEM;
> +		goto err;

Wrong return code after the change.

I fixed it also dropped replacing err with ret since this is probably
going to be backported.

>  	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
>  	if (!rdma_is_port_valid(device, port))
> -		return -EINVAL;
> +		goto err;

Same mistake again

I also squashed this with the prior patch to make backporting simpler

 RDMA/core: Provide locked variant of device name to index function

And queued it to for-rc

See below, please check my work.

Author: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Mon Jan 1 13:07:15 2018 +0200

    RDMA/netlink: Fix locking around __ib_get_device_by_index
    
    Holding locks is mandatory when calling __ib_device_get_by_index,
    otherwise there are races during the list iteration with device removal.
    
    Since the locks are static to device.c, __ib_device_get_by_index can
    never be called correctly by any user out side the file.
    
    Make the function static and provide a safe function that gets the
    correct locks and returns a kref'd pointer. Fix all callers.
    
    Fixes: e5c9469efcb1 ("RDMA/netlink: Add nldev device doit implementation")
    Fixes: c3f66f7b0052 ("RDMA/netlink: Implement nldev port doit callback")
    Fixes: 7d02f605f0dc ("RDMA/netlink: Add nldev port dumpit implementation")
    Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 0deff4c4911b2b..8dbfc3ab48a608 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -294,7 +294,7 @@ static inline int ib_mad_enforce_security(struct ib_mad_agent_private *map,
 }
 #endif
 
-struct ib_device *__ib_device_get_by_index(u32 ifindex);
+struct ib_device *ib_device_get_by_index(u32 ifindex);
 /* RDMA device netlink */
 void nldev_init(void);
 void nldev_exit(void);
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index a8757b5552de1d..1b413a2df9489b 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -134,7 +134,7 @@ static int ib_device_check_mandatory(struct ib_device *device)
 	return 0;
 }
 
-struct ib_device *__ib_device_get_by_index(u32 index)
+static struct ib_device *__ib_device_get_by_index(u32 index)
 {
 	struct ib_device *device;
 
@@ -145,6 +145,22 @@ struct ib_device *__ib_device_get_by_index(u32 index)
 	return NULL;
 }
 
+/*
+ * Caller is responsible to return refrerence count by calling put_device()
+ */
+struct ib_device *ib_device_get_by_index(u32 index)
+{
+	struct ib_device *device;
+
+	down_read(&lists_rwsem);
+	device = __ib_device_get_by_index(index);
+	if (device)
+		get_device(&device->dev);
+
+	up_read(&lists_rwsem);
+	return device;
+}
+
 static struct ib_device *__ib_device_get_by_name(const char *name)
 {
 	struct ib_device *device;
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 2b631307349ddc..5d790c507c7e17 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -150,27 +150,34 @@ static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
 
-	device = __ib_device_get_by_index(index);
+	device = ib_device_get_by_index(index);
 	if (!device)
 		return -EINVAL;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
+	if (!msg) {
+		err = -ENOMEM;
+		goto err;
+	}
 
 	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_GET),
 			0, 0);
 
 	err = fill_dev_info(msg, device);
-	if (err) {
-		nlmsg_free(msg);
-		return err;
-	}
+	if (err)
+		goto err_free;
 
 	nlmsg_end(msg, nlh);
 
+	put_device(&device->dev);
 	return rdma_nl_unicast(msg, NETLINK_CB(skb).portid);
+
+err_free:
+	nlmsg_free(msg);
+err:
+	put_device(&device->dev);
+	return err;
 }
 
 static int _nldev_get_dumpit(struct ib_device *device,
@@ -228,31 +235,40 @@ static int nldev_port_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EINVAL;
 
 	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
-	device = __ib_device_get_by_index(index);
+	device = ib_device_get_by_index(index);
 	if (!device)
 		return -EINVAL;
 
 	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
-	if (!rdma_is_port_valid(device, port))
-		return -EINVAL;
+	if (!rdma_is_port_valid(device, port)) {
+		err = -EINVAL;
+		goto err;
+	}
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
+	if (!msg) {
+		err = -ENOMEM;
+		goto err;
+	}
 
 	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_GET),
 			0, 0);
 
 	err = fill_port_info(msg, device, port);
-	if (err) {
-		nlmsg_free(msg);
-		return err;
-	}
+	if (err)
+		goto err_free;
 
 	nlmsg_end(msg, nlh);
+	put_device(&device->dev);
 
 	return rdma_nl_unicast(msg, NETLINK_CB(skb).portid);
+
+err_free:
+	nlmsg_free(msg);
+err:
+	put_device(&device->dev);
+	return err;
 }
 
 static int nldev_port_get_dumpit(struct sk_buff *skb,
@@ -273,7 +289,7 @@ static int nldev_port_get_dumpit(struct sk_buff *skb,
 		return -EINVAL;
 
 	ifindex = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
-	device = __ib_device_get_by_index(ifindex);
+	device = ib_device_get_by_index(ifindex);
 	if (!device)
 		return -EINVAL;
 
@@ -307,7 +323,9 @@ static int nldev_port_get_dumpit(struct sk_buff *skb,
 		nlmsg_end(skb, nlh);
 	}
 
-out:	cb->args[0] = idx;
+out:
+	put_device(&device->dev);
+	cb->args[0] = idx;
 	return skb->len;
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
