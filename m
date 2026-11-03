Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793747441;
	b=F/c7/hP7+30it2JyMNneqD14kfijDBpRyfET7SvQz3nYOH9+hSZMtEbHnVvxSodJwuIE
	 +KVUI7QHKjTmGN+E7KmDfAgKypr3IbJ8EcRL4TdnLYLifERdh8yV/qtPFlMJ1B5IFhibV
	 jw9MSggAGd9dFDgSIs5jT5YI+ERYTbCrsSwVXTdJqj23HyxWIm9z4N79h6d+KRM893xCu
	 PFXnu3vZnACKP/2vJYQQgQPtHk/FCnOUUrwRMxacQyB0C4fmj53lns3neQzwYeJdNw4Oy
	 kvpqcQb7PV/IhOxyL+a2W+nBQmBgX9R7LkLsF2hOgJ5RXQbDwUSdC7OXtMHQ/gdFcxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793747441;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0eU/hjcUFjh++FC7iUcDAyhM/AjcJjm8YHkmHUel4QI=;
	b=Jn37Dd17Hjs3ufzcLZwon4Efcil/obpicxS+2UG198BQvPdH/mVaVWW297KgeR8qI+d/
	 YCfr9DJIuVH8vo1CnnRaauL1T/o1HLxm6S+3eZVnVXeU/IjVfCHIcjN3Y6jZCXgKM95GL
	 24RXh8SmWEO5AhWSIsp5482JSveUlVD4ZLrBeSKW3ALlmDVwGvZilzXI9cutv7JaPtw8q
	 qDZMXMdIoCbLwt907xbKeUtpK1MsERRXs/9JqjjkkSPtBVWsSOtdL8TUJ2K9I2tegsHhh
	 EMS18m9kLcEV33HcCCwCQRjoSqePuWFdKY9xI6AHH09QiLPoThV1SNpVcW92qEwDh8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VEOO7Ihw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4728606A336;
	Tue,  3 Nov 2026 23:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VEOO7Ihw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556CC1F00A02;
	Tue,  3 Nov 2026 23:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793747440;
	bh=0eU/hjcUFjh++FC7iUcDAyhM/AjcJjm8YHkmHUel4QI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VEOO7IhwhgvQPV2d7jJ6X2Th7Q3ew3tOP1kzhSWjDBPha4keMD3FVuL6Tu3rU9EVO
	 dpPfiuE3qV4lvvsusua1KLTgh+cn5FVnOX7n2njarBkAXFPIdTz9ibsYAlFtctR2Bd
	 WmbJ/7YvvYjxLK3sWXKEdy0O1P5kWVWpT8YBN6tOR46yX+2jwR6cIbW3mdFMkNZO48
	 +eO2trWPSNJzCbOoQ+KcGl/odyqpKaA4v1KICxfZ5AbhoeZQLG+lJblaT7sXZww6dO
	 PNbbn3a01MrxhrTVqabaPTt5ZnRQ8LKefs11OMl5iwUYuptbudbvNMyfUartCOyXeF
	 a44OkiMPqty3g==
Message-ID: <sashiko-outbox-196182@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 5/6] IB/isert: do not build a new isert_device for a
 device being removed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261103223802.1697607-6-yhlee@isslab.korea.ac.kr>
References: <20261103223802.1697607-1-yhlee@isslab.korea.ac.kr>
 <20261103223802.1697607-6-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 23:10:39 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] IB/isert: race window in isert_remove_one() before setting found=
->removing
--

commit 5f9189f7b427c87e967cf5a96e3a777eb552f8e4
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

IB/isert: do not build a new isert_device for a device being removed

This commit prevents isert_device_get() from creating or returning an
isert_device for an ib_device that is being removed by tracking device state
via ib_client data and skipping devices marked as removing.

> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband=
/ulp/isert/ib_isert.c
> index 712d6165150e3..2057bb35af4ca 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c

[ ... ]

