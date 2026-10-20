Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792491696;
	b=gjBHA6o/cUNOWK04FHczHJ1fFTcqusGHguClRIqOfOsA84ibTGE9Xly+JqRFqwmKIQFi
	 N0vcFTqNT7EuioJbqGNCcmKkbOMIPQ71zfIXPQgTpHazPf2BMUioNVQZK/VmWcVoIDace
	 Oac9DmqWIXxe7sUp7rG6jSlzZregChlq4FBm39tf6iu0U8MTR/4FkkQ7iWkKMkM46Q5iD
	 cAGxihsCXLv9dqUuLzvO9BnrmW6BezLr1tg3BfwSScJS9JjSCIcCuebQAeIitItgJqsAq
	 dkzljZkpDWzYP7qAOELAOsVCaFXdsKgcfpe5LJtmabj2zVDfdtQ0Whjo9yjFuP89NwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792491696;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=sLkVzjX1l2hLP7ZsDWwT29QsYQw9dp6JDO7H3p3t6UI=;
	b=UQq7+earzPNjnXpIgPjWCpLT3w2AhkNcJUTPsvpHmaa0ce1ylTzBXBft9Jhjr1rTpRIP
	 7rgpZPugNQ3Q1Q5kCxLWQnqGHu4XBg0kWxMeqwP9AkdsIdhmqId7VrEHmidEmfK8ae/Ry
	 cDgjNvU2VveV7OLz6fnULb+J8y5k7MCUacp/0Qzd10yAQE6hiELs4x7KcqwK+d+5sfUHd
	 YkSpzDrOlYWqNcE6CrMUlnNV7u/iICvmJaGdECx9FDQDk2HM65BBfFSPAdzhdZRlFoxRs
	 cQ99a4GsPF8/+hNo/ad0LK1k2PXcZ/1JFMFJN3Ie+TAIZFEqIvfK/iQ2Ix5Cmadt1sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eYgHvt4+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E68606A31A
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 10:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eYgHvt4+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DF61F000C4;
	Tue, 20 Oct 2026 10:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792491696;
	bh=sLkVzjX1l2hLP7ZsDWwT29QsYQw9dp6JDO7H3p3t6UI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=eYgHvt4+qvGt2Pp9Q9PCLaRHRKdkjUqFOdzcoHh8DvefTSmXzKz/VCdVwCu55Sdnu
	 KDrzUDGSXNQwTr1v/5oRYSz6ZOoXJweuvdxy1yWYpKtZoJA9kfywc+KiUytJtjwB2C
	 O4dWRJUr41E+xlddEY4pMWueuFtVhT6w8SiNgEzCqODbixm7dv5YE6vgf731H9s+zb
	 zuElBB6RldJuDgw1dv8way61h+/yooVEbXaIjqvawcRaRavcZsHo+V0kAKG3Ao6ocM
	 auVf09oYWEakxnb1CAB7ZTcJX2Il9Y/rnjtLflqKlY3U3DBzJwgv68aasUkH1bHrys
	 HGwcn4wEF+qIw==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Sunny Tiwari <sunnytiwari@google.com>
Cc: linux-rdma@vger.kernel.org, jmoroni@google.com
In-Reply-To: <20261017052856.3570063-1-sunnytiwari@google.com>
References: <20261017052856.3570063-1-sunnytiwari@google.com>
Subject: Re: [PATCH] RDMA/irdma: Bound in-flight CQP ops across deferred
 completions
Message-Id: <179249169324.630872.17353058629187832033.b4-ty@kernel.org>
Date: Tue, 20 Oct 2026 06:21:33 -0400
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


On Sat, 17 Oct 2026 05:28:56 +0000, Sunny Tiwari wrote:
> On IRDMA_GEN_3+ devices, CQP operations can complete in two stages:
> Stage-1 on the CCQ acknowledges receipt and moves an entry from
> cqp->ooo_avail to cqp->ooo_pnd, while Stage-2 signals final completion
> via an AEQ event or a subsequent CCQ CQE.
> 
> In irdma_sc_ccq_get_cqe_info(), Stage-1 processing advances
> cqp->sq_ring.tail so the SQ descriptor slot can be reused once consumed
> by hardware, whereas cqp->completed_ops is only incremented on Stage-2.
> Because irdma_cqp_ring_full() only checks cqp->sq_ring, a burst of
> backlogged commands in dev->cqp_cmd_head allows irdma_process_bh() to
> submit more concurrent in-flight CQP commands than the maximum supported
> limit (cqp->sq_size - 1) while earlier commands await Stage-2. This
> causes CQP completions to be lost and synchronous waiters to time out
> with -ETIMEDOUT (-110).
> 
> [...]

Applied, thanks!

[1/1] RDMA/irdma: Bound in-flight CQP ops across deferred completions
      https://git.kernel.org/rdma/rdma/c/c3e8e9451e6f1b

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

