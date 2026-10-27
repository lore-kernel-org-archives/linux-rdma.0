Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793136452;
	b=NBMiO3JKbbRdYdSWeHuZ5UkvkCEw52nrt4qKmrtSnbbeUFPmJg9a4b8c31DFCPdnbBkt
	 lDtU7wnER6ojFplwqwaCNCtjQqLQ9I93Ik8I2IWurZBgS75NMaD4Qh+TK0Ijou2AWVj03
	 elN2WIva/OPzFiwQt04zvAwxbKijhmnXvXImPB3v3qh95FW5CoIhu5PgmHE2s5bJwBU3C
	 oi/ZEjs+kNdB5qO8oc/19lf/DIzhEIlN82qVyqUGFfvJIcIxjsu4a4JLwcNhRLjl5l/Dn
	 SNwtl5Yk1XfFqN+FKQkIYURtsSUW+07LYk0YPrDqlK+aEHx4Gph7HuNY9djF2LgUJRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793136452;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=zmfjQ+QJFoW1j+qRFoligu6O+sZZbd+7UWwEUgPrfjk=;
	b=wc7ew1PppE+C6p0g5PT7X5B6NtyGJCYd5Vnr2BK5vROu907WCjztLziJjsYN4HW9bLSr
	 HflvKnbUqM/2NmjRAxHmbYtwp8fCFRhdOqahQnb1Yu0TSvDNZCKG67zF+Zyl/drzJIK1p
	 DHtp7D+NnL2mHScXSlmZ7Zw+0cb5Dvlpq5JazLAZNSqcshJxsp0IVp1AnhfhMdwiO+l8b
	 y/Xkx4wd12mRNor8IlHxASzR953CMmJ1utOrx57gU18XljBG+kpEvLZN3cGhdji4c2E7S
	 8qKmiKTztkTw4qkNl6urxwSLGEB3ftyzxdiCUP2BAH4msan8dt4g/oxSqCvimeA/VSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HBsaAymq;
	arc=none smtp.remote-ip=209.85.221.177
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6F8606A321
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 21:27:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE6F8606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HBsaAymq
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5eadadf23e5so344096e0c.2
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 14:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793136450; x=1793741250; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zmfjQ+QJFoW1j+qRFoligu6O+sZZbd+7UWwEUgPrfjk=;
        b=HBsaAymqvQ6e3C208Z9epw6vz5FpkGs2UPqRvGkcy7eeT8xedN4cMAjHC389rdsTp9
         0ulWpDKH8JyQJhAzOmpR4u4IPYt9w+s09bGYW65H1hL1H5349sFtUf2cZKLA+rLzCJJb
         rHvT820FBKpXmgX6vd3Avr2PUb9ETGrcpQZsdXR1YF1Us2uN9mlmggnSVAk0RebLwjfg
         7flLpT2gMoFS6t7vhwQqTzI2BAAERs/Q2C/hJLn1sDd8oGWIa8c4xVhT5mKUKbVj//MB
         m+p4dr/juATYVk6KgVJxCQctQY/ODmt9F272gk7sQ4fxrxtaMcJ2zlBjbW8Q7JT+RYmm
         lnbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793136450; x=1793741250;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zmfjQ+QJFoW1j+qRFoligu6O+sZZbd+7UWwEUgPrfjk=;
        b=X05ToN5Ljo+axDcyhNOYFTzqt7M/+fbVvGEPZYMC+G1emntE1EFNVDMiPgBzZ8cQXv
         ulaKgBP3/PelCCodg34B7RcY0ySWo20WDJiMYqPnRwndIjgpuDCRAi/N9HEYw2DIK6XR
         GeEbFuMnRyZqo/B67D2Ifa6OUKsIiY1CxrMOjWpCdIOxIWFBT90byGKfeA65xPL2AmoS
         IqLgrfTuf3jG7P55arRt1peltTEX/jecvJbcttd9MDzQ+tL7k39uuu2VOEdJofwhxZQt
         nHlZw13nGcLeAGnjgEXL2MIlI/nrpbcJhGwZCiaKpOyws46cDMBiRYkRQXvUX6PtWJiM
         lbJw==
