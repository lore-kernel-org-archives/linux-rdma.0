Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B2C36A35E;
	Thu, 16 Jul 2026 08:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784189689; cv=none; b=rb3eLQkDKzSrO4oLELKnin+Y/M5CHQC+YACiDa9MUwYf76sIkQ3ZJq146Y0KDbtRNrLCIQggioNE1gPgsbFcgGVqJtuMq7NJEbVMHUOuVcSyHv/cNfzvMi+hdparFnoimaXylwPNSMlk4ybcatSEIZyQzIXUYwfohV3ovejv8Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784189689; c=relaxed/simple;
	bh=RDYW39+rCA82Sd1rCyGKpi/jdVtRbs+yZCjffZXlPnU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=f/S6QO14FxQERIHeTVZK0yVI/KWgyfBePSyb0VtD1KxYDqxo5Wk4xSg4CcV5nDPLyWlLvKA9Lq/AnJxxk3GCfYq3KvLwQ4Rxz0g637wBNzwZuN19AfVXJfg8d56IEps5Hs+VF8b1OjW6GReokrAyg2dTaQLalMwzJEHzYF0jkGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M55tHtvB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M55tHtvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23EE11F000E9;
	Thu, 16 Jul 2026 08:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784189688;
	bh=fxJSyB0+B74i9Kjb9E5KLTTxqxqTtgejcScZmy1jYAM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=M55tHtvB9mYp/nYOy2WnBRQeJrWshKjQVBtpmr9RgbOkaJ1sZZ0LOWA0gUAlTFv8Y
	 86++qdInYE2pur8n/bvCj68VHg86Il392360ObCTJBUW3Opl3Ckz88eNerSYLR7bW5
	 L1GcvemISknlMireXZb/HATiIZ9v4DLMHZYFldemX/6svDkfmMLtemRr93bPINUjrT
	 8byuAbiXSIpyEKvHb93TxFpiRgpmgAnEePbfpE6/O8D0YZt24c5vG6/+rtQ9atD/7B
	 CaPn3OMXnIimvJmQykG3i69BpxcYLXjbwz/VUk9fBeqiPcgaSasv/ag8L+I/QvdAn1
	 5uDzKHBWtocKQ==
From: Leon Romanovsky <leon@kernel.org>
To: yanjun.zhu@linux.dev, zyjzyj2000@gmail.com, jgg@ziepe.ca, 
 Ibrahim Hashimov <security@auditcode.ai>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20260712121720.78001-1-security@auditcode.ai>
References: <20260712121720.78001-1-security@auditcode.ai>
Subject: Re: [PATCH v3] RDMA/rxe: fix responder UAF on
 IB_QP_MAX_DEST_RD_ATOMIC modify_qp
Message-Id: <178418968562.292019.4878349763423795235.b4-ty@kernel.org>
Date: Thu, 16 Jul 2026 04:14:45 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 12 Jul 2026 14:17:20 +0200, Ibrahim Hashimov wrote:
> rxe_qp_from_attr() handles IB_QP_MAX_DEST_RD_ATOMIC outside the
> IB_QP_STATE path, so it holds no state_lock and runs while the responder
> task rxe_receiver() (recv_task on rxe_wq) is live. A modify_qp() setting
> only that attribute calls free_rd_atomic_resources() then
> alloc_rd_atomic_resources(), swapping qp->resp.resources[] while
> rxe_prepare_res()/find_resource() walk it; free_rd_atomic_resources()
> also leaves the cached pointer qp->resp.res dangling. A local
> unprivileged user can race the free/realloc into a use-after-free in
> rxe_receiver() (local DoS).
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: fix responder UAF on IB_QP_MAX_DEST_RD_ATOMIC modify_qp
      https://git.kernel.org/rdma/rdma/c/a37da605b395b9

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

