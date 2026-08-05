Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C1F352008;
	Wed,  5 Aug 2026 14:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785941083; cv=none; b=uGF1BDYT/qakdC1GfoDCrIVhnlWR09ogT1v5oRKcksmUuYktrY1W5aV4/mncRtFWsxE6a/eiFzoUcvQB6GBBtTyzayeopdRB9KpQD35qN7Yy2UciXvD1rd5chtDbB9w1Xw2P6S45fCRcXwdU/31PSF9fXtrDyAX1rvrDTi0u+wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785941083; c=relaxed/simple;
	bh=jbBcDu4Ar2bW0EIMlS6qARnXHzrozmefu0LnrF+Ogg4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GmTB/i4XJvNp4UeBAEtJioxd2cGnM0hHrOUOgLEPHlBkgABPBNQlDfRoTl330s3sGCzo9rcZToKxC5zbp8wpUrWci+4xR3eAHyv5KUYev6Ev3yRBuSsshCp6Xgj3zE++2g3hKV13oJf78BTloJ0GbV2NP25RL7sx6AtZFYViqHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWfP30tn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWfP30tn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4E21F000E9;
	Wed,  5 Aug 2026 14:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785941082;
	bh=+HrhtE/rRNYewk6OV4ENi8ayLsALJwKlM7/v0cfQFpU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=nWfP30tnbkjsTC1h6+LaXkmy0sEYuF2el2fbw3bWbdRAZ+H7axbRkPrRlX9w3DOmV
	 EseGoCXjnLx50/iJVn9584QsTUtcOl3uFH0igQjDfbGYgOYwarOlWZRly6doWc+HA+
	 Icmpapx3dM3XNK/hMoQpMpv/BpEukofYvuWAKxRaoa5HS81JbidrsiXeofbJykZlx2
	 mIg3Jk2K/GVzX0EjBdqZAYDF9NIZl18t8vnrNsWfK0kl2K0IiQ21jE261u4xFdKILd
	 R9Nyx692W+g5cVIwp3T4Y8/6cF7g6V7vMRodxdhR8DUQQWyZUql3HLw8WNrenIiqrW
	 oiZZc3VNAmfHA==
From: Leon Romanovsky <leon@kernel.org>
To: kotaranov@microsoft.com, longli@microsoft.com, jgg@ziepe.ca, 
 Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260723115955.1859519-1-kotaranov@linux.microsoft.com>
References: <20260723115955.1859519-1-kotaranov@linux.microsoft.com>
Subject: Re: [PATCH rdma-next v5 0/2] RDMA/mana_ib: UC QP support
Message-Id: <178594107921.4133396.13917915555927637465.b4-ty@kernel.org>
Date: Wed, 05 Aug 2026 10:44:39 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 23 Jul 2026 04:59:53 -0700, Konstantin Taranov wrote:
> From: Konstantin Taranov <kotaranov@microsoft.com>
> 
> Implement UC QP creation in the RNIC HW for user API.
> 
> v5: revised 1/2 to incorporate the drain fix from Leon
> v4: renamed rc_qp destroy helper to rnic_qp. Use the latest robust udata API.
> Unified QP lookup table to simplify code for inserting UC QPs.
> That is why the changes were split into 2 patches. The first patch is about
> the changes related to qp lookup/store.
> v3: use new udata helpers
> v2: removed udata check and removed enum from mana-abi.h
> 
> [...]

Applied, thanks!

[1/2] RDMA/mana_ib: unify QP lookup table
      https://git.kernel.org/rdma/rdma/c/a489ab44ab73a6
[2/2] RDMA/mana_ib: UC QP support for UAPI
      https://git.kernel.org/rdma/rdma/c/6aad80a1d4e70c

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

