Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD31F459AE4
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 13:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792072782; cv=none; b=jsD5GvRRXKJFLQ6XaMO8aiQGCDwVTt+JMtHxk9OGwmVbt6v8x4Bk6n4AmT0sVv7dNt0tm4alXDJUck0EHGxImcPbPad0JJDA2rJSpbF99nxsoUZ+dm5NCyLxBTIBWFPMwQjHntUFADBdkh1yHK1LAf7D6s68n7c1mpqUSC8jqqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792072782; c=relaxed/simple;
	bh=3vJkfL0evb4ucrt5TI847HFAOR5Q2oEDMbfuYQLxnxY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=P//AW/fAeLa9yox813cIcsw/iwq9UoEHznso4G3Iz9QiN3VvuekJoAh+TUNeEWgJqoik21KtWgOsZN+G7GS/Z1eKYY4YoTT4URfoMUrAOysNS2BLHNsSvPBngL/wtIQJIIfEv2r6Yj4JXfP7UUJh7vIrcKTs+T/U1s7iJPAQNW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LwY99jnh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LwY99jnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF8D1F000C4;
	Thu, 15 Oct 2026 13:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792072781;
	bh=E2CenWuVTvNR/gPLevAauUfamdoDTEHfY4aWxJ1Fa94=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=LwY99jnheCVL/fnNzm/DXumHpDfkiN16K5BRJfVHJZtORP8SWesrLUfBA1MArVCHw
	 9PU0NQcZKtw0RrjYaGFdITtA0U9az6nJCkme4niutar+LJbqqUt7QnDnRlYp6Sawlm
	 2i1ccinNiEjVDd/9KAfiCT4jbAvJnj9zAfiYI5rbcXNY5pO03FDEX9UWPPOieDEMnJ
	 HqDGDUb1gm2UZjCEnUXg56Tvqog7eFgh7ssmLuJPOE0HK8QLS6asBKFBvMR7qyOqS6
	 RutaKncgb5QkZFK4TFsiqK8cxAz638xj5NYX1h0YCgAiz+OifZj4bv/TZ45VazgwYs
	 T1IQIl7TRoxwA==
From: Leon Romanovsky <leon@kernel.org>
To: zyjzyj2000@gmail.com, Youngsung Ahn <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org, security@kernel.org
In-Reply-To: <20260930182223.2511145-1-ays511.kr@gmail.com>
References: <20260930182223.2511145-1-ays511.kr@gmail.com>
Subject: Re: [PATCH] RDMA/rxe: refuse to destroy a QP with type 2 MWs still
 bound
Message-Id: <179207277849.164616.17601279882035588346.b4-ty@kernel.org>
Date: Thu, 15 Oct 2026 09:59:38 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 01 Oct 2026 03:22:23 +0900, Youngsung Ahn wrote:
> Binding a type 2 memory window takes a reference on the QP:
> rxe_do_bind_mw() does rxe_get(qp) and stores it in mw->qp. That
> reference is released only when the window is invalidated
> (rxe_do_invalidate_mw() on IB_WR_LOCAL_INV) or the window itself is
> destroyed (rxe_mw_cleanup()).
> 
> rxe_qp_chk_destroy() does not account for those references -- it only
> refuses when qp->mcg_num is non-zero. So an unprivileged user can bind
> a type 2 MW to a QP and then destroy the QP while the binding is still
> live. __rxe_cleanup() cannot drop the QP refcount to zero (the MW still
> holds a reference), hits its -ETIMEDOUT path, and frees the QP anyway;
> mw->qp is left dangling. When the MW is later invalidated or
> deallocated, rxe_mw_cleanup()/rxe_do_invalidate_mw() do rxe_put(mw->qp)
> on the freed struct rxe_qp -- a use-after-free write (refcount_dec, and
> complete()/list work if it reaches zero) reachable from userspace.
> IB_WR_BIND_MW is a local operation, so no peer is required.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: refuse to destroy a QP with type 2 MWs still bound
      https://git.kernel.org/rdma/rdma/c/9e61a2ac6590e9

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

