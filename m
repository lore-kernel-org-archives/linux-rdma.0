Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083087;
	b=IeSirVW5+RlvS1MwsIgFv63ZaQDgl6j0DBsh5OSTvYlMTr1lunOZE7ne1M47MaY1sdD3
	 jHRLMS/PIYaLoarCv730JFsan2xDr9FQwT01QZ6k6J2REf2SgM7XehhrJU0tmAx/YQcW5
	 6clhbySpbZNX4R4aTuuVYBFUqQ32RON8JTSbIdO6KxYMoHQtu8izPjQeRo+v1AdRYweuv
	 mcTxnCfqnTtOpW+Y0o82rI2u766NlPd8PvJmX/Z3xqNursp07RU5Mia/BTgXgNPhswPoe
	 E3NoNKPCfLo/kHToHP1Epf1I70dMTnnLTizyIef5SSMkmyWZeVnZxGSCIBhh2YauDTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083087;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=5I5j3lcfn95BPYhvqhWqzDUccJWCWDr5bp0HOI0uXjs=;
	b=Ii9joYPZ+7QH1KjfhVr00EbIc8pNBaOqgKFktO5a7IdngXEoYA9IeJgnJqcQF0rDfqVf
	 t7mjKabIjbkjB52kuTRsoLlwzhqZmhJFKzdElL+LgEWhYF3Ku7lODflMyxqO0gxnYgOj/
	 WzHv9fBVMETkOP/I9xY0t51NsH79PpACVt1WirY8HCl9Q73jYQP9WL6tFQv04HqU85z8v
	 9VyKSU1koRFUlfqxzd2GeHAiwyM3tn10sik5CnpCIF3rr08V3I8pehzbG+VS4Mo29EjDc
	 cMXQETfdJU9E9YCCIwDhVQ8JRsZ1BvWhs0LWrgZlvZt688mR3FEOfGeQkz7TNZugfmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W2fbVZd7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672FF606A32C;
	Sat,  7 Nov 2026 20:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W2fbVZd7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C83A1F008A1;
	Sat,  7 Nov 2026 20:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083087;
	bh=5I5j3lcfn95BPYhvqhWqzDUccJWCWDr5bp0HOI0uXjs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=W2fbVZd7OWYdWRZknc8NX3xTE1F1qjNzhYm4UfixWL4hb7QdHDkqvYgo8xKanH7b/
	 40H2U7Mt4kAEIpS0mk7rxDRJ0z3SzV3kd3HJwkt4gaA6/uy4+KvXpP0Ycg9SXxoyQ3
	 13cee8t1Oe5ziOAjqsD/SSWBe6gilyzGDHP49fFcvhMH6zDxP7RCS8YQj8y7Bh56KN
	 rfw1QfIJKN10IZXFTYlwJjTAhB8cuq1SSjku9nhuXP5ATs1mNGkuBpQFhIoRPeMZYe
	 FQ/0ZlClddhOmq32X83QNdjb3Wi38BQdK7/aKu4QcMRxCMM/FncOR12oT7xBeuBjvS
	 vjhhi06SvKt6w==
Subject: Re: [PATCH rdma-next 05/23] RDMA/mlx5: Reject QP transport types not
 enabled by FW capability
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:24:46 +0000
Message-ID: <179408308609.994134.6909095699902527577@kernel.org>
In-Reply-To: <20261103163949.1554-6-yishaih@nvidia.com>
References: <20261103163949.1554-6-yishaih@nvidia.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message says the new rc/uc/ud checks in
  check_qp_type() (drivers/infiniband/hw/mlx5/qp.c) refuse 'a transport…

--

RDMA/mlx5: Reject QP transport types not enabled by FW capability

This commit makes check_qp_type() in drivers/infiniband/hw/mlx5/qp.c also
check the rc, uc and ud general capability bits. QP creation for RC, UC
and UD now returns -EOPNOTSUPP when the matching bit is clear. Before
this change, only XRC and DC were gated on capabilities.

> Check the rc, uc and ud capabilities as well, so that QP creation is
> refused for a transport the FW does not support.

[Severity: Low]
Could the commit message explain why this is needed and what userspace
will see after it?

As far as I can tell, the new lines in check_qp_type() are the first
readers of the rc, uc and ud bits anywhere in the tree. With trusted FW,
the change seems to only move a CREATE_QP failure from the FW into the
driver.

The visible effect seems to come from the earlier patch "net/mlx5: Add
capability filtering in adversarial mode". In caps_filter.c,
mlx5_adversarial_filter_general() clears cmd_hca_cap and then restores
only an allow-list of fields:

mlx5_adversarial_filter_general() {
    ...
    memset(dst, 0, MLX5_UN_SZ_BYTES(hca_cap_union));
    ...
    MLX5_HCA_CAP_ALLOW(cmd_hca_cap, rc);
    ...
}

rc is on that list, but ud, uc and xrc are not. In confidential computing
guests running in adversarial mode, every UD and UC QP request would now
fail in check_qp_type():

    case IB_QPT_UD:
        if (!MLX5_CAP_GEN(dev->mdev, ud))
            goto out;

Only RC, RAW_PACKET and the internal special QP types could still be
created. This affects userspace. It also affects kernel ULPs such as
IPoIB until the later patch "RDMA/core: Suppress kverbs_provider for
adversarial_mode devices".

The driver itself clears these bits by policy, so would it be clearer to
describe that as the purpose of this patch? Could the message also say
whether this is a bug fix (with a Fixes: tag) or hardening, so stable
backporters can decide?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
