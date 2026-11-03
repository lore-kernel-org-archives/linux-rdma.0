Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713009;
	b=mWHs3SUbX5fecTqRqYo9AxxnvmFg/qNOLfvKEt+M7SKznP9G2Q2Y1cAh+bRycCEnlAgm
	 sF08zw8XeOo199joUGxuS8kH33VTZUVW+rjKQ1HcRTJwsekReMAWtYs26WgUfZJl7vdYW
	 6eZsC3qsO9vnmlTcaOfQiMAePluM+s0aRxhiRtT8/dDsHiob6Xp/vDQPYFQci5r2frMAZ
	 Rx2NSf44NGRC05lHRcM77qWLN3zVdPDEXWikOOfW6mSzmkRXJUsPQ0JqgRUQYSla0kk7n
	 14YB1+3Ug0n19lkLUJmQAyL63aRu35B8phImFpXG/LMCLu0Jw1arnjPG3UcH4btClFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713009;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=5REs0PQyy1aQTV9SDNqWmprxjCocKmaoWo19CLVO858=;
	b=S+fUReCHx0RcF2u58MtFP2K8qBIDSqaqV1IRvBrzMclhPx8wUGFjNqztAqVHCFVPzeov
	 sAjWTeQpaxoXJt9w/gJGWx/DRAi/4WxQAfIa0DjYISE3tLvf7UptEtAyPhhUu87PKp2Co
	 +QDZtoCuqmTT2H6ZYp71oECN9li82JeWZmk7P/8A3+v9yPkKzrsqIxWfuQByIg22wUt62
	 GseGhnrdQOigIeZOcy202cAJ0FXru9sHJMwEYINeQ4RdrkojtGx1lKqrC8rGzvIoKRTnX
	 bs3xMuQAY7p00ui2abJgxFo+jExeXBoLW2NCH937CdUKgnZsu6SOYfmKjt/9FyPF9Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=laCcPKsp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E6B606A32F;
	Tue,  3 Nov 2026 13:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=laCcPKsp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6341F000C1;
	Tue,  3 Nov 2026 13:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793713008;
	bh=5REs0PQyy1aQTV9SDNqWmprxjCocKmaoWo19CLVO858=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=laCcPKspajLFrlqK9cNREzQ7HYsMT514yRxqfPoJJ0rfbsUH7f//Um3i0bRFdqaM6
	 BS8l8Tc8qkob5QUyQbNZCVhsDMbhM2A8AbfGDl5jz+xLowEdP2CPjVNy5P8CHHZoM6
	 PDJwYMVgHiKqbssI5s1al0kj22uqzvmwPtfKXUwvIGkTFAUHpTdfGjbuhsFlLyANI/
	 Nv1HX3YCdUusAZH+VDpplmEZsFc9JwD3S4PRB2iIbMuDFQIQGhVnhkvEBq6Rc8AkdP
	 YhbA93/lTjvUn/6Nm4j4zyVDgRzKkv5Ocgx1/VL8mm//y4dmddAgz3xiGYdpZRsdwx
	 PEmScpb6RU5oA==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: allen.hubbe@amd.com, nikhil.agarwal@amd.com, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Keith Lucas <keith.lucas@oracle.com>, 
 stable@vger.kernel.org
In-Reply-To: <20261030082402.841751-1-abhijit.gangurde@amd.com>
References: <20261030082402.841751-1-abhijit.gangurde@amd.com>
Subject: Re: [for-next 1/1] RDMA/ionic: Use a linear QID space when
 udma_shift is zero
Message-Id: <179371300602.1727061.708492342043734954.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 08:36:46 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 30 Oct 2026 13:54:02 +0530, Abhijit Gangurde wrote:
> Firmware reports udma_shift as the log2 of the number of queues in
> a queue group. A value of zero means the queues are not striped
> across two UDMAs, so the QID space is linear and the device has one UDMA.
> 
> The interleaved bitid/qid transform treats bit 0 as the UDMA selector
> when the group shift is zero. QID 1 then becomes bitid
> 1 << half_qid_shift, and freeing that QID releases the wrong allocator
> index. Skip the transform and select one UDMA so QP and CQ allocation
> uses the QID directly.
> 
> [...]

Applied, thanks!

[1/1] RDMA/ionic: Use a linear QID space when udma_shift is zero
      https://git.kernel.org/rdma/rdma/c/687a1e161457b2

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

