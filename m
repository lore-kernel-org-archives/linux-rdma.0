Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713166;
	b=RDD57DvpsGoHS8GhaDWWQG0e5KSoYdWcXROax+Kamy8R59emqh3ySXrVqDZVBVdLge/U
	 +b/o2e4r8B2+epQUMp8NctqO0XKpJHBbaTxZpSNamEeF3VgxPD5OASxpykTf53P8xvEY+
	 mr4oZ6bdvbKvbG6tguZV6bKjK7ZFd7siFlRGDJXPNnRaX0P4ctCoC6fK98Q9Ru6K07LdU
	 uHrV3pLvgAxK0yf8xwX8TUQyi+h1nwsUw+/yubxIIbWwREDyUwPsJa3tjCMeloGEbD4oz
	 U1QEXn5IRj5yugiMta5ccmWrm38/ofoqUjEXWpdBh9aTp8y4LK08uznvY1hi3qErFNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713166;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hCSNrY6Dw3KNDEqgv/IZHslYqKdk0LvrNJV2LCDQSLU=;
	b=QQUm6xw/kApNXpye14pQWgbvRqJY96yaKiWfrknJv93Tt5Fbr0PBhfYygkCL63F9KPwy
	 47c4MKa670xmTiJaIUzoXKe2ZK3+pFjX5IAjQz+n4Z1P6996wopky0D0boBVNxNzl3cRc
	 xglJCnKTFX/bk4Coa1lB+MmrxTbhykFoDYV7OgmFOqGcfPdXkG5LaV9X2o3sSrD8xqhCX
	 GSsAGHrtp2tRkxlPs1UBOfedxW/M6af4v8hq0aQ6BzDNSG9dvqVCc9JBDK6BseVd0RF29
	 pBcIbpdnwmjCb58KpdR6w3bPoIKqUfsrOp7MFOc1CPg5NapWYZKUahvBXhj89RBygkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MQuQS4nR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4F4606A326;
	Tue,  3 Nov 2026 13:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MQuQS4nR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBE81F000C1;
	Tue,  3 Nov 2026 13:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793713165;
	bh=hCSNrY6Dw3KNDEqgv/IZHslYqKdk0LvrNJV2LCDQSLU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MQuQS4nRLeXKrFL/rP87T0TNWk7JPVrnmg+o17OIZ1rxwJk73f+E8tECk1NGJapVL
	 GaJ1RDMOhbwjK4V6WxPq8jqq8xKsHMJRDgTXF8+IJ/9yLHltsrRAbcQqX7iDde3hhH
	 ZLSkxCFgDCo862rxiTfKcn0rSQx2Im8D5QmYgvSqlt2PLqol/q7ekBRB/T0z0WfAqD
	 heQBcyhU9vzYZKH2DAPUqMttvAx//2GtvWOxL8gzVdmaTNsRnNRc0Zh4P2/ZCB5xA1
	 fryf6BShZrmN0ey9RKkmbNlpdOang7EXc+NbgYu5i2gKE+ZT6xlpwwdgw6CBSjsKgH
	 HWrBWlx2N8fpA==
Message-ID: <sashiko-outbox-195380@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 5/5] IB/isert: do not build a new isert_device for a
 device being removed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261103125955.1530355-6-yhlee@isslab.korea.ac.kr>
References: <20261103125955.1530355-1-yhlee@isslab.korea.ac.kr>
 <20261103125955.1530355-6-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 13:39:24 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] IB/isert: stale removal marker in isert_device_get() before isert_=
add_one()
- [Medium] IB/isert: unbounded leak of isert_device markers in device_list
- [Medium] IB/isert: memory leak of removal markers in isert_init() on error
--

commit 812d1184eb1546b67f3290f713769f5e49331bb1
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

IB/isert: do not build a new isert_device for a device being removed

This patch retains or allocates a removing struct isert_device marker on
device_list during isert_remove_one() so that concurrent isert_device_get()
calls reject devices being removed with -ENODEV. The markers are then freed
when a matching ib_device pointer is seen in isert_add_one() or when the
module unloads in isert_exit().

> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband=
/ulp/isert/ib_isert.c
> index 712d6165150e3..4bcd14f5045ac 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -260,10 +260,12 @@ isert_device_put(struct isert_device *device)
>  	isert_info("device %p refcount %d\n", device, device->refcount);
>  	if (!device->refcount) {
>  		isert_free_device_ib_res(device);
> -		list_del(&device->dev_node);
> -		if (device->removal_comp)
> +		if (device->removing) {
>  			complete(device->removal_comp);
> -		kfree(device);
> +		} else {
> +			list_del(&device->dev_node);
> +			kfree(device);
> +		}
>  	}
>  	mutex_unlock(&device_list_mutex);
>  }
> @@ -276,14 +278,21 @@ isert_device_get(struct rdma_cm_id *cma_id)
> =20
>  	mutex_lock(&device_list_mutex);
>  	list_for_each_entry(device, &device_list, dev_node) {
> -		if (device->ib_device->node_guid =3D=3D cma_id->device->node_guid) {
> -			device->refcount++;
> -			isert_info("Found iser device %p refcount %d\n",
> -				   device, device->refcount);
> +		if (device->removing && device->ib_device =3D=3D cma_id->device) {
>  			mutex_unlock(&device_list_mutex);
> -			return device;
> +			return ERR_PTR(-ENODEV);
>  		}
>  	}

[Severity: High]
Can a stale removal marker in device_list cause isert_device_get() to reject
valid connection requests on a newly enabled or namespace-moved RDMA device
before isert_add_one() has a chance to clear it?

Because ib_isert depends on rdma_cm, cma_client is registered before
isert_ib_client. In enable_device_and_get(), client add callbacks run in
registration order:

drivers/infiniband/core/device.c:enable_device_and_get()
  xa_for_each_marked (&clients, index, client, CLIENT_REGISTERED)
    add_client_context(device, client)

When cma_add_one() runs first, it immediately activates wildcard listeners
(such as an isert_np bound to INADDR_ANY) via cma_listen_on_dev() before
returning:

drivers/infiniband/core/cma.c:cma_add_one()
  list_for_each_entry(id_priv, &listen_any_list, listen_any_item)
    cma_listen_on_dev(id_priv, cma_dev, &to_destroy)

When the same struct ib_device pointer is re-enabled by
rdma_dev_change_netns() (which calls disable_device() followed by
enable_device_and_get() on the same struct ib_device) or when a freed
struct ib_device address is reused by the slab allocator, the marker left by
isert_remove_one() is still on device_list in the window after cma_add_one()
starts listening and before isert_add_one() runs. Any incoming
RDMA_CM_EVENT_CONNECT_REQUEST during that window will match
device->removing && device->ib_device =3D=3D cma_id->device in the first pa=
ss of
isert_device_get() and fail with -ENODEV.

Additionally, if a connection request arrives on a new ib_device after
cma_add_one() starts listening and add_client_context() subsequently fails
before setting CLIENT_DATA_REGISTERED for isert_ib_client, isert_device_get=
()
will have built a live isert_device, but the error unwind in
disable_device() will skip isert_remove_one(), leaving its IB resources
unreleased.

> +	list_for_each_entry(device, &device_list, dev_node) {
> +		if (device->removing ||
> +		    device->ib_device->node_guid !=3D cma_id->device->node_guid)
> +			continue;
> +		device->refcount++;
> +		isert_info("Found iser device %p refcount %d\n",
> +			   device, device->refcount);
> +		mutex_unlock(&device_list_mutex);
> +		return device;
> +	}
> =20
>  	device =3D kzalloc_obj(struct isert_device);
>  	if (!device) {
> @@ -2792,20 +2801,29 @@ isert_remove_one(struct ib_device *ib_device, voi=
d *client_data)
> =20
>  	mutex_lock(&device_list_mutex);
>  	list_for_each_entry(device, &device_list, dev_node) {
> -		if (device->ib_device !=3D ib_device)
> +		if (device->ib_device !=3D ib_device || device->removing)
>  			continue;
>  		device->refcount++;
>  		device->removal_comp =3D &removal_comp;
>  		found =3D device;
>  		break;
>  	}
> -	mutex_unlock(&device_list_mutex);
> -
> -	if (!found)
> +	if (!found) {
> +		device =3D kzalloc_obj(struct isert_device,
> +				     GFP_KERNEL | __GFP_NOFAIL);
> +		INIT_LIST_HEAD(&device->dev_node);
> +		device->ib_device =3D ib_device;
> +		device->removing =3D true;
> +		list_add_tail(&device->dev_node, &device_list);
> +		mutex_unlock(&device_list_mutex);
>  		return;
> +	}
> +	mutex_unlock(&device_list_mutex);
> =20
>  	mutex_lock(&isert_conn_mutex);
> +	mutex_lock(&device_list_mutex);
>  	found->removing =3D true;
> +	mutex_unlock(&device_list_mutex);
>  	list_for_each_entry(isert_conn, &isert_conn_list, conn_list) {
>  		if (isert_conn->device !=3D found)
>  			continue;
> @@ -2828,8 +2846,38 @@ isert_remove_one(struct ib_device *ib_device, void=
 *client_data)
>  	wait_for_completion(&removal_comp);
>  }
> =20
> +static int isert_add_one(struct ib_device *ib_device)
> +{
> +	struct isert_device *device, *tmp;
> +
> +	mutex_lock(&device_list_mutex);
> +	list_for_each_entry_safe(device, tmp, &device_list, dev_node) {
> +		if (device->ib_device !=3D ib_device || !device->removing ||
> +		    device->refcount)
> +			continue;
> +		list_del(&device->dev_node);
> +		kfree(device);
> +	}
> +	mutex_unlock(&device_list_mutex);
> +
> +	return 0;
> +}

[Severity: Medium]
Does this accumulate struct isert_device markers on device_list without
bound across RDMA device unregistrations?

Whenever any IB device is unregistered via __ib_unregister_device() ->
disable_device() -> remove_client_context() -> isert_remove_one() (even a
device never used by ib_isert), isert_remove_one() either keeps the existing
struct isert_device on device_list via isert_device_put() (with dangling
pointers in device->ib_device, device->pd, and the stack-allocated
device->removal_comp) or allocates a new struct isert_device marker with
GFP_KERNEL | __GFP_NOFAIL and appends it to device_list.

Because isert_add_one() only frees a marker if a newly registered device
happens to reuse the exact same struct ib_device pointer address
(device->ib_device =3D=3D ib_device), any removed ib_device whose slab memo=
ry is
not reused by a later ib_device allocation (for example, during repeated
rxe/siw link deletion or VF hotplug cycles) leaves its struct isert_device
marker on device_list until module unload.

> +
> +static void isert_free_markers(void)
> +{
> +	struct isert_device *device, *tmp;
> +
> +	mutex_lock(&device_list_mutex);
> +	list_for_each_entry_safe(device, tmp, &device_list, dev_node) {
> +		list_del(&device->dev_node);
> +		kfree(device);
> +	}
> +	mutex_unlock(&device_list_mutex);
> +}
> +
>  static struct ib_client isert_ib_client =3D {
>  	.name   =3D "isert",
> +	.add    =3D isert_add_one,
>  	.remove =3D isert_remove_one,
>  };
> =20
> @@ -2881,6 +2929,7 @@ static int __init isert_init(void)
>  static void __exit isert_exit(void)
>  {
>  	ib_unregister_client(&isert_ib_client);
> +	isert_free_markers();

[Severity: Medium]
Does isert_init() leak the struct isert_device markers if
ib_register_client(&isert_ib_client) fails partway through?

In ib_register_client(), if add_client_context() succeeds for one or more
devices and then fails on a later device, it rolls back by calling
ib_unregister_client():

drivers/infiniband/core/device.c:ib_register_client()
  xa_for_each_marked (&devices, index, device, DEVICE_REGISTERED) {
    ret =3D add_client_context(device, client);
    if (ret)
      goto out;
  }
  ...
out:
  ...
  if (need_unreg && ret)
    ib_unregister_client(client);

That rollback invokes remove_client_context() -> isert_remove_one() for each
device where add_client_context() succeeded, which allocates a struct
isert_device marker and adds it to device_list. In isert_init(), the error
path jumps to destroy_release_wq without calling isert_free_markers():

drivers/infiniband/ulp/isert/ib_isert.c:isert_init()
	ret =3D ib_register_client(&isert_ib_client);
	if (ret) {
		isert_err("Unable to register isert ib client\n");
		goto destroy_release_wq;
	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103125955.1530=
355-1-yhlee@isslab.korea.ac.kr?part=3D5
