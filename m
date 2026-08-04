Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4AE3BB13F;
	Tue,  4 Aug 2026 00:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785804450; cv=none; b=nIZZ+rCRGU24tSfZXiOEkC2+n5qfz2c8e6HFEnCnXlveJ479DsnX1OO1gmhrAOKUrzLvkK2fzZvNhOZcJmJlMjQGnIJO/7TXwRvIo6kro8iErfqiMsl+6x4D0dsnL5zlTsQ3RaaUYs0DmScF3/rkjVJMI9GY6bnVhZmZjsZyPN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785804450; c=relaxed/simple;
	bh=gS/o7zThbJQOCe9OudjQMENmSmFF4opRlQ8azxJbJKk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CfREiEg3O4q5wZZCdJgwZLJK0CkaeFRjLLSbAvRUAg+Hos2VlvUnycuBaTfIAb6HtEpEyUwtE6Sm2FJnnHV8v1t2czE5wgHFsrREC0pGkh5O0Gh/JuTKm2nDy/kQLd6hTEAVEksQBAl6fl3TgBrnqcQXPnq157IF2QiJirsnvx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zmg6eV74; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zmg6eV74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0E31F000E9;
	Tue,  4 Aug 2026 00:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785804449;
	bh=u4xwT9wFc5is/zo2LuqtmC3eq1JMh0EZpaYm3ysz+GI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Zmg6eV74RIaq7FfDVG8XRLksMiod//2XICtjFva71lm87iCzKLeIVXfScktFqEsAz
	 44sEoPRAGtJjUO6nuc1s/8ZWcO678gfIw7/GdtWZZKljm/9MDeWqASGm03TGS0/KwB
	 ctrVZsLeW2g32o4nk4lu8LM8DS64PTsQrLMkHtruPDst7XyttyJwkD8Ewbp5GbL76s
	 nHphQEzF624mbXNHBxxL3JoUhMvmsh90SBSYQwGOdHGDSr0qCTVW/6yqc/cchVZF+v
	 yYOUYeJf8eMNMvXBpT/ur2JGYUG0jBFB2Ln/4CxLKgOJUNJthGEHuYTOzKvXsroKbd
	 SGgTZEyqQRHlg==
Date: Mon, 3 Aug 2026 17:47:26 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: chia-yu.chang@nokia-bell-labs.com
Cc: linux-rdma@vger.kernel.org, eperezma@redhat.com, jasowang@redhat.com,
 virtualization@lists.linux.dev, mst@redhat.com, xuanzhuo@linux.alibaba.com,
 pabeni@redhat.com, edumazet@google.com, linux-doc@vger.kernel.org,
 corbet@lwn.net, horms@kernel.org, dsahern@kernel.org, kuniyu@google.com,
 bpf@vger.kernel.org, netdev@vger.kernel.org, dave.taht@gmail.com,
 jhs@mojatatu.com, stephen@networkplumber.org, xiyou.wangcong@gmail.com,
 jiri@resnulli.us, davem@davemloft.net, andrew+netdev@lunn.ch,
 donald.hunter@gmail.com, ast@fiberby.net, liuhangbin@gmail.com,
 shuah@kernel.org, linux-kselftest@vger.kernel.org, ij@kernel.org,
 ncardwell@google.com, koen.de_schepper@nokia-bell-labs.com,
 g.white@cablelabs.com, ingemar.s.johansson@ericsson.com,
 mirja.kuehlewind@ericsson.com, cheshire@apple.com, rs.ietf@gmx.at,
 Jason_Livingood@comcast.com, vidhi_goel@apple.com, Parav Pandit
 <parav@nvidia.com>
Subject: Re: [PATCH v4 net-next 1/1] net: update comments for
 SKB_GSO_TCP_ECN and SKB_GSO_TCP_ACCECN
Message-ID: <20260803174726.585aed45@kernel.org>
In-Reply-To: <20260728161007.650717-1-chia-yu.chang@nokia-bell-labs.com>
References: <20260728161007.650717-1-chia-yu.chang@nokia-bell-labs.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Jul 2026 18:10:07 +0200 chia-yu.chang@nokia-bell-labs.com
wrote:
> For RX, SKB_GSO_TCP_ECN shall NOT be used

but it _is_ still used in hns3, what's your plan there?
Documenting something we adhere to at the outset seems like a red flag.
-- 
I'm expecting at least a commit msg update at the of the discussion so:
pw-bot: cr
