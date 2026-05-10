Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7CD371CFF;
	Sun, 10 May 2026 16:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778431055; cv=none; b=pFIWucCmibkcOWIcsHRRsNwzOz8RRGplggtAgVn3mOG4t8Lyj5XdOLHNec7aXtZFsz2PTYQZ01O1R4pXx7MLBkcrOKvBxi/ebQrMts3Xx3swuc05kOix3SsYbocXt2mDGYmH3WMhB9i6SkZAfPUMzxYXEVhxRmemWIhG8zKcKxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778431055; c=relaxed/simple;
	bh=L1xXaxGzoHwwroa3Zr/iluLS4q9Nr5n/YF8ZM6klWAI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VX5CC8APN8QJcTDGjNu5S95CUUaZXp7q74BD/h8qifasTJ747bzQpy6rcHgV2/Och1TWOhkrDWmB3czyv20db38OWk43F5EfzWq2BB2XKtkvY8Rkao5khcS+6VUDdG2SuG3OtayvRWthW/Kq+9UGv4PoveTBpM/3jGRyktrAl24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ymejetap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ymejetap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B38C2BCB8;
	Sun, 10 May 2026 16:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778431054;
	bh=L1xXaxGzoHwwroa3Zr/iluLS4q9Nr5n/YF8ZM6klWAI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YmejetappZu2ZJ9Zi3qLnqfqreo16SA9xAr7Yjn6jpx0CJK+5jTLugHkfSy/52gJi
	 5ul8YzfVPW6hCvF+pUMrnGYNSEuQJWFis4rYbr/2Owohegve5Y67jT3JuA3foP8cWw
	 yV8My0r8fKXTchq0UWB0APXQHO/biL3XWfa1JkInNwlGYp/o2WilHWJ6BZS1IiEmqq
	 vtBWDI3jb8AMsfZRSU58ucWEtKhV4M4gPkeLD5XHeY2PYm/DY3sqcCXEXkAavJrnJN
	 OwQI64rExWJN+sRrsO439QxErqYgB945tOZ0PbG+S0NvRctXWsesaHMEAyuM9DN2VF
	 GCVWrfzrQGe/g==
Date: Sun, 10 May 2026 09:37:32 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Mark Bloch <mbloch@nvidia.com>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, "Borislav Petkov (AMD)" <bp@alien8.de>, Randy
 Dunlap <rdunlap@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Christian Brauner <brauner@kernel.org>, Petr Mladek <pmladek@suse.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>, Thomas Gleixner
 <tglx@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Dapeng
 Mi <dapeng1.mi@linux.intel.com>, Kees Cook <kees@kernel.org>, Marco Elver
 <elver@google.com>, Eric Biggers <ebiggers@kernel.org>, Li RongQing
 <lirongqing@baidu.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [RFC net-next 0/4] devlink: Add boot-time defaults
Message-ID: <20260510093732.6ba47e54@kernel.org>
In-Reply-To: <af7Y4AYv-XDCbK_8@FV6GYCPJ69>
References: <20260506123739.1959770-1-mbloch@nvidia.com>
	<aftaW-irGmkfA7FS@FV6GYCPJ69>
	<3f9215c4-7c84-46d9-ba74-30dabe24db09@nvidia.com>
	<afxvzOjqw-vxUAED@FV6GYCPJ69>
	<b6a9b568-dd09-4414-be57-6b9cd282a43c@nvidia.com>
	<af4lBIJdCuN5VKq_@FV6GYCPJ69>
	<20260508175213.1952097f@kernel.org>
	<af7Y4AYv-XDCbK_8@FV6GYCPJ69>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 9 May 2026 09:01:23 +0200 Jiri Pirko wrote:
> Sat, May 09, 2026 at 02:52:13AM +0200, kuba@kernel.org wrote:
> >On Fri, 8 May 2026 20:07:44 +0200 Jiri Pirko wrote:  
> >legacy vs switchdev only describes the eswitch configuration.
> >As a non-SR-IOV user I really don't want to see the extra representors
> >hanging around my systems, confusing all daemons. IIRC mlx5 had some
> >limitations around the uplink representor. Maybe that's the disconnect.
> >But for a real, fully featured switchdev eswitches having the
> >PHY and PF representors on boot, always, will not make sense.  
> 
> As "a non-SR-IOV user", what extra representors you talk about? When you
> have pfs only, you don't have anything extra. Just 1 netdev per-pf, one
> devlink port per-pf. What's extra about it? When you don't have VFs/SFs.
> Everyhing is the same:

Some devices have separate uplink ports and PF representors.
As I said, what you're proposing isn't going to work for all drivers.

> >> Well, as any other nv config, it persists across kernels/hosts.
> >> Think about it as "unbreak-my-not-legacy-device" bit.  
> >
> >For most devices the switchdev mode does not change anything
> >substantial about the device. It's purely a kernel / driver config. 
> >It changes what objects and default rules kernel / driver installs. 
> >So I don't get why it would make sense to flash into the device
> >nvmem a Linux SW stack specific config.  
> 
> I look at it from the perspective that from some CX generation,
> switchdev mode should be default. So that is a device-based decision.
> I believe as such it can optionally be permanenty configured (nv config)
> on older device. Why not?

Feels a bit arbitrary and won't cover all cases. The question should be
why you are nacking a more reasonable solution. Keeping Linux config in
Linux params.
