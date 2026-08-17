Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC1341F37A;
	Mon, 17 Aug 2026 12:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786971588; cv=none; b=MEEzOA/5kA41SHSV1geEFt8Uj4vAF9HkscJIK9BIvM/pOtOE52Nrzfm9RZ/mTEUy7iQTfrQYiEdfGoQ56cA3QtLSDsbWF9tJOhygvB27r3mIAi+W934PYU8L0RFM//i5oyE15EH73nI6gzjtCigLLE23XrYMJioWI6q891EmamE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786971588; c=relaxed/simple;
	bh=DRyKZDUerO4XoZiKd0/UMs68uPcTpzCDEqnmCAFZfJw=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=LgcZjqZM1HK+pGVMFXEsW0szJP+eGQHUHEJwJPOZhNc9JaEmKQhBS3PRIgEgO5NkxYmBcQFk+TgfELQsZF8Zk/ojHB3pyrmUoY5Kq0UGRd+PTWiThHdsUHDtjbdj6ArpGPujA1XgM0EHBXSDrAlhhFkKMosNyhp9ebLH/fwhIoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=GXRjuXp7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=iqk0ZZGL; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="GXRjuXp7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="iqk0ZZGL"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.phl.internal (Postfix) with ESMTP id 9E27EEC023A;
	Mon, 17 Aug 2026 08:59:42 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Mon, 17 Aug 2026 08:59:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1786971581;
	 x=1787057981; bh=bQ68rGWO5+XJK8Ee7Y4MpJFQgMAvX184NdiLnRVSkzI=; b=
	GXRjuXp7Jv+3Fds7JDBpdOJL6G1CE4gD9Q/IqnxqxWBRPIq0Lw84CWRLF1bvVJGr
	xmPYDAXG2rH1cW433tXlnm/j93zkl3UKZWysNLFOHI45DOSgXBmvGOxR4RnRX/lp
	B7GUXiC/8udS4NoK+K4ISch9RsEnC/24wPiBlTl+k763cvBIuP/nZF0FQom1/5uX
	YxUf/+31mfneVrsawfhBf3bqRkFv03L3YSUzAkvuRfDSZw2MoP5vgu6FHLW56CK4
	PrGCtNqWYU2ENGUaGwx1fKBnXG2CN5DUb97CtJQsTTEbn5GEXwQHEc+URYSWmpOW
	tUrajbGLLfx3JDSiwbcq6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786971581; x=
	1787057981; bh=bQ68rGWO5+XJK8Ee7Y4MpJFQgMAvX184NdiLnRVSkzI=; b=i
	qk0ZZGLQPfTfh2kptC750VNH9PmChyfYQx5a5sa2HUzx390rfuMo+KPS5/ep4zMG
	LMBsJxY9WnhwQBRB909OWefFpqnZ5zJ+Dblok3DBePsj2WpSshvae5Oh3c7wmow5
	eAQYz91n+DdXshP3Z/giKu5eYAUIzRpGD6BeAGYMrH9tY/11aWGfjyrvbYATtLG1
	wRWVlDVK248PFhnrjrF18HilhDan0U6HknNojhtHPgzPUZwROpH/Fn90ewOUFE4l
	6ER2ou/yIflu00LYZ0KLCXI5ymoXCVIMCmFSc8C2+yxVSgPBFgWeYPLYPHYxx9C/
	ZCtW3z6pBHYEhqo1hdtdQ==
X-ME-Sender: <xms:sgWDaqgrCKVVCvHxjDye6qxsId8-HfFnu0DF9f8J8JQI-ieRq0KCtw>
    <xme:sgWDal1aImYo5BfcDZDMLcinayUsbH2vyq9-ZH2akzqiMzW3eGQB_eLIU-4VRHBKv
    Aqkn06p7ifIPIt_pMW0qPRBR1vobxrwrbfBr3uQ6UL_gSFR7lxdU6y8>
X-ME-Proxy-Cause: dmFkZTFrJQquK4O/Ss9PIUnA61QMTKUxplzDdeAV+mGJHm6az6ApcdUzgLb4ocbjXBTFEQ
    5ZIKh+gRdwlURyM1BOZsyjg3BxgSAv9jwi31hDOmEcJFGkpWNl0sok7rBC3wSehXCV6Gcd
    budBvHA5eC+q9TOcRGZPvDE4DVSXy3T7vhgLk6sFJ94H0eJL0jnslBuB3FSILMtRZlFAYQ
    3zD7qDx+GwpfSiV+tmkDGSn7hVAwA0Km7hBXyITvN8slYbT4kTN2IlGcCesnDzxGm6hE8C
    8uoQeNiOVoRRyEGlVYl/E1aRIeYW6CczUWjdYlcaXU6UiTG2IHG3NaqTZV3ij0f/mFK9tZ
    sDMwl00WCYHSE2mF4xDuFUlGcdM/kJShAvBgye9OftzsK1LkfEas2LA64uZZaEwvzL1Opw
    qWsrsuzES5iljhkKU7/9VVHzMPCGSGkFFtyFG4W60Y/fyqzM9DlYA7Yeh3H+HnBKmIhxiz
    eDbyotJI3ZlN4G2pIJIHrODsDnfClP65xHYvCqQNewEare2JOBXlatPbzd2D5ducAH2C49
    NPmXvbXIotr4tQ4v3ZU4LiGzEa/lYEmy8eQXrm48CQFUwp5Y/mWYene0Vs4ctJdQSiKgVm
    m2b+evTH2uotPBCeFVTIIZa7LOWED6upQNzX/x3CJoJPJWBs16qXr0181kpQ
