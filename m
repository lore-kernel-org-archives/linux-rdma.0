Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD3E17C206
	for <linux-rdma@vger.kernel.org>; Thu, 30 May 2024 14:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717079175; cv=none; b=rvMePlyBsOuUnRYfY9+TdeW+mQOnhPsp300QmDelN6gCBnoJU6/D3WzWBDbJ9vkXzeoGPR5cN8+bDHQ5c5/xBSxbohTILXmrvzeFae9LkxrzynQZ6LlcpyCOv9q7DT2p89mCe427nYMsrQiqtGafEfpnqpDL/geKhBNEPypxq3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717079175; c=relaxed/simple;
	bh=TbSKYeLZWPr/y2Tgtrj8dkQArNsbw505hcvc8l4AJ0Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JZgW7rrJB5JrgB3hYcUqK6sDZfHrH7LgFjPDxN1Yg5XIw6PiSPWGdbn7QrryUBi8YozwHL9TqaudvxnnHVB0ZtB8C4yRgJuDRC8kTbeILHQP2+HZdjtMdqWcbKcB3PqSRjmvcM8Gqnl6//nu1FJHLvD6Mea4NsshSKOyV+UjrBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nUKuUYsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nUKuUYsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319E2C32782;
	Thu, 30 May 2024 14:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717079174;
	bh=TbSKYeLZWPr/y2Tgtrj8dkQArNsbw505hcvc8l4AJ0Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=nUKuUYsaDhNuerbZbsB9UHcHdm3aNfTrqkTg5a7UhXbEiZKWwRwU0XfCvlNmzgBYe
	 YMLHh01AdfiD7ccdSRrWgl3XpRgrAEh1P+v0NMmzpAsNnhmqItRlU0MBtA0y+l/TtF
	 xmECmZjwYNGuqjXUrRDQsUER3SLJbWct53XWZCK3V7Ku6w+o6CrKfSHlK0eJ+3v9qv
	 0ihhB+sXgzi4Lag2QyZMuQTjpRf6I0bgBlpVT0875/sSPN6y9eSnnENrQBRMnSg/hD
	 +z4uKM6b8QNOXQvXSssomIU7HaO5t7MbiAmqRfM2hXZogRngs0MbFX7dnfM6zpMK/L
	 xRKcnDsqwm0iA==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 Michael Margolin <mrgolin@amazon.com>
Cc: sleybo@amazon.com, matua@amazon.com, gal.pressman@linux.dev, 
 Firas Jahjah <firasj@amazon.com>, Yehuda Yitschak <yehuday@amazon.com>
In-Reply-To: <20240513064630.6247-1-mrgolin@amazon.com>
References: <20240513064630.6247-1-mrgolin@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Properly handle unexpected AQ
 completions
Message-Id: <171707339531.120479.14276809573716609238.b4-ty@kernel.org>
Date: Thu, 30 May 2024 15:49:55 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14-dev


On Mon, 13 May 2024 06:46:30 +0000, Michael Margolin wrote:
> Do not try to handle admin command completion if it has an unexpected
> command id and print a relevant error message.
> 
> 

Applied, thanks!

[1/1] RDMA/efa: Properly handle unexpected AQ completions
      https://git.kernel.org/rdma/rdma/c/2d0e7ba468eae3

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

