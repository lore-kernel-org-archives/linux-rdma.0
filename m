Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E02C288C30;
	Sat,  4 Jul 2026 18:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783190061; cv=none; b=O4gfqa94QQROJRfRpDn4PiWZknIbks/TerKXog8GX8MD44cdcdYvx3D5GHdOxJr5JaIa3q4QzNwzCKVNb+/6uIhwAIUabW192M2qVAW0O/baIhvWTbAaze1nfACaySexcdODg4YEwNygRyQiUK5jE6B50p83c8CtKMtyrbtyOoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783190061; c=relaxed/simple;
	bh=t4uLipmtTHy4TWILekTxNplI5i8nYUWkrj5/SDDiN8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cuu4j0dmU7TA01uJcNwNJxFoymmX3BmMj+4TtptChR+7mjBohQUXTruuF4Iyk+kYBUW/jjJ8+j5dvcMlqpT2kgGXyTNxJSq0gdIPhARRLTguqNBl/Hcb1nUa8BXfz9M+v0aURau+ITRq2NuXdvAWQ1LAOKg2K09NkCjGV5FBryQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=m538+Iqz; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="m538+Iqz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=E8SM0kUCm63/KA5auRY+06ic1R1eaIh69eRXGvfr/9c=; b=m538+IqzX64c8XRC/KO4zFNtgr
	XEBwPOZ17t5enfp6bSfr2TxY9bbwG4nmCNsndLuCed5R+Q0+SBoWU9vEaZqcPJp+G2hY+V9pavMCT
	53bcv1DR6Cm05dUdK1gi0n8bw+NO3lhKrrihbDoIu8VUS8VT2BSmdluikB+n/Ed7iFlw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1wg5Bk-00AiZ5-8P; Sat, 04 Jul 2026 20:34:04 +0200
Date: Sat, 4 Jul 2026 20:34:04 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Vikas Gupta <vikas.gupta@broadcom.com>, gg@lunn.ch
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, andrew+netdev@lunn.ch, horms@kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, leonro@nvidia.com, jgg@nvidia.com,
	bhargava.marreddy@broadcom.com, rahul-rg.gupta@broadcom.com,
	vsrama-krishna.nemani@broadcom.com,
	rajashekar.hudumula@broadcom.com, ajit.khaparde@broadcom.com,
	Siva Reddy Kallam <siva.kallam@broadcom.com>,
	Dharmender Garg <dharmender.garg@broadcom.com>,
	Yendapally Reddy Dhananjaya Reddy <yendapally.reddy@broadcom.com>
Subject: Re: [PATCH net v2] bnge/bng_re: fix ring ID widths
Message-ID: <13ce47bb-c8e2-4ad6-8942-e0b4f8ff9e49@lunn.ch>
References: <20260704164747.1995227-1-vikas.gupta@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260704164747.1995227-1-vikas.gupta@broadcom.com>

> - Backward compatibility with older firmware is not a concern.

Could you expand on that please.

      Andrew
