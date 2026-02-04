Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5E82D73A0;
	Wed,  4 Feb 2026 02:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770172922; cv=none; b=jAkPS4PKvHZ5oIDLhT0a4LtNSIUan7eofVvJ2VvgZ7SZ7C5eGRs7s6puz6+805ygUW6nwLBS8emMhyfxGGI2qwv093DV1vE1NRhMgowh6SsIAIE6cX9UiQbVidKeFlGWtBv3Td91RdZeHXKumKRPpt9lLAJAtWprZ4vOCV/EnTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770172922; c=relaxed/simple;
	bh=eJr8hiZsk9Jm858UXogm2Fgm8PesKeG4Nne4S52av54=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q8BxI0YJS6JMS9tJv/rnkSPTjc+B/rItlPjhRU1PouPobqxHyAd/h7MycFJzQ/FBbHP4NBgQyMRp4EH9rhzSDpGkZyPTigyH/1gcT3HIZJdZ71MqFIN3tyQRoIcveptd+KNRW5qkY4FhQIWfc0Dwl8oMxzZpPtHkmutoqapkwGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WELAKbXa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WELAKbXa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446C9C19425;
	Wed,  4 Feb 2026 02:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770172922;
	bh=eJr8hiZsk9Jm858UXogm2Fgm8PesKeG4Nne4S52av54=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WELAKbXabwXNbM1aj6pDKW1izTyaA+pich5YpJXTCqhOecmecxpJVb4Wrea9Wm4VY
	 Q1uNWpJIGpw9DDjk2GmQ+Jlvs9lVVijzWJ+TOdRFZxkzgWAMJ8LOfpPL2zg9rZ6TC+
	 RnoyEILi++csXlRiB2gbf5PaA91B3AfWbFqdVqxbjy8fX2PUFZoCCNBkRBVYZ1IKLB
	 /2fInX7Z7u0tloXvsnfgdM8uusKsnkOE9jGY3xowdcVHcD4UAGqfrrv1DCnaa4f7b9
	 8hD9oZXjREimKhNAyh+GhpBOlEui8hHOFQsxvaziRbXOXBvGjDEucphbCOfSinIBfK
	 d6Id1Lg3TcpeQ==
Date: Tue, 3 Feb 2026 18:42:00 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Tariq Toukan <tariqt@nvidia.com>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Donald Hunter
 <donald.hunter@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Saeed Mahameed
 <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Mark Bloch
 <mbloch@nvidia.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-rdma@vger.kernel.org, Gal Pressman
 <gal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Carolina Jubran
 <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Jiri Pirko
 <jiri@nvidia.com>, Randy Dunlap <rdunlap@infradead.org>, Simon Horman
 <horms@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH net-next V7 02/14] devlink: introduce shared devlink
 instance for PFs on same chip
Message-ID: <20260203184200.216bb426@kernel.org>
In-Reply-To: <wdkd7yelgosii7bklmahxf5t6xnn2vydnwiiruiwqpyue722dj@yjnkcdctzeav>
References: <20260128112544.1661250-1-tariqt@nvidia.com>
	<20260128112544.1661250-3-tariqt@nvidia.com>
	<20260202194946.64555356@kernel.org>
	<wdkd7yelgosii7bklmahxf5t6xnn2vydnwiiruiwqpyue722dj@yjnkcdctzeav>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 3 Feb 2026 10:44:16 +0100 Jiri Pirko wrote:
> >> +/* This structure represents a shared devlink instance,
> >> + * there is one created per identifier (e.g., serial number).
> >> + */
> >> +struct devlink_shd {
> >> +	struct list_head list; /* Node in shd list */
> >> +	const char *id; /* Identifier string (e.g., serial number) */  
> >
> >Why does this have to be a string? The identifier should be irrelevant,
> >and if something like serial number exists it can be reported in dev
> >info for the shared instance?  
> 
> String gives drivers flexibility to use anything. Perhaps I'm missing
> your point. Are you againts free-form or just string and buf+buf_len
> would be fine?

I was thinking binary buf+len is fine, and we shouldn't really expose
this to user space in any shape or form (hence no concern about free
form).
