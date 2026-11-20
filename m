Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795142629;
	b=5Q6inEQk+luUbJ3Yk3LOaJYkB+kGA0X6aQTnM9GGKsiyLqVS6NEVjVzqR+3FXpijNnAM
	 4Ym62xOpw2d3zT4fysfVAP6gf93wlL+3LfD1A5qA/q+0raoBWfSceQe2BPUKtKQ62pyL5
	 cvxO1LpoGXxDk0EGd+7+6ywbNMbXspWmCygW3Q+0ITELu2hUR+cWGVvkiJXMEBymgEGss
	 eqWE/oat1CbYH2uZ369PFixLVsB13lC96otHrb4tO6YjMCLXWobbsjCVA8RH14rSigSGp
	 6yv2CMdtNwzSGqG1I8PO5oGgLs+PVD/lt7qBFPDNadoWBSEWCWkOBiuoWDckz98YxlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795142629;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=MvKGYFn44nLBmp5gVMRZHWmkvoqsHonCJrDJdxX86W0=;
	b=0HKg6wmwQNyiViTpocWNaQ5QCCVSV4NVclrANNSZSS7qKFtrU2f9fGXFgkhniqH1iGb8
	 ReCfpw34y84gTJ2wK9oC0xq4+nIXVenGVCDs2dSFd1E4g478DqYmOxg+MJy03rtvsKsw9
	 B8Hl0IyVyWocNwsPCxnN8w0ZCW+lKI4wRSbH09+QvZIZMToI2lIzwFAojjW7ri9zGpe+U
	 lrou9saJPB4xEKEbfFYWlRTxdV2qW+NOIIXK510V/vFCxw3EmyDtzxPfyN2lyrqvv9b9e
	 WKdT2ENv+VvUyhaPnvWV3WU2AJL+Z+XLXRXt/g0yYRkkUANAe2pNw4mmGOPxlL1y2eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TZxjX2Dc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71F9606A320
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 02:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TZxjX2Dc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379701F000CA;
	Fri, 20 Nov 2026 02:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795142629;
	bh=MvKGYFn44nLBmp5gVMRZHWmkvoqsHonCJrDJdxX86W0=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=TZxjX2Dc3/zk3fq/2Us0Fof6p9nPLNAWwdZ9PkW1C6B6xGokpAUAtHdC07dlYjkuI
	 Vb+VRl0trljKk6Tu4HV8P74ZieUMuZDFRco0NGCyR4UBvF66VdXKhSkuJ4PF18EtR7
	 FWLnX2pnQP9SdXvsflBwq/ErGoThUH5xtUgGZdaZm3Mdd1qwUqil65bneIu5JDI9nX
	 UfSSljHdWfIhDMco3n6exTFgVzxBXBEdW64LC69sI9RZI/WSbKmbOiKs1baM/KgILn
	 rAcVd/2Q8H02+epbwpzXUtjTY/65n2XtC6iTIfkK0zMkGJWedpvzKPc/EMASxGtMPe
	 jWQDaRgsqfWvA==
Message-ID: <sashiko-outbox-224377@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/cma: Use a separate lockdep class for the
 listening cm_id
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?U2hpbidpY2hpcm8gS2F3YXNha2k=?= <shinichiro.kawasaki@wdc.com>, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org
In-Reply-To: <av-vJXx2CZppcnAW@shinmob>
References: <20261117113129.746490-1-shinichiro.kawasaki@wdc.com>
 <sashiko-outbox-218731@kernel.org> <av2QarZ0_u32MHzM@shinmob>
 <av-vJXx2CZppcnAW@shinmob>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 02:43:48 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] RDMA/cma: missing Signed-off-by trailer in commit message
- [High] RDMA: debug msleep() in siw_accept(), nvme_rdma_alloc_queue(),
  and nvmet_rdma
--

commit e60962bf8161cfd3de3b001dc6bdc13944ed9245
Author: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

