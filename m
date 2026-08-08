Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B262853E0;
	Sat,  8 Aug 2026 01:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786150857; cv=none; b=sHVsRyp6xwy+lkSaOtGAJXZV4gLeM9knNODnm9v8lMAcIDWZrFFniPjgc6asyy0ZX79t+B3zfmbsgAzNUdjtLrtxLkqaHPsotidxYn9SrMApgxTkh/bqbg0PNUqZW0QVNR8ghzBmiy1OMFH57x/ChjqB9N3xzLr9kGeQ6j6kYac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786150857; c=relaxed/simple;
	bh=AliDQ5pLcGwEu0ilrw2lHXTGcq9rNhVuQ2W1AMYiEyw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MWYMoPq5SHlXRQB25omSgGB1P0NZERXEc+TxbU2dWEAl6sxHCA/Vc9xTlxHs0y4F0l+MzmutROZqzNofb1edBfgJVFSHtG0FGs2DEf7uv8efIZaGxF12Rwno/IGQf4XZjv0piVVhIFdwKCfooYR1lF0yUU3IMB9AeXhxdl90d2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GcfVVher; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GcfVVher"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199001F000E9;
	Sat,  8 Aug 2026 01:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786150856;
	bh=syosqafmb08TK1bwXXbZFsKYTDVFwR/DvSgacRRUpL8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GcfVVherGT0LkSFb/qyfgLmSC3FW4iWMaU1uHaC5+JZJWJqAmwm1fZOlsTnPDstZX
	 O6knC1/W4MNwKkvMrDM5JM1hQfoZuDF2iGRVhTuN032Iapn/2igMhpEMQPhncYWaSP
	 rJ7U2UYwJvSYpNGAsMTKNSlUnC3IvhF1Km3ykZIjnQi3iTQlyH7GGKBsbVffBUhUcy
	 oo+RhFeRMTrIZiWWMkLdhNFKbXQ1Z070ikQmXKuaLGOzJLY0svT9clsyhxf8DkXg+T
	 bHtvgD2QSTY+5B8ZPYZVLbsmmGuI1kvpQ6D82VA/kLbLP4xVe4wJxRO6RVZSDVFF83
	 1WMuBpi3F3Xvw==
Date: Fri, 7 Aug 2026 18:00:54 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, Sabrina Dubroca
 <sd@queasysnail.net>, Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
 Alexei Lazar <alazar@nvidia.com>, Boris Pismenny <borisp@nvidia.com>,
 Carolina Jubran <cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>, Cosmin
 Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan
 Ozturk <doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
 <gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Jianbo Liu
 <jianbol@nvidia.com>, Kees Cook <kees@kernel.org>, Lama Kayal
 <lkayal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Patrisious
 Haddad" <phaddad@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul
 Rameshbabu <rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Simon Horman <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>
Subject: Re: [PATCH net-next V2 13/13] selftests: drv-net: psp: Add a test
 for PSP with HW-GRO
Message-ID: <20260807180054.380be9d0@kernel.org>
In-Reply-To: <20260804083535.2946459-14-tariqt@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
	<20260804083535.2946459-14-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 4 Aug 2026 11:35:35 +0300 Tariq Toukan wrote:
>  tools/testing/selftests/drivers/net/psp.py    | 131 ++++++++++++++++--

This is not the right place, and the test coverage is really weak.
Please see the level of detail we have in the other gro test cases.
This should probably be a separate test due to a crypto complexity,
and we should exercise the various header fields PSP has, as well
as crypto failures?
