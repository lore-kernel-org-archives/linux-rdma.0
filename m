Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795528074;
	b=48ZN3X8oKiLkKiQUkM31di8rJBt0JsB5ShBYfqmu0eaCarWdk7C8ZwfyRouKsK6bCxEo
	 S/EezVURxHppDBBM9bxzVau7MqlgBnkQa3e9g+M205MOOilloaeqfGw0zsiiWB3F+ZIdw
	 MGt7hzONuNHJ8Dw229zhPmwu9kV4SudEqLy9MD+WWB7ZAGuU8BuZUg5fEPlBW0WvxJ7gs
	 g3ZrPye9SdlpkNHC4w5VRkobc4Ar2FoLX57dE3xjWd47cfqbtlsIYLDh3hMHlDR+O0h7o
	 gRiCOdme6m6520O4M/vZ/mRLtf//id39w6ChAzABsCF3YR64OlekFc06kz+n+mCbIbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795528074;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=vMDqbnU1JcZRjV4iBwiOSDccQES6fNfvp7K7cXvvapM=;
	b=HgWJDZTmx8ajbtaSPsbqQqlMxJtXsWOgLkPM2SIboaDs6+7o1guQ5cOV8m1E198Lp8rm
	 CiMN+EkmeUl4ggus4yWWt2LG96bFOMxOu2RXbo+L11/XSeNlJeopsu96C195dgxQSUB9L
	 QUcNzq2A1k+2tGqSuOaIMif8esvu4/N3UmzlY6JFuuxPNuCYs6Xq4eCVWUp+w8H2XgDuQ
	 6PfnJmkblNOmilfnt++U25yzUCIPqJ76hh5RtACrPDEDrD9YXZMqMs1rpst/3Qi2L23e4
	 JU+oWE49oMW1lDPGlJB+0JUTVEdfMjRGGn2Ah+G/UDYZG8HPNPZnv+EVaPLXJ7GCNww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=NdQ+RUQL;
	arc=none smtp.remote-ip=209.85.219.54
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C392606A336
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 13:47:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C392606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=NdQ+RUQL
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-92157f2e8c1so24802646d6.1
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 05:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795528073; x=1796132873; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vMDqbnU1JcZRjV4iBwiOSDccQES6fNfvp7K7cXvvapM=;
        b=NdQ+RUQLLl9NE7pcsTGsPyFo0JDIEwqHUWUTh6FGstCQlXDqQGm4bzmVpn7NrOMNN/
         nUmwzw+7AXCwCOB0lNWa/4gs7ETmEy+gpNc4PFSFMZjW/XN/5hCSia7u7LYeQBThBZ1s
         DiCl/4CxtrHD+AkQegWdE2/heCv5J50ilql3Jbj6NtTeAwCS2NgW2snsnz8shWgS8ORA
         4CjgkakkgOFF7v6BRpaIBjQ1evzQr94a4nFlmL3Ecij589zRHBuiOv2HWEgE4nsYg3jw
         CvQ9uEbdjNe/2RQk5kPtL5ExT9kibh7OEtq6HLk6gebbjDW0HErvE5oB55F0r55nzcPm
         FDDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795528073; x=1796132873;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vMDqbnU1JcZRjV4iBwiOSDccQES6fNfvp7K7cXvvapM=;
        b=pLzyWqvS3TeIJGVdKuiDwONF4zYxgyrpVPUaDrTbTVPp4U4qcHQSHE+zjIcczgmivN
         5e8KB2D8fUDCH7auMkZ6eBvH5rrslZmMZ5usaw7yeEw5NA4VDRwBjeHbhk6yM8H8ioGe
         XfmhpZyyaTkD3/M6RB+yB5sn8lWNHbzziEvDzqfN1sUTqIAf854LbtTxfWkhFy2Fmgag
         OE3OrmiAkp1jeg8aKJtat8KMR5mDtZCCLAjXXUT1gGDh6XjtLa6w94xzPKPRUJ14TVuQ
         HCQcqYl/HLW2KI4T4fB6VlUYTSi71iUost26mQOjZKHgZUmyxWzIzi7dKshuBBexq/+B
         3V/Q==
X-Forwarded-Encrypted: i=1; AL+hErFh5FS8A2zl1W0MZcxdbCkWf2fy1qU2hSc3gLYFW8W2ODGYfA1RnStVF4ulsOYg/utZWNsM2/Kzetab@vger.kernel.org
X-Gm-Message-State: APuU4Z/Sw9JRTk2xKYYpasHqinXLDoXNUbRNsPFB2ScYJMgL/MVMwRF8
	Cdl4xsyI9+zezVIZKqAfDkFfWq6gZnLQ1LyL3wHJ9p56avgbyQMPmet7mXH50EV6fZQ=
