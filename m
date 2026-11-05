Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906814;
	b=UiJM2mks2W4qVwz/uJfyAsSGEPIWbqZ9xHpdbPlZvF8Dy1lI1sKGNV5yj54pU93v1VC1
	 rN9rTyxi4MTcZftom2CYy16WsdNMA0DB36TTazTb1mS8NFLgz+YacaIuFiSwuVBOFxd8L
	 Gx9mfJtuu6ZUcnoK/0MG7vnBi92V/b0EvobeuERSOsemcnkzrnsrCYbRKGfHKXJN3AZV4
	 hCqZ8kCl8jBNxNWcsL9l8FQgZBp5UivEkuIOXY5zeQU+aJso7zpEyPlRjjSX8YkTC80X/
	 t/VtSs506wXGD9VeMlWSi+CNxgD7bWa3m0XlnzoaUtx8yNkR02gzvA1dyAlP+lnAzkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906814;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=QuuCh+RhU10BYuTgmRUn3SQyp1gbQbjbgTUFyHM1D+0=;
	b=MgWJze0HF8eH2YJPki9/IHPziZuvhXr1AoPx0tQA/tpWVsWqkPxSYvGk+iKbFQ8SWYHD
	 G+auqRnIRPiz6QCeTf7L/XXJpxmbwCFKFERjW8zSYoIT22BXT2Jzlz8HgMhECZw7LnNVZ
	 aAbqiVQl9WpIXr0OgKdgkg0oYj2nIj47ZbwL6wwGiHXbvYVR2Gv91kMZ7kADzohJXNuhb
	 JeEI/SLJm3vwQFZCiujEivAVUKV+/31MvEpPvI3Cpf8SVYj7yzqzCamluW5XQVZgdLsC4
	 T1wxX+iq7JXp7eIIRUrqfM/5AMINmQ5RNcIrulV1SvblAb11FrnBfQS/CJ773EPcIdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MBgeSzer;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D33606A31B
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 19:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MBgeSzer
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC12F1F000C1;
	Thu,  5 Nov 2026 19:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906813;
	bh=QuuCh+RhU10BYuTgmRUn3SQyp1gbQbjbgTUFyHM1D+0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=MBgeSzer4biCd0/iQwJjP1/VuoA7xTTaOhxIoPGksxT7FeY8UIlEJTBTFU426X5CD
	 I01K6QEareno1xxl8tk4vpEq0NazkCbEIu+RiFvZguY+OV1yy2SsJjCB/QRamYiMCB
	 F69yoBLmQbGh5/PAcPJvPuJd7uCXGqDajTY7pQLlJlGpKoP9MBKUDYpXqElC8PKNCk
	 LVYoAPNHr1UbuWPSi++dVYT8ec6z3xZAFtm9cA0TLHGAXneTvj8d/dBxKTrjSy+4Dn
	 euiN6YjFwwrxtg/uA9YbDnDEZQ+gQ8g7G4m9mhT46cfkwDa2xn2TRaO+3mcR+WOOZ6
	 LUb11zDXDYBTw==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org, jay.bhat@intel.com, 
 john.s.lacombe@intel.com
In-Reply-To: <20261030173556.1873811-1-jmoroni@google.com>
References: <20261030173556.1873811-1-jmoroni@google.com>
Subject: Re: [PATCH rdma-next] MAINTAINERS: Add Jacob Moroni as irdma
 co-maintainer
Message-Id: <179390681065.97620.8326542688106401540.b4-ty@kernel.org>
Date: Thu, 05 Nov 2026 14:26:50 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 30 Oct 2026 17:35:56 +0000, Jacob Moroni wrote:
> Tatyana Nikolova is currently the only listed maintainer of the irdma
> driver. Add myself as a co-maintainer to help with patch review and
> ongoing maintenance.

Applied, thanks!

[1/1] MAINTAINERS: Add Jacob Moroni as irdma co-maintainer
      https://git.kernel.org/rdma/rdma/c/3ec76ed5bea344

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

