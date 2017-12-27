From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/4] RDMA/core: Enforce requirement to hold
 lists_rwsem semaphore
Date: Wed, 27 Dec 2017 14:49:56 -0700
Message-ID: <20171227214956.GI25436@ziepe.ca>
References: <20171224115458.27577-1-leon@kernel.org>
 <20171224115458.27577-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171224115458.27577-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 24, 2017 at 01:54:55PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Add comment and run time check to the __ib_device_get_by_index()
> function to remind that the caller should hold lists_rwsem semaphore.

Upon closer inspecting, this is not entirely right.  There is no bug
here, the locking is clearly explained in the comment for
device_mutex.

lists_rwsem's down_write must only be done while within the
device_mutex.

Therefore holding the device_mutex implies there can be no concurrent
writers, and any read lock of lists_rwsem is not necessary.

>  struct ib_device *__ib_device_get_by_index(u32 index)
>  {
>  	struct ib_device *device;
>  
> +	WARN_ON_ONCE(!rwsem_is_locked(&lists_rwsem));

So this is wrong, it needs to consider the device_mutex too

> @@ -526,8 +531,8 @@ int ib_register_device(struct ib_device *device,
>  		if (!add_client_context(device, client) && client->add)
>  			client->add(device);
>  
> -	device->index = __dev_new_index();
>  	down_write(&lists_rwsem);
> +	device->index = __dev_new_index();
>  	list_add_tail(&device->core_list, &device_list);
>  	up_write(&lists_rwsem);

And this sequence was OK before - the only thing that needs to be
protected by the write lock is the actual list manipulation, not the
search.

The locking here has become a bit nutzo, and the sequencing is wrong
too..

Below is a draft of tidying at least some of this.. Can you work from
here? Will drop this patch.

* Get rid of going_down, we can use list_del and list_splice held
  under the locks to prevent access to the ib_client_data struct
* This allow simplifiying the removal locking to only hold write locks
  while doing the list edit
* Correct call ordering of removal - client remove should be called
  before we break set/get_client_data, otherwise the client has no
  control over when those calls start to fail.
* Client remove must prevent other threads from calling
  set/get_client_data - so safety checks now become WARN_ON
* The kfree doesn't need locking since the list manipulation have no
  dangling pointer anymore.
* Add assert ASSERT_LISTS_READ_LOCKED in all the right places

Jason

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 3aeaf11d0a83b7..9e973483b7b91d 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -52,12 +52,15 @@ MODULE_DESCRIPTION("core kernel InfiniBand API");
 MODULE_LICENSE("Dual BSD/GPL");
 
 struct ib_client_data {
+	/*
+	 * list uses a dual locking scheme, readers can either grab the global
+	 * read lists_rwsem or the per-device client_data_lock spin
+	 * lock. writers must grab both the write lists_rwsem and the spin
+	 * lock.
+	 */
 	struct list_head  list;
 	struct ib_client *client;
 	void *            data;
-	/* The device or client is going down. Do not call client or device
-	 * callbacks other than remove(). */
-	bool		  going_down;
 };
 
 struct workqueue_struct *ib_comp_wq;
@@ -84,6 +87,16 @@ static LIST_HEAD(client_list);
 static DEFINE_MUTEX(device_mutex);
 static DECLARE_RWSEM(lists_rwsem);
 
+/*
+ * Used to indicate the function is going to read from client_data_list/list
+ * or device_list/core_list.
+ */
+static void ASSERT_LISTS_READ_LOCKED(void)
+{
+	WARN_ON_ONCE(!rwsem_is_locked(&lists_rwsem) &&
+		     !mutex_is_locked(&device_mutex));
+}
+
 static int ib_security_change(struct notifier_block *nb, unsigned long event,
 			      void *lsm_data);
 static void ib_policy_change_task(struct work_struct *work);
@@ -141,7 +154,7 @@ struct ib_device *__ib_device_get_by_index(u32 index)
 {
 	struct ib_device *device;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&lists_rwsem));
+	ASSERT_LISTS_READ_LOCKED();
 
 	list_for_each_entry(device, &device_list, core_list)
 		if (device->index == index)
@@ -154,6 +167,8 @@ static struct ib_device *__ib_device_get_by_name(const char *name)
 {
 	struct ib_device *device;
 
+	ASSERT_LISTS_READ_LOCKED();
+
 	list_for_each_entry(device, &device_list, core_list)
 		if (!strncmp(name, device->name, IB_DEVICE_NAME_MAX))
 			return device;
@@ -172,6 +187,8 @@ static int alloc_name(char *name)
 	if (!inuse)
 		return -ENOMEM;
 
+	ASSERT_LISTS_READ_LOCKED();
+
 	list_for_each_entry(device, &device_list, core_list) {
 		if (!sscanf(device->name, name, &i))
 			continue;
@@ -292,7 +309,6 @@ static int add_client_context(struct ib_device *device, struct ib_client *client
 
 	context->client = client;
 	context->data   = NULL;
-	context->going_down = false;
 
 	down_write(&lists_rwsem);
 	spin_lock_irqsave(&device->client_data_lock, flags);
@@ -531,8 +547,8 @@ int ib_register_device(struct ib_device *device,
 		if (!add_client_context(device, client) && client->add)
 			client->add(device);
 
-	down_write(&lists_rwsem);
 	device->index = __dev_new_index();
+	down_write(&lists_rwsem);
 	list_add_tail(&device->core_list, &device_list);
 	up_write(&lists_rwsem);
 	mutex_unlock(&device_mutex);
@@ -559,23 +575,27 @@ void ib_unregister_device(struct ib_device *device)
 {
 	struct ib_client_data *context, *tmp;
 	unsigned long flags;
+	struct list_head client_data_tmp;
+
+	INIT_LIST_HEAD(&client_data_tmp);
 
 	mutex_lock(&device_mutex);
 
+	list_for_each_entry(context, &device->client_data_list, list)
+		if (context->client->remove)
+			context->client->remove(device, context->data);
+
 	down_write(&lists_rwsem);
-	list_del(&device->core_list);
+
 	spin_lock_irqsave(&device->client_data_lock, flags);
-	list_for_each_entry_safe(context, tmp, &device->client_data_list, list)
-		context->going_down = true;
+	list_splice_init(&device->client_data_list, &client_data_tmp);
 	spin_unlock_irqrestore(&device->client_data_lock, flags);
-	downgrade_write(&lists_rwsem);
 
-	list_for_each_entry_safe(context, tmp, &device->client_data_list,
-				 list) {
-		if (context->client->remove)
-			context->client->remove(device, context->data);
-	}
-	up_read(&lists_rwsem);
+	list_for_each_entry_safe(context, tmp, &client_data_tmp, list)
+		kfree(context);
+
+	list_del(&device->core_list);
+	up_write(&lists_rwsem);
 
 	ib_device_unregister_rdmacg(device);
 	ib_device_unregister_sysfs(device);
@@ -587,13 +607,6 @@ void ib_unregister_device(struct ib_device *device)
 	ib_security_destroy_port_pkey_list(device);
 	kfree(device->port_pkey_list);
 
-	down_write(&lists_rwsem);
-	spin_lock_irqsave(&device->client_data_lock, flags);
-	list_for_each_entry_safe(context, tmp, &device->client_data_list, list)
-		kfree(context);
-	spin_unlock_irqrestore(&device->client_data_lock, flags);
-	up_write(&lists_rwsem);
-
 	device->reg_state = IB_DEV_UNREGISTERED;
 }
 EXPORT_SYMBOL(ib_unregister_device);
@@ -617,6 +630,8 @@ int ib_register_client(struct ib_client *client)
 
 	mutex_lock(&device_mutex);
 
+	ASSERT_LISTS_READ_LOCKED();
+
 	list_for_each_entry(device, &device_list, core_list)
 		if (!add_client_context(device, client) && client->add)
 			client->add(device);
@@ -654,33 +669,27 @@ void ib_unregister_client(struct ib_client *client)
 	list_for_each_entry(device, &device_list, core_list) {
 		struct ib_client_data *found_context = NULL;
 
-		down_write(&lists_rwsem);
-		spin_lock_irqsave(&device->client_data_lock, flags);
-		list_for_each_entry_safe(context, tmp, &device->client_data_list, list)
+		list_for_each_entry_safe(context, tmp, &device->client_data_list, list) {
 			if (context->client == client) {
-				context->going_down = true;
 				found_context = context;
 				break;
 			}
-		spin_unlock_irqrestore(&device->client_data_lock, flags);
-		up_write(&lists_rwsem);
+		}
 
-		if (client->remove)
-			client->remove(device, found_context ?
-					       found_context->data : NULL);
+		if (found_context) {
+			if (client->remove)
+				client->remove(device, found_context->data);
 
-		if (!found_context) {
-			pr_warn("No client context found for %s/%s\n",
-				device->name, client->name);
-			continue;
-		}
+			down_write(&lists_rwsem);
+			spin_lock_irqsave(&device->client_data_lock, flags);
+			list_del(&context->list);
+			spin_unlock_irqrestore(&device->client_data_lock,
+					       flags);
+			up_write(&lists_rwsem);
 
-		down_write(&lists_rwsem);
-		spin_lock_irqsave(&device->client_data_lock, flags);
-		list_del(&found_context->list);
-		kfree(found_context);
-		spin_unlock_irqrestore(&device->client_data_lock, flags);
-		up_write(&lists_rwsem);
+			kfree(found_context);
+		} else
+			WARN_ON(!found_context);
 	}
 
 	mutex_unlock(&device_mutex);
@@ -735,9 +744,7 @@ void ib_set_client_data(struct ib_device *device, struct ib_client *client,
 			goto out;
 		}
 
-	pr_warn("No client context found for %s/%s\n",
-		device->name, client->name);
-
+	WARN_ON(true);
 out:
 	spin_unlock_irqrestore(&device->client_data_lock, flags);
 }
@@ -1133,9 +1140,6 @@ struct net_device *ib_get_net_dev_by_params(struct ib_device *dev,
 	list_for_each_entry(context, &dev->client_data_list, list) {
 		struct ib_client *client = context->client;
 
-		if (context->going_down)
-			continue;
-
 		if (client->get_net_dev_by_params) {
 			net_dev = client->get_net_dev_by_params(dev, port, pkey,
 								gid, addr,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