X-Gm-Gg: AZFdTZfSdni8UDmScQWQGim27jVaKteCbcSX35Npw510YT58S4sFdR1VwVPIMcmxO4c
	sn53byZgkET2Ngm4ZjpTpdNosJXBKBm911rnw5jronF8ZUTpL/DoAj2sHMB5q6VcGwQwNhfNxnu
	nZLrPSp0Hp9G01k3tGYiub4+HTffuJnXaQpD0lpiQLz4OO789fR7fGazxPxnj93lex5AgbXcmUS
	pL4+6doLqGksM48j1dXWuMScExs7jIlgMXNiei68U8kQKfZLT3ETN57Yj1pKEZe1nrueUPV2/lU
	mvSta16FcKvlYvlsw7K3WI8AQpRoesfkmD9oV3c+8Hh5Mbpkkbrn2ucnTDt083bxnErTTVm6wHE
	QBzup0QjhxpcwpXso1OlD+N+m5KsNyXA4Cn7ITcAtQ8Xrh8sT5dNWRDEwxKDeJHhONTRV7il82i
	142Yc8UkrJmtv4oKf4AHV55qDFOtDq9cNfE10wU9Mcj5IvFRCkPCvSeylx4z3hHuAV1i2irzOiP
	i4f8GOmifD5/YW2lgJr0XuM6mO04hYQAR+nf+Gx9nCE6aTSJCGQehLBTm+qpR8TVHRmdCIdw4Ah
	ZPSY+Q==
X-Received: by 2002:ad4:5c86:0:b0:921:3a31:64c7 with SMTP id 6a1803df08f44-9213a316546mr238701036d6.13.1795528073118;
        Tue, 24 Nov 2026 05:47:53 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349b081csm132608436d6.7.2026.11.24.05.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 05:47:52 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVqsB-00000000QLY-46Ib;
	Tue, 24 Nov 2026 09:47:51 -0400
Date: Tue, 24 Nov 2026 09:47:51 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Yishai Hadas <yishaih@nvidia.com>, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
	mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
	dtatulea@nvidia.com, moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 rdma-next 21/21] RDMA/core: Report and enforce
 adversarial mode via GET_CONTEXT
Message-ID: <20261124134751.GJ9566@ziepe.ca>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-22-yishaih@nvidia.com>
 <20261122073156.GA12665@unreal>
 <761ca80e-a772-41f3-b8e9-cc332e4ba5d9@nvidia.com>
 <20261124125327.GR14811@unreal>
 <20261124125950.GC9566@ziepe.ca>
 <20261124133353.GT14811@unreal>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261124133353.GT14811@unreal>

On Tue, Nov 24, 2026 at 03:33:53PM +0200, Leon Romanovsky wrote:
> On Tue, Nov 24, 2026 at 08:59:50AM -0400, Jason Gunthorpe wrote:
> > > > RDMA/core: Report and enforce adversarial mode via GET_CONTEXT
> > > > 
> > > > In adversarial mode the NIC is not trusted. As the kernel protects its
> > > > own code from it, user space has to protect its own area, e.g. the data
> > > > path that polls CQEs directly from the HW.
> > > > 
> > > > Hardened user space might use a different data path, with extra checks,
> > > > and support a smaller surface. This isn't needed for a trusted NIC, so user
> > > > space must know when a device is in adversarial mode.
> > > 
> > > This information is part of trust level series. Why is this a “must” in RDMA UAPI? 
> > 
> > Userspace has to work differently if the kernel driver is in the
> > adversarial mode, and the kernel should not permit an old non-supporting
> > rdma-core from loading to prevent a security downgrade.
> 
> I understand the first part of the sentence above, but the second part is
> unclear. Why should this prevent it? In adversarial mode, the kernel simply
> isolates that device from the others.

Userspace needs to do it too or it is not a complete defense.

> Moreover, the kernel cannot determine whether rdma-core has actually been
> adapted. A locally cloned version of rdma-core can set the new adversarial
> flag without changing the old, legacy version.
> 
> Once that flag is set, the kernel allows the patched rdma-core to proceed.
> Therefore, saying that it “should not permit” this makes no sense.

If someone makes a non-official version of rdma-core that doesn't work
securely then I don't care one bit.

I care that the official versions are not improperly mismtached to
give something insecure.

Jason
