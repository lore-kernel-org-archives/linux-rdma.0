Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B2D509F00
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 13:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789567185; cv=none; b=Qo5AdUbamTM0el5+6ME2X87AS+S6cXBtyInnZpE8JGXEkfI/MCKiio2cpz7p6yl3EprFF7vhspAIjfMTuyD/KFXAS4lOjUKcQImiwnNmE/TS0py6gSSe+c07f9ZO7qWBnSWUMAnEHM3m+G/+7G+qb1dVcJnP1yM4wYvWCmV7f50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789567185; c=relaxed/simple;
	bh=boPgn6cQUpCAZ+hBG3AAH5z5zz11p1QqG4N0tOZ8Dgw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XmqqZer7AWvfqMk+MDwIKZstm+Lc0qHWe+IF+mq/7BCXMQwPC1PLmcKtIi5IVEPi+IqOx9c8gAm9yOYTVHICb14fQEVrEY0/e2cM5j6bGH784HCn84EEFwU43H24zsN4pdhrV/fkn3YSc7yrirZzKS/nJVR+QH82dSNHtvFt5vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lUzY63Fb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lUzY63Fb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDB81F000FF;
	Wed, 16 Sep 2026 13:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789567183;
	bh=boPgn6cQUpCAZ+hBG3AAH5z5zz11p1QqG4N0tOZ8Dgw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lUzY63FbVKSlo1r9iL3U24VAtYn4sxJHArjQqnWUhzKrAlGXC/hM3u3MiHuRgJRGe
	 Xeh/Ofpdq8GY753QVkqVSYv2rAwSPvwD9TxBmcWODF4e/Qitg1aeqp/u5uWM7I/1IG
	 CnZn0lawOCGlWRG2IBKFFyYdutpGZ1uSBHCRt38qQYENjIfC+RdpdU39ze5dROcwVD
	 qNJa0cJY4xit5C0c8KPa1RHIhZ6wRrMTnG3ixNNh6Hr+nRWgM5nRzbIjRr2mdhyIT+
	 yw++jdryvzQEp2rNiL200MXB8K8B4+mU/tDo6bxJqGPbagsfONAR24dmSkjXpfL6tT
	 neshbuGxbLPAw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 1/5] RDMA/mana_ib: Optimize shadow queue
 bookkeeping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260916134835.2380971-2-kotaranov@linux.microsoft.com>
References: <20260916134835.2380971-1-kotaranov@linux.microsoft.com>
 <20260916134835.2380971-2-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 13:59:42 +0000
Message-Id: <20260916135942.DDDB81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Use compact bitfields for the posted WQE size and send opcode. Flatten
> the UD receive shadow entry into the common shadow_wqe_header, retaining
> byte_len, src_qpn and the cached status until direct-CQE polling replaces
> their readers. Use this common entry for both send and receive queues,
> including allocation, posting, CQE handling and WC generation. Derive
> the receive WC opcode from the queue rather than storing it per WQE.
>=20
> Publish initialized entries and release consumed entries with matching
> release/acquire operations so posting and polling can run on different
> CPUs. Retain the legacy completion cursor until direct-CQE polling and
> software flush lists replace it.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916134835.2380=
971-1-kotaranov@linux.microsoft.com?part=3D1

