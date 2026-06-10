Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E21229B18;
	Wed, 10 Jun 2026 01:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781053811; cv=none; b=J3+lPHDHQmMN3Lfs0oKJzBpj0E9iUVKu+1LEqUfaKR14KXiiWNUH3gAcFdIyvWQkkDzhymQ859M/FcKQrni0XvUpUc1WTVjnQJKhscGn0kmA66Mbf2rUUqpHZ+6eZoSf/ewzP+E650ODcTDaqbnROutnkxi9/HjP6hYlSDwyIBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781053811; c=relaxed/simple;
	bh=tBjRxMsvIYkhu3TLqVGi/Jwn+5CVWmSg5F9Pqg86ms0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=DjGlEPypCW18Pc3ClLIJt2rf8RCoGi4LScylo9znmUugV4mByB3s+UVLeSAxoytg1W4HV0DWbxB/kSUcz9WokuVNSl3BY15kdcirgxekqbSo+FJ95lfj5hRjg4bqrp8NxvDVEZL6Ak0KtucYg0G4MLtXo+FNXOOSHctljA+F48I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V3i9UpCw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V3i9UpCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7C41F00893;
	Wed, 10 Jun 2026 01:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781053810;
	bh=TRS0K2x+KhOyLAb3tWycsjifz1cV0PWzUeVzV2T5i7U=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=V3i9UpCwdTAuGrFUGaoDvZ0YlBN+c98pcC0vYOhEaxHTmlZRikA7NAEeiFnZi+Nuj
	 JT9mwlPh//qEisc1QxUatPUijLuBv06rIULDBZK4sp1orZhnPQ9fTZ7FUWXSQCvCjw
	 P+DYiXFn8s3TmPbbEWG9cRhy6a4vpmKLWGtL32dfK1ivBUGyQWFzwq1Z3Oii1OgWL2
	 bTABkk01S8Y6qfUWZzqCwRcAUWos0zVvjhubRmfcCXNtP7fnA2IUmvdUrPZVJkBWy4
	 ecTxxPfjIYiSfUgTlgkACuBC7FB+0D0Qlx4ZOPdJS+ONy3aflxPDMS+1dS1J9ksmIF
	 Tx62cCH8yAT2w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198133930A12;
	Wed, 10 Jun 2026 01:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: mana: Cache MANA_QUERY_LINK_CONFIG
 result to
 avoid repeated HWC queries
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178105380863.2776665.17686730574089327914.git-patchwork-notify@kernel.org>
Date: Wed, 10 Jun 2026 01:10:08 +0000
References: <20260606133301.2180073-1-ernis@linux.microsoft.com>
In-Reply-To: <20260606133301.2180073-1-ernis@linux.microsoft.com>
To: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, longli@microsoft.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 kotaranov@microsoft.com, horms@kernel.org, dipayanroy@linux.microsoft.com,
 kees@kernel.org, linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  6 Jun 2026 06:32:55 -0700 you wrote:
> mana_query_link_cfg() sends an HWC command to firmware on every call,
> but the link speed and QoS values it returns only change when the
> driver explicitly calls mana_set_bw_clamp(). This function is called
> not only by userspace via ethtool get_link_ksettings, but also
> periodically by hv_netvsc through netvsc_get_link_ksettings and by
> the sysfs speed_show attribute via dev_attr_show, resulting in
> unnecessary HWC traffic every few minutes.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: mana: Cache MANA_QUERY_LINK_CONFIG result to avoid repeated HWC queries
    https://git.kernel.org/netdev/net-next/c/8e0ffcc926f4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


