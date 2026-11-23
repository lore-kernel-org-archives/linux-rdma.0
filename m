Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795445658;
	b=phsf3R9BpGHQdfULgpoBYN1of/OotShnb8VZ9ujBSwWeicHrWfdWTTmEPjDS2pahw27o
	 X76HazfFVLkaPud6AzR8VE7AT5SDxPupICDATyVK6Krxq5HP9G+yPda55df3wIMmPHaIl
	 ncq6VQMPGiAOSLPNwDCIaQwcTPHezdF5Mgk13AFcQ1Juj+GoXyXvLw6N9m4KSnB/ACk2Z
	 ZbL0ESP83YQnOcaz9S/NWTPwO6HYfUljnqlAtHnNfLQVCS/z7xRH62Qoqpb7Anxfpd205
	 8WWH+AHtKOLkVZCQmXIgmZmVkcO6gi/lytaX/kWSPPVt9hMg1KdEr7ppSucZGzFCkuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795445658;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=nbCRcJ3CZPxOULxWfeRq0Sbbd2T3nRGZ+rn7/jTnOUQ=;
	b=rx4KAQ2HoY3mcFWWLiev3fgaCClH5YMURb4W9ZoZIqF6eImNaPBZEpSSKa7eevTKpBx3
	 wWaoIkmL+okaM9TCMiKUU0xK7APEge4hdTnLQvxpLRX8og7rZ7j0JzUwxMnMZ5pkY523v
	 Wireztyjgw+fdY1VXcga4K2ZwW07pCjYRE1BkJhnOYxmnylTIUilhYnaVJJOQnNEja3BB
	 /2U7WrpNtkIjg11XF9hQrdgRdrqlSOO2LqbG7hA3HnX0SgKYvIYXOOWLlz+FmogssTbjz
	 c7Ku1F07ZtgXh6DI1qP2Xc0nt00NYRQAihMWUalbn2vcpNcLwxmZVfLZKdOzc0rLnjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=XdaP+3fg;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531D160A3807;
	Mon, 23 Nov 2026 14:54:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 531D160A3807
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=XdaP+3fg
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 05E1420B7168;
	Mon, 23 Nov 2026 06:54:12 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 05E1420B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795445654;
	bh=nbCRcJ3CZPxOULxWfeRq0Sbbd2T3nRGZ+rn7/jTnOUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XdaP+3fgC4CahbgZMIYBjKu9m7/wRsXZ/HvmjTm1FDppHsza/DmgnbgSvHPHkd+YT
	 HvgjiVqhj+O48c6taDabJ00qf0kueVbzeapgR7ucurVQU8HDi2VnKiXPr+WbYzsM6t
	 RcDhUv1k6IcOa+SEvbKxgQiNY3qu9qHvw8a+iktA=
From: Wei Hu <weh@linux.microsoft.com>
To: leon@kernel.org
Cc: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gargaditya@linux.microsoft.com,
	kees+treewide@kernel.org,
	kees@kernel.org,
	mawasthi@linux.microsoft.com,
	weh@microsoft.com,
	edumazet@kernel.org
Subject: Re: [PATCH net-next v11 4/4] net: mana: add dynamic HWC queue depth with reinit path
Date: Mon, 23 Nov 2026 14:54:00 +0000
Message-ID: <20261122064231.hwc-v11-leon-p4.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117180931.GE162713@unreal>
References: <cover.1794751992.git.weh@linux.microsoft.com> <100c6b7a71e86c8d7afd0c55f6b231f01db184d5.1794751992.git.weh@linux.microsoft.com> <20261117180931.GE162713@unreal>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Nov 17, 2026, Leon Romanovsky wrote:
> No. Make sure you also call mana_ib_gd_create_dma_region() with valid
> parameters.

Both callers already reject unsupported page sizes. The guard you
quoted checks the HWC's capacity, not an argument from either caller.
Before RDMA probe, the channel has already carried a 640-byte version
request. With one page address, CREATE needs 72 bytes and ADD_PAGES
needs 64.

I dropped the redundant guard and its debug message in v12. Both
commands still limit their batch size to what the channel negotiated.

Thanks,
Wei
