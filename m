Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADCC3DB964
	for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 18:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790705248; cv=none; b=m6bN1+Mz3rmZSMEPJdHUBHN3pL8He6URctGln89b48t0xSsi6afQvsE7Uv0QKX/VoEbchW5p2bNCASZ9b7PnTYct4+mCJVK7qQIGwVFViKJH4FIZvD0R0cJjgZ5YvA+CmgNaoQh7PNJ9bT8bnHT+sfbvvpYDnQM01u8+3jBpYHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790705248; c=relaxed/simple;
	bh=Zi458qeQ1HCeDAlp4KEOgUjBppxXWlre23d8F9+SVpU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YXTxxOYXzu7TLtRYm5VHQIfaFdvR40P7BxQTIywNy0qrEKDcR6J6dG/CZKZzWklQMOCNPIpHwtN1paINr8p1TROiZVXIxFYQweMbMhJcko/eDWgVYwMp+uWM1H6pK8tIUeYtAEAS2Y95udHJeMQAxtY6DhiIYWi92G7LeVPwqxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P+zyjXzp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P+zyjXzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F431F000FF;
	Tue, 29 Sep 2026 18:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790705247;
	bh=yVoN8nvoLDMvLHU9Xj3tAVx6GdLub/wLCD43Prrmslg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=P+zyjXzpE31DvIYPn/l7eBPUb2zg0tlg8fhEHbUqbCNbTmq13chGm6zOEmdtXhtYH
	 LyciLvbP8mW3zpTf/YCbYheIJIgatzuktyzMsykANyMdMolgj5+RMT0A+fSEEo2kJ8
	 lxq6mw1nwoqviMx2xt+zCp8JVE3aFDOmUohxqCRQfNVzHtC5LUruq8zRQAIKIwWRUg
	 CZJ0fUFhjKoodq1YEU1Mm7aL57y0w3YxyRYNYr3iAw5MCHqa0jV++2Me8JuCKXj3Vj
	 6x/rLnvHqlA6hrFa1e9IWlMfI8SiJYql5pvKk95KvbRIVTCpMsDGJ6kUMuPRWxRtUH
	 B0M8Y/wqm3cGQ==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 Michael Margolin <mrgolin@amazon.com>
Cc: sleybo@amazon.com, matua@amazon.com, gal.pressman@linux.dev
In-Reply-To: <20260922160118.990-1-mrgolin@amazon.com>
References: <20260922160118.990-1-mrgolin@amazon.com>
Subject: Re: [PATCH for-next v3 0/2] RDMA/efa: Add support for MR relaxed
 ordering
Message-Id: <179070524412.3966717.5979561935203891618.b4-ty@kernel.org>
Date: Tue, 29 Sep 2026 14:07:24 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 22 Sep 2026 16:01:16 +0000, Michael Margolin wrote:
> Add support for MR relaxed ordering access flag, allowing userspace to
> create PCIe relaxed ordering MRs.
> 
> -------------------------------------------------------------------------
> Changelog:
> v3:
>  * No changes, just resend
>  * Link to v2: https://lore.kernel.org/all/20260824073057.1046630-1-ynachum@amazon.com/
> v2:
>  * Remove the relaxed ordering device capability.
>  * Link to v1: https://lore.kernel.org/all/20260806075758.3476667-1-ynachum@amazon.com/
> 
> [...]

Applied, thanks!

[1/2] RDMA/efa: Use device ABI MR permissions instead of verbs flags
      https://git.kernel.org/rdma/rdma/c/b840f0890ad06f
[2/2] RDMA/efa: Pass relaxed ordering flag to device
      https://git.kernel.org/rdma/rdma/c/eb6aed55cc0152

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

