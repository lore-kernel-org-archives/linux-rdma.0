Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A012357739;
	Fri,  5 Jun 2026 19:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780688334; cv=none; b=HHCkY37EYqtymbFYjH/CjWAE/J35L/INfXQxWX50Q0UJcCHtBLBQIT8Gve/x+pO5Lf3MzKlQ1L7ZCwbbfP4gpBR2yVEZVCRPaVBjbxXDTtvlf5y+H1DMy0usSdWJrUQhLlrFU3LHFLVZM7zsHQzCkli0rfHik0GL4oclpW/0WEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780688334; c=relaxed/simple;
	bh=lCwO5Rwr3CuwAk5QAocAvVlHD7rUNE/JkIOKu5NrsHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tGCSmzA2ftFi2ZUveMxhHb1lG9Jntythwe24Oukb1+oXL3wr4I1Kh4x7eu9HimYgBX/3ga0eLu+ptIFeRD6eTYdZagr/y1ISbzyzBVR9nuWTTBO4VyyKBsF8qU5jJqtXmx+kljrNGHMPb0vB8xn7Bjl6KkW4ZyqVle663w53iho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=L5ivxWRC; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="L5ivxWRC"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id EA09540E01F9;
	Fri,  5 Jun 2026 19:38:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id UseOQ94Zu18F; Fri,  5 Jun 2026 19:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1780688318; bh=yMNim7+M4ABpkCsf5wTM7i14oOqpyG/4aQieIQ4pxgs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L5ivxWRCx4VgbIkEomBzqdDTY/eUKo20HGoIT9Gx6wEvTJp81zrO3rwkwjnpCgr/w
	 c9HFOOH8Pp/Y88RsGxhP5wEU+IGCP0Ml3HzO5ZpwZO09z1TCv5+TAHt6xwblstOsAK
	 NkPFeHEVDnbfjnzwIcldbTcSDHuzfqOcq+tZc3+OxkHuGkG5Xef41svr0bz9ix4ura
	 8zHOSx48y+6S7rGN7Eez4/GMM17vLfc5U/MFzljFJZTdS4NFzniDBQzrr52Vu5ErA6
	 ZUxYY3jNw36TuOynV6Y/ojdEIjGM1Rduulv3pjU+W3/YxdyG3RVKJi5XsCPZr+Bgv5
	 k6KgUrKgPssTGJw+MOpTUgOfD+KCuocStOsbIWFVTopQgjO//oTZHVSqTB9agm0AmK
	 Dg/TPpawtLGmxCV1Qem5zHj1nxV0fJ7WVt7bfdxvfCAMU5kERh2t26FvCRA1YoAhcF
	 PqCF7PX4GXv+MqNkb9Fqpx3IK932v+9mL9RJ/aYVfOPBJsXG3QjS4XQI3czWX7hbm0
	 TfsKFVrz6fBrQHRPXJfI5uCjiLzm6551VucGUsKZB4kI5F5avzlgHyMytYZ/H0Yxmf
	 CY/7S+91ujoSjSpSaZHaqDGsMWZyXVj8mC1dPNmRfN2jWOadkbmNnWVw5ZnflXhtq+
	 a/4p5C5BiTnlEAfjqCREC+sA=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::2b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D53DE40E0203;
	Fri,  5 Jun 2026 19:37:57 +0000 (UTC)
Date: Fri, 5 Jun 2026 12:37:55 -0700
From: Borislav Petkov <bp@alien8.de>
To: Mark Bloch <mbloch@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jiri Pirko <jiri@resnulli.us>, Simon Horman <horms@kernel.org>,
	Sunil Goutham <sgoutham@marvell.com>,
	Linu Cherian <lcherian@marvell.com>,
	Geetha sowjanya <gakula@marvell.com>,
	hariprasad <hkelam@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Petr Mladek <pmladek@suse.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christian Brauner <brauner@kernel.org>, Tejun Heo <tj@kernel.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>, Eric Biggers <ebiggers@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next V3 0/7] devlink: Add boot-time eswitch mode
 defaults
Message-ID: <20260605193755.GEaiMlkzeIgEXc-qtZ@fat_crate.local>
References: <20260605181030.3486619-1-mbloch@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260605181030.3486619-1-mbloch@nvidia.com>

On Fri, Jun 05, 2026 at 09:10:23PM +0300, Mark Bloch wrote:
> This series adds a devlink_eswitch_mode= kernel command line parameter for
> applying a default devlink eswitch mode during device initialization.

Please trim your Cc list. There's nothing I can do about networking. You're
CCing too many people unnecessarily.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
