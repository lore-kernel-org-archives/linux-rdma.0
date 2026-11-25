Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795609947;
	b=JKadF2Jzdl+7fyp307tSax/sVUSYSEPk8rHW7waDDBmFFtL3x38IU6e0KCPsY3p0Issy
	 f0FNB5GuVye9cD1Y05trI7VetB5nb6YPJOdaMc/Fen6gADWYWlNGk9N8LOKeAKYzycw+U
	 hIrWbS1kwFj71ibitiJoGx5+XNvPPw7RkBvjP12DhBrn1Bg5hEMPgGZcZ/jpePLI+ACBJ
	 dgLbVz50qBlLsPAt2vXqvDci27rMtAsHwHHnMa5ipZ0Yl8gy8cAzxTkyi1xNXbyMMeqiF
	 XQ9UzSk8qdLXePeotVRyPXjU6rjWEsVo50QdmlrPbqxmlDyBWgdR23TlI71PI8sk+oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795609947;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=4NWmtZ8CW/7A9XJyobnEBmpRbMXZZGSv3a/9zyUB5u4=;
	b=rImRU0qWdLW47u/TFogPP+Og7gtMrQLhvrChKhuOR/kBturVN7OFuAmtc12kOoiNZyTY
	 +U4vJwcgYHv6Q7ebKI7UjArjRWW9yF7m7ArQdZSfKvgHlK1GYKFT9XnBOWT7lFdG1ZEJj
	 XWwYt0oL+NiF7gPOaCrzIfW6wHdnaYz2VBeVjkMSVy7BPHvKEo6Ov/1vSX5p/gDN8sTZU
	 svYFK68kv/Q4KDW4N4g9FSiSCJAvwfyf7Tj01+3hWyaefKjR5j4TjN3gZ7VN8xLMZkWPR
	 ygDRs+6mFoEJOF2+cdXImFsjCBLjIB+Aik/Gj9//K0XQIrjHmevOFhUVfWzOTk9S7kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TAjcqReb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC027606A31E;
	Wed, 25 Nov 2026 12:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TAjcqReb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECD11F000C6;
	Wed, 25 Nov 2026 12:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795609947;
	bh=4NWmtZ8CW/7A9XJyobnEBmpRbMXZZGSv3a/9zyUB5u4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=TAjcqReb3U63bw0ULkLKAMgSBOS3ijzwvQqcP9eEtXz8BRBbQotTHRHXWBxOTSPS8
	 d6bDOnf2cnNqfdtylj8qXNFONq9MA6l/lYM+ESj3t4PDA+HR/177wZPJU9lrUSaRSW
	 LufX50vkMUIG+ftf4RH8KfRLBMnqtE5qsDbKVLBhpOtR9wT41FtVKi5nufDP5yPKv5
	 MDXJaanHRm1Oee7wDmb9Cd04BnpKxWAOQHfI7MbI0zYPIZROK0nUdUtwNC3riztpzZ
	 MkzkLDd1ktKM8GTrtWH1VUez75lB1avIKRpNxFf5bV4p6aweDbFB24fLJ+xwHXcV8e
	 XgHDJPYEWcp4A==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <zyjzyj2000@gmail.com>, 
 Andrew Stellman <astellman@stellman-greene.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <yanjun.zhu@linux.dev>, 
 Daisuke Matsuda <matsuda@preferred.jp>, Daisuke Matsuda <dskmtsd@gmail.com>, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261122003712.91551-1-astellman@stellman-greene.com>
References: <20261122003712.91551-1-astellman@stellman-greene.com>
Subject: Re: [PATCH rdma-rc] RDMA/rxe: Fix the copy offsets in
 __rxe_odp_mr_copy()
Message-Id: <179560994458.1211799.13917205332984308475.b4-ty@kernel.org>
Date: Wed, 25 Nov 2026 07:32:24 -0500
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


On Sat, 21 Nov 2026 19:37:11 -0500, Andrew Stellman wrote:
> __rxe_odp_mr_copy() maps each page it copies and copies to or from the
> start of that page. It uses the offset of iova in the first page only
> to size the first copy, not to find where in the page to copy, and it
> does not advance addr after each page, so each page is copied between
> the start of that page and the start of addr.
> 
> Tested as root on rxe loopback (path MTU 1024), three runs, with an
> ODP MR registered 100 bytes into a page:
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Fix the copy offsets in __rxe_odp_mr_copy()
      https://git.kernel.org/rdma/rdma/c/53598d569e5509

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

