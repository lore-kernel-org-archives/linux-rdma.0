Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DAF30C165;
	Mon, 12 Oct 2026 07:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791790252; cv=none; b=G+t+tRrq2agqpEzssfvz4cPEoYRxsncYWm8Mb0g7y+Bq+laF3S6qxOWFQEXgl/u+HC5euv2XtB/q7YWLFstuRzYtj8FRZ8rxzK/Ls0EimaMPwqnPC/axoxaTZNZTgnXdWoKiKvv2/tYA1HQ2wg+C8DXaHw3dPLrjd6+g1x8/YXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791790252; c=relaxed/simple;
	bh=8Nic7KkNK/jraCD1kbmgZjSMOsxJwVHdWGrriEu6jsE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jH0DxZmDrO3yxm8qaINerOKnzneruqnkqKWDSaOvF7DLVz34kPlWPpQTeH2RZtt7QdooLkSu+F6T10+fvzJrvNR1OOttNP9p41vRWqlw+3m//weKwrh1aWDQjkLCuaRKinv/iTz23m1xx7aK7ppEhqJZWYEkMGs1ZmofHf+BIOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DuVU+rNv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DuVU+rNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458A11F0089B;
	Mon, 12 Oct 2026 07:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791790250;
	bh=7YeyenG+qo9FfPzJ5fCyicXBqI24WShG/Wjla3YC59Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=DuVU+rNvWozMHOrudMudnsHOTx1oMdn2Ztc1eMw2JXUKXWHSdufh1ELMvfcqBAnjI
	 wn4udI9NbvQFi83P+bkBz3gGMi1Oq8fdL1mENwUkUUhSTAZ/d9iyHVo60a+R0UeXBR
	 0batRK0z7XHGjpb5nPuo6xXFmMR+sYOxdNRuDA+vYX3WcmzHaDo14BHOH4aThLJQbk
	 +U7oo//1K26LUonxuexgZPHrMMqj2ZBSRHkm5cNXRlChYvpPl6mDTdbpI2HOIWH6+W
	 lhP80enwGQQeId1xGLAYP79k8CrRtbM8UuHwpEiB4Kj5FQ6CgPYTXNL2xQ9AtLuAm8
	 Qh2tfgMDccmcg==
From: Leon Romanovsky <leon@kernel.org>
To: Tariq Toukan <tariqt@mellanox.com>, 
 Saeed Mahameed <saeedm@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Cc: saeedm@nvidia.com, tariqt@nvidia.com
In-Reply-To: <20261007234216.2765-1-prathameshdeshpande7@gmail.com>
References: <20261007234216.2765-1-prathameshdeshpande7@gmail.com>
Subject: Re: [PATCH rdma] RDMA/mlx5: Cancel deferred page-fault EQ work
 before teardown
Message-Id: <179179024771.3817733.15753630766032234503.b4-ty@kernel.org>
Date: Mon, 12 Oct 2026 03:30:47 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 08 Oct 2026 00:42:11 +0100, Prathamesh Deshpande wrote:
> Page-fault EQ work can remain queued after the notifier is disabled.
> Destroying the EQ before cancelling that work can let the worker access
> freed EQ memory.
> 
> Cancel the deferred work before destroying the EQ.
> 
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Cancel deferred page-fault EQ work before teardown
      https://git.kernel.org/rdma/rdma/c/aea64024ac37d2

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

