Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793382905;
	b=UcefZWNYUXDE0ryBkosN6EkKNAD5cumjQHDfXliVHRSUH2KTC5ZuAbceDLgNjZwTuDf7
	 7042td9iryulsYYgZpuYzFydiDVTxqV8awPnMniw4yk3bLyZ4nIBEmGm3Fy3JDKxFRioj
	 TMv1C8YEFzbXoiZBpKNAXabEFDklgUi5hisDBg2/vtxjOfpQ/R/agDjeOdkxBLvRsyDyq
	 YJ2Q0euDZ77+1VW0c26ttTrNDtdE/mfJVLcBPMFOWUQcYVFm42QWe2NC7lIeijaYOm0dv
	 0Dh7ePTuet7UL9fgvZp324TOXVB8Nz9BudVSYH9OsRuj2REOq2SgqdYgoDn33Mi15LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793382905;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=MzzqWp87mX5uee7dUtoL4mvgcS92KEzrPEuuf8TFmTM=;
	b=Gq3PIq96G5wqp27SZO6qXHXvq1j17QuB7iFjXGsPIP2AVoovr0VWdG6G+REJJUkVy+7d
	 ItxUcrfS57GWV3u0QGIeVKqKbtbtSBn0Mhb/kBCvB7fzVRSC4SgSj13MzjUw2Of06R3KY
	 +f8qI91gLCE5Mtb4zRXP7atodgf2wE4dTlSkDKCOm7JuKADCfhDmmWws0NvuSXyucEnDg
	 Vicj7vK4Sx/UGWyfxbeJL6buVWnpjDW/EyVvnlPjPmE6Ek7t0pGhwD215cSn3iXs/Y1Nu
	 kCoAHXzwRH8WTOi13P40I+iR0SyKlmzlkvxYwrcfB7LKStfnJoCcUc22regIO7SdiqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=WLldK+qX;
	arc=none smtp.remote-ip=209.85.160.172
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC2D606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 17:55:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FC2D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=WLldK+qX
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5365f9a04c5so14447581cf.1
        for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 10:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793382903; x=1793987703; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MzzqWp87mX5uee7dUtoL4mvgcS92KEzrPEuuf8TFmTM=;
        b=WLldK+qXaflqWIgs0lIRcgKdb/3w+58LtOXkenmN9279RrwmfsaHG0bbzFLE5CPcwA
         xH3nfDTLFrN4LVsxEogRQ75SBGJT6InL8dUG+VZ+U0hL3HF7OuJ5/+QBkNqY1oDpYW5s
         oz6pxgbQnVqCnfNXIZ0FNaDkcysg0n3oDEGN6Fl2XH0uJ1Ho09PPMqvem4C8v+E9+6yv
         dIeq0VWZ+vIKJj47+DV0uOXiOJ4TtYJCBG8V1Ij1DQK8eBcBNlkBtELpUPi6LLIReR1j
         2mGeKUf5Qw2fPkhH7Agb/hFG4qPxTxuaG6NxUOGZVs+obfzmDxE94B6wPtM7B73Yt5jJ
         Xq0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793382903; x=1793987703;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MzzqWp87mX5uee7dUtoL4mvgcS92KEzrPEuuf8TFmTM=;
        b=cIOCFOatygjmwqWm6AdooP8LtY7LG48pkSi/9eGTUAlCVtkqjPK9YLxpPImRRXglQy
         lNi3/GNjgQ7jYj5vYjqVmwqZffgGBaSNOG7aCx1gX9YoZrS+/nCWwRVM7B5C7s1KrXDq
         Tr4j4xw1INnFc95q98lH6v4dWdOM7PR2tPxBIuhGfBTCIYkaYegan8AjTEEgVWVNWpKS
         CSiXy+/P/sgkrF7GyBtjsl+p9wUv0ZLz+q7zFBTjIZDoOcVcDdACpmaLqUcoDwFABrpD
         KR0uo9zU51EHlkelVapPFkLbWoOXbhEfCfTXHb38ZuOX407ofDhnrMTW0QJA+tIpj3Vu
         UxQw==
