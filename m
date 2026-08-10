Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8EE3644CA;
	Mon, 10 Aug 2026 20:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786393865; cv=none; b=f4RUbF+5G3Z5vmglmvv5RUBVibnIl6vMs4lviAln9iLJHJhDsg1eE0uR4DK3+qyuWaBlrr+crT00QTj4eNlBj14rGIPzASEP1mcx9s7IS/zr0wUuh7PMMPIJTo3M7RTfG87v87ra9cwg1ie9HWUYzYS7Cr0Nb7EXQ2kkDf1mvoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786393865; c=relaxed/simple;
	bh=eLqJZVsbNMVPw4Su568i8+DFgZWbxMdi1OgK7MAYdfI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tlfXKXjMvMFCgcs8CAkRWQG+QhtiuTxal9Ov7onUnbUAPBawU0qK4DFnJg9ddSe/HrZIlcOAH9+riusVLOynnHNMTydxP82toX7fOVFMuKLQBnq6RXM7h9G4X7z24oC35imRHFUUw3/SaUDpto/TY7qv6NpSRSlf1Ue31k45QHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ieOBzgUY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ieOBzgUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBC51F000E9;
	Mon, 10 Aug 2026 20:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786393864;
	bh=fLLSPUGa7hV6YByxrdNAEWzwRgQO1sw+rDyrjIKtFLs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ieOBzgUYuWoNWkYd7DOsKs+HHMy0KapEeBI/s9CmQtWECqTcIyBbkTjF3E/3jc3xo
	 wTUkJ7DIZjqdkJZhr2YcXFVUiemUvuC4bUpTEErJco4+wkcsZmBNNm4GGcQ96CjpTh
	 LzkgxXfWPunEG/6/Od6nTULp5N6xg9L3IzqnYBTSglPX4UU+J0f+RNxH46cHi09Npy
	 53ncmfHbkrQqLZDJXapJWJNGdF7QRfuhFgPcNoPqV4HM1XDm/UUQ2nFIHuekyIEjGR
	 Tkt1WNHNijjJi/pQ2oA83txxBwe9qnx4m1MoM+9OMnvRUUGOrIsJ9+RJoLXyEuY96w
	 nvjHKMnkqXvNw==
Date: Mon, 10 Aug 2026 13:31:02 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Cosmin Ratiu <cratiu@nvidia.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Patrisious Haddad
 <phaddad@nvidia.com>, "davem@davemloft.net" <davem@davemloft.net>,
 "daniel.zahka@gmail.com" <daniel.zahka@gmail.com>, Chris Mi
 <cmi@nvidia.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "pabeni@redhat.com" <pabeni@redhat.com>, "horms@kernel.org"
 <horms@kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "kees@kernel.org" <kees@kernel.org>, Dragos
 Tatulea <dtatulea@nvidia.com>, Boris Pismenny <borisp@nvidia.com>, Rahul
 Rameshbabu <rrameshbabu@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>,
 "leon@kernel.org" <leon@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
 "shuah@kernel.org" <shuah@kernel.org>, "andrew+netdev@lunn.ch"
 <andrew+netdev@lunn.ch>, Mark Bloch <mbloch@nvidia.com>, Alex Lazar
 <alazar@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, Gal Pressman
 <gal@nvidia.com>, "sd@queasysnail.net" <sd@queasysnail.net>, Raed Salem
 <raeds@nvidia.com>, "Jacob.e.keller@intel.com" <Jacob.e.keller@intel.com>,
 "skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 "edumazet@google.com" <edumazet@google.com>, Lama Kayal
 <lkayal@nvidia.com>, "linux-kselftest@vger.kernel.org"
 <linux-kselftest@vger.kernel.org>, "sdf.kernel@gmail.com"
 <sdf.kernel@gmail.com>, "doruk@0sec.ai" <doruk@0sec.ai>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "aleksandr.loktionov@intel.com"
 <aleksandr.loktionov@intel.com>
Subject: Re: [PATCH net-next V2 13/13] selftests: drv-net: psp: Add a test
 for PSP with HW-GRO
Message-ID: <20260810133102.7b406e35@kernel.org>
In-Reply-To: <35b40fcde5439a9ff50054fa9d264b77307ee103.camel@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
	<20260804083535.2946459-14-tariqt@nvidia.com>
	<20260807180054.380be9d0@kernel.org>
	<35b40fcde5439a9ff50054fa9d264b77307ee103.camel@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Aug 2026 14:30:19 +0000 Cosmin Ratiu wrote:
> I'll move the hw gro tests into a dedicated psp_gro.py test for the
> next version and increase the assertion strength similar to other HW
> GRO tests.
> 
> I found a way to spawn multiple psp_responders to verify cross-stream
> assembly errors and other weird edge cases.

No, please follow how the GRO tests work. Can we not pass 2 Rx
keys encoded in hex when you spawn the sender, and use AF_PACKET
to check the geometry of the received data?

> In order to avoid duplicating a lot of psp connection management code,
> I hope it's fine to move shared stuff in a psp_lib.py file (similar to
> hw/devmem_lib.py). I know you're against frameworkifying stuff, but in
> this case I think it's a good choice.
> 
> All of this will push the series to 15 patches.

Try to think 
what the point of the rule is. It's to keep series small _in order to_
make incremental progress, in reliable (form process perspective),
comprehensible chunks.

You could split the first 9 patches out and merge them separately.
Internal metadata reshuffles and decap may be required for your
implementations but aren't inherently part of HW-GRO, IMO...

No point keeping the first 9 patches hostage to HW-GRO and ksft work.
