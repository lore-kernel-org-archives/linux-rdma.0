Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F07364951;
	Fri, 20 Mar 2026 15:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774022007; cv=none; b=K/5zXX/Xoq9jZ434vl13ADLxN5Eozgc39ZEqSBebFWYaNt65zHR1uthIaOyt0CKBnTfn2otYJ0idUiOXEfOM+US/8siNLgQOcV0IwFmfJnoVdvJOoA37GQSAR2XvRLdpVAFqSDMvMcq9LNPrywk1HNNJrnlkva0KfpKeFde9/u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774022007; c=relaxed/simple;
	bh=dUoSYwUjUcEnqomdHPtx9gEQLHzWM4becMbFXd30NRM=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=tdmK2vQxpcXi6bRlaoeNmyHT8CuOTAz6lWXz64GbPCeyW9R+07CO2oobJ/qYmszRHUsFggFhbMUcT9jYiyWABEiNprUWUJy0rW1W1WF7D79SD6qx4XB4Y0yPuqDHX7+K8CDcw/w43fevF5f+NIiJ4l9d5ikbyACkYQ4aYMXl2ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=BJQCyPfW; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=dUl+OaHw; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="BJQCyPfW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dUl+OaHw"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 3DD2F1D00126;
	Fri, 20 Mar 2026 11:53:25 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Fri, 20 Mar 2026 11:53:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1774022005;
	 x=1774108405; bh=noOXDEKNXN1IiJg4buPQeIP+T9GD+aXC85Vf+H9KRV0=; b=
	BJQCyPfW6MMtGrEkrmOalK04Na5N9+J/YpoKt/bOhbsSm91nZz62CYQSlreN/kDq
	MO/BN8AxGQgB97e6sGfMEYXXyBP3AgzecxTqx+3gWhF0tqsWBBaIVedivoWv1IAe
	5TXAzX1GLPhp0f+p7d4jXnekfuq7VIJtNYUodfcl53elVYtp2WloVQWJeD6nEiRy
	7MDpAP59SOYWQ8SPg7KdZU/rZUre18zWjDVDdwHyQIiq938mcqgkfKl8l9OBqrtr
	+Y35wrIDXtWNsVVgj9NhCkw1Fk7uanYRvZO0gUckeTOog7WFHnMvTi6JJKU2YTjm
	oHA+IwNzXqIdRquiq4B/iQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1774022005; x=
	1774108405; bh=noOXDEKNXN1IiJg4buPQeIP+T9GD+aXC85Vf+H9KRV0=; b=d
	Ul+OaHw8DmDG5cqP02h4If8IdvLpYIYXXiQi+NpdUqpWIB4+eJSy+mtpCmdMCfMd
	MWsZ/3MpPfTOx2h4Lasxp+ar5CNvpfUhTxEY/fb37gjOyR115l3bWCgiK4p/JwLH
	19cLHpfJ4doBAwVd/FFfzqbecfTp6xnS0EBxB5tNRkIqEi7Pz5UEH2i2B+43exu/
	8/AOYOc4bH/5UZC9emQuK44+iTXfZcMHu0dfpAm9dp12LG69mOYHMTXwCsBmkRFY
	sFxdtw/AC1fRnTAHkHMgB7uwkPCKvqP9D2oXomBX3uuXlCZyoDPOUXbzIc35Sv3B
	dIP1pFrN4xLMJeFl+NkKw==
X-ME-Sender: <xms:dG29aec_8ELwMA0levilxeGwhLh-PGysm-5BJIG6EeLpShd0GZshDQ>
    <xme:dG29aTCTN3DutBayUnzE-bd-PjDn0lZflLK7pmtAKFZejPxHb3wQnskjjYG5TYsOp
    FzIPyuAiekY75KjF6zQNqVzprfwpcnmcuN0HlrttPIcstJFF2NHHAA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefuddtfedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepudeipdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopeguvghnnhhishdruggrlhgvshhsrghnughrohestghorhhnvghlih
    hsnhgvthifohhrkhhsrdgtohhmpdhrtghpthhtohepnhhitghkrdguvghsrghulhhnihgv
    rhhsodhlkhhmlhesghhmrghilhdrtghomhdprhgtphhtthhopehjuhhsthhinhhsthhith
    htsehgohhoghhlvgdrtghomhdprhgtphhtthhopehmohhrsghosehgohhoghhlvgdrtgho
    mhdprhgtphhtthhopehmihgthhgrvghlrdhjrdhruhhhlhesihhnthgvlhdrtghomhdprh
    gtphhtthhopehmihhkvgdrmhgrrhgtihhnihhsiiihnhesihhnthgvlhdrtghomhdprhgt
    phhtthhopegrrhhnugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhgvohhnsehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopehmihhnghhosehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:dG29aSJcFB1R9IPken2tzTCSmk3Z8kIaVeBToUQWrCHgqEiuSdzm1A>
    <xmx:dG29aYoEUPdINb2Ps3_1bS8xiMtgXZmGWqulg4T9eOvPiR6Bpf_30g>
    <xmx:dG29aZgGWoLcnIb2hCS9MLyBuySOCYlJikFRv3Rj0GVbv8ZWIf8Amg>
    <xmx:dG29aXaqxxcvgOld4MB4HL8hub4iax5--KkgRR_k_sytlyCeWaF1CQ>
    <xmx:dW29aQfx9L08UEF-Iom27A2keqpOYEODhtVaR3dH7IyzT8VY2VCWeEfn>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 62EC8700069; Fri, 20 Mar 2026 11:53:24 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AhovTUn8f-P3
Date: Fri, 20 Mar 2026 16:53:04 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Arnd Bergmann" <arnd@kernel.org>,
 "Dennis Dalessandro" <dennis.dalessandro@cornelisnetworks.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>, "Leon Romanovsky" <leon@kernel.org>,
 "Nathan Chancellor" <nathan@kernel.org>,
 "Mike Marciniszyn" <mike.marciniszyn@intel.com>,
 "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
 "Doug Ledford" <dledford@redhat.com>
Cc: "Nick Desaulniers" <nick.desaulniers+lkml@gmail.com>,
 "Bill Wendling" <morbo@google.com>, "Justin Stitt" <justinstitt@google.com>,
 "Marco Crivellari" <marco.crivellari@suse.com>,
 "Ingo Molnar" <mingo@kernel.org>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Message-Id: <6b56c476-86fd-4d43-8dee-c7f89d346941@app.fastmail.com>
In-Reply-To: <20260320151511.3420818-2-arnd@kernel.org>
References: <20260320151511.3420818-1-arnd@kernel.org>
 <20260320151511.3420818-2-arnd@kernel.org>
Subject: Re: [PATCH 2/3] RDMA/hfi1, rdmavt: open-code rvt_set_ibdev_name()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Mar 20, 2026, at 16:12, Arnd Bergmann wrote:

> +	 */
> +	ibdev = &dd->verbs_dev.rdi.ibdev;
> +	dev_set_name(&ibdev->dev, "%s_%d", class_name(), dd->unit);
> +	strscpy(&ibdev->name, dev_name(&ibdev->dev), IB_DEVICE_NAME_MAX);
> +

I messed this up during a rebase, that should have been 

       strscpy(ibdev->name, dev_name(&ibdev->dev), IB_DEVICE_NAME_MAX);

(without the extra &). I'll wait for comments before resending.

       Arnd
