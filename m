Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795609503;
	b=rNuot6Bmi6Yutt96+gnPTj2M1va7vmXYyqsDK8sGvqNKA5JefiQxjt7upM64KHKWqHaq
	 X3n893aLYvqzOZQzkCHAFAK5sfDVgW+Mz2v9LN+We4vbpzeAgu5hpiAFJf9mO+pqMf/3a
	 IdR46ON30cNIifPIDOaIS4WiDSdy1XgectDT1VzQqBHAawf4Dw0p68A1Sr51hnELRTEtL
	 9x4JU3Qu5lrL9XF7zKR0JsyPT9v9dx2FoMA8binl4V9WEjtEzeOcN92MItb0gcL2Xul8J
	 Ek8braKDiMICZFaZTmxZ+wvoDwS2ds2A2rVK15zHC2vnFF5u0at4uawBQa4sV3JEVVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795609503;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=tOVEigTAMlbJqp1UGeUt8ulAnm3uSAJ3Jp9WqDx3RDM=;
	b=FN6g1LSrdvKYbAsVImmtW7MbXEQJmYbAFxHc3qSTGM3pr5VcTAuNUWsO93vnsOi5+n5P
	 G5xLiFEIuAPfk9z91R8FJYn201d0YdlVJZelD7IDXnq+ZqyV5WPTBzMHNEfRB6ST+Cug9
	 A8u2W3X6T8Sun4Y7wD4qQvEFHteRaI8eW3/B09zhyYablaG3l7t8cDtXVVGlwRJ4Q/d8h
	 07zagWcrl2SGOlenJZGEEOJJJRqBCGbHy+s/MY0SPJDQGzpRv0/tKN9HtUIYenp5sDkw8
	 9fwo2sVAn9fDrHln6yhsZjO+W55AmqSY+ahAzOb9BfCFK03MHzc/P5FsnX6iY4GoLiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I4kMG0ET;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05955606A327;
	Wed, 25 Nov 2026 12:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I4kMG0ET
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6741F01564;
	Wed, 25 Nov 2026 12:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795609502;
	bh=tOVEigTAMlbJqp1UGeUt8ulAnm3uSAJ3Jp9WqDx3RDM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=I4kMG0ETdLiDRiWKJH1iB+8FIFTsXSSOryE1LqIsPrlHIMyg5iP978NIUfoCzyNzi
	 3mE3t8mZ1GRS0Xl0ihlFZmtAeLSeP4f/tDXovLYgbxwscamhUnZ6Z9W2zRa6gxrUZ/
	 2rGfNXi4BuMf/GjZgb2N7pOrXbD/okFqSj8LnVHUN8ENzvIzC9BY2RKYeDPAGqYAb3
	 m/5QIJzviR7B3j6OXrDXNv7ZaCv74UQ/GtoPzvX9vAA4+EQ0Z0eVAo9uhla0rCE+Mv
	 K5crbRRkkHa0xBr2XOZ7ik9yJ+/oBD6CsniQuf/cQwRk84Zpe2Tx1+gJI+Juta2vZg
	 lyY12jMNG5asw==
From: Leon Romanovsky <leon@kernel.org>
To: zyjzyj2000@gmail.com, jgg@ziepe.ca, Yiran Qiu <eritque-arcus@ikuyo.dev>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20261120055951.302239-1-eritque-arcus@ikuyo.dev>
References: <20261120055951.302239-1-eritque-arcus@ikuyo.dev>
Subject: Re: [PATCH] RDMA/rxe: match a duplicate request to a resource of
 its own type
Message-Id: <179560950018.1210376.7975509467780141366.b4-ty@kernel.org>
Date: Wed, 25 Nov 2026 07:25:00 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 20 Nov 2026 00:59:51 -0500, Yiran Qiu wrote:
> find_resource() matches a retransmitted request to a responder resource
> by PSN alone, and rxe_prepare_res() never sets the PSN range of a FLUSH
> resource, so it keeps the PSNs of the request that last used the slot.
> duplicate_request() then gives a retransmitted READ the FLUSH resource
> and reads res->read through the union, so read.rkey and read.length come
> from the FLUSH's RETH va, chosen by the requester. read_reply() replays
> the READ through rxe_recheck_mr(), which only checks that the rkey names
> a valid MR.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: match a duplicate request to a resource of its own type
      https://git.kernel.org/rdma/rdma/c/fb3a71e8bbcdf4

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

