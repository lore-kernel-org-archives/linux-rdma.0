Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795791491;
	b=E8kSNenHe1m/SNqjTTfohrBo5ZWngkOwXrwu5dZR7MqH58C5fUP00GP9FzNleL3wJocT
	 WvYqZ8hbz0UlmVSjEcEO87UKYCyTERglIMuBEz98UxUaffVQt0jQdI3glgnYqTtd0WoMD
	 nwTn/TkNo3vkRcIM/ZkD3kT3psW2NtN9hvfRFsIk+TwxvU36fLLhAkB3ryhV4jOdEd1eU
	 6Cj7oDVqiph4gHzOzvNJnLlEJCt4jAN4lrMvZRmIeg+DRKaKqS3dufYvGu4NgjMEzEk/V
	 Gp1S6eePOVmfR5AgdK+Ef6bmvDOGxpEqMdF0gomJ3K46NPz2yWjLztWpvNP7h220+Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791491;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=PzCwcsdujtzXaGsZkDusvoM2GFrPvOTFYYksQXR49Mw=;
	b=uyQpwVxeV2Bc/vPUuHhzm+Tvs4RrV8QJJzEIN0oiyowkX1wfKXjLBE3Am7Ff1X4NjGr3
	 4iy7LofK0fj6YpiboAjlPfvMfDZIKazGyUOeVyYpbAKn4UoUnNnE3pH75mJX1rSxyoA6L
	 2n5sc3DI3H4HXWK+ppZhjIlAtF6f5cuayhvtfwu8bKVNWa+70mwgEQDYZqokuDMysrU6E
	 wWXy/Kf5vgAS6x5WfIC38jefJjN1lajsxB7CqdJhjEa3rg8Qfg9V00LEndcb7ghL0v6rK
	 9KwogZ/WtckHdMiuqK4v35EPpWCnaJyfu/s/4YFfWItdJvF3DwCpktN2ALwL8PbkKzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="QT70/cQM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD34606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 14:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QT70/cQM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388BF1F00897;
	Fri, 27 Nov 2026 14:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795791491;
	bh=PzCwcsdujtzXaGsZkDusvoM2GFrPvOTFYYksQXR49Mw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QT70/cQMs5f9zKaSZdqGe+bssxLG1NGxEslU0syiYNz6hwFR2DdQ+MB4iQR3rmBOP
	 TCWRqKVGk+bnI8JOHJc/Hy/1KVAq55q4XdTQrsSflVwk7cONfJCEDqHDIqC0zXE1a/
	 a4e+eduWexOsIqQV4CCusUBMY1UFVxTyf9CpfYcrMmhulpF4AqyQHmrGt6TLiJiC5N
	 cf24enLpsVOmCZlXZvFKAzpYzi1F5uXmlDZ89lKjqLKpxVVPCp5k+iswyz8uJ7vc5V
	 olrk2zRRo1sha+ZKGnMDyrmBay1W99IBBxcGf+KyzLhO+oUCwhjfK2LZ7yvJlbsGAf
	 l1QtS4JpLpbwg==
Message-ID: <sashiko-outbox-237641@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/11] net/xsc: add the single TX/RX channel
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126145733.70868-9-tianx@yunsilicon.com>
References: <20261126145711.70868-1-tianx@yunsilicon.com>
 <20261126145733.70868-9-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 14:58:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [Medium] net/xsc: return -ENOMEM on di alloc failure in
  xsc_eth_alloc_rq()
- [Medium] net/xsc: disable NIC HCA and port before queue teardown in
  xsc_eth_close()
- [Medium] net/xsc: WQ DMA buffers freed on xsc_core_eth_destroy_qp()
  rollback failure
- [Medium] net/xsc: unsafe CQ teardown and memset on failure in
  xsc_eth_close_channel()
- [Medium] net/xsc: unsynchronized set_dev_node() in
  xsc_dma_zalloc_coherent_node()
--

commit 72a1cf783f0fa5afa01bbb9581c2a8a19828e758
Author: Xin Tian <tianx@yunsilicon.com>

net/xsc: add the single TX/RX channel

