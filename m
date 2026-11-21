Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795278572;
	b=F1kTczmXiDMX/Utm94uQdOuB95c4ioJvD2xDXbassSv3V0FCrD0D1gdxrEsZGHKdUGAP
	 nkpyhmqpYnHHEA6vEmWGSOqoQGzz8dwp3UvGUj9IkBP7Y25CkwVirxjEzkCAu5wdcNggH
	 zIm46ekMdl3VbdiqTx0G5DG/FYx7AfsnWwR+Ox4wt4R5wOt3s/K+eGHgbAV4UR8iz/ATh
	 uB7kjYs2y+o/4jsM43CoGQRi79ocrLq8mup2RW+n5ZIdTujTkLuRb0sQ2XAgkRjrRdnkL
	 FVB5+/+flHxbsMifYPb1F5LRlbFDImkR1vj6OdAe7J7yajV7kw2fZEv7YLRsqoaP2jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795278572;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=10HbSVel32GOfT7pI1UsLMtCKzdjjhVSnX3ViLZ7i1E=;
	b=YBy163g5b9aKrUAyR0NW09gq3vvWegy2BQJrBGkLb1a+nJnlpoPeLzUNjP2ecSKaLo0i
	 3Dsz1MwFSi7QRz9ZyWHdoqw44ONgf6+qqgUhEVmccdUPJztMNZJCtSPPwuLrtMqu+TGvY
	 EBzJguYAkhxnWPna+fhgyLcWVTwCk5fUk7NHCjw+IzjEm9odQ83rK+arF2f1OPfTNFBuo
	 ij8WDUU7m5uol8HnD5rnWTYf6OZygy8F71WaMpU2ck4Bb3yE1b2k1ZKa+5WOe7YSWKz1o
	 uG7WEnGOG1wqXsclwW+8Sb4sFfeFP2ZwMlUBfHmDLkux+Ip5vejFtU+DrYdidZCgXOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zd+EX4E+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18373606A32C;
	Sat, 21 Nov 2026 16:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zd+EX4E+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440A41F000C0;
	Sat, 21 Nov 2026 16:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795278571;
	bh=10HbSVel32GOfT7pI1UsLMtCKzdjjhVSnX3ViLZ7i1E=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Zd+EX4E+KUVzFXZj0nR9l72zaEkD97BYp7xAa30nQ++qLmfcxheDon1gbPVeM4aTZ
	 WvGVJxNyBpMeyyuj6jcS/vzOJBj4T0hXjgG7w0/UzfSyhClPSpptddBWfHnHt70kGV
	 WKK3KwxcPBciSWoua1XKuSZAOMhMSokcKrmhrA7ce+1Yb9nMd/NjwHNRCueu4trPKm
	 Ov5huR3k/Pk9OQjHImGecQU+iPjItg60e1ygwZTvjtX1yjEYPFHwgCHF3IPNcfEXiH
	 OVXT2GqS40tcRxqkoUldOsAVf5rSQ50G8RHipULtIs7ToH4XY5TlYgsmB+gSCA1zfT
	 gbove2eUoIHAg==
Subject: Re: [PATCH net-next v11 2/4] net: mana: give each HWC message slot
 its own completion state
From: netdev-bot+sashiko@kernel.org
To: weh@linux.microsoft.com
Cc: longli@kernel.org, kotaranov@microsoft.com, kuba@kernel.org,
 davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 andrew+netdev@lunn.ch, jgg@ziepe.ca, leon@kernel.org, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 gargaditya@linux.microsoft.com, kees+treewide@kernel.org, kees@kernel.org,
 mawasthi@linux.microsoft.com, weh@microsoft.com, edumazet@kernel.org,
 shacharr@microsoft.com
Date: Sat, 21 Nov 2026 16:29:29 +0000
Message-ID: <179527856985.3135.17373359776897418814@kernel.org>
In-Reply-To: <42d753b49df1b873b2f0f6477771820e14e9fab4.1794751992.git.weh@linux.microsoft.com>
References: <42d753b49df1b873b2f0f6477771820e14e9fab4.1794751992.git.weh@linux.microsoft.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message for "net: mana: give each HWC message slot its
  own completion state" ends with two trailers the kernel does not…

--

net: mana: give each HWC message slot its own completion state

This commit adds a per-slot spinlock to struct hwc_caller_ctx in the MANA
hardware channel. The lock lets the response handler and the waiting sender
agree on the output buffer, error and device status of each message slot.

Slot state is reinitialized under both the bitmap and per-slot locks. The
output buffer is withdrawn before every return from
mana_hwc_send_request(). Status handling and cleanup are split out into
mana_hwc_response_status() and mana_hwc_finish_request().

Link: https://lore.kernel.org/r/20260908035201.402424-3-longli@microsoft.com
Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.com
Link: https://lore.kernel.org/r/179196575434.434549.4428132041097324407@kernel.org
Link: https://lore.kernel.org/r/179196575640.434549.9102950927041409151@kernel.org
Link: https://lore.kernel.org/r/179455239815.2199510.4673285259543925635@kernel.org

> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>
> Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>
> Copilot-Session: 8c2361e6-c0f4-4b0c-bf01-b5e4cdacec50

[Severity: Low]
This isn't a bug, but should these last two trailers go into the kernel
history?

The kernel does not recognise Co-authored-by: as a tag, and checkpatch.pl
warns about it with "Non-standard signature: Co-authored-by:".

The closest kernel tag is Co-developed-by:. It must be followed by a
Signed-off-by from the co-developer. AI agents must not add Signed-off-by
(see Documentation/process/coding-assistants.rst), so an AI agent cannot
meet that requirement.

Copilot-Session: is a session ID internal to the tool. It means nothing to
maintainers or to stable tooling.

The other patches in the series carry the same trailers. Could they be
dropped from all of them? Any AI assistance could be described in the
commit body instead.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794751992.git.weh%40linux.microsoft.com
