Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFAD366814
	for <linux-rdma@vger.kernel.org>; Tue, 24 Feb 2026 09:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771926871; cv=none; b=qYT63NH2etyw0twiJxD7EC4OaXv/IRFn+PKaPeu5SqOoiBgUglxSmRkHewKCS4k8lKyYmzJwyqX5sPtishpIRmiLbBzAzD7T56s/pVXudAPlgGP9w4ky+4wbp4yAGo+qfNfVdwBjktvpzJxJ/621NplyXFHU/z+OigfNs6eU7w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771926871; c=relaxed/simple;
	bh=C4okLm4O6qltws2qquhsqbgl7uBtAzaP9ETCCrSB9Kc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ctpe5+AaresyjNvNE1tN7XTqQBtgM5i3oH4TXCQ/IzM+3+0ZqRaF0AQQBI6qdIaNtfLskel799z6eF2Th5ghourQ2E1uMfS08QaFxCR1srkedsY/4odHCV9gOkjXtZbujbHH5jywjiyCqr9Wszzvwur/fGt+wEyiJ9bUAylQ0W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c4KuItd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c4KuItd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B670C116D0;
	Tue, 24 Feb 2026 09:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771926871;
	bh=C4okLm4O6qltws2qquhsqbgl7uBtAzaP9ETCCrSB9Kc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=c4KuItd9z9IX3i0X4HHQk4VkuAO+wWlkfmt1hxJr1ewI0VfEHrn1vsielFoc3j5Zy
	 6YSqlKiP7LqFg7uOIaKvJnkSIMui2lnFrRNK4hG/QeuLR+haB/b8ww8jSwjXyfoq19
	 De2L5AT4+N2wBbzSGEBc+mO57PXY3bikLdUltoIUL6daQEiDgpeEw0eTZrTxjjFbIl
	 vA1Y2jTjluuM2vqUlMeK9VMv9iX5vTaWpufJHrmmLZ8dZsXKNlxyErwZZM69wAZPmO
	 sSsoiCXQqNMOMRbhEvjfbRu9ipqwzReD1vVylKsb/iyKErQres+WkENGPjQFocaUpg
	 mrXfjGeK35mUA==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Kamal Heib <kheib@redhat.com>
Cc: Abhijit Gangurde <abhijit.gangurde@amd.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
In-Reply-To: <20260220222125.16973-2-kheib@redhat.com>
References: <20260220222125.16973-2-kheib@redhat.com>
Subject: Re: [PATCH] RDMA/ionic: Fix potential NULL pointer dereference in
 ionic_query_port
Message-Id: <177192686686.747035.3973512104219547018.b4-ty@kernel.org>
Date: Tue, 24 Feb 2026 04:54:26 -0500
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773


On Fri, 20 Feb 2026 17:21:26 -0500, Kamal Heib wrote:
> The function ionic_query_port() calls ib_device_get_netdev() without
> checking the return value which could lead to NULL pointer dereference,
> Fix it by checking the return value and return -ENODEV if the 'ndev' is
> NULL.
> 
> 

Applied, thanks!

[1/1] RDMA/ionic: Fix potential NULL pointer dereference in ionic_query_port
      https://git.kernel.org/rdma/rdma/c/fd80bd7105f881

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

