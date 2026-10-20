Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792508425;
	b=sgjr/zcVpKLOvps29NnLWX//wrAAQQwZ9aalDROtgXrCSa9gPzxAXNzTN/EBMS+RiiiU
	 3BubzVRmGtTHZC42lHtbRCFij/xJ7+ctu4abbrk7B1wFfAKXgw0yedN02Ddzskw/byndc
	 VbzPunRCkQ4k7WOiTX7RS+PGXKDmhfomyGiydynmjWBb2N+UlYiwGpC0t0aMq7Ba93IKc
	 IKA0fUlEvTA3q4Q93EHTDAr6hrrU8i+VNbV75usAbv9Fjb5CTwH5hQzC4YNoD6LgAAHp5
	 X9OrowXHY8YeIrl8RUFJBi3Re6mDTM+bH1o9Jj4lekrKRefFpHbgEUU88vLEaJF7iSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792508425;
	h=Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=FNdqmEWPp23nwT1xOaRd/OVsSvQwCva65ssRTXpnIaE=;
	b=tEeTwjQtSYoK65fP7U8AN9BlukHmX1Lg9Q5H1SaU38Ot1BLWGgRY/Vs1fd6Dx5yBc7q9
	 AGWEuT8EsQxHI64afEYkqXpmBhLWFKa6faYmPO3H6Q3pOvKSMLafCEk4aBEsU2tXmUXtI
	 pG/i9Eb/doMZXAd0QlXnrY4VPgtLDC1CFUo6RSGcxjbZ1JFcIcpw7y3Yb24OaO3Ei/NLU
	 TgL6jE2pZjExoI81ACcRr0iudLgsmmGTu1QBAI+uy/XTa6cyud3CMWjVkDcssFZUVQ7FZ
	 O/3+Fp1t9o0KG7Vprf9fMqfSyak4Tnv9qowQXmZvkegh8HgGHRxbUoO5pNTGdDJH94g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C995C606A31E;
	Tue, 20 Oct 2026 15:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A622E1F000C5;
	Tue, 20 Oct 2026 15:00:23 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: Michael Margolin <mrgolin@amazon.com>
Cc: patches@lists.linux.dev,
	stable@vger.kernel.org,
	Anas Mousa <anasmous@amazon.com>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-6.12] RDMA/efa: Add EFA 0xefa4 PCI ID
Date: Tue, 20 Oct 2026 10:59:52 -0400
Message-ID: <20261020145952.3643186-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019150905.GA8110@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20261019135441.1420968-330-sashal@kernel.org> <20261019150905.GA8110@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Oct 19, 2026 at 03:09:05PM +0000, Michael Margolin wrote:
>The 0xefa4 device support requires previous changes introduced in 7.3.
>Please do not apply this patch on stable kernels.

Dropped, thanks.

-- 
Thanks,
Sasha
