Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289713093C6;
	Wed, 18 Mar 2026 23:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773877443; cv=none; b=Di80fCmH9rwQ6QYEkhEmE+NkX15+/wUAVQF7aVFPs22fFDjCoM97XhHg/YONwGBFlt4AOjaG08ARtHKFcvXP5WVnyDzpcDfR6X1kThmDLjg8vn7nPKTJhfZwBpjSZrNH98bqV/k+f49mitcGG2MrisGhwkTx+xbF7M9sc1VBelk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773877443; c=relaxed/simple;
	bh=LDVwKwhU66UNnxyBdRwWIlldfQz8DanP52j6qpEBkp8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NOGFvGkhQaYgHg4ZKcYYZxbKaa3uEvp40dqFp/OpKpDENLzcxnORa5p35F5Q1tEjKDKjLNO+MB/kpuuJnf09qayCVkqQbo81tSZNJrgByE0AzOs6puntZ3QUsgKBRJKOsfIAsKBbW/lXsIQDaheAZVzEer6lu9nb1kro4ywMz0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NEra8VZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NEra8VZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC41C19421;
	Wed, 18 Mar 2026 23:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773877442;
	bh=LDVwKwhU66UNnxyBdRwWIlldfQz8DanP52j6qpEBkp8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NEra8VZiV2gad9jUrMtokVLpfDYJW6lME34Ou9fuHbaGdpFJ3s18CbixJLn88BUgL
	 KC70KvdxTUjM7iVF8CxBG0wbPhDihj4zQo33kB6KV6bWm/mjErbf9ZiqNuah2mQ+uB
	 dqqqsZDHMxA5yMFLoTSuPK+I5/KFkR5sQMiSoRQOcn4kmT35WOSynEDGrNjpsAiLbA
	 0S1zgVEF8mcqn+m8AkBYR4TEzvUtXNJDqrQIXuyN7Y/WmzXRPiemrMekAV5F1NLwWE
	 +aVeg23spYOOvNuQvAL/adfw6DLPS77BRoboCTkz0wJ2OrIaTo3a2YbDboo+vm1Ezq
	 n0nenH9yHDQ8Q==
Date: Wed, 18 Mar 2026 16:44:00 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Saeed Mahameed <saeed@kernel.org>
Cc: Tariq Toukan <tariqt@nvidia.com>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Saeed Mahameed
 <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky
 <leon@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>, Moshe Shemesh
 <moshe@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>
Subject: Re: [PATCH net-next] net/mlx5e: Enable mac forwarding on uplink
 representor
Message-ID: <20260318164400.11f75f41@kernel.org>
In-Reply-To: <abr4O7rfDoOIKHYW@sx113>
References: <20260310104841.1862380-1-tariqt@nvidia.com>
	<20260311203319.76d35ce0@kernel.org>
	<abmZf3bRl2uQ69EA@sx113>
	<20260317143653.0eaa50a1@kernel.org>
	<abr4O7rfDoOIKHYW@sx113>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 18 Mar 2026 12:10:37 -0700 Saeed Mahameed wrote:
> >> Mac forwarding in the sense of linux bridge mac forwarding mechanism which
> >> requires set_rx_mode ndo to be implemented.
> >>
> >> Linux-bridge --> mlx5-uplink-rep --> set_rx_mode --> set up mac in HW.  
> >
> >And the actual forwarding happens in SW bridge? This is just to
> >configure the Rx filter not to discard on Rx?  
> 
> Yes Forwarding happens on the SW bridge, just to register the mac so it
> won't get dropped.

Ah! Please respin with a better explanation and calling that out? 
I think it's fair for the reader to assume offload when reading
about representors.
