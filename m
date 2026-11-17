Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931423;
	b=qS1NovOHMY99Lbzk/WuYfiO5FwZgfS5EaguVMCAUv5n2kT9VSPAiDRPZW41HKVaLgIkB
	 Py8e0DxwcMp14tEYPpjQVNAJHVbzaR83f8ygsfxOGdnbaECry4kTbLIksnAMsMkZEpmxS
	 npUSq8yaVDR6pKWpOUmDa/eLhS8Np1JnFGesC8/XGVb5Aqeaz/8Yg0eBUWtjT5/Q2pxzO
	 1f9QDpd4Pgc/RttpVMjSR1E9PcsZJpISSZ+QZJY9zCAGfNdUWmy6du+egvHHKRcm8NDSl
	 mdEwndwOXLdp0BYZ0ECGCSDyFAqMrcm4lxXxc7osRew6RjcGv1AOiePwKrorHm2iLFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Ld9+YyGfs/W/wYUchYl+G0tuTdeNOsMW/DqiAiz5bT8=;
	b=soRTBQ1klYd+QxJbchJ96k8NRRCq654IPIVhh+Gw9bzoglz0QDNgBbjffi6mcnpNwlxx
	 WoDFPLiAHr+qAScrjV8j46AYVXQUQA5vcNYJdQ5rszBt343CLFnEqCYJqn0YSYqC4H7yS
	 WsnSnbTIqUfXAiJbEeuJw60oMZyVMVGr6UWSIZeWziwwYGPip6WkxAaQjpAWFic5qsk9v
	 udoG+5oOzaLem+Ui1bTYvR/6EpTLACUauTUmYEC4WnXbZdnDXCTeHM0uCOad2bmZ4aPSW
	 Lewlwqijou0HBxGpxWAxnACayjRmbUKdt4e65Xj9c6QZB3GN/3x6Cek0L7cMw9SWLMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lQJn1vWA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E43606A31C;
	Tue, 17 Nov 2026 16:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lQJn1vWA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A914B1F000C5;
	Tue, 17 Nov 2026 16:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794931423;
	bh=Ld9+YyGfs/W/wYUchYl+G0tuTdeNOsMW/DqiAiz5bT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lQJn1vWANzv+sPIfw2hf5sx/UjpCexnoEys8FIe8H1v8DwNVlmkSvXMCIYCmV3rIh
	 pWjlAYtusYS7vUx7AdpjxFihIIyNIYlpMhT7x+HgFT3RE4XA7SGIWls5wdZpQp++Mz
	 mJZpRct77cXJlxebJc/SIeIXnVyNw47tLroqXFskePvd9lV90/ZcuDLW0ZOsniMiE8
	 l8T4Mb64By9+R1XeYIaccO3yRDrfFsaby581+DJ00f4BjmiPcJlKBqA7l/Tlon4C81
	 RAhDqYW8921dUHUHElCxYLZzqZ7aG+jx4U4kpcaW/zozgYRYV0k94/frHCwuSO7AF7
	 VKKXQ16JE3Qrg==
From: netdev-bot+sinfo@kernel.org
To: Wei Hu <weh@linux.microsoft.com>
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
Subject: Re: [PATCH net-next v11 0/4] net: mana: concurrent HWC requests and
 dynamic queue depth
Date: Tue, 17 Nov 2026 16:03:41 +0000
Message-ID: <179493142123.3291.5899879378261297163@kernel.org>
In-Reply-To: <cover.1794751992.git.weh@linux.microsoft.com>
References: <cover.1794751992.git.weh@linux.microsoft.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by LLM and not proven at runtime). If it was triggered
   please include the symptoms, like the stack trace or kernel messages.

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account.

*IMPORTANT*: If you do repost (for other reasons) - please include
the relevant info in the cover letter or commit messages.
-- 
The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
