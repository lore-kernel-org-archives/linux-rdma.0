Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794617746;
	b=V0ObU7HMlF+KCsWpP7Ch0hnJ7wVYfJi4BcnGM7h/XcJUb7CfM9xfd3cATiHALqrJZzOY
	 GrJIEoyGxi2r1HaQJ2dRh5Coq+5BxxXsS2j4RYNdw4urt0yDyQude0mBcQ+W9IVneug2w
	 bLIrcMRXCvzrYukUyCyVoEaC51nfGbKK07vi50Jkcmstubyc/ZcL0BIu8RrJi9+XGtKeX
	 JJPbPJRN5+TDnWte5w8yPQpCbJdpBRVYIVJnHMrpTGYOV567giEY0uUoRa4CeVMGb2m0E
	 OoBmhszi3sg54gbQHyuFEuEMLHtwYJZgsSTqC+Zypv7ewbHfboB5WX2U63HMo6eBk8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794617746;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=NrrdTxEybjmQB4EMVQi/eTv+sihxtLG97d9QSISBCoU=;
	b=1lzWrizCbqLmXE2Z6rWT0ALKJWEQuUhRx2x4p/7T7c8w7h+CyZ+yqlyjKyDk2oK8IFp/
	 vlV1oU3TGY/EOYjsi212Qhx87ket+D9YliAyaF4WoZY2CO8XPCTsCiY/z1VDRVSO0m3KA
	 gLIDhzZNJMG6XvI/YXGtEItNu/Vve3iGOdgM3fr45pTnyGOJ/CNO1hH8/+Sz+l4qdRsQT
	 mXKJ6fnv3mQGvDOxlUmpJyKV2q+0Ltrm7J10e0ta71z6g/b04I19d7WnHJMx5RHJgHtUI
	 r/CNvZnEYRh12LxkVtHZ0oXtyLRsos4syIqZk/F0mszqSiZ899W4hMExwNbkM93Qn0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GTWX9usc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F60F606A336;
	Sat, 14 Nov 2026 00:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GTWX9usc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C758D1F000C6;
	Sat, 14 Nov 2026 00:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794617745;
	bh=NrrdTxEybjmQB4EMVQi/eTv+sihxtLG97d9QSISBCoU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GTWX9usc0Aq52mJ2vQsgDkynb4EKN5gF7uP4P+c6DVwV6X83Wx9JOeBl7cLAjjCUd
	 NkDAa7X7B+T8xAQEXLmRCoERM26Ix/dGHOGkzNVob1jFw9DhuH70YnNKwgYs7Ext7X
	 PacExLVFgCKw30BmCmyWUMcSZYTDzd8xJEDOAyARebAUWf4nBbHlZ+vK6sF1RguI/K
	 2JazvmIy4QT939GGP+2A7wU749I2s854DehmbTV6zbEi9msAgsh0VyLGJ+YtW7+6I5
	 3tlHUPiRoBrRZM7yZ97Bt/9UGIni9Fild8MKn2MQYFpwudN5aK9g7LitYOJPIe1NnC
	 l+sqdaH3SVYJA==
Date: Fri, 13 Nov 2026 16:55:41 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: "Nikhil P. Rao" <nikhil.rao@amd.com>
Cc: Brett Creeley <brett.creeley@amd.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Abhijit
 Gangurde <abhijit.gangurde@amd.com>, Allen Hubbe <allen.hubbe@amd.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Jiri
 Pirko <jiri@resnulli.us>, Simon Horman <horms@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, Eric Joyner <eric.joyner@amd.com>, Arun Kumar
 Prakash <ArunKumar.Prakash@amd.com>
Subject: Re: [PATCH net-next v2 0/3] ionic: make the device command timeout
 configurable
Message-ID: <20261113165541.76879709@kernel.org>
In-Reply-To: <20261105-b4-ionic-cmd-timeout-v2-0-35a9a2aa48b1@amd.com>
References: <20261105-b4-ionic-cmd-timeout-v2-0-35a9a2aa48b1@amd.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 5 Nov 2026 22:43:10 +0000 Nikhil P. Rao wrote:
> ionic waits a fixed 5 seconds for device and admin queue commands, and
> the RDMA driver gives its admin queue 2 seconds. Some commands can take
> the firmware longer than that, for example while a PFC configuration
> change flaps the links. The firmware is alive but slow, yet the
> timed-out command and everything queued behind it fail, and an RDMA
> admin queue timeout resets the RDMA LIF so that later verbs fail with
> -ENODEV.

This needs a respin after the HWMON series was merged.

Please respond to the AI feedback in a timely fashion (even if it's
just a brief message like "all feedback already refuted in previous
posting").
-- 
pw-bot: cr
