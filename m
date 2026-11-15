Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794746073;
	b=l+VlWVBkFEqJF1N/ADT8cSOVP4Me8j1KVj7/hXmWVFkrMExTHmC7BtvHV/an3LlcFiP1
	 awsKP0Rhr41r4HWwirAI8bD+6W6aJpwX3iKKKCgOj2FaPPBrvxpOkBPxbH/EpXcce84Q/
	 fHrJ1uBR3jkdQonKphdovMBn8S3CrdY4LBdr2ysRdDe8eTJqdBDTJV0hr19PvPpADy5dG
	 ATe5UPT+nAMPeD8OVyOFeX7XbuUgIgMFlhXFTmXosRebvcjJ9ZSSgnZ0yBf7lin9iXBpG
	 bOWMQ07NOnL1WzdJbnxCpOSnBEw1KZDTLcq8kLbf9CF8fhiP/PYebDzzDQzK5psBCQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794746073;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=5d99x9Z7iGP/XoNMh8Cda41fFbLCQQN+rYDaKXQczIY=;
	b=W1attjA1WUeGsVveaRLy7ixfBV7x1x9oEkEt8Eg8XbxtJqMV+3YRW1OrCg/CBrJcrMNS
	 tQygWdj4HHy8pnmF35z3V+hS8kqjCqvbxwqoH5IA7RzhJ5OvnyR3n86K3z4f6H9290hF9
	 CPR+Lgixampph19SGhzv3atPu/s+fOAY8L8An+UD/x/PsE+OLxbsEhDP14IxRzO7i00UQ
	 jmQeTcnsUQNlj4qorJadFGQJtc0lahDCLLfPL+u8ApbQRlGBrYgY731qLxV7H42RFv80f
	 kcUKAmF0jHAgw/xWQ/CxLcHQtIa4PKTAtT/45amCK6MDbLAJebE815+uGJjDPxaxDEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=RdsDG4jx;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BB8F606A32E;
	Sun, 15 Nov 2026 12:34:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BB8F606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=RdsDG4jx
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5440920B7169;
	Sun, 15 Nov 2026 04:34:21 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5440920B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794746062;
	bh=5d99x9Z7iGP/XoNMh8Cda41fFbLCQQN+rYDaKXQczIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RdsDG4jxnOTbRCcRLKn8KqNbjJNqcL7K8pXNK/914kpDO8n8yeqxYHuWtNeJbLBUq
	 DKTedkh6++WOqmHvLYlX0r6oycUAo72qMSzKNx1zb+ZrFuMCYrvEmX9MFTvJsakBD1
	 WBDB//+dnecoe92lyu/QgI3LR5oZ3YEAvQPsC7xo=
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
Subject: Re: [PATCH net-next v10 2/4] net: mana: give each HWC message slot its own completion state
Date: Sun, 15 Nov 2026 12:34:11 +0000
Message-ID: <179457550419.109246.17805974147168949918.hwc-v10-all-reviews-p2@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <179455239815.2199510.4673285259543925635@kernel.org>
References: <d3c71452bb2938a5c1fcfebb32d44827eaea94e9.1794208055.git.weh@linux.microsoft.com>  <179455239815.2199510.4673285259543925635@kernel.org>
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
I will include the small metadata follow-up below in v11. The four Medium=0D
findings are pre-existing and will be addressed separately. Where later=0D
patches already provide protection in the completed feature series, I=0D
have noted that distinction below.=0D
=0D
> These changes fix bugs that can already be hit in the baseline, but the=0D
> commit has no Fixes: tag and no stable note. Should it have them?=0D
=0D
Agreed. I verified the original-driver commit ca9c54d2d6a5 and will add=0D
the applicable Fixes metadata. I will explicitly describe the stale=0D
caller-storage and stale-completion bugs, and make the dependency on the=0D
following quarantine patch clear for backporters.=0D
=0D
Patch 2 alone does not solve response correlation or TX-buffer reuse after=
=0D
a timeout. The backport guidance will say so; I am not proposing automatic=
=0D
stable pickup of the complete feature stack.=0D
=0D
> This isn't a bug introduced by this patch, but can a late response for a=
=0D
> request that timed out still reach the next request that reuses the same=
=0D
> msg_id?=0D
=0D
This is pre-existing. We will address it separately for the baseline.=0D
As the review notes, patch 3 already keeps the ID quarantined in the=0D
completed series. That protection will be preserved in the respin.=0D
=0D
> This isn't a bug introduced by this patch, but can this memcpy() read pas=
t=0D
> the end of the RX slot?=0D
=0D
This is pre-existing. We will address it separately for the baseline.=0D
Patch 4 already checks the requested response size against the effective=0D
RX limit and slot capacity before admission in the completed series.=0D
This is not a claim that standalone patch 2 fixes the bound.=0D
=0D
> This is a pre-existing issue, but is the TX DMA buffer for this msg_id sa=
fe=0D
> to reuse at this point?=0D
=0D
The early TX-buffer reuse is pre-existing. We will address it separately=0D
for the baseline. In the completed feature series, patch 3 retains the=0D
slot and its TX buffer while the response-side ownership is outstanding.=0D
The respin will not undo that quarantine to make admission succeed.=0D
=0D
> This isn't a bug introduced by this patch, but the caller of this=0D
> function, mana_hwc_rx_event_handler(), drops the RX buffer when the devic=
e=0D
> sends an out-of-range msg_id:=0D
=0D
The missing RX-buffer repost is pre-existing and remains outside this=0D
series' changes. We will address it separately, rather than silently=0D
folding an unrelated RX recovery fix into this respin.=0D
=0D
Regards,=0D
Wei=0D