X-ME-Proxy: <xmx:twWDahMaUZL_NGJfM4dNKNxkheLO96-qLwnUF3pePeuKxd2RncTFrA>
    <xmx:twWDal2UZxDXZ1wN5eBMTu5NJ434qothwIqe2lHweQXfVN3k8JdmJA>
    <xmx:twWDak724YEbGwd8yoHEzIJDHgRePjwgnyRrOZvkqG1QMIFiCYW4cw>
    <xmx:twWDasM70ZfBvoT1gUiKLR1nJMl9FIZSOfjZlhAV-jvOq5tMWQyJEg>
    <xmx:vQWDap6g-dNLJszNbPPoxBx0DQEx1fc0plUfLqH7afMBTZ65OZ-2_Nd8>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 21A9432A0070; Mon, 17 Aug 2026 08:59:30 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AdWx15gK6UpR
Date: Mon, 17 Aug 2026 14:59:09 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Stanislav Fomichev" <sdf.kernel@gmail.com>,
 Netdev <netdev@vger.kernel.org>
Cc: "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>,
 "Anthony L Nguyen" <anthony.l.nguyen@intel.com>,
 "Przemek Kitszel" <przemyslaw.kitszel@intel.com>, andrew+netdev@lunn.ch,
 "Saeed Mahameed" <saeedm@nvidia.com>, "Tariq Toukan" <tariqt@nvidia.com>,
 "Mark Bloch" <mbloch@nvidia.com>,
 "Maxime Chevallier" <maxime.chevallier@bootlin.com>,
 "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
 "Alexandre Torgue" <alexandre.torgue@foss.st.com>,
 "Alexander Lobakin" <aleksander.lobakin@intel.com>,
 "Simon Horman" <horms@kernel.org>, magnus.karlsson@intel.com,
 "Maciej Fijalkowski" <maciej.fijalkowski@intel.com>,
 "Stanislav Fomichev" <sdf@fomichev.me>,
 "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>,
 "Jesper Dangaard Brouer" <hawk@kernel.org>,
 "John Fastabend" <john.fastabend@gmail.com>, witu@nvidia.com,
 "Martin KaFai Lau" <martin.lau@kernel.org>, yoong.siang.song@intel.com,
 rohan.g.thomas@intel.com,
 "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org,
 "Leon Romanovsky" <leon@kernel.org>
Message-Id: <06f8153d-2156-4e7d-9d49-006db4b2cec4@app.fastmail.com>
In-Reply-To: <20260813190800.222527-2-sdf@fomichev.me>
References: <20260813190800.222527-1-sdf@fomichev.me>
 <20260813190800.222527-2-sdf@fomichev.me>
Subject: Re: [PATCH net v2 1/3] xsk: align TX metadata layout across ABIs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Aug 13, 2026, at 21:07, Stanislav Fomichev wrote:
> Add explicit padding before launch_time so xsk_tx_metadata has the same
> layout on 32-bit and 64-bit systems.
>
> On i386 and m68k, the old native 32-bit layout put launch_time at offset 12
> and had a natural size of 20 bytes. Using sizeof(struct xsk_tx_metadata) as
> tx_metadata_len was already rejected because the length must be a multiple
> of eight, so the straightforward use of the interface was broken on those
> ABIs. Userspace could still register a padded length of 24 bytes, though;
> mixing the old and new layouts then silently reads launch_time from the
> wrong offset and misprograms packet launch times. This intentionally
> replaces that incompatible layout while the interface is still new.
>
> Fixes: ca4419f15abd ("xsk: Add launch time hardware offload support to 
> XDP Tx metadata")
> Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>

This is probably the right approach, given lack of alternatives.
In the changelog text, it may be worth noting a few more points:

- A few additional architectures have the same issue: csky,
  nios2, openrisc and sh.
- the commit that introduced the mistake was part of linux-6.15,
  so the 6.18-lts release also needs an ABI change. I don't
  think the "while the interface is still new" wording
  makes sense here.
- what actually saves us here is that none of the affected
  architectures are likely to have notable use cases for
  xdp that would care about the ABI break.
  The one that is most likely to have affected users
  is x86-compat, and that is also the only one that is
  broken right now.

      Arnd
