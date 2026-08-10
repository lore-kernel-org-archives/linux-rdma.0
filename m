Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15EC31355D;
	Mon, 10 Aug 2026 18:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786386790; cv=none; b=d6bLn7pt9ERvDff5rmp+TWhkV0wdYrntR7mDxAm4kUWZnQ9BoLsL+i5L8UoQO9GlxzwPTOdwl8ZdiwktQOs3teGTNi7Vg/0Dw9QIz6wpa00MWvQ0rF8DLBW8xrAnsPRMDl7mxC9CVLFjQEACbmzZPv6Lr4eUd2HAQC+xcEIFIH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786386790; c=relaxed/simple;
	bh=nptBKg23r+9iHdN8+G8QrK/nlaDlJy1vvy/8hof/4/8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U6Kz414SnXCePQlz6l8savwGyUamVWaeacFA7GBEX8BJ6tTR0neSmBmVm3rgKy1kWO3BBI1QwTdNEimcLAZ2V8n7uggznES2RifFhReCRUnZ4nZn952WnnWdcbSI6sMan4FLE0qFV9RO1Y4ESEA4DUXUiU4PO2cN5mFBDdAgbac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j2qs9V6O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j2qs9V6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7831F000E9;
	Mon, 10 Aug 2026 18:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786386789;
	bh=nptBKg23r+9iHdN8+G8QrK/nlaDlJy1vvy/8hof/4/8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=j2qs9V6O4iZ3wLXNgpdGHnEDyHniTsck9y8cj+LsOpwl0CUjG+xgR4qfK/UNg4Ppv
	 w7BI1HxWbMPIoidNkq3noqAk8Zk4dShGVFsmd9Hw/uVl1T8yK/6WDGYDP3+msesz1R
	 JFqSuX3W0x+Udytw++08ewAMPOCM240TbFdIIC/4ncPpQ+OceTTkotptI6DQKErko5
	 yjRlw9qE9e3LJNlDPi8yukYslc11aoMfHZ4UTu8enut7rFxwHNR14PKjcXSde0POjy
	 uBBZLPNHwSzIX1NYEwYAa16i7C6OQ9y6W3OyWq9FK1GPF3dK2GtBQSbWvD+68Jipom
	 KwCgdpCG1GDcQ==
Date: Mon, 10 Aug 2026 11:33:08 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-rdma@vger.kernel.org, Andrew Lunn <andrew+netdev@lunn.ch>, "David S .
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
Subject: Re: [PATCH net v3] RDMA/core: Reject unregistering netdevs in
 ib_get_eth_speed
Message-ID: <20260810113308.5db6937e@kernel.org>
In-Reply-To: <20260810133124.44513-1-krystianmkaniewski@gmail.com>
References: <20260810133124.44513-1-krystianmkaniewski@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Aug 2026 15:31:20 +0200 Krystian Kaniewski wrote:
> Subject: [PATCH net v3] RDMA/core: Reject unregistering netdevs in ib_get_eth_speed

nit: Please don't tag as [PATCH net], networking maintainers don't
normally touch RDMA patches.
