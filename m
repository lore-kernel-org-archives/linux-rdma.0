Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0E830AABE
	for <linux-rdma@vger.kernel.org>; Wed, 17 Jun 2026 11:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781694371; cv=none; b=QFLG0luCXuJtp+osYUvJlpJLKrFn6b6QHciADQtQFaNtnVRgAGoMoqDHNOGdBSt8medDiu6rZ0dRVr6eY1dKzkk9dSl5+scoyZNiud5BUaLCtZckx1ecIOHyFwGTXpmG01nFl22KUhaCDtQmFXHI4RlTqakpxqNWY3b0gikULIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781694371; c=relaxed/simple;
	bh=J+oLaiyqK45OlNLXcSs2TFa4nMzb28mHaFn63qDxQmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oWv0CPNSAj4umN79IJzvXVZZmZHT5gGxrZpIn9vpxqehg9DaI0+ObnlJUUopWVLBrWxHwOFXdVErVS9LfovIiSLlPod/8uHn6Pf/v9u4cI1mhHCvOebXSwkwdYvFBByMHEiHBoVLjHgnwyfSUp3EiRRMGhGruwQeRLr/RtdmKJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jj2R9OX3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jj2R9OX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799F81F00A3A;
	Wed, 17 Jun 2026 11:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781694370;
	bh=+d2UtPQvJQdF1vdCxQDXcrINoipyrt8LagZ/wY8BDIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jj2R9OX3+NEIHJgoxGNn0+ZEl5AheWFEOBtCMgX8nlvT/5hra+OQTpb5jyAxGww7u
	 8KkvknkjeQIKbGq0Y7+e7rRQxVqaUaVEsDVfU/Q/X7arOSbDCj6TGtezEMhKdDqvG0
	 nqCd3Lz2oW3D2Y14r+QrEhpiQcD2tixRH3KmPZ5L/X/updWLDUTVIKldLQY/uD116H
	 9U8CIfy6UqovlIqGpUksvwqZxePQtHkmjlwz3207Nrcy1FE4lQr7iZRRhEs0z0u8eJ
	 AhCMIMqn4wbP2LfpaMx1hg0Bs/pKLLPxEgRC/kwbg8wNgp3O3VxNyKVVjpj2n+cDF4
	 RdaOfMY996nfQ==
Date: Wed, 17 Jun 2026 14:06:05 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-rdma@vger.kernel.org, jgg@ziepe.ca, mrgolin@amazon.com
Subject: Re: [PATCH rdma-next v2 4/6] RDMA/uverbs: Add ioctl method for CQ
 resize
Message-ID: <20260617110605.GV327369@unreal>
References: <20260615085040.1396623-1-jiri@resnulli.us>
 <20260615085040.1396623-5-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615085040.1396623-5-jiri@resnulli.us>

On Mon, Jun 15, 2026 at 10:50:38AM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Resize CQ is currently only reachable through the legacy write()
> uverbs command (IB_USER_VERBS_CMD_RESIZE_CQ). Add an equivalent modern
> ioctl method, UVERBS_METHOD_CQ_RESIZE, on the CQ object so the
> operation is available through the ioctl interface and can carry
> per-attribute extensions. The handler mirrors the legacy command: it
> looks up the CQ, calls resize_user_cq() and returns the new cqe count.
> The legacy write path is left in place for ABI compatibility.

I have a general question. Do we actually need CQ resizing, given that it is
rarely implemented and often incorrect in existing drivers? Maybe this is a
good time to consider deprecating that path.

Thanks
