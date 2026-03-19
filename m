Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3CA3CD8D8;
	Thu, 19 Mar 2026 11:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773921375; cv=none; b=GgPUceD3xXC/A2RZm1AyOLINM/e8UvaXShIMT+ui16zi4+vY+yhNJKRiV4B1M23GNiTwCDl3nhq7x3efRXuPBcD9KAGd24Wu+Hk6mH94D/PhMyM797reoJokRQxSqUTsiyFu77q0vdzbRCWmp5SuEoVPLfBWeSJR1TF1nOdChr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773921375; c=relaxed/simple;
	bh=9jOj9hyckDBevQ31EEmBeud53Almc4xdrBdbgr33FJc=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gw5qI3f3KxPGOA2ex6fxPao7CwOVuOgt5r4PpNbHEUe7w9RFPzpWytOKdHhWzIN7fk5Jg8ZHfRZoxXpmj8DOtsHlJ8PuVbWNBG6E5Ji0SDX98DEFjknhs/h9EisRE0Gl8fZgtheLfNlnxdZKVOQCvVKepcjyP54WO090dA2cRGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HomQ5igv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HomQ5igv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6F1C19424;
	Thu, 19 Mar 2026 11:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773921374;
	bh=9jOj9hyckDBevQ31EEmBeud53Almc4xdrBdbgr33FJc=;
	h=From:To:In-Reply-To:References:Subject:Date:From;
	b=HomQ5igvUv+xuE/qPh+jaiAylFnJpSfJ7ZZi6VAUD6TaGZEh4fG5jH2mlEABV8zxQ
	 CYGpFIU7fbwjJxUIlFxHFBqRdpu0tcQR+XXSsTI6V2CLrvXsYcpCLu+UrfxrL1Fo32
	 6wXCiEcPHoRrqZASt5/mUZPISSAkdgGz8EDVTMbOh2ExapuHFC/p0RqSC9+sYsA81U
	 qBNpIpa+/5IS4LHeckJNHW5BG3StdhsGbawxSbP1fGlitVeC7k17mn7fDs68RKYpKG
	 rr1e8MwmF419J+kSlMPzeGEFiBH7VhK7WaD/3OdMwLnt7QtC6a67TJikMzrnorF81Q
	 1VvDRP0/uqOlA==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, zyjzyj2000@gmail.com, dsahern@kernel.org, 
 linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260313023058.13020-1-yanjun.zhu@linux.dev>
References: <20260313023058.13020-1-yanjun.zhu@linux.dev>
Subject: Re: [PATCH v7 0/4] RDMA/rxe: Add the support that rxe can work in
 net namespace
Message-Id: <177392137151.816693.16033033040849071915.b4-ty@kernel.org>
Date: Thu, 19 Mar 2026 07:56:11 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 12 Mar 2026 19:30:54 -0700, Zhu Yanjun wrote:
> Currently rxe does not work correctly in network namespaces.
> 
> When the rdma_rxe module is loaded, a UDP socket listening on port
> 4791 is created in init_net. When users run:
> 
>     ip link add ... type rxe
> 
> [...]

Applied, thanks!

[1/4] RDMA/nldev: Add dellink function pointer
      https://git.kernel.org/rdma/rdma/c/fc3992d6e1e9f8
[2/4] RDMA/rxe: Add net namespace support for IPv4/IPv6 sockets
      https://git.kernel.org/rdma/rdma/c/63ce1810c841df
[3/4] RDMA/rxe: Support RDMA link creation and destruction per net namespace
      https://git.kernel.org/rdma/rdma/c/6d8756013d0e24
[4/4] RDMA/rxe: Add testcase for net namespace rxe
      https://git.kernel.org/rdma/rdma/c/a4f4c76c90c53a

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

