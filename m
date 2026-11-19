Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054777;
	b=JqgAaZWEEgFZAX+tj16OjoYwnxK8a4KTj8FNViccWB0rMtvg0nGyZfRb2eKrI2MIDjjI
	 3iusOyZtURKXwVddvBC3J7EYLcjnMp/Nq26qozEhUdfR4ySMqXtrn5K0naKFKKZ02b18a
	 1t6T2s4aO1z9gthvZPS4AUBU2710Qq8Y/23Snd+Wcgwm/Xl545UN2HWTPVL6pFg6lWcBN
	 2DnHPPWR5N+eKD6pHgSNtBBJhCLUhuBrKEDyFTd5uVyMwzP6ckhny/Q7rvJ+WZQ28nDPj
	 prVzUxb0Ffk8WRnGMjEcHTrk8mHeo1bcfq27wEkipHfmGoVL2XxrJWIGFU/O7TFQyVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054777;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=x76fuySMjOLJQoIqrOK++7Ix1/3pTjbSZqz/xRH57XI=;
	b=LUwdjCp7BBQJsOsQ6jvUNQFP2RRsnrq9EIq44dlI5s1apCZDnlgCqdD63fiBeSi6TwDW
	 MCEzyicv5lp5sYHpwlsnVoAQVLyyM3spHtHenBzPfjwpC68CvVb752fQROKcOjW+0WlLU
	 D8KdP3rYCh1Ud5tDoh5L6KPFDTBMEr5xRkyhRg3nTlLxfPZ5Lyix9VnRNuBKedd0GMemw
	 NMuaAEVU76H3pU53aUNPqaSWebntCgLmVM29+4m2cyZDJv7UY69JiR5fQR7szUEdLgg23
	 Euffhowxm1rrMtZr9lodKAFhkoDvoavXfmmoItoLrtJzEe2fDsV20Orvb//ONpznCLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ATlvJmji;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D895606A32C;
	Thu, 19 Nov 2026 02:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ATlvJmji
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9311F000C7;
	Thu, 19 Nov 2026 02:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795054776;
	bh=x76fuySMjOLJQoIqrOK++7Ix1/3pTjbSZqz/xRH57XI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ATlvJmjiEovAKxuWckCcYVqGExELfmCknB5sJyWhvJCNr63WaxMSWm+zBY33vXhWU
	 jt2ic4n7iX07Rm4qkVJB46YB8IYtj41DzBkwafWT6KWSydMMHpjh8XkopJlqxd8XkK
	 pBdDmJ5R0dEwTdroOTPwdAVFZcpU5c+GBJDGPGP0jm2qMgvJYLWkrbf8BYExPQXdmY
	 ILV4CaV/dktuxwPsP8+i4RSBRiGGM4pa5xK3C/e2HJ7kpFlHW32R1rwlOS9Ds4zFsc
	 KU4gZsuMnob048KqzOUtb8J/4DwKpOrbAis2tIzkBKmMncoM3tGZ7MR0689eVFv72F
	 WiHcnoaLFHFhA==
Date: Wed, 18 Nov 2026 18:19:36 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Allison Henderson <achender@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Joel Granados <joel.granados@kernel.org>,
 edumazet@google.com, horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/5] net/rds: move sysctl-only code under
 CONFIG_SYSCTL
Message-ID: <20261118181936.2f6e9d7b@kernel.org>
In-Reply-To: <avmymGvelu00X5EH@redhat.com>
References: <avmymGvelu00X5EH@redhat.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 15 Nov 2026 14:24:40 +0100 Oleg Nesterov wrote:
> Compile tested with CONFIG_RDS CONFIG_RDS_RDMA CONFIG_RDS_TCP CONFIG_RDS_DEBUG,
> the kernel builds with or without CONFIG_SYSCTL.

Why tho? Who cares about this? How much is this series improving
the life for those who care? Otherwise it looks like pure noise
and a bunch of ifdefs we were happily living without until now.
-- 
pw-bot: cr
