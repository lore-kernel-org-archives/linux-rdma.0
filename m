Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A4E493646;
	Tue, 15 Sep 2026 11:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789470991; cv=none; b=so+WD84FK/fXP+9UrCwTbflW0ESFu+L18/DHvO1A3XYqU5uBrkaCPNOHuV9/wOBPNZdfMUmFRRdm0130DzoRsu+3vyj3j2tnaUuJUk+MpC5BKYpltaEQJ6iavyBqHOzNgaXwfnSKFKmRELxu/Sb1p6QROOWu+pA/otrDfVeiwB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789470991; c=relaxed/simple;
	bh=eRGHVoKYzXdjnkH5LznyqUqVZdIKv9ZTvmeMvsMfG+0=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Wjjh5abzZTmWGg3w6ZbxI6yzCHZ6KrnEPKDhBDid3Houi5uW8BMgXw9MWwQyyog0a2ONjNqzsnCacAeqFQS7nAanRYHqlkrwLQGV67sjYgspf0lcFMRLyOvECA2+icvsBGgrZTIoXmD2g5R1ri6kvFYs3T1IstcPS0gtgZxrDb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G8EfeTs3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G8EfeTs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3561B1F00893;
	Tue, 15 Sep 2026 11:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789470989;
	bh=bBHa0nrpFqvj1h4STpmvMh3HTgPBp9v0aoOLPqed4KY=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=G8EfeTs3VPdpkBXraU0FYK4/I5Rlvd0KWgg7bqxe+3nl1BROKrYBdQnbSubT2GrP4
	 51AuYZ9vymYFFh3TV8qjJyCN1q6x8R1skWp7NT3Qx829yVaCERhX37UpltNB4sDZzV
	 /cBGxL+2gm15N/qR5BsFR9djsFi4hQs5m1mgQxtqhDCh6hHjwV0dAPvbQzIF4FBIpc
	 tkl73Qfo6VnqfxRXyltUOvERPKT9oGzPHpevb5W02Lm6vjfthG7g/2Z9uHVbJc87Hf
	 P0Fyz50WfhGgY0Oa7wPqUlpXyDuKu/Ky+73UthAXnBmQm1e/qSHWL3ByXPeGy3swpv
	 tWlAj7dqFmK4Q==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@mellanox.com>, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 lirongqing <lirongqing@baidu.com>
In-Reply-To: <20260911021557.2113-1-lirongqing@baidu.com>
References: <20260911021557.2113-1-lirongqing@baidu.com>
Subject: Re: [PATCH v2] RDMA/uverbs: Make CQ handle mandatory for WQ
 creation
Message-Id: <178947098678.1230106.15681890155815264544.b4-ty@kernel.org>
Date: Tue, 15 Sep 2026 07:16:26 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 11 Sep 2026 10:15:57 +0800, lirongqing wrote:
> UVERBS_ATTR_CREATE_WQ_CQ_HANDLE is declared UA_OPTIONAL in the ioctl
> method definition, so the mandatory attribute bitmap does not enforce
> its presence.  When userspace omits it, uverbs_attr_get_obj() returns
> ERR_PTR(-ENOENT) and the handler stores that error pointer into
> wq_init_attr.cq without validation.
> 
> The bogus cq pointer is then passed to the driver's create_wq callback.
> In the mlx5 case, create_rq() calls to_mcq(init_attr->cq) which applies
> container_of to the ERR_PTR value, producing a near-NULL pointer.  The
> subsequent access in get_rq_ts_format() triggers a kernel NULL pointer
> dereference:
> 
> [...]

Applied, thanks!

[1/1] RDMA/uverbs: Make CQ handle mandatory for WQ creation
      https://git.kernel.org/rdma/rdma/c/f7d28791433d37

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