> RDMA/cma: Use a separate lockdep class for the listening cm_id
>
> On Nov 18, 2026 / 20:53, Shin'ichiro Kawasaki wrote:
> > On Nov 17, 2026 / 11:48, sashiko-bot@kernel.org wrote:
> > > Thank you for your contribution! Sashiko AI review found 2 potential
> > > issues to consider:
> > > - [Medium] RDMA/cma: unsafe lockdep_set_class() placement in
> > >   rdma_listen()
> > > - [Low] RDMA/cma: unreclassified handler_mutex on
> > >   nvmet_rdma_enable_port() error
> >
> > I think the two issues are valid. The first one means that the approach
> > to reclassify ids in rdma_listen() does not work well. I will think abo=
ut other
> > solutions. One idea is to go back to the solutions to add a new functio=
n to
> > create rdma id. The other idea is to reclassify the rdma ids not for
> > listening. I will try if these approach can address the sashiko issues.
>
> While I worked on the new patch to reclassify the rdma ids not for listen=
ing
> but for other requests, I ran a local Sashiko review on it before posting.
> Sashiko made the comment below, quote:

[Severity: High]
The commit message is missing a Signed-off-by: trailer, which is required
under the Developer's Certificate of Origin.

> diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/s=
iw/siw_cm.c
> index ed49818793dde..bea7c7aacd678 100644
> --- a/drivers/infiniband/sw/siw/siw_cm.c
> +++ b/drivers/infiniband/sw/siw/siw_cm.c
> @@ -1738,6 +1738,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_co=
nn_param *params)
>  		siw_sk_assign_rtr_upcalls(cep);
>  	} else {
>  		siw_qp_socket_assoc(cep, qp);
> +		msleep(300); /* REPRO: let the host send before ESTABLISHED */
>  		rv =3D siw_cm_upcall(cep, IW_CM_EVENT_ESTABLISHED, 0);
>  		if (rv)
>  			goto error;
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 32189fdfc0f51..e8c55dfad9d54 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -583,6 +583,8 @@ static int nvme_rdma_alloc_queue(struct nvme_rdma_que=
ue *queue)
>  	struct sockaddr *src_addr =3D NULL;
>  	int ret;
> =20
> +	if (idx =3D=3D 2)
> +		msleep(1000); /* REPRO: connect I/O queue 2 later */
>  	mutex_init(&queue->queue_lock);
>  	if (idx && ctrl->ctrl.max_integrity_segments)
>  		queue->pi_support =3D true;
> diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
> index f386c388da188..cde0315ae71e4 100644
> --- a/drivers/nvme/target/rdma.c
> +++ b/drivers/nvme/target/rdma.c
> @@ -1673,6 +1673,8 @@ static void nvmet_rdma_queue_established(struct nvm=
et_rdma_queue *queue)
>  {
>  	unsigned long flags;
> =20
> +	if (queue->host_qid)
> +		msleep(10000); /* REPRO: give time to unlink the port */
>  	spin_lock_irqsave(&queue->state_lock, flags);
>  	if (queue->state !=3D NVMET_RDMA_Q_CONNECTING) {
>  		pr_warn("trying to establish a connected queue\n");

[Severity: High]
Were these debug reproducer msleep() calls committed by mistake instead of
the lockdep class change described in the subject?

In nvmet_rdma_queue_established(), sleeping for 10 seconds on every I/O
queue runs inside the RDMA_CM_EVENT_ESTABLISHED callback under
id_priv->handler_mutex on the single-threaded ordered iwcm_wq workqueue.
This stalls CM event processing and rdma_destroy_id() for 10 seconds per
I/O queue, exceeds the default 5-second NVMe admin keep-alive timeout, and
forces open the nvmet_config_sem deadlock window.  siw_accept() and
nvme_rdma_alloc_queue() likewise add unconditional 300 ms and 1000 ms
delays during connection establishment.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/av-vJXx2CZppcnAW@sh=
inmob?part=3D1
