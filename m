Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795645183;
	b=iLjQyeA92fkJZaNAbomERRoBy9GBobJMqCEAq/pktIFHUTTf2Lc8F9RuVSVzxlIVzgc3
	 7ZN+NTHS7/VHcg6T2OQfiFVijg/1Rw91WqUwIjO6H+gDdVdeqelIEPSou3jbd2unPbik6
	 5XyvS8lUEIXy8fDzEKjgacvYI716x/4lXVvrvQxgqDi4RWpnhpnHEkFz+hrt3o0wwh18U
	 PZLFJ7bt/r0hSr4pZuGWkxJ4nRTbAcZ0p1MKi+7uI//iStEThGFWLhkM4NNoCpnnjrqf0
	 cXzqBJsFkfVOuBbwZKcPPTYZRwsj5xmdaBiWaD9gc7GlHwjgPbLgatF+yWxe53mup/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795645183;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uFEINKxnLnXo+ULKqfk0aVBFOpN7/oGFhsg+YCW0q60=;
	b=qF+ZrWAPHmDsevluS+1wIByiFuyQm8YBzxlN46eVcuZ+b3uW5L8J3MguJvhgSYA9n9ft
	 86MdgRPF2n+FWIsxBCq1Um4Nu6rYuUm2xeF9JCLHOaQUImrJIVK+oAdNDfYy9QJs3FH52
	 iQW7qdTd9kFaEsnQ+ciEiVnG0RmCHOGCdF6Ki66BlRArsr8Av2B3gTZ+X7mY3q9u1yIBN
	 nbVazDyRw7gr9I+9XtpTOpfOjQcDaWgYYcj6dehoaQxVXWcaIlyjOxn1yjuwFSStRIpJC
	 EN8y5z8tumVjQ/IiGBvN18PmDX/gXOlInjd0zFJO41POpOMtItRnW8qyQN2WRRmzYbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fQ9Pelmz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9531C606A321
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 22:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fQ9Pelmz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71391F000CF;
	Wed, 25 Nov 2026 22:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795645183;
	bh=uFEINKxnLnXo+ULKqfk0aVBFOpN7/oGFhsg+YCW0q60=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fQ9PelmzXCdulNAKhhI5ayN/TvsZvR3QsAQEY9Ke5QHfP3ztldQNW512DIgdzxCB8
	 ZqMTrJFknn7AgTz+GuGPnh1eX4Xzoxhjtv1AGZgMQRF6JvoxQDYjoU/EcAuznpyUDy
	 CUyP3F1P/k30dIIAaSht4njlswB56Wpnrocwjn4LkCGjn4FuixjiJmCEd2N/yC9Y0n
	 GGVEtEPSzAUPGmrFsMtRV3ACeZ0wDhug6hzMSr19CuXvb+PQGwalMhtPFqpXADDh/5
	 MB0cEO49UKYjod+emK5HueEG66ae/GJlKuqFh4PL2+bkMhVGMXjkI9cdDG/xS8C+cM
	 WNjWDC/z+sWmg==
Message-ID: <sashiko-outbox-234248@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 00/12] psp: introduce socket-less
 associations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261124221758.3230929-1-toddfreed@meta.com>
References: <20261124221758.3230929-1-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 22:19:42 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has finished reviewing this 12-patch series:

- Patches 1-4 and 7-12: no issues found.
- Patch 5 ("net: add METADATA_PSP dst to carry a psp association..."): 1
  potential issue (1 Medium)
- Patch 6 ("net/sched: add act_psp for psp transport mode"): 1 potential
  issue (1 Medium)

Detailed reviews have been sent as separate replies to patches 5 and 6.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124221758.3230=
929-1-toddfreed@meta.com
