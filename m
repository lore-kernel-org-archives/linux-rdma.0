Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719524;
	b=49bai9dotTxw9ewxqfAlB7kwonX467UJLTooxXRU/Mv90sgKnB5i041nRx1HEFeUz0PJ
	 Jdgw4e8eLvufUbQlovyQJq2avNzG7mcTQA/OFH5G6FKI6iAhD/XVd+1KmXZRsK+kgLp8w
	 SRCL7x0razXjtxIggoSwvsgv/X1cGo2gb2YDjDv5kePjskZdxb2ls8ZrJZdBC9lfaITtb
	 jNvTrG/j9qNb0gyly3zoFN2y6vr6NaujQ7u+K8qPkKQ3e0pUzMl79ZrIS9wktNKMV7Upz
	 Wu6chfWSS2A0cxXQHcdEc7TEYpP3RpDhVNTKd9lDQwnYdrM8ePSkGlMM/jhFDUxN2jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719524;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=oJM+5qKm3HChtsYW/9jpiIl6Et4WsbvoNBr/kloQ5Lk=;
	b=C0PDUNRgrJs0kLhgeX30iB+o+lg1D7LrvIedcUzssVmOcmFai1eI2gOX/pBRz/tioj5q
	 U69bhaKRbGUJ9jN/ukLL+nTPilNu1SLJLCo7g9ITmbUlWSUCzVcUQPOaYOkP/Kk0BFwHz
	 sPzf7W24v8hVsZJD/bQXFANqN8RHd8PbLKKG6mEDuANAwIawxapuNlaOj5mH6PAaly9WX
	 GKPsd5QWul+leKuDpAZyc/yakahdOlga2y2kW5iHPFo6uHPOS0oQ8Ok3diRbXEWrBb5ET
	 5Z2OB4lE6Sb18WIMagf1SYdqE+jj5lGKi6hw2V4j7wth5r/lNjayRpYUajqZWwU8wSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=omF+WVOC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C71606A324;
	Tue,  3 Nov 2026 15:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=omF+WVOC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C941F000C1;
	Tue,  3 Nov 2026 15:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719524;
	bh=oJM+5qKm3HChtsYW/9jpiIl6Et4WsbvoNBr/kloQ5Lk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=omF+WVOCLzpnRBDyoU5lB3T44CT4XKWHTI5qISQiLMsOXACli8TvtNz4DsUSBPSCa
	 2qV9kQzRnOaiET+RXh5aYuMsR+v/sDjCijD/YeOfQahqs5JMjXx179mOjo+6gtV8ev
	 nvqkVMSnW4JzsJXCHqrcYLSJwiU8MJU1k1qJiQioEszcprBuxy1Xdf95lk/De2tRP/
	 lG4lrPFsvForIPe6Xl1AQ8+8FpsTxltRH8xhpf/zjNCoa7NN46iZPWY1uuly2ZoTFf
	 YWpAhpIUWzp5L7n00pzBe+Upt3srJYxzfjX31CSkht+EaDOgtxAbd3dWrdlOf2RCTp
	 SruWZ1mGJa5+w==
From: Leon Romanovsky <leon@kernel.org>
To: Bernard Metzler <bernard.metzler@linux.dev>, 
 Deep Shah <deepshah146@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20261102064437.23976-1-deepshah146@gmail.com>
References: <20261102064437.23976-1-deepshah146@gmail.com>
Subject: Re: [PATCH rdma-rc] RDMA/siw: Fix use-after-free in
 siw_mem_id2obj()
Message-Id: <179371952100.1731945.2108233244777170457.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 10:25:21 -0500
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


On Mon, 02 Nov 2026 06:44:37 +0000, Deep Shah wrote:
> siw_mem_id2obj() finds a siw_mem with xa_load() under rcu_read_lock()
> and then takes a reference with kref_get_unless_zero(). This is only
> safe if the object stays allocated until RCU readers are done with it.
> siw_free_mem() frees it with kfree() as soon as the last reference is
> dropped, so a lookup that races with the final put reads freed memory.
> 
> This happens when an MR is deregistered while an incoming RDMA WRITE
> looks up its STag:
> 
> [...]

Applied, thanks!

[1/1] RDMA/siw: Fix use-after-free in siw_mem_id2obj()
      https://git.kernel.org/rdma/rdma/c/a70672b9b3ac7d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

