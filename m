Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793756627;
	b=QinZ5h2eGR9JjFwKOIgIitvjDijOH6acTGo8pbsuFGxirX/2rjGguzufHKHJA9xOlNt5
	 nNaHbFsyGr3DADaoWacVWmjlqe8Jd0uobtktkjSKFtZYw9D+NXGSqfXcvzI/oeR3Qs0rW
	 tTGzCl2apvaJJVnCBdi4i4y/L+FueOgK+8So7Z5czoI4x818XWxcmQ4PYQTQhMFg4EpdH
	 KU0ApeEhvWG7U//H4UZWiD3ysF+SmTR9bhdik1nZdriM5czLYflyFjyEbFOXBbOmdXnOi
	 5TSpfkCHNmr9MxlAeHATRpcI74crp6XbgXz+lc2CxIVbbj+F7YpMh22YTL5zSuj/oaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793756627;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=K8erlwxkTMfXo//4EhMU9SF2J4lQcW73I0XnlPu5kgU=;
	b=aSb/jG2HwYVwNoMAyQpHifPwQuZt1Z+xf06Z1mR8Vlhd00P4R6oss9GD8Ytmlktd6LE3
	 6kracAEzl0Jpkdpo4/Z9JV3iSYvItHUgGPQvwJWkVrrCJV1FF7GEgntDr4hxIFmOFkwBw
	 n3zHaCRtS2ceqgcmAWrbu36Zm9M9cAN4YT6CebRIgsfu05+UeoxyoP8aTE0OPaR2EMniA
	 hjTaO4b6iy0TkEOe3iONU63tXyvapmCMaQO4QvcjXd2xjie7pEmo0lKZNgmtBeeVU0828
	 oC+Q2AKVCFIKUrJ4HJY8DwktdKwsIBu6xssFD5UDkkiaOje6u1b39VItzulsaPSK8DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QPEjlpmb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB065606A326;
	Wed,  4 Nov 2026 01:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QPEjlpmb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1166D1F000C1;
	Wed,  4 Nov 2026 01:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793756626;
	bh=K8erlwxkTMfXo//4EhMU9SF2J4lQcW73I0XnlPu5kgU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QPEjlpmbgGMUdkCJzU0ZeI1Wd++qW6+uSgMUOxB0BIAlNduGISIakF8nmrDosophA
	 42i6IKM+9P5K5LDIjhPJNFjkojD5Y4iMrdwLyMSO+nabUcLyEl/a5mBgHSaHa9z+UM
	 UZsdiDOMqnz3MUIT9TiQw4H87VUDfduDhVi0CDZrgPd+W39mTjAE9R6z1GcO0HHmfG
	 tPAkIr20GUS8SYR+sG/KuD7cYcsDyUuyVTvGzzJie4x8YXgtDyLUX2l4Y3B5pJc+X5
	 wfpjF6vfpWMzooemVdgh58pbUp3rYvmxQNCQDe+2dQ63bayvMtt2pgJzsd8wjGyUUn
	 DLvRmrjNtbH1A==
Message-ID: <sashiko-outbox-196373@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 5/6] IB/isert: do not build a new isert_device for a
 device being removed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261104012219.1759523-6-yhlee@isslab.korea.ac.kr>
References: <20261104012219.1759523-1-yhlee@isslab.korea.ac.kr>
 <20261104012219.1759523-6-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 01:43:45 +0000
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
- [High] IB/isert: Cross-device aliasing via node_guid lookup in isert_devi=
ce_get()
--

commit 01d8f2361924f11ef1e502a2b19ce2e53509658d
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

IB/isert: do not build a new isert_device for a device being removed

This patch uses ib_client data to track whether an ib_device is active and
skips devices marked as removing in isert_device_get() so a concurrent
CONNECT_REQUEST cannot create or grab an isert_device during device removal.

> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband=
/ulp/isert/ib_isert.c
> index 712d6165150e3..1b388075cc633 100644
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

[Severity: High]
As reported by Sashiko on v6 [1], when two ib_device instances share the sa=
me
node_guid (for example, software RDMA devices over netdevs sharing a MAC
address, which the commit message notes), can matching by node_guid in
isert_device_get() bind a connection on one ib_device to another ib_device's
isert_device?

Each isert_device is bound to a specific ib_device pointer
(device->ib_device =3D cma_id->device), allocates its protection domain on =
that
device in isert_create_device_ib_res(), and is looked up by pointer equality
in isert_remove_one():

drivers/infiniband/ulp/isert/ib_isert.c:isert_remove_one() {
	...
	list_for_each_entry(device, &device_list, dev_node) {
		if (device->ib_device !=3D ib_device)
			continue;
		device->refcount++;
		device->removal_comp =3D &removal_comp;
		device->removing =3D true;
		found =3D device;
		break;
	}
}

In addition, while the commit message mentions that taking device_list_mutex
under isert_conn_mutex prevents a sibling device from raising the reference
count of one being removed, isert_device_get() only acquires
device_list_mutex and does not acquire isert_conn_mutex.

If ib_dev1 has an active isert_device in device_list and a CONNECT_REQUEST
arrives on ib_dev2 (which shares node_guid with ib_dev1), isert_device_get()
passes ib_get_client_data(cma_id->device, &isert_ib_client) for ib_dev2,
matches ib_dev1's isert_device by node_guid, increments its refcount, and
returns it.

In isert_connect_request(), isert_alloc_login_buf() then maps DMA buffers on
cma_id->device (ib_dev2), while isert_create_qp() allocates a CQ on
device->ib_device (ib_dev1) and calls rdma_create_qp(cma_id, device->pd,
&attr), which fails with -EINVAL because id->device !=3D pd->device:

drivers/infiniband/ulp/isert/ib_isert.c:isert_connect_request() {
	...
	ret =3D isert_alloc_login_buf(isert_conn, cma_id->device);
	if (ret)
		goto out_conn_dev;

	isert_set_nego_params(isert_conn, &event->param.conn);

	isert_conn->qp =3D isert_create_qp(isert_conn, cma_id);
	if (IS_ERR(isert_conn->qp)) {
		ret =3D PTR_ERR(isert_conn->qp);
		goto out_rsp_dma_map;
	}
}

On the out_rsp_dma_map error path, isert_free_login_buf() unmaps
login_rsp_dma and login_desc->dma_addr using isert_conn->device->ib_device
(ib_dev1) instead of cma_id->device (ib_dev2), unmapping on the wrong device
and leaking the DMA mappings on ib_dev2:

drivers/infiniband/ulp/isert/ib_isert.c:isert_free_login_buf() {
	struct ib_device *ib_dev =3D isert_conn->device->ib_device;

	ib_dma_unmap_single(ib_dev, isert_conn->login_rsp_dma,
			    ISER_RX_PAYLOAD_SIZE, DMA_TO_DEVICE);
	...
}

Conversely, if ib_dev2 already has an active isert_device in device_list and
ib_dev1 has none when a CONNECT_REQUEST arrives on ib_dev1 just before
isert_remove_one(ib_dev1) runs, isert_device_get() matches ib_dev2's
isert_device. When isert_remove_one(ib_dev1) then searches device_list for
device->ib_device =3D=3D ib_dev1, found is NULL and it returns immediately
without waiting while isert_connect_request() is still mapping DMA buffers =
on
ib_dev1.

Should isert_device_get() match by device->ib_device !=3D cma_id->device
instead of node_guid so that it is consistent with isert_remove_one()?

[1] https://lore.kernel.org/r/20261103223802.1697607-6-yhlee@isslab.korea.a=
c.kr

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104012219.1759=
523-1-yhlee@isslab.korea.ac.kr?part=3D5
