Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DA4224AF7;
	Thu, 14 May 2026 02:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778726283; cv=none; b=OKPYmq5b/JC6gu5+IvOIgAqda8ajq/pxukrLPshj6j1tY63v+R/M99NQUcvXiJ16a4uOXlEDaHmI7fEo30lYSgIUQcUB1RXW4sIRDa9Pb11DElPtQG2t7czogUD5bpP2bE/sQl5df90Jr3zYp9mxgG0ZelOjZqxTH9wo6ppnPHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778726283; c=relaxed/simple;
	bh=OkqJKLPa5/XWhe7b5tvMy99sdc3gDBLM7Mk7A4X0AS8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z1/zQN48WMZB8L3R61/5auJTikmZW13T8YGIJMPjhnTo/19BJPIbXBm/pCI1NNyieSBB+BNDguOvxdXvZRMUTwDFNFKQfpZmzztnNFlMk6vyjA38JFEeLsjbOVJVVlLvM4kE/gqpEoz1+fF1fbOOKDaaZ04hTR8taTIIV1LwQjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gj1fBhJX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gj1fBhJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C98BC19425;
	Thu, 14 May 2026 02:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778726283;
	bh=OkqJKLPa5/XWhe7b5tvMy99sdc3gDBLM7Mk7A4X0AS8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Gj1fBhJXmKTXqg9VRUh/5vLialAkSg2jjNpJUH3da3w0xw23gLNPS5uaYgB9qM7rx
	 qMARyNg6VJtIFp8BD3vzCz7TZjdV0dMXHym77KLE/dsjWzj0mGoXJnqZJTgpiWJSRk
	 /QnLZ93qVuMu+oYu+RKmDULObMd+PFoa94PYitPfUw8XL5RC+xTklUrKVNOtk5liMM
	 XHkIMUC+QlTSEqq/Qm16pMqfBrdzhEVprpK9Znq/PEH7V6xsu3o++2N2lOPyDIeVhB
	 k32Oj1Na6qgYOpa9o77AJE56aLFhYj6cCkvf3qTy4OpLTCka5H5mCW7WGuftaKha/V
	 Q8lDzWBF+0LCw==
Date: Wed, 13 May 2026 19:38:00 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Alex Shi
 <alexs@kernel.org>, Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu
 <dzm91@hust.edu.cn>, Michael Chan <michael.chan@broadcom.com>, Pavan Chebbi
 <pavan.chebbi@broadcom.com>, Joshua Washington <joshwash@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark Bloch
 <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Alexander Duyck
 <alexanderduyck@fb.com>, kernel-team@meta.com, Daniel Borkmann
 <daniel@iogearbox.net>, Nikolay Aleksandrov <razor@blackwall.org>, Shuah
 Khan <shuah@kernel.org>, dw@davidwei.uk, sdf.kernel@gmail.com,
 mohsin.bashr@gmail.com, willemb@google.com, jiang.kun2@zte.com.cn,
 xu.xin16@zte.com.cn, wang.yaxin@zte.com.cn, netdev@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Stanislav Fomichev <sdf@fomichev.me>, Mina
 Almasry <almasrymina@google.com>, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v4 6/8] selftests: drv-net: refactor devmem
 command builders into lib module
Message-ID: <20260513193800.680a3375@kernel.org>
In-Reply-To: <agUzR3O35Rx4RHnu@devvm29614.prn0.facebook.com>
References: <20260511-tcp-dm-netkit-v4-0-841b78b99d74@meta.com>
	<20260511-tcp-dm-netkit-v4-6-841b78b99d74@meta.com>
	<20260513192133.60a82598@kernel.org>
	<agUzR3O35Rx4RHnu@devvm29614.prn0.facebook.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 13 May 2026 19:28:23 -0700 Bobby Eshleman wrote:
> > Also I think you missed adding the new file to Makefiles ?
> > It needs to be under TEST_FILES for building tarballs  
> 
> Ah okay, I wasn't sure if the already existing `TEST_INCLUDES :=
> $(wildcard lib/py/*.py ../lib/py/*.py)` was sufficient or not. Will use
> TEST_FILES with the devmem_lib approach above next rev.

Ah, you're right! Forgot we have the wildcard there.

We should probably update
https://github.com/linux-netdev/nipa/blob/main/tests/patch/check_selftest/test.py
