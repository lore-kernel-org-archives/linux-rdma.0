Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF474ED183
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 09:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846665; cv=none; b=Za9c+z773osG2mIoxBq0OyBzHhQLH7tPWvi/AHNiaINC8Clu/EtrhGIf9/OawH66RBQoEloN2AISmgUdqiCS7w0H/8tuvd/WUwnJKyN7rOpuwAt61eh9yHnsSKIRdeGRZnSBww42tPdt6vBF3ABl1gw9Fv2EeaRrCxmmRjPyXX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846665; c=relaxed/simple;
	bh=HBX9J/I15QlUqKjgeJSG6fQ9shFNES0oJkVPBZFg+Vo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=N4cxSI3Vi2v2Xn1i2Q9T+Iio0Ju4i0UHr+VOqYVQyhc+olRtTHn9LJEfFl9eSHFYV3rrJ4CpiscU1MjkXgzaOCfmXO7k2ZhoGes16JLJKwiCuFgVnY8P4PFJjkV4UyGPqYzh7CkVAgjdh8hLfCjjjI5b9hCKUXPPjiRpP5w+73E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HdEVSEsQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HdEVSEsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA761F0089B;
	Thu,  1 Oct 2026 09:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790846660;
	bh=3jpKVdzERfYrFBVURlHBqhXKegFc+YQP3ReoSl7AroQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HdEVSEsQsro9Plaax1w1yw7UNN9T+w0sDei2xVJytOm1fKAhebhMhG4O8kRgwCFS0
	 ohgqb9Glc1IYypux/wX+bItyc+VYnB3zz3qeC9UExhzc0YJrrKab4s4aJqT81WDEr3
	 BPxsUhzNXn3uvRxeorOfGgGsQRJu9VKkC2FFYe3rf1rgUd3Lbt6ANlP7STC2FojICu
	 T/bONuuxsIZZgtTf4NB5oO2FZKrStbxXNBH5+OkrUSolo2a7gIzRKz9zDu6yWGteaB
	 zm0XA1xnHx7K1hQH4ECBNauOvp4cYpwLBlKxpqSbN8aRp7+OJfspVlWvTGUyt97uii
	 t41Y7pWfhJN0Q==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v4 4/5] RDMA/ionic: add Shared receive queue (SRQ)
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930092111.3176738-5-abhijit.gangurde@amd.com>
References: <20260930092111.3176738-1-abhijit.gangurde@amd.com>
 <20260930092111.3176738-5-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 09:24:19 +0000
Message-Id: <20261001092420.0CA761F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] rdma/ionic: silent data loss when kernel polls SRQ-attached CQ
--

commit ccf1245b508acbe9a1128018da0500733eaed2c6
Author: Amit Kumar <a.k@amd.com>

RDMA/ionic: add Shared receive queue (SRQ) support

Implement device supported verb APIs for shared receive queue.
SRQ is supported for userspace only. ionic_create_srq() returns
-EOPNOTSUPP when there is no ucontext, so kernel ULPs cannot create an SRQ.

> diff --git a/drivers/infiniband/hw/ionic/ionic_datapath.c b/drivers/infin=
iband/hw/ionic/ionic_datapath.c
> index 522c6f08c9fdd..c5726c6bd5cb3 100644
> --- a/drivers/infiniband/hw/ionic/ionic_datapath.c
> +++ b/drivers/infiniband/hw/ionic/ionic_datapath.c

[ ... ]

> @@ -526,6 +526,12 @@ static int ionic_poll_vcq_cq(struct ionic_ibdev *dev,
> =20
>  		switch (type) {
>  		case IONIC_V1_CQE_TYPE_RECV:
> +			if (qp->srq) {
> +				ibdev_dbg(&dev->ibdev,
> +					  "srq recv cqe for qp %u\n", qid);
> +				goto cq_next;
> +			}
> +

[Severity: Medium]
Does this logic in ionic_poll_vcq_cq result in silent data loss for SRQ
completions?=20

If an unprivileged userspace application calls IB_USER_VERBS_CMD_POLL_CQ to
poll a memory-mapped CQ that receives completions for an SRQ-attached QP,
this block appears to process the CQE, skip it with goto cq_next, and free
the hardware slot without returning the completion to userspace.

>  			spin_lock(&qp->rq.lock);
>  			rc =3D ionic_poll_recv(dev, cq, qp, cqe, wc + npolled);

[Severity: High]
This is a pre-existing issue, but can the call to ionic_poll_recv here
trigger a NULL pointer dereference for userspace QPs?

If a userspace application calls IB_USER_VERBS_CMD_POLL_CQ to poll a CQ
containing completions for a userspace non-SRQ QP, ionic_poll_recv will
attempt to dereference qp->rq.meta[wqe_idx]:

drivers/infiniband/hw/ionic/ionic_datapath.c:ionic_poll_recv() {
    ...
    meta =3D &qp->rq.meta[wqe_idx];
    if (unlikely(meta->next !=3D IONIC_META_POSTED)) {
    ...
}

Since rq.meta is explicitly set to NULL for userspace QPs during
initialization when udata is not NULL, this seems to lead to a kernel
crash upon accessing meta->next. Is this reachable by unprivileged
userspace applications?

>  			spin_unlock(&qp->rq.lock);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930092111.3176=
738-1-abhijit.gangurde@amd.com?part=3D4
