Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2CB3AA504;
	Mon, 23 Mar 2026 19:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774293928; cv=none; b=pjzuNG4gtmy3pky943oGTpYoOvQi5RNYQ7T/Qwks5u185n0QoJp7v0v7MxNADWpzAssAIjTIlcvjJE4mrLNCDNDBy80fXdFSh++3rzaasG081VHuMl5CD2+7z+BZmXjRbi3ZNwT29LemvqpNJqz68iTtz64SzHZvg+D8qgSayag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774293928; c=relaxed/simple;
	bh=PbbzAz5GcMzF4ZwrWaRF3CThzVznzGkyBW1UzCD8xYU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GMMiRm8CHrtLH6u8ZODZIFKfE8t7/o3NGW1fyK6adK4yPX9kXiW06/BH6CdpXSqjaiLs3vO16apy5u44c2+UPSVxMcR7CVfQo3ZDYAv/CVKaXIotDKyZ5kj7n28jeMFI7Ao32Zhmds54A1yKmb0j7RYvL6qW0v6kGvsgRhp6Oaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QGnc2LhJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QGnc2LhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE49C2BC87;
	Mon, 23 Mar 2026 19:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774293927;
	bh=PbbzAz5GcMzF4ZwrWaRF3CThzVznzGkyBW1UzCD8xYU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=QGnc2LhJxCIEUPwPdv5mzgU+UMw50y0FGfO/dtzv6HfsnvK2rBEKbcBKi+/mfCbHg
	 iwYQOyYGoiqmXSDcT3GRqyP2zX6J2pYrCXrcCJ+FUslzLZrF2eZ7PMuyf6KCgrMa3E
	 cqBLxSiW9Ubl2vAkKv6QmV5/Jy9F5F696pd7F/IpQSbQD0PSm1s603VNcZUy4ejJOA
	 rkVp71cD+R+83FlopQZdYetzD7NBAnEKpNXhwCC6UBInVKBDeb8LCEWYwI3BsfrznO
	 1M5TJhUfjR1TAYKEediPJO+J/Kuf4ThibvvxeQ2/5qCMl0ykUHWPnYYvPeb6eZLCkP
	 0xyY9qILSjYOA==
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>, 
 Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260318-bnxt_re-cq-v1-0-381cb1b5e625@nvidia.com>
References: <20260318-bnxt_re-cq-v1-0-381cb1b5e625@nvidia.com>
Subject: Re: [PATCH rdma-next 0/4] RDMA/bnxt_re: Miscellaneous cleanups
Message-Id: <177429392482.2367219.14593949422088253229.b4-ty@kernel.org>
Date: Mon, 23 Mar 2026 15:25:24 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 18 Mar 2026 12:08:49 +0200, Leon Romanovsky wrote:
> Perform general cleanup following the recently added CQ creation logic.

Applied, thanks!

[1/4] RDMA/bnxt_re: Simplify bnxt_re_init_depth() callers and implementation
      (no commit info)
[2/4] RDMA/bnxt_re: Remove unnecessary checks in kernel CQ creation path
      https://git.kernel.org/rdma/rdma/c/8c65d350b5bf9b
[3/4] RDMA/bnxt_re: Replace kcalloc() with kzalloc_objs()
      https://git.kernel.org/rdma/rdma/c/48730650ae101c
[4/4] RDMA/bnxt_re: Clean up uverbs CQ creation path
      https://git.kernel.org/rdma/rdma/c/1c3eaf5186228f

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