This commit brings up a single TX/RX channel on the netdev by building queue
parameters, creating the CQs, SQ, and RQ, enabling the NIC HCA, and adding
the queue ring and fragmented DMA buffer helpers.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/net/main.c b/drivers/net=
/ethernet/yunsilicon/xsc/net/main.c
> index b9e75d7e14e78..1c7bbc27d8c4f 100644
> --- a/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> +++ b/drivers/net/ethernet/yunsilicon/xsc/net/main.c
> @@ -25,6 +25,774 @@ static void xsc_eth_netdev_init(struct xsc_adapter *a=
dapter)

[ ... ]

> +static int xsc_eth_open_qp_sq(struct xsc_channel *c,
> +			      struct xsc_sq *psq,
> +			      struct xsc_sq_param *psq_param)
> +{

[ ... ]

> +err_sq_modify_in_destroy:
> +	kvfree(modify_in);
> +
> +err_sq_common_destroy:
> +	xsc_free_qp_sq_db(psq);
> +
> +	xsc_core_destroy_resource_common(xdev, &psq->cqp);
> +
> +err_sq_destroy:
> +	xsc_core_eth_destroy_qp(xdev, psq->cqp.qpn);
> +
> +err_sq_in_destroy:
> +	kvfree(in);
> +
> +err_sq_wq_destroy:
> +	xsc_eth_wq_destroy(&psq->wq_ctrl);
> +	return ret;
> +}

[Severity: Medium]
Can this free psq->wq_ctrl while the SQ is still live in firmware if
xsc_core_eth_destroy_qp() fails during error rollback?  Unlike
xsc_eth_close_qp_sq() and xsc_eth_close_qp_rq(), which leak the WQ buffer
when DESTROY_QP fails so the device cannot DMA into freed pages,
err_sq_destroy here and err_destroy_qp in xsc_eth_open_qp_rq() ignore the
return value of xsc_core_eth_destroy_qp() and unconditionally free the WQ
DMA buffers (and prq->page_pool in the RQ case).

[ ... ]

> +static int xsc_eth_alloc_rq(struct xsc_channel *c,
> +			    struct xsc_rq *prq,
> +			    struct xsc_rq_param *prq_param)
> +{
> +	u8 ele_log_size =3D prq_param->rq_attr.ele_log_size;
> +	struct page_pool_params pagepool_params =3D {0};
> +	u8 q_log_size =3D prq_param->rq_attr.q_log_size;
> +	u32 wq_sz;
> +	int ret =3D 0;
> +	int i;
> +
> +	prq_param->wq.db_numa_node =3D cpu_to_node(c->cpu);
> +
> +	ret =3D xsc_eth_wq_cyc_create(c->adapter->xdev, &prq_param->wq,
> +				    q_log_size, ele_log_size, &prq->wqe.wq,
> +				    &prq->wq_ctrl);
> +	if (ret)
> +		return ret;
> +
> +	wq_sz =3D xsc_wq_cyc_get_size(&prq->wqe.wq);
> +	prq->wqe.di =3D kvzalloc_node(array_size(wq_sz, sizeof(*prq->wqe.di)),
> +				    GFP_KERNEL, cpu_to_node(c->cpu));
> +	if (!prq->wqe.di)
> +		goto err_destroy_wq;

[ ... ]

> +err_free_di:
> +	kvfree(prq->wqe.di);
> +err_destroy_wq:
> +	xsc_eth_wq_destroy(&prq->wq_ctrl);
> +	return ret;
> +}

[Severity: Medium]
Does xsc_eth_alloc_rq() return 0 when kvzalloc_node() fails to allocate
prq->wqe.di?  Because ret is still 0 from xsc_eth_wq_cyc_create(), jumping
to err_destroy_wq frees prq->wq_ctrl.buf and returns success to
xsc_eth_open_qp_rq(), which then reads the freed prq->wq_ctrl.buf.frags in
xsc_core_fill_page_frag_array() and double frees prq->wq_ctrl on teardown.

[ ... ]

> +static void xsc_eth_close_channel(struct xsc_channel *c, bool free_rq)
> +{
> +	if (free_rq)
> +		xsc_eth_close_qp_rq(c, &c->qp.rq);
> +	xsc_eth_close_cq(c, &c->qp.rq.cq);
> +	memset(&c->qp.rq, 0, sizeof(struct xsc_rq));
> +
> +	xsc_eth_close_qp_sq(c, &c->qp.sq);
> +	xsc_eth_close_cq(c, &c->qp.sq.cq);
> +	memset(&c->qp.sq, 0, sizeof(struct xsc_sq));
> +}