X-Forwarded-Encrypted: i=1; AKwUvBxEDF429SwwZ/BtnMFfXhHLOXvnxWM6z9wYeTtHL1OWzzfPyRETQGTPvysHl/1Ef6xIL6cIqCMHottj@vger.kernel.org
X-Gm-Message-State: AFq9FYI3FTh8Oy7XIR/trt0iZyOmBMuTAMtnUYQJB3PkhnUjecmJo6MJ
	rNLcO5jX4z43ONog8ojJVi/UAg3xCWxrkfnP9QY8UgR+/dcO2PdQ5jbG
X-Gm-Gg: AYBFou1kya24jzOd7DNEK27tOOuCOZG4PLsUb0DiJjJDJcHsOodY//LPh4qY+sPYMhW
	C3o2eW86oJHM+gq93BI534uYqNAD40S9dcCYAraLXXcU2RPJxSDLZn1+9Rsy4RA6DLoqU7x/W0H
	eMR9L5M9/Yq0Ekm/oVnKw6hu+8jUbzmUx+5FXh4C6w8gor4HKmajhYLwGvMph1xuMbyixhhTE0U
	wKc5mo6fOOZtIr0/1BruScun87Sg4rjK5ei1X2V66/7+U3WKUGmxXYhmT35Aer9GR3dSER0o241
	lZ1uvY/71rDmX/XYf0xier5eB+p+RLzW/gLLq3jRisDwBLUUA/3+pFP1P4r2JzSAiIFDxRQ8BTK
	mtEyBr9APmTK0lFvIL46XWjOHMLzKhxRe3ShWYZ7tEqylLOpmo+yIrJJ/tABbxUo7BTkjYfGTgt
	Z+iTmID1TFZFA31d0veWkhDVwpHGzYKbLtqfYPnZCxU1ZX3fhIYQvhX4xnvsClw5tjwWyu4XJnr
	AC8A3BvecxDddAX3B9DE/TAlpjxHkTs6/w78p2RYqezuekn3f2VhHgesLDlwHMAtrPDK5My+slr
	ONsvNwP0WGzm5AzPeL71OIIBqucniQiNTdbdvNNbhPB19g==
X-Received: by 2002:a05:6122:3306:b0:5c9:a60c:273d with SMTP id 71dfb90a1353d-5ec4cc9d3d9mr258607e0c.21.1793136450614;
        Tue, 27 Oct 2026 14:27:30 -0700 (PDT)
Received: from 16.15.168.192.in-addr.arpa ([187.74.25.171])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec23067632sm12770415e0c.0.2026.10.27.14.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:27:29 -0700 (PDT)
From: Joas Antonio dos Santos <joasantonio108@gmail.com>
To: Simon Horman <horms@kernel.org>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
 Boris Pismenny <borisp@nvidia.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, David S. Miller <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5e: macsec: free SC lookup entries after an
 RCU grace period
Date: Tue, 27 Oct 2026 18:27:19 -0300
Message-ID: <179313643925.89661.17416575088535677375@gmail.com>
In-Reply-To: <20261027142601.GM257209@horms.kernel.org>
References: <179285888829.90275.17386097105525068016@gmail.com>
 <20261027142601.GM257209@horms.kernel.org>
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

On Tue, Oct 27, 2026 at 02:26:01PM +0000, Simon Horman wrote:
> This patch does not apply because the problem in macsec_del_rxsc_ctx() has
> already been addressed by ad17ad50b8dc ("net: mlx5e: Fix use-after-free of
> the MACsec xarray entry on RX SC deletion") using kfree_rcu.
>
> I would suggest taking that approach in macsec_fs_id_del() too
> unless there is a reason to use mightsleep.

Thanks Simon, I missed that ad17ad50b8dc had already landed. There is no
reason to use the mightsleep variant, so v2 drops the macsec.c hunk and
embeds an rcu_head in struct mlx5_fs_id so it can be freed with
kfree_rcu():

https://lore.kernel.org/all/179313582625.87630.11382992904624255106@gmail.com/

Joas
