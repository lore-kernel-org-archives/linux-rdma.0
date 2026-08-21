Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384372C21C5
	for <linux-rdma@vger.kernel.org>; Fri, 21 Aug 2026 13:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787318764; cv=none; b=M3jdfOvmO/umDHj7QB+k3PhdwkAam5fcVlRJzl73/PVxcAb0WCy05uQNabSRUzvLfvsx0ip99v4+PtHD4Rs2k2UAVQNQi+0cRj1g2VYUYg6bA+3b6Z9t4LLPpz7afDOEjFnc73ltOqNT30P75rQJjhRhyfcDPKaU/xJpA4vQktM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787318764; c=relaxed/simple;
	bh=YawnfO93lFpiiiVsEDgOo67WdtKdWlruskTJ6qCMRPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DGc3LsIgQ9CEjFEgdlHNENTkmO+ofElEKaVCacMn5Ngx5mQFjXu2YdkN5UlzftSHOuF6/V+arw5SVhg76KEfV7UriQaMAjnfjNusMhiLkK2m7DpF+NbKmkoVDQWRrNC0ubjpYaxLizITe0LU8qPgdB1ykT+rsRfzjzwsHeoitag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=i/1DlRNz; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="i/1DlRNz"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-936dfd009d1so164245985a.1
        for <linux-rdma@vger.kernel.org>; Fri, 21 Aug 2026 06:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1787318762; x=1787923562; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yZFW1sueN7C2JgtdNrAMsuj/OpX3+XPmkVX06g87NwY=;
        b=i/1DlRNzb+0/Qma+N7q7Xnhsg7CoG9BU3OoVNln18goCP2U8AQo2Eu8mnZSsxz0/3o
         C3Qyoa5J2Gg/0A5D71v9oyuFQHrFZ/5WyTbt2Ogz4eB3l6sZcNe4/srwKQUMDpzNcUxM
         nZ/W7V6SNaza2d8Xo2DOHwOF8Pyk6kyGQzsbUYNY9He+Wb0NBs2+YuaiguOJzX9gwLXJ
         FG7l8nAnwMRdcY/g6Yt5Jdg9osVf0eTufv8QygZEsu4CzBhtIK40aQy5fLncQS8M3E9v
         v50YDQfN2XGeDKyRwotzUTehHoiA+JQT0KyDFeChT4hiW7yZCF1HGMWJjxgE0AUZis1i
         Uk3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787318762; x=1787923562;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yZFW1sueN7C2JgtdNrAMsuj/OpX3+XPmkVX06g87NwY=;
        b=iL+nszKSR5sI0MdI+67BzWjFTX6+/BKt3pD8lY24gB0qvmjsRweGjmngVNSDsS66xl
         lGjoe3079ZyNOJY2cQL10mbNRW404/xVbK+WqpDD8kA5aAZBdf0ltyUR3KSlulvPxoNW
         erd6y2NqFWCv/ntQApqXbm9jqQPzE2doIfH9QUtujutjxw9svdFvrfmC5o6BTIEWjoPd
         JVsU4VZb8sE2dtplcDwJNSCGWfbzWKJLVgFwqL6EEzvUxLmfXjXsFs5VLTybKezkDfyV
         JmM1sbTtM0/OF1clQRJAn+Snt4shXURgm20sMTDQZKQI8zwSRO3loCi+hzDpUe/psX+5
         oXvQ==
X-Forwarded-Encrypted: i=1; AHgh+RobXZFdsIVEgm+FXqOMVhLu1LSlHaXjU48gvaylF8dCjIy+NyraJIi3hEwWUGGKP/RjKckhcZPGqOY5@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd5In8wXewh37wmvxqE3vScFuhKzMP59/5XfXhr2LrjSnv735n
	6j3sfJJQ8n3HpTmJP/sAAGu/mDu6PxHi0cfmt70qIPOGKZXRSrm7eFtafZngo0x4xgE=
X-Gm-Gg: AR+sD13bPSutc1L8CMLiqsmfXkFDlbUldlWax6ApVIuhniFuK0xQfpgL1xvmhvqwGGI
	XVWosTYGaeJ/7k6ErJKuaLLmtunp7NWzlPi5P+F10zggXlZwUafrIXGUrMh7gaDX9cx/eXnR2/8
	LToMUbvsjTRgX3o5lh/mbyXzPY8rAvA84anM/t61F2F4+wiRUJjW/6EsnvVe1Bw82osxgQjCcXi
	YyVypKL18yUCgCf93ziHGYVZQO6iEUZshjfjaAcF/ItQXv2alfpe53VOQa4mBvQzUdhhEWUP4Aa
	DGGnanZUAHNpGlloNiL5mPCL3v57/Tw2kAyJTGL57TIYdVw4YoheeaStFj3DUc42epa41kQ3v3j
	MZRTiicMYRZHQCcL+LpnFXBqUen+AhL28bZr3cYSzhaHsQt3O9MuDVaYyUALzJXtDcK1lldWhAS
	lG75drF7p3vARgp7vCeaojkU+Fdo7In49+ejV2RcFlC4SnbqUruEtLJbo2QOO7jX5YgWCGBppRj
	GRJmlseP6ldeSGZGbpKDcfwrMCif6z/MNerSV9U13bpbg==
X-Received: by 2002:a05:620a:800b:b0:936:a8cd:a28a with SMTP id af79cd13be357-937285a4fd6mr1422261185a.22.1787318761951;
        Fri, 21 Aug 2026 06:26:01 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93720493f35sm593233285a.9.2026.08.21.06.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 06:26:01 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wxPFw-00000005zlu-0XgF;
	Fri, 21 Aug 2026 10:26:00 -0300
Date: Fri, 21 Aug 2026 10:26:00 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Eric Dumazet <edumazet@google.com>
Cc: Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH] RDMA/core: Fix use-after-free in ib_get_eth_speed()
Message-ID: <20260821132600.GA1114497@ziepe.ca>
References: <20260821070512.3122442-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821070512.3122442-1-edumazet@google.com>

On Fri, Aug 21, 2026 at 07:05:12AM +0000, Eric Dumazet wrote:
> In ib_get_eth_speed(), dev_put(netdev) is called before inspecting
> rc and dereferencing netdev->name in pr_warn(). If dev_put() drops
> the final reference to netdev, netdev->name accesses freed memory.
> 
> Move dev_put(netdev) after the warning block so netdev is kept
> alive while its name is read.
> 
> Fixes: d41861942fc5 ("IB/core: Add generic function to extract IB speed from netdev")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  drivers/infiniband/core/verbs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

I was intending to take this patch next cycle:

https://patchwork.kernel.org/project/linux-rdma/patch/20260812081708.32468-1-krystianmkaniewski@gmail.com/

Which has the same change embedded?

Jason
