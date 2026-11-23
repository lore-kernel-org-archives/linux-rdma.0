Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795447314;
	b=UdW2g3awP7ha4ufMoikG6UQCgRjm7xY89SjimgP+3U3scHN4wbCdKS2VH2XhHQ75Kirp
	 kUFNJsyEoOkPTI477HNUPJ8xmJLDGNpd0vP1cX1tHqLGhEUyYYdJuAo9c896/UCQTNyGk
	 hSbOQNfO0mCmkbMQrWS/3I4xQR6++G5qcDB7wVCiLqXqLz/4JObFP7F4wYPEq9RsEHHdc
	 5pgq5iQ6hwaSfiFlEu9fi8hFBlRujAK52uA9042JrGTrZGkOfD4/As1ZlNjqntJkWZeBA
	 KiHioxtfS74esv7m+EArSUGcWl+npFdZ39JGcxwdksusHJw6aaMfqZjD63UNfKqg7Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447314;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=2Sx7YyQZhZSyc1/RwYOc4ocxELc/8nu4dZNulzsCBGA=;
	b=p/8I1JJy5f+Ha5b0z169NoTvbR9LhhIhUfN5wiwI6Eyvrwa1ekXCyJHwnKOW9UYFZZEz
	 ll+zuzZeSR//wUx531/dvWxbIqYtr31iZMLLgPGGMSRCn151Cy18U1TdZX6kEsn4DXGXY
	 VpqOR6nfjmroFmpWKigu/YEGOq7w9pm6xhPg0uSKqwaMjJ1QJrGMrDbjTmmKydf9E2Tjw
	 tHi8Wwyq6dVKdKLpvXXf3qf4SrTCySX42/JxhU8mV9LRLLKTFUftRaCxOI3dexEpYjhWi
	 f1olQ96+1OEEgHIQEF05TbimuBB8iTeOVwXNdza1S7OniV7NoiSyHyDO5uJEJX9SJ3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=gml5r+EH;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62455606A693;
	Mon, 23 Nov 2026 15:21:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62455606A693
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=gml5r+EH
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 2D89720B7169;
	Mon, 23 Nov 2026 07:21:49 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2D89720B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795447310;
	bh=2Sx7YyQZhZSyc1/RwYOc4ocxELc/8nu4dZNulzsCBGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gml5r+EH5ZpXCV/ikVL7acA1DS3gS53lk4MSyL8ogaPJvspgxwG3BnmuZdU02kHmi
	 t4DFQNL1hZ2BAWj+VATZbvcxoKdwuZPlGHX8WWDI37UV1oHvBHfyBOaLu148FZ4Oi/
	 CVmsRmGKGzIRibd8gL2eyOc7FcsOmEXvQ9Ts4JeU=
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
Subject: Re: [PATCH net-next v11 3/4] net: mana: support concurrent HWC requests
Date: Mon, 23 Nov 2026 15:21:45 +0000
Message-ID: <20261122064231.hwc-v11-netdev-p3.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <179527857180.3135.15262062177473658662@kernel.org>
References: <45db2acd8f03421191f5b3a9f4bd7ce9e9259b33.1794751992.git.weh@linux.microsoft.com> <179527857180.3135.15262062177473658662@kernel.org>
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

On Sat, Nov 21, 2026, netdev-bot+sashiko wrote:
> Can this leave a dangling CQ callback for kernel CQs, which then runs on
> freed memory?

Yes. ib_free_cq() can free the CQ even when destroy returns an error.
I removed the v11 early return so the normal CQ teardown withdraws the
callback. This doesn't fix the separate upstream race with a reader of
the RDMA CQ table.

> Can a rejected destroy here leave the driver tracking a QP that the
> RDMA core then frees anyway?

Yes. V12 also drops the QP early return: teardown removes the QP from
the driver's table and CQ lists rather than relying on a retry.

> Does this leak the GIC reference when the rejected command was not the
> EQ disable?

Yes. V12 restores the upstream EQ-create unwind. If creating the EQ
fails, its caller drops the IRQ-context reference; it doesn't use the
HWC error code to decide whether to keep it.

> What releases this retained GIC reference later?

V12 doesn't retain that extra reference on EQ teardown. The last
mana_gd_put_gic() unregisters the handler before freeing a dynamic
MSI-X vector.

> After the continue, what still points to the retained tx_qp[i]?

Nothing in v11 once the parent is freed. V12 keeps the upstream
Ethernet TX, RX and EQ teardown instead of retaining those queues.

At the normal response timeout of a posted HWC command, the PF has
drained DMA to the old queues and packet buffers, as well as interrupt
writes. Unanswered commands haven't taken effect. V12 stops posting on
that HWC and won't accept a handle from a late reply. A reset notice,
a failed post or a wait for a free slot gives no such guarantee. The
HWC's own rings and buffers still require a DESTROY_HWC ack.

Thanks,
Wei

pw-bot: cr