[Severity: Medium]
What happens in xsc_eth_close_channel() if xsc_core_eth_destroy_qp() or
xsc_core_eth_destroy_cq() fails?  When QP destruction fails in
xsc_eth_close_qp_rq() or xsc_eth_close_qp_sq(), the QP remains live in
firmware, yet xsc_eth_close_channel() still destroys and frees its bound CQ.
In addition, when xsc_core_eth_destroy_cq() fails, xsc_destroy_cq() returns
before waiting on xcq->free for in-flight event or completion handlers, and
the unconditional memset() zeroes xcq->free, xcq->refcount, and cq->xdev
while a handler can still be using them.

[ ... ]

> @@ -45,25 +813,46 @@ static void xsc_set_port_admin_status(struct xsc_ada=
pter *adapter,
>  static int xsc_eth_open(struct net_device *netdev)
>  {
>  	struct xsc_adapter *adapter =3D netdev_priv(netdev);
> +	int ret;
> +
> +	ret =3D xsc_eth_sw_init(adapter);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D xsc_eth_enable_nic_hca(adapter);
> +	if (ret)
> +		goto err_sw_deinit;
> =20
>  	adapter->opened =3D true;
> =20
>  	xsc_set_port_admin_status(adapter, XSC_PORT_UP);
> =20
>  	return 0;
> +
> +err_sw_deinit:
> +	xsc_eth_sw_deinit(adapter);
> +	return ret;
>  }
> =20
>  static int xsc_eth_close(struct net_device *netdev)
>  {
>  	struct xsc_adapter *adapter =3D netdev_priv(netdev);
> +	int ret;
> =20
>  	adapter->opened =3D false;
> =20
>  	netif_carrier_off(adapter->netdev);
> =20
> +	xsc_eth_sw_deinit(adapter);
> +
> +	ret =3D xsc_eth_disable_nic_hca(adapter);
> +	if (ret)
> +		netdev_err(adapter->netdev, "failed to disable nic hca, err=3D%d\n",
> +			   ret);
> +
>  	xsc_set_port_admin_status(adapter, XSC_PORT_DOWN);
> =20
> -	return 0;
> +	return ret;
>  }

[Severity: Medium]
Should xsc_eth_close() bring the port down and disable the NIC HCA before
calling xsc_eth_sw_deinit()?  Right now xsc_eth_sw_deinit() destroys the RQ,
SQ, and CQs and frees their DMA buffers and page_pool while the port is
still admin-up and the NIC HCA is still steering incoming packets to
adapter->channel.qp.rq.rqn.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c b/drivers/ne=
t/ethernet/yunsilicon/xsc/pci/alloc.c
> index 46eb0b031511d..0b0478c64be3b 100644
> --- a/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
> @@ -121,3 +121,105 @@ void xsc_fill_page_array(struct xsc_buf *buf, __be6=
4 *pas, unsigned int npages)

[ ... ]

> +static void *xsc_dma_zalloc_coherent_node(struct xsc_core_device *xdev,
> +					  size_t size, dma_addr_t *dma_handle,
> +					  int node)
> +{
> +	struct device *device =3D &xdev->pdev->dev;
> +	int original_node;
> +	void *cpu_handle;
> +
> +	/* WA for kernels that don't use numa_mem_id in alloc_pages_node */
> +	if (node =3D=3D NUMA_NO_NODE)
> +		node =3D numa_mem_id();
> +
> +	original_node =3D dev_to_node(device);
> +	set_dev_node(device, node);
> +	cpu_handle =3D dma_alloc_coherent(device, size, dma_handle, GFP_KERNEL);
> +	set_dev_node(device, original_node);
> +
> +	return cpu_handle;
> +}

[Severity: Medium]
Can xsc_dma_zalloc_coherent_node() use dma_alloc_coherent_node() instead of
mutating xdev->pdev->dev.numa_node with set_dev_node()?  Overwriting the
shared device's NUMA node across a sleeping dma_alloc_coherent() call
without locking exposes the temporary node to concurrent readers of
dev_to_node(&xdev->pdev->dev), and two concurrent callers of
xsc_core_frag_buf_alloc_node() can save the overwritten value as
original_node and permanently corrupt the device's NUMA node.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126145711.7086=
8-1-tianx@yunsilicon.com?part=3D8
