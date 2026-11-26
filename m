Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795727608;
	b=d+999scL5aJUiZ0OeWiiliBSsOc0ONwBVDWQFm+IjwxxZwQuHiWA7je5W4VjA84AjZQd
	 F/PiuF6ajsh0gjI3yTVG0QukZlUAH+xbJWBbj8QgaZKUtakzmChEyt1+O5ftCaVuh4+Ce
	 tRZCjd0tH7eJaNOy3hc+0F6F/E5yViHohCvcEKNyAPSj0gfa8e+Uuk0hPT4T5DclJwNuh
	 mYBJDevTjonnJXgfxRFKchUaM3P4GBy87ocsDIHlPSR+0wGmOnSKgm2vJu7kuJhnVep5K
	 zoaGliC3yoY/Pt3vMNirzZ88R0kYGq75/WTfSYhEu7YtKG+cjR+GIJmn70mX63iSxLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795727608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	b=f4cniUeotoOj+5m3uGA6zLjnIV6IMCcfepDyKGsRUShEcQbU+787/vVBQgOkYx3iCDTk
	 NqzrcPcOTO3cIO1D2M3o9WifS/IHZDPvGDIZl8yygw7jpfqYqP6cNms0DayyyStpeOWPc
	 L3wtL0E18MFLVQ1bv7A+MK05xhKdOehxEtd7ktzJ+J5SpXcgOYHoDymVpVDwjzWZRRCto
	 ewCvXQ46BTPwXiKZ/s6QSPqJRuPvkSCsZWJWNVC3XCjvbvU4WaRtSbKBya+el4B1Sw9hj
	 MODpauXKjUMSQHjWMpIrCaor4HiYVnKwVEwoLMshW16Ism7xZezwMH6AbfdoKwvGuWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y+F2681g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC08606A31C;
	Thu, 26 Nov 2026 21:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y+F2681g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A18C1F000C1;
	Thu, 26 Nov 2026 21:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795727607;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y+F2681gJ5JuaTeV/gpkfDYlLJRTBYWI601R96kVMflmSkJ9s72mTu82jatdBw/HU
	 SbAHn7qxFqSPSe5W2OpN/srQgaoPGRRTUU/sTToUDfXySmAt+fF00VRdPv+HiOYcb3
	 CBvpv2dLnhBYqcS8o86CmGCt4Vasm52XTQSTb9mHjW1dGuJ2BtRRBCQFu157IEVTo+
	 +2kWflrwkho+pi7kbyyjbznzy7tIxzsCO/Q8mp9XzF4SNB4VLBTJcTIybZXNXlCDjn
	 +J1q1XxR9ozt/Zgd5FW4x2SH9Gc4BI2n46fz59jKyBwW9cZK5VgghNbatoFozZCLru
	 7GMO2Sj1rMY3w==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>,
 Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
 Boris Pismenny <borisp@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Daniel Zahka <daniel.zahka@gmail.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>
Subject: 
 Re: [PATCH net] net/mlx5e: psp: Fix stack info leak in PSP device stats
Date: Thu, 26 Nov 2026 21:13:25 +0000
Message-ID: <179572760597.3294.6336919055347712801@kernel.org>
In-Reply-To: <20261126211115.767481-1-tariqt@nvidia.com>
References: <20261126211115.767481-1-tariqt@nvidia.com>
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

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account.

*IMPORTANT*: If you do repost (for other reasons) - please include
the relevant info in the cover letter or commit messages.
-- 
The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
