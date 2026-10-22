Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792680259;
	b=Ed/35QZGVj4QOzO0UMd+0u9PXXRT1O8YZGPS4wtxRyRyEQJxQzmVxtIjsfLbl+p92Keb
	 78sHUfwFmyw7SYFyVGeEUxjcfU+2tTQ/U/d8DKs8QLoSeapEuKk9CiYn+MLF8f8e+K0hf
	 cvYO3cfL8uQQA92y4BbpK4PPSMoA009fgVHZX+iwaIv5ZUrZ9ptF6Pdi1IpiXLtCCmpuO
	 WhqiTzhS/GItczNINWKnyyJGITayB3tjZYqRroAVPj/hVB92ZRWPcfCE6dCk+j/0RXVl3
	 pFUyAWlIgBBsB+K0OaVJJRXUr+JWoq9vusHYhXAuv4WeDTt0eRo0NFWP8u8WMK2Aeng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792680259;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=ayP+q1gm7UL5keoQcXEPc/Rm/6pM2kBzEPnRBgonUmA=;
	b=EtqYyJG8Y4MZ0JNhX5w2fPp7z9M3Rj9vOcCoElOe+XUIb0uMbic3YxN3YCv2m32tvzOq
	 9GJ1k0TIyWjtGGyY48ejcn92XQFU3BjvC/RCWCCZE/54qrP5q07I3IVNHmgfxAC8sLH2w
	 GMf8OdOa1/agtVL6T6iDqHcdYeDjiTzYEvdUfBn5eqUK/GoA677vVl7X3ONSFnNFr5aUj
	 0jCFR5M6rC/1xs2mjKp6MK1qfQSNtOvFo6uUDf980WUkaus1E5HCYvbDhvdAzLRLum+Yl
	 NPZ/i2W1ikWTbzXlv2F9WUVaXoU1EMI0jVhg+dR/yRUNryhOXh3CCTtxw6BO73Nxr+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=P9U4Guc9;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6126D606A321;
	Thu, 22 Oct 2026 14:44:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6126D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=P9U4Guc9
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id B2FD820B716A;
	Thu, 22 Oct 2026 07:44:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B2FD820B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792680250;
	bh=ayP+q1gm7UL5keoQcXEPc/Rm/6pM2kBzEPnRBgonUmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9U4Guc9SeDXckcRjc6z+MBAt3t/FXMyYQ6IEINfj+oRs2TMoe0hbK88gGTvJOlvT
	 yGYwyma1seblb/zAcr2nVwKTOZ5rJHUA8jgcPG9xzEhbaqbY8PbNLeEp1BJkIyPL9k
	 xm6WyxDWgwqcPNgFzjcFoPFM4S29WgcJBKmOIHac=
From: Wei Hu <weh@linux.microsoft.com>
To: netdev-bot+sashiko@kernel.org
Cc: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
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
Subject: Re: [PATCH net-next v8 3/4] net: mana: support concurrent HWC requests
Date: Thu, 22 Oct 2026 14:44:09 +0000
Message-ID: <hwc-v9-v8-review-20261022-patch3-0ea848289b23d97a9133@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <179250339266.3135.15035365058593192217@kernel.org>
References: <983b5719644379806ac278b45cfb7cb70d2935f6.1791998462.git.weh@linux.microsoft.com>  <179250339266.3135.15035365058593192217@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Thanks for the review.=0D
=0D
I will respin the series as v9 with the following changes.=0D
=0D
On Tue, 20 Oct 2026 13:36:32 +0000, netdev-bot+sashiko@kernel.org wrote:=0D
=0D
> Before this patch, admission could only block here. Every command that=0D
> reached mana_hwc_send_request() was eventually posted. With=0D
> down_timeout(), a channel that is healthy but busy can now return -EBUSY=
=0D
> without ever sending the command.=0D
=0D
Agreed. The independent admission deadline introduces a new failure=0D
before the command is submitted, including for destructive callers.=0D
=0D
This is addressed in the prepared v9 patch 3. Admission uses a bitmap=0D
and waitqueue instead of down_timeout(). While the channel is healthy,=0D
a caller waits for a free slot rather than returning -EBUSY because of=0D
contention. This removes the congestion-only failure that could skip a=0D
teardown command. The response wait for a posted command remains bounded.=0D
=0D
> Can this choose -EBUSY when the channel is hung? Only the permit holder=0D
> raises abandoned_msgs, in mana_hwc_wait_for_response(), and only after=0D
> its own completion wait has expired:=0D
=0D
The remaining ordering, cancellation and logging cases are also=0D
addressed in v9 patch 3. There is no separate admission timer to expire=0D
before the holder records abandonment. Slot release, recorded response=0D
abandonment, cancellation and channel stop wake admission waiters.=0D
When no slot is available, abandonment or cancellation returns=0D
-ETIMEDOUT, preserving the existing recovery errno; a stopped channel=0D
returns -ENODEV. Healthy contention does not trigger recovery.=0D
=0D
Available slots remain usable for best-effort requests after cancellation.=
=0D
mana_need_log() suppresses expected -ETIMEDOUT/-ENODEV after cancellation=0D
or channel unpublication, while keeping live-channel and other errors=0D
visible.=0D
=0D
> This is a pre-existing issue and was not introduced by this patch. This=0D
> rejection path reposts rx_req, but the range check before it in=0D
> mana_hwc_rx_event_handler() does not:=0D
=0D
The missing RX repost on an out-of-range message ID is pre-existing.=0D
We will address separately.=0D
=0D
Regards,=0D
Wei=0D
=0D
pw-bot: cr=0D
