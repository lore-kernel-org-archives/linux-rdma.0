Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE731545DA2;
	Tue, 13 Oct 2026 20:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791922573; cv=none; b=UPMoExH1wLdrcXPgSYfmB3v9EX5toPd5fdQpZr1GoP/DmZw/UNfPvQiRb8Unx293TIlEx/QoWhJmCfpO5yKdezKXvBvkktP3rV0zj5wX1p6wovj34dPBAg1a6WMqWftnF0QozRrkWF+q8nYuJ4cEHRT0VJPxogHb0Lu8ARheQFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791922573; c=relaxed/simple;
	bh=x8GQ9TqAFu5driuvo38kqzYt3n324pebOlaNmEELI+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c6iFlaNklczKLCfhxWmlrbDo2HDTgCHKv/lGYVFdVCL0EaQ0d3DsZi6LK4x4IYYNGm47NjXHIs10GxIe3IMmVg4q0+GIqWB+EEKZfRrm3StHXm7h0uIsYNtPpnGPAqQ47CymZiiiOegm/LB0xyHfQAPMMNxgh47/Ms+VJNcdif0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hbn6RXen; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hbn6RXen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D891F00898;
	Tue, 13 Oct 2026 20:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791922571;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hbn6RXenAXMTz0p62vwmsHLL/yqFj1XeQudGiT7zKP8vBQR4lwIks9fpDv23Q1MkQ
	 2BheRE+w5aqmxQCv+n+sFTF8a9wNKGaEPE3bE0AxjQKeczzLy31HyjMSdfehNoEvGf
	 7AgpLl5fowAcdD8ikTKvYlH9wwAam5aL5lou7Ot7sBw9hffdCX+k66ybLlVY/9eUAy
	 rYS+sHIIH/EHtpz/W2v6EZPkyYqbjIX1mtmwt9n5iuHkaEhswclG1UtmwoqCoxMTAe
	 pbazJYBisa/CQXHbKWXK3SLOiZUlQxqIgZcmI6+PaBTYj2NKTuKLfW+qHm43YKkS92
	 nv6K6jEAw699A==
From: netdev-bot+sinfo@kernel.org
To: hexlabsecurity@proton.me
Cc: "D. Wythe" <alibuda@linux.alibaba.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>,
 Dust Li <dust.li@linux.alibaba.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>,
 Sidraya Jayagond <sidraya@linux.ibm.com>,
 "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
 Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org,
 Wenjia Zhang <wenjia@linux.ibm.com>, Tony Lu <tonylu@linux.alibaba.com>,
 linux-s390@vger.kernel.org, Guangguan Wang <guangguan.wang@linux.alibaba.com>,
 Ursula Braun <ubraun@linux.ibm.com>, linux-rdma@vger.kernel.org,
 Stefan Raspl <raspl@linux.ibm.com>, Hidayath Khan <hidayath@linux.ibm.com>,
 Wen Gu <guwen@linux.alibaba.com>
Subject: Re: [PATCH net v7 0/4] net/smc: bound wire-controlled CDC cursors
 against the local buffers
Date: Tue, 13 Oct 2026 20:16:09 +0000
Message-ID: <179192256949.160550.18282620239378164781@kernel.org>
In-Reply-To: <20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68@proton.me>
References: <20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68@proton.me>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