X-Forwarded-Encrypted: i=1; AKwUvBzDHoAbIvnmu+HHsFMqBJBl1smejz+weJ1O7su7feLCzUJWNH79aVUb+64snXQBy2hhNfUEuY/rmrKc@vger.kernel.org
X-Gm-Message-State: AFq9FYJfYeUNnSsCIt7cmR2GdX9CTs/YY4tCtgs/dMRVR/LLLiUqlSiM
	Vs+i7HAFn6PSBb90ADVVKqUJNf1MKXs0yfU0oEGIQRAX76706/ZwhXvYvym6w2RqpchtjB3ak9k
	22idK
X-Gm-Gg: AYBFou3C/PiENtiyONpzoPSjWvrOXUAB0sTqHqqnPtzuGfuu3kJzeFSXp2V8byZdHuM
	mwR+dbaOYutwX3b8DaciZRHA9eTofAkKvENsLBqrSKiD+XL2/chTm5VbRg1Lcd6I2OunNrCPtLn
	VzK+2SI6YoG4SCvNmwlZ/gTuyT01WNTukAb8xYr3vDPE6HnA+PnB/RczSj69zC/+ec+rJi4qxiJ
	87arrJRFUgpkG2GILkZc4xbOSlgOScv/u0G6gKwDzeANFI8LLYFiO7xOtXACzTyUrqQ0COcRn19
	cYjdpOBtJVdonLWCK1p1XUeKgKVV0hOcb6f/Tak4ioYzUqxuqU08CI69mQ2m5tyJ5+Fy93/QQyS
	zT5/tprFmdp2mEzcMQCxb7OhU2xaXR0fvTTJ3DymDxTxZqgDvvWIqI+PdSkRjgUSzdICxcBbgqn
	qm+YLKtF7aMfM59P8ERqF6qjPkELpm8MvqowjiRuhIdqTT2iy3TkbJfguDf7/ewXCrCehZ7sMCO
	RQ6cBnfeVfo8fsypf+LNlRjTOJfedBZ+x0Pvk5BHRjBPrnJDstrL40V2jNqVYRxV8PrEnuoaaLG
	93cD5tepm788gpM75X5sFr4v2k68MCpH/sI/82vzyr+7/wXhAgXXIDTzv2+GripLSLR6Wv3znm4
	4fUCfmo4F4L8=
X-Received: by 2002:a05:622a:178d:b0:535:30a:76a8 with SMTP id d75a77b69052e-542b7a12990mr51504831cf.59.1793382903065;
        Fri, 30 Oct 2026 10:55:03 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca806e1b6sm20596526d6.37.2026.10.30.10.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 10:55:01 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xMqof-00000001H0V-0by5;
	Fri, 30 Oct 2026 14:55:01 -0300
Date: Fri, 30 Oct 2026 14:55:01 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jacob Moroni <jmoroni@google.com>
Cc: tatyana.e.nikolova@intel.com, leon@kernel.org,
	linux-rdma@vger.kernel.org, jay.bhat@intel.com,
	john.s.lacombe@intel.com
Subject: Re: [PATCH rdma-next] MAINTAINERS: Add Jacob Moroni as irdma
 co-maintainer
Message-ID: <20261030175501.GF3889730@ziepe.ca>
References: <20261030173556.1873811-1-jmoroni@google.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030173556.1873811-1-jmoroni@google.com>

On Fri, Oct 30, 2026 at 05:35:56PM +0000, Jacob Moroni wrote:
> Tatyana Nikolova is currently the only listed maintainer of the irdma
> driver. Add myself as a co-maintainer to help with patch review and
> ongoing maintenance.
> 
> Signed-off-by: Jacob Moroni <jmoroni@google.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)

No objection from me! Thank you for volunteering!

Jason
