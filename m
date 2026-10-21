Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792619166;
	b=kBhXbML6ZABiMXNBOOG41NhjD1ze9za5GziyC4SOF7GAReQ5IjP1qa/mamqdJsKXagU0
	 GaN8YN/255kw3msdMyhJbidEeVlsS2W2Dz6P3IOD4hxmuq0hUX+yGFbhU81o5aWHlbm+u
	 INGn9Cs1FFV1R5RMEkZ5rhs2jHsCfLqR19YB1K1O6oPdmdgv8UdjdMXJZOKXkMk4tYiEV
	 euwsALa5sFow/xfGirHA0nBvqHZyBzLydKhRodnuZgcSyZOleND2yoVdGvWj0WZpMEugr
	 JAfh1sQIZb4sLi/L8rHzvILt2TC2tpsp6CP0pCIrlj85PgWSNNXo3tkFwNcXX1M7vgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792619166;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=8yJBRvpjgR7quXtNAIjCN/1FZLyDqFq7sO16iTcFUe0=;
	b=vglHEkxlqPL41gC7rCsgK6QTHUOU9hURMD0hq4P76yIjzPmsqURPV5VRYM1kSodtrlZN
	 DWV+Yjedl6d++GifkEHtEHiFM97NcXMP6SOZWFJvJXlxVzR+GHQWFbqHG//623SM8xkeR
	 J5I2Xg1sqT+N5hbPXJu1HKp6yk2Wns3vUMfbTALnScFBdw3C5GAOr26Vhwvu9W4BrEi7B
	 cpmPZLXwfmLfrh6K1r9E704PgZ+qvIrA/NR8UyMyMsWKQmOT8BVjkzoFZXga2fttFq2bb
	 Us5IjQLiHtMZLtvmBiI4jER8n6ddXDeCfQOJBAEqy3beQbDDAQ/r1JyZBzGqFnv/cLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kvCyjaiY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CE7606A31A;
	Wed, 21 Oct 2026 21:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kvCyjaiY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038611F000C1;
	Wed, 21 Oct 2026 21:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792619165;
	bh=8yJBRvpjgR7quXtNAIjCN/1FZLyDqFq7sO16iTcFUe0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kvCyjaiYZi3+UMhOs3nY16mX3NtFbSrWBVMNTwyEbBsJghUjTrc+X2E5/KFvMywgn
	 lMJzhHivRPgQ7MjN8UD8vpHY0bYnE3Ohipt5pGVbw3OT7VIn6YvJf+L77MLzTjVt27
	 V0j9QhHfR4G1OhvMjb6YSZ//9KSWIQtLYUaH0No7fiRhPNbICzrvJvfTSBSKVBlIY3
	 qpYPj5Dm0eBZpHCOCT4cPizkb0G73PzE+h6oJIKt3W6pcH8RTIHTRSu4F4dBNWJiYE
	 +TrHQQMA0pkliGYVPTGNg0L939FtVPhX5rMRxXY4k+IclUv0m1UbhZr+tt76b0xq1S
	 fRBMh0+Tea5iw==
Date: Wed, 21 Oct 2026 14:46:04 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Wei Hu <weh@linux.microsoft.com>
Cc: longli@kernel.org, kotaranov@microsoft.com, davem@davemloft.net,
 pabeni@redhat.com, edumazet@google.com, andrew+netdev@lunn.ch,
 jgg@ziepe.ca, leon@kernel.org, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, shradhagupta@linux.microsoft.com, horms@kernel.org,
 ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, sdf@fomichev.me, daniel@iogearbox.net,
 hawk@kernel.org, ast@kernel.org, john.fastabend@gmail.com,
 weh@microsoft.com, edumazet@kernel.org
Subject: Re: [PATCH net-next v7 00/13] net: mana: reconfigure by replacing
 the queue set
Message-ID: <20261021144604.5a56a096@kernel.org>
In-Reply-To: <cover.1791710735.git.weh@linux.microsoft.com>
References: <cover.1791710735.git.weh@linux.microsoft.com>
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

On Fri, 16 Oct 2026 15:38:33 +0000 Wei Hu wrote:
> I am carrying Long Li's queue-set reconfiguration series forward for this
> revision. Long remains the author of twelve patches, and Dipayaan Roy
> remains the author of the detach change. Their authorship and signoffs
> are retained; I have added my signoff for this revision.

The BQL support went in and this series no longer applies, sorry :(
Please rebase & repost after the merge window.
-- 
pw-bot: cr
