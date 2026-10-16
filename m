Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F67626C3BD;
	Fri, 16 Oct 2026 23:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792191905; cv=none; b=Dk82GSOPILQLe6zjSfOIupp5prVDS5LnleWrT378o2cPsugc1yHOSWYqViYHbGYpv0xbKB617t4Uxib2w4AvNm+VH+Umld+jsLM2W/AgPeEz7ZGXb9Akh6H6BtgQcAHM2u+CSlCYm4YezUEwl29QjvEMJUHywGL7Ujx7KZDlNPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792191905; c=relaxed/simple;
	bh=9XPttyTlHUFqyWxo3Q3vhzRejEsG6o9LCr2IFxUbPb0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gg//bPn6lKUCjvbS6NgEt0tonJM+W8okE6ztqV99EEJwe2hcfxlsHaglvEe/G2/aVmKe49xp1+gWlSnrEE4+Z1zveRqJZIfMWkh+69fVQKa1oF9dpipKjAofvi5c1AuK6epjzBDP+rJ1VC82rsL4DOT4igptoO6vHY7ksakq0Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RgZXMTYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RgZXMTYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917971F000C4;
	Fri, 16 Oct 2026 23:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792191903;
	bh=EQ81ZeKOvs1Cq4G2sdjIM++9f9iVTY3PCeB22nEhGuA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RgZXMTYhwSW+0sCtcuEZWFJDZ2m8jeVHe7c3pdYMtYav4PKRm5yYys2C3hSfpPGR/
	 bG9Knx21MMUj7U6oOB/GXaW5oAPZCdU3xA5dL0hP8CAqzmFw/R5bgyIRaf2f79xUaZ
	 wUD3jtSOlOuPsayAyuKwjLJgPqJYYbuZD1JHnI/LynEALPd1KAXbaCRI7TP7+8j4og
	 begoRo8P2HGQFsWnS5Zqm+CC+92zHScJffLA3babq81C7RDacmI99L9Tv13C3gFn4u
	 +KEKxWVvO2Gr2+CefO0VlpYlb1YrJtd1/BXDR7jMKM+ccVlfBBM4kAlpyBfTum9xxL
	 fXfigHITk9eJA==
Date: Fri, 16 Oct 2026 16:05:03 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org
Subject: Re: [PATCH net-next v9 00/13] net/rds: make connection lifetime
 reference-counted
Message-ID: <20261016160503.1f1b807d@kernel.org>
In-Reply-To: <20261008031333.1142174-1-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Oct 2026 20:13:20 -0700 Allison Henderson wrote:
> This is v9 of the connection-lifetime set (v1 at [1], v2 at [2],
> v3 at [3], v4 at [6], v5 at [7], v6 at [8], v7 at [9], v8 at [10]),
> following
> "net/rds: own the fastpath locks across connection teardown"

Patch 12 fails to apply now, sorry about the extra long processing
delay.
