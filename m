Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46304EA378
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 08:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792054629; cv=none; b=MHCGxQUTGfBaxL9haVoMgGIRUiPEj2xFaOU9g5lQqW2M4PI0VmuJHIw1I3SFl1Ln5+EkXd4F1/MJyJgr5nQl9J1u/j+j50xjcqJ0ReT+E4o7hunQhRCaIjB1seVR0k8jopLeeLfELdSu31Jwb9uAyl/q1cArU6XXL14DgFLz55E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792054629; c=relaxed/simple;
	bh=vZFbMe9eDeP8TfeuExjSHCXVxgImnb5Wo7TVkiV0CF8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=OXwwKIfyK5W9z9JRBXXUIF6KmYfuP/GPDXQ1R7rsh6QgD8zmS+qS22OZPvVqR+HgSu9P6zViwnz40kDg1zd8CHpH8AQMYb8SHr8aZVxWoMz7xCOp+sHhmsUnDyl+2cFOGMSKTG0lk/wXaNAREwy5zfsZzXObJCF7/pni/m4jI5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QhSME9n4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QhSME9n4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D3A1F000C4;
	Thu, 15 Oct 2026 08:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792054625;
	bh=vZFbMe9eDeP8TfeuExjSHCXVxgImnb5Wo7TVkiV0CF8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QhSME9n4qIb1BhaE9hyvdaoAzKIsv+hbY86CX0stORIhZJmh7VlW6M06j2ag1yxKR
	 hbyUvvB63gbeyqpt1cVR/MSRRlcdDKVgKsc/lZ3WthMIISy2KBqRJIcpyi+IDELg7e
	 wwIbjIQurO5jld6xYx07AVqJTucJofG20I/VlWhH6OI8XDJVdXPOIyYJg9AKKpJmZf
	 kOjqZ4ZqyzAp2+R5ol1L+i/qq5foZBUtmp3Gu9tcVeX/HpQ7+d52Qbn9b4ur7WaWsV
	 WzMKPCjiclKcBcbslITa2IdrBaWfRWMZS4AMme7X/TPhr4gD+VAA+rJD6kPcueAceH
	 fQ8Bn4+MqNiJA==
Message-ID: <sashiko-outbox-172527@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc 1/2] RDMA/uverbs: Fix uobject leak in DMABUF
 release
Reply-To: sashiko-reviews@lists.linux.dev
To: "Deep Shah" <deepshah146@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261015083637.200958-2-deepshah146@gmail.com>
References: <20261015083637.200958-1-deepshah146@gmail.com>
 <20261015083637.200958-2-deepshah146@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 08:57:04 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> uverbs_dmabuf_release() treats a NULL uobj->context as an aborted
> allocation, but normal ufile cleanup also clears it. Closing the uverbs
> FD before the dma-buf FD therefore skips uverbs_uobject_release() and
> leaks the uobject and ufile references.
>=20
> Clear dmabuf->priv before dma_buf_put() on allocation failure and use
> that NULL pointer to identify an abort. Otherwise, always call
> uverbs_uobject_release(). This also avoids reading a freed uobject if
> release is deferred until after the allocation has been aborted.
>=20
> Fixes: 0ac6f4056c4a ("RDMA/uverbs: Add DMABUF object type and operations")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Deep Shah <deepshah146@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015083637.2009=
58-1-deepshah146@gmail.com?part=3D1

