Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF54936E46F;
	Thu,  1 Oct 2026 15:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790870139; cv=none; b=Kp1YHwxtpt5BunGadejquzNkqTp06XsWf6VM9fvTdi4oeN7rQwsaDHLtlNYhV70Y1xKqzBhVyqlNVHHi73q5urLpIikl80NesO47BIWQbFwtgw3vvC3g/VwzXM+fU4A6MBv4R+4vlhTEtP8yOW4RI6eDHVSCM0AIy1sRVP0kf4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790870139; c=relaxed/simple;
	bh=MTDQXGGxc+pTRKwaAkP0qLnrnlaZ///2l3xPH4xaIfQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mB6NjArID7BzGJplad2lN3LObUyXu3gjxIMKRnUwfv0c+KtR7S0rVvIRiwMPweb6uUXHMK8F1Hwscr1+1MISuzqaAEvI0pFEX1rpcC3qs+XlinRc/O1SzjxyUnCh7PeyEfHLwoukzr3aYsEbzQgnH4LfknzLJp8t36JwJqDuPoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aq0t82JN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aq0t82JN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBC91F000FF;
	Thu,  1 Oct 2026 15:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790870132;
	bh=RygbB9xBwuwMTP2siLgkMsDYObD6FWwDnpI0v/7Py6s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Aq0t82JNtkB3bEN1VurwYQcVg0usZrJLklPFSSATxkHXH6H20+EAWAFrHciqqFQtP
	 8OgL3Bw8W60LJ7na4ir5IsqWmhJdVUajjGlLOeHQoqb76I0rz6rh4bv7ScsDacHQJG
	 eM5riXQvahIBewz4a+kxmTx3W1/okGp+/ZwIb3w8XHwyFLYyPmySONv50pZxuVG3Rl
	 0ec98tE/QDYWYffJp8+aD6izPAJi1kkflqc8muyVa2Z8/j88repRaB7pq97t4vbS7z
	 7MkgctxQCQCQgRW6+6owBKJPir0SADAMkTsYJJ0BMs00zpKBMK1lONzdsCBf6vSYZ9
	 TFBHVaU8MOGGQ==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Shuah Khan <shuah@kernel.org>, Bjoern Doebel <doebel@amazon.de>
Cc: linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20260930135530.881281-1-doebel@amazon.de>
References: <20260930135530.881281-1-doebel@amazon.de>
Subject: Re: [PATCH] selftests/rdma: Skip rxe_sent_rcvd_bytes when rdma_rxe
 is missing
Message-Id: <179087012977.374812.13144988487105376279.b4-ty@kernel.org>
Date: Thu, 01 Oct 2026 11:55:29 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 30 Sep 2026 13:55:30 +0000, Bjoern Doebel wrote:
> On a kernel built without CONFIG_RDMA_RXE the test exits 1 instead of
> skipping:
> 
>   # modprobe: FATAL: Module rdma_rxe not found in directory ...
>   not ok 467 selftests: rdma: rxe_sent_rcvd_bytes.sh # exit=1
> 
> Every other test in this directory probes with modinfo and exits
> $KSFT_SKIP. Apply the same guard, identical to the one in the otherwise
> near-identical rxe_socket_with_netns.sh.
> 
> [...]

Applied, thanks!

[1/1] selftests/rdma: Skip rxe_sent_rcvd_bytes when rdma_rxe is missing
      https://git.kernel.org/rdma/rdma/c/d2c08575500145

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