> @@ -275,14 +280,19 @@ isert_device_get(struct rdma_cm_id *cma_id)
>  	int ret;
> =20
>  	mutex_lock(&device_list_mutex);
> +	if (!ib_get_client_data(cma_id->device, &isert_ib_client)) {
> +		mutex_unlock(&device_list_mutex);
> +		return ERR_PTR(-ENODEV);
> +	}
>  	list_for_each_entry(device, &device_list, dev_node) {
> -		if (device->ib_device->node_guid =3D=3D cma_id->device->node_guid) {
> -			device->refcount++;
> -			isert_info("Found iser device %p refcount %d\n",
> -				   device, device->refcount);
> -			mutex_unlock(&device_list_mutex);
> -			return device;
> -		}
> +		if (device->removing ||
> +		    device->ib_device->node_guid !=3D cma_id->device->node_guid)
> +			continue;
> +		device->refcount++;
> +		isert_info("Found iser device %p refcount %d\n",
> +			   device, device->refcount);
> +		mutex_unlock(&device_list_mutex);
> +		return device;
>  	}
> =20
>  	device =3D kzalloc_obj(struct isert_device);
> @@ -2791,6 +2801,7 @@ isert_remove_one(struct ib_device *ib_device, void =
*client_data)
>  	LIST_HEAD(removal_list);
> =20
>  	mutex_lock(&device_list_mutex);
> +	ib_set_client_data(ib_device, &isert_ib_client, NULL);
>  	list_for_each_entry(device, &device_list, dev_node) {
>  		if (device->ib_device !=3D ib_device)
>  			continue;
> @@ -2805,7 +2816,9 @@ isert_remove_one(struct ib_device *ib_device, void =
*client_data)
>  		return;
> =20
>  	mutex_lock(&isert_conn_mutex);
> +	mutex_lock(&device_list_mutex);
>  	found->removing =3D true;
> +	mutex_unlock(&device_list_mutex);
>  	list_for_each_entry(isert_conn, &isert_conn_list, conn_list) {
>  		if (isert_conn->device !=3D found)
>  			continue;

[Severity: Medium]
In isert_remove_one(), device_list_mutex is unlocked after clearing the
client data and finding the device, before acquiring isert_conn_mutex and
re-locking device_list_mutex to set found->removing =3D true:

	mutex_lock(&device_list_mutex);
	ib_set_client_data(ib_device, &isert_ib_client, NULL);
	list_for_each_entry(device, &device_list, dev_node) {
		if (device->ib_device !=3D ib_device)
			continue;
		device->refcount++;
		device->removal_comp =3D &removal_comp;
		found =3D device;
		break;
	}
	mutex_unlock(&device_list_mutex);

	if (!found)
		return;

	mutex_lock(&isert_conn_mutex);
	mutex_lock(&device_list_mutex);
	found->removing =3D true;
	mutex_unlock(&device_list_mutex);

The commit message notes that the lookup skips an isert_device being removed
so a device with the same node_guid cannot raise its reference count again.
However, because ib_get_client_data(cma_id->device, &isert_ib_client) alrea=
dy
rejects the same ib_device once client data is cleared, the device->removing
check in isert_device_get() is only reached when cma_id->device is a
different ib_device sharing the same node_guid.

If a connection request on another ib_device with the same node_guid calls
isert_device_get() during that unlocked window (for instance while
isert_remove_one() waits on isert_conn_mutex), won't it observe
device->removing =3D=3D false and increment found->refcount on the removing
isert_device?

When that happens in isert_connect_request(), isert_alloc_login_buf() DMA-m=
aps
buffers using cma_id->device, isert_create_qp() allocates a CQ on
found->ib_device and fails in rdma_create_qp() with -EINVAL because
id->device !=3D pd->device, and the error path in isert_free_login_buf() th=
en
unmaps those DMA buffers using isert_conn->device->ib_device (found->ib_dev=
ice)
instead of cma_id->device:

	ret =3D isert_alloc_login_buf(isert_conn, cma_id->device);
	if (ret)
		goto out_conn_dev;

	isert_set_nego_params(isert_conn, &event->param.conn);

	isert_conn->qp =3D isert_create_qp(isert_conn, cma_id);
	if (IS_ERR(isert_conn->qp)) {
		ret =3D PTR_ERR(isert_conn->qp);
		goto out_rsp_dma_map;
	}
	...
out_rsp_dma_map:
	isert_free_login_buf(isert_conn);

Additionally, if an in-flight isert_connect_request() on the removing device
already called isert_device_get() before isert_remove_one() started, and it
acquires isert_conn_mutex before isert_remove_one() does, it will also see
device->removing =3D=3D false and accept the connection.

Should found->removing =3D true be set inside the first device_list_mutex
critical section in isert_remove_one() when found is located?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103223802.1697=
607-1-yhlee@isslab.korea.ac.kr?part=3D5
