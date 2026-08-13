Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF2A7080D;
	Thu, 13 Aug 2026 00:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786579828; cv=none; b=AyCuJK+J3WXIRFz3ycZYkeAAB9shmIHp0PuLWoQbk1nw77RpC+hQfiRL6zVffeTptFx38mKaM69W/4N/bAPqzbRO9Py+U5Vc6WmT2wI3DSPPAk5ctI0Oc80tI2Zp2kIJXKC6QRPP6wwZqqUbDoNUG948ltPBp//DGcV/ruWJgwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786579828; c=relaxed/simple;
	bh=1ppolaZ38RgTMkzoxVyxBClMPbQBiTZace7W0FmRdI4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eeofocATnFeqClF7+0h/11WbBhzTejADIfkfZMcIHW0dMdGPEhIQ+rgOcEPUT8d54mTuQtUw71en6UADs/cdz+3LJGeGeUtSw12tzQWlZ+X97QZOeFFIqQY1ILak/AntukIGM7t0njEDVfkdDCC+7Rd04nbvIzenfwbN9HuqR20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eeyhQSdQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eeyhQSdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62021F000E9;
	Thu, 13 Aug 2026 00:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786579827;
	bh=1ppolaZ38RgTMkzoxVyxBClMPbQBiTZace7W0FmRdI4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eeyhQSdQ5jhCCmDh04oJ6nK9sqqlTW8Pwf/nDkLWkBttkyypOWtishuLxZkcJOYwJ
	 5TY6SJCGKGvWcafR0DjxqojD7oxL7Pr/lHXnSM8O8owSwK9MWV/OBh52s98Bqtr8VC
	 olTw9nIIzmusYQHHYr4+G1FyjPpk7V6poaJYJ25L5GDgdenHfFwNLpkEqFUUYwWAH9
	 tadl1DR8LjveUTpFFQWAQJtHZueIzxiEHScHFVkngVogcbYw53RpUODfnO6rsFRBfE
	 S7gUrPNl8IwLHsw6kpEFTds3tnPXYg1wn1Wb///nPXtRDokNVKXPds7JKOrEfvFtob
	 X0+tFUVKNdBhw==
Date: Wed, 12 Aug 2026 17:10:26 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>,
 Dust Li <dust.li@linux.alibaba.com>, Sidraya Jayagond
 <sidraya@linux.ibm.com>, Wenjia Zhang <wenjia@linux.ibm.com>, "D. Wythe"
 <alibuda@linux.alibaba.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>, Tony
 Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>
Cc: hexlabsecurity@proton.me, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, Simon Horman <horms@kernel.org>,
 linux-s390@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] net/smc: close the SMC-D teardown window
 around the ghost send buffer
Message-ID: <20260812171026.7f98785a@kernel.org>
In-Reply-To: <20260808-b4-disp-22f119e6-v2-0-61647601a6f3@proton.me>
References: <20260808-b4-disp-22f119e6-v2-0-61647601a6f3@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 08 Aug 2026 02:21:22 -0500 Bryam Vargas via B4 Relay wrote:
> Both patches only matter on the SMC-D DMB-nocopy path, where the ghost send
> buffer exists, and the only in-tree provider of support_mmapped_rdmb is
> dibs_loopback. CONFIG_DIBS_LO is default n and its help calls it a testing aid,
> so on a stock config neither bug is reachable.

SMC maintainers, please TAL.
