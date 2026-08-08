Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA55272816;
	Sat,  8 Aug 2026 00:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786150742; cv=none; b=AKfHYYnSx+1x0ks6Y6KCp3fMW5zwlGEO5hS4V6dED/pYMrRY7Ycq1Y5gTYAvVMFjkdqYLfF4sdFPRxtIiZ0DInAiYoSF5lkEb7NwKiG1PP4zLKpspEM6YrZcQSBuA4ch1ilmcJKV/QSTUc6nD0lHE+FYfzSP0bhzzHdiEUdQecw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786150742; c=relaxed/simple;
	bh=YGuSVUOMY56+RRIAcCYgwtca/i2nDVqQejr5/tB8nnY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=swbhHJowvqSKkrxZAtEagvB7UOwsdn4L1eiwthGzPI6UJbtM7gh00BDVVLbLgmkaKoe8yLTZCCWyQUabuZgA/eVZPflJl0cwb/ZJvN8/XyxnZYbNdU4+x+Mz65bV4jOKKbsIjNM6Fn4W3v23wQqmcMsfccZW9a2Nu53Gb46DcD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CPBU7H2w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CPBU7H2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72171F000E9;
	Sat,  8 Aug 2026 00:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786150740;
	bh=FxQWgheFrGGIAFY2WTZAGots/+C6XDFhzlfMzxIo6NU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CPBU7H2wUpkV0heySQzYdIO8q6cUYIuOC4MlusA5+nesc+hT3SVqwhRb2eJ2gjG9w
	 O9fUrureOUHY9QN2Yx3WyS+ZCKq88w9HrT1+YyGlB7M6oJeUgw/G4jD1nb9lA0HV1l
	 f6bzqDfE0tEcMnAYzzsEzQADs1UdBct8Gr1ET+iDFLV3p5m95eHUR/B67xvh99KWty
	 wh4DeN5uUa5QgxyC8f74gbk9TjChqKFnwNv/4k1Bk8gxF6F6ANzrVLtx0+BywQmVWn
	 KWARFmLVdqu6l2bTnKFyUYWDLoBKRFybeoVF6IoE7ghoAfGolKVPloa6ZWpM9SVXa1
	 tBTV/CMrNlzcw==
Date: Fri, 7 Aug 2026 17:58:58 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, Sabrina Dubroca
 <sd@queasysnail.net>, Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
 Alexei Lazar <alazar@nvidia.com>, Boris Pismenny <borisp@nvidia.com>,
 Carolina Jubran <cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>, Cosmin
 Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan
 Ozturk <doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
 <gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Jianbo Liu
 <jianbol@nvidia.com>, Kees Cook <kees@kernel.org>, Lama Kayal
 <lkayal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Patrisious
 Haddad" <phaddad@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul
 Rameshbabu <rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Simon Horman <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>
Subject: Re: [PATCH net-next V2 12/13] selftests: drv-net: psp: Fix
 responder parsing
Message-ID: <20260807175858.70a717d6@kernel.org>
In-Reply-To: <20260804083535.2946459-13-tariqt@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
	<20260804083535.2946459-13-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 4 Aug 2026 11:35:34 +0300 Tariq Toukan wrote:
>  			off += n;
> -			n = off;

> +#define cmd(_name, _extra_sz)						\
>  		({							\
>  			ssize_t sz = sizeof(_name);			\
> -			bool match = n >= sz &&	!memcmp(buf, _name, sz); \
> +			bool match = off >= sz + (_extra_sz) &&		\
> +				!memcmp(buf, _name, sz);		\

Please don't replace off by n.
