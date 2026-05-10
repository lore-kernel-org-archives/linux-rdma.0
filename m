Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AD017B418;
	Sun, 10 May 2026 10:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778410370; cv=none; b=ekuYpmOpepmFwHPqkW5Vvh2H205pYLFjW9tWXWJWvEjbEpXIZv56vs0dWOQ4or3fJ6yFbBks/n6DzYfZSi7SIJPjSz0FmHD/Yc3BzR2K3ngTIrtRYIcdBTHWNE7jrf3F3b2WdxgJXTQNzOLaWAw7UU84pxsb9i9+P3SwFJzR6Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778410370; c=relaxed/simple;
	bh=LftJf76+uNNK/cg4iCtwSfOrMZWNzVuHdjY881aCPpM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mmFzuDNbxi7RMUp2PwZbVCEXPk3ahDau+ylMVQ8tcrdaX/C4ICqQCRnBCXpGP7TQL36zSIPJFjs2WUHKx2z/vyjKqrTossPpJ4v1YR9XYIBw/1q8fv+er1pWDfMdIjBftGoTZEFUVMsrpkV3X5XELNnr0FisBrLRdzD3Rwe5O+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sZvgsrya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sZvgsrya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F42C2BCB8;
	Sun, 10 May 2026 10:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778410369;
	bh=LftJf76+uNNK/cg4iCtwSfOrMZWNzVuHdjY881aCPpM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=sZvgsryacbkPQKwlThUpu0PMhLno2ervgRfcLF+98LutqG4V5YaJSUyexAXemEAXg
	 Pw47Wnyg6sTdLh5JJ8Xul91zqL/cRsvhLTlN9cKq6z+EnoBu3xxaky4R/fdJjvslzZ
	 JU8bKErEpj4eg+0w9bpr7Gz14g5xmBePUXy7+iD8pgSa++m9IHtC5nCEEMN3lCgguT
	 9L5KXrF4Qgdmr0vGlgjF7lcpGbjM59lnhe1VUa+RxHoB3ML33tiQkHsQrt5cGTEy4O
	 UAzU76QzlwKTSs1Q2iiz0O9A/0cWWGz4outky0m9v9Q82f5vHkPlXx6cOMsaxJ2tJP
	 qcOQlN/lgxHqg==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Surabhi Gogte <sgogte@purestorage.com>
Cc: Edward Srouji <edwards@nvidia.com>, 
 Vlad Dumitrescu <vdumitrescu@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
 Kees Cook <kees@kernel.org>, mkhalfella@purestorage.com, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260410001549.3149060-1-sgogte@purestorage.com>
References: <20260410001549.3149060-1-sgogte@purestorage.com>
Subject: Re: [PATCH] RDMA/addr: change addr_wq back to unordered workqueue
Message-Id: <177841036659.2016936.13620368468717671153.b4-ty@kernel.org>
Date: Sun, 10 May 2026 06:52:46 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 09 Apr 2026 18:15:49 -0600, Surabhi Gogte wrote:
> Commit 5fff41e1f89d ("IB/core: Fix race condition in resolving IP to MAC")
> changed the workqueue "addr_wq" to a single-threaded wq.
> Commit e19c0d237873 ("RDMA/rdma_cm: Remove process_req and timer sorting")
> eliminated global work and started using per-req work.
> Now we no longer have the race, change "addr_wq" back to multi-threaded
> workqueue to speed up multiple addr resolutions.
> 
> [...]

Applied, thanks!

[1/1] RDMA/addr: change addr_wq back to unordered workqueue
      https://git.kernel.org/rdma/rdma/c/dd2403fe1499bd

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

