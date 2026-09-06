Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257303B14B3
	for <linux-rdma@vger.kernel.org>; Sun,  6 Sep 2026 09:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788687353; cv=none; b=jWL2519eOGUZElL0WuA6xvt7yCB5tqJ91l9D4m/0TFUWek9KY9i/ZCtKGKjBTxawOpbgdCDTz6dD8OpS7SBMP34664Ick8tX4Z2veo8MQ8aktzu7ITxln51kOA8JbbJ74i2CkdYJuSbsIU9XuPMhhiCqGt5dXVq4bxQLSa4o6lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788687353; c=relaxed/simple;
	bh=/EMlKvWnnUYajS1zdpAHP49fgvIk+FIF3/EaOb+QJBM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=NeKNjc9YMOv+amuToMWNAzxPgmtaQNkjzrWVph4vM+QUjKEbvl1uW9qvMqm2QrVaUo/WlOF4j5yA6ZFZM6Cp6QbzPEsijKua0y2K+6cR7N16romHoaDKszz5AaQAU828Zb8ghiRRnGcKhR0rrLUOrhleG/fEzuHMxAe7L/PRp+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dOW0H2Bl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dOW0H2Bl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D601F00A3A;
	Sun,  6 Sep 2026 09:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788687348;
	bh=GJR8JmQAtwfU3J0ty+PNtAsm38iEduVGnSWyd022lGM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=dOW0H2BlAb2CKmnnN550zrq+pbMzJdxJO97IhVTZKgbK3xxZ78/Se7yUWidMRAQeZ
	 48mqhgTUssZgPQd9wjsLlM9OCpI9k38daO45qEoW1qFD1qAwFaAIforJiaw0xgOTnf
	 u+y/AO/7Klg5CFV6W1+8DjbVsXoU+H6fzGgXY3fJhZo+2T6+IikzvRTZtPbvXWzhj+
	 zrWUme9kJJ48gom1SZZJbuqvBPKiF5rWkRTwh1+w0Fj8ZZkbnZ7mVaMniP8o+p8wJz
	 nMVjnh2vdlsbbl7yDR6ZJa+7lhDdQb5pAdcvdms724rcZzH2zmpRkyvMBCSPxsDc12
	 1LcI61xOKhvHA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, 
 Karl Mehltretter <kmehltretter@gmail.com>
Cc: linux-rdma@vger.kernel.org, 
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
In-Reply-To: <20260905092057.41306-1-kmehltretter@gmail.com>
References: <20260905092057.41306-1-kmehltretter@gmail.com>
Subject: Re: [PATCH] ABI: sysfs-class-infiniband: Drop the entries of the
 removed qib driver
Message-Id: <178868734589.3955094.17528842703637739283.b4-ty@kernel.org>
Date: Sun, 06 Sep 2026 05:35:45 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sat, 05 Sep 2026 11:20:57 +0200, Karl Mehltretter wrote:
> Commit 24baad32b710 ("RDMA/qib: Remove outdated driver") removed the qib
> driver but left its /sys/class/infiniband/qibX/* entries in the stable
> ABI file. Nothing creates those files any more.
> 
> Remove the block.
> 
> 
> [...]

Applied, thanks!

[1/1] ABI: sysfs-class-infiniband: Drop the entries of the removed qib driver
      https://git.kernel.org/rdma/rdma/c/63367df6e72550

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

