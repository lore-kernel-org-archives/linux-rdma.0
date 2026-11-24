Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795530629;
	b=n5ZaC35dvMCYzctSkX2R84J6F8Pgr6O7kmcISghx+66pbn5zFQV+JtKkdxaOCw6Ni4O7
	 sbx3VPsFMnj5EiwuFGwBkmApQbbDXF+2ZgnVi5FbpV6Zz5QgYsQweG87YFeBb11cTup0j
	 vyrEE/NAyHg11UZ4kaZFwJrL7p7IPoFlBixexkC5qmGyS8y5AX/Oh7tyLgKkbX6VYzI2N
	 Gq/7LYOJwyCzqSnxIHLcFH5qCg2KdwvhpNQFZH4Jsn4a1DJfXUAxcVZrIByocPAMNU7MG
	 eb6NDpxsyY2cNu8euyp/IECcd5L2pFesm8+hsthB0/mOtDuDnxXFbkS596Orw/g3BoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795530629;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=jVFdSwnS47EFl8UcZbr6GAKJGNG0CDFPn0KaTVMkw9w=;
	b=mZyHcCMASp2YpuEMxFK/cut7ZsEyk16z8/Y4hTrhTnsXsuD1kCs2X/8dKZXJkODuPDE0
	 vD6Zt6uLYXw67ALK54EAtiGIutrr50NwQH5KgkkMsiUmI+NC1BmgcHFWSHFEVm+UPLRRs
	 ShE9yeK2JgXFYy9m+XuVArHd2K0lazxO4BUaBMEQg8OTXORz7Fpu6oepyci1FlKcvFWfz
	 YBJlMfuAkccapjwRQHcijzdvOM28uQVr4hmbZE+43yl7Rk6bpJnGzHasCGUQKBhGCx8Rk
	 sjRQmDGKmJJN8YfWz52ZtiXjhFDMlFY099Jak9CBqFw8uWxKOSDXWoEnHpWXjoLxw7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=G3Eb1aSi;
	arc=none smtp.remote-ip=209.85.222.170
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E7B606A329
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 14:30:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16E7B606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=G3Eb1aSi
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-949589c1495so410417985a.3
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 06:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795530628; x=1796135428; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jVFdSwnS47EFl8UcZbr6GAKJGNG0CDFPn0KaTVMkw9w=;
        b=G3Eb1aSiZGOuAbMP0/V4MCpuAFp4RHwcDx0YgPHKuJI85WOxFXaykXGDBOrUxp5hxI
         svqhv+lcU5Xn2WoHRkKis0zSWzRWpZP4x+YBKOl+HiJQ3F/jI5rLYL1C1GSQhkZTKoX0
         RuY/B6M/MHr3FyhUjfEAgBPtdaUFmTn72E6OyprhGxlogNACnzUPeRT5V8u2s/vW8R8n
         UqMNNvMgdLU8g7SJ+K5wcVTEDD/apQLocUlnskMmJGi36NBcWcgQGarHoh5qGGb5073f
         ++iqhwwJfUr7XuPmBCdx/47VnFNkSnTPcnpTvjlVH8sR1YSOMhDL+N2nYTqscjMyU9xm
         aT7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795530628; x=1796135428;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jVFdSwnS47EFl8UcZbr6GAKJGNG0CDFPn0KaTVMkw9w=;
        b=eGk7eR7kFPNcLx7wO6MOTKiKlsQz6XM8NIsuuITt9C0pSsJ5uqTXR+Cw+1zzy77Qk9
         LyG6eL1QDzySQqnhszZgKj2ewkTeRbL/atEmgiLRJbr1erlumbuW7fM0dp6r8s40dHK7
         VZvh6UlGLDQMUIvZSHQNbPa4bY2RPMTrIs3Hkc3QmK4mhP+k+w8rAck4piJ0ySjs7ssg
         5/N8g9HZ15VRihDTCVQs2vrFjbEJczBsn1FbtrklMLIMXx4h2WUkEiQR1WCxUk44Fyyr
         g74uiz28xiHnSuioOioqbZD7E9BxO5ZZkVhGCzfy3/vpeQrmSe4G6P32xqoQM89EmFsf
         zY7w==
X-Forwarded-Encrypted: i=1; AL+hErHHlUXJyoAWWKjfmO/Lwz45GO8RvaCwEoiGLwFWol1FjYAgW7jJMS9UeiAXA4Ro8HXtQMf372LA5lRB@vger.kernel.org
X-Gm-Message-State: APuU4Z8IpgZLWQKlq2ukvUA+V3j0YHqOgYQWOLlEb46VFeLn/1JbwRCj
	MxYoLnXy2kekKrjtY128wukpC6yBTlQCIe8WaUFQrUU4Aom+J1P0mvi/nNzomB/3rE8=
X-Gm-Gg: AZFdTZch5pFbghtmco15PWMM1GFvNiRcJ1glUx0DU5k9+SiboIKLSDIrSk3w3XqALnU
	rbBc0pPxBAsLDpJVtrmYBMOur1VNwdfv9UconsTICuELDsXkX04Awo6JpbVysia58Npa+WvSHWG
	KyKYgtWE1UoM23h5rNaY73znvQmOpAYRvyiI+4pUZA+OlV2Fr4Vn9zQCTLJH+F/rMr0o6FXeN18
	rGraINdFryAc2tuRCzkaX7WqCGNc32TdYToW+1OsSKKGkrcpN74DGxJBQ8WSDJpZjb7JtFvpQY/
	ainaeaa10FjJCbrlv91iC+jSPVur4lNUVJFJF6XaPSJ4+IOtBzloQYMNArFQyMq/AWhxOKTwxha
	/3QHAk3wgsOydwFEHUxaUoQWO4bww5YTIAxEnYIfjr9hko1Lf7sGsvZ04n/dDc8paAUMHJMlUM9
	Osh3JZzF5lNziiU3jd6dwjYXuL/BmkUPOLppmwdWwOsNdeumiaFQj9nJeluhL+lOt48VZ8k5xpO
	pbBmneBGaf9lLQN+CaDOXTSL/1IG+mRW+WnqUOk2EW3Do0G5wmWCKPrDdchrU3KhXQUNIrM+ATA
	GWIdEg==
X-Received: by 2002:a05:620a:bd3:b0:93c:6417:f9c8 with SMTP id af79cd13be357-949ba9b3e00mr2686641385a.29.1795530625685;
        Tue, 24 Nov 2026 06:30:25 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb031617sm1047656585a.1.2026.11.24.06.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 06:30:25 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVrXM-00000000SA4-25fy;
	Tue, 24 Nov 2026 10:30:24 -0400
Date: Tue, 24 Nov 2026 10:30:24 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Yishai Hadas <yishaih@nvidia.com>, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
	mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
	dtatulea@nvidia.com, moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 rdma-next 21/21] RDMA/core: Report and enforce
 adversarial mode via GET_CONTEXT
Message-ID: <20261124143024.GO9566@ziepe.ca>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-22-yishaih@nvidia.com>
 <20261122073156.GA12665@unreal>
 <761ca80e-a772-41f3-b8e9-cc332e4ba5d9@nvidia.com>
 <20261124125327.GR14811@unreal>
 <20261124125950.GC9566@ziepe.ca>
 <20261124133353.GT14811@unreal>
 <20261124134751.GJ9566@ziepe.ca>
 <20261124140906.GU14811@unreal>
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
In-Reply-To: <20261124140906.GU14811@unreal>

On Tue, Nov 24, 2026 at 04:09:06PM +0200, Leon Romanovsky wrote:
> On Tue, Nov 24, 2026 at 09:47:51AM -0400, Jason Gunthorpe wrote:
> > On Tue, Nov 24, 2026 at 03:33:53PM +0200, Leon Romanovsky wrote:
> > > On Tue, Nov 24, 2026 at 08:59:50AM -0400, Jason Gunthorpe wrote:
> > > > > > RDMA/core: Report and enforce adversarial mode via GET_CONTEXT
> > > > > > 
> > > > > > In adversarial mode the NIC is not trusted. As the kernel protects its
> > > > > > own code from it, user space has to protect its own area, e.g. the data
> > > > > > path that polls CQEs directly from the HW.
> > > > > > 
> > > > > > Hardened user space might use a different data path, with extra checks,
> > > > > > and support a smaller surface. This isn't needed for a trusted NIC, so user
> > > > > > space must know when a device is in adversarial mode.
> > > > > 
> > > > > This information is part of trust level series. Why is this a “must” in RDMA UAPI? 
> > > > 
> > > > Userspace has to work differently if the kernel driver is in the
> > > > adversarial mode, and the kernel should not permit an old non-supporting
> > > > rdma-core from loading to prevent a security downgrade.
> > > 
> > > I understand the first part of the sentence above, but the second part is
> > > unclear. Why should this prevent it? In adversarial mode, the kernel simply
> > > isolates that device from the others.
> > 
> > Userspace needs to do it too or it is not a complete defense.
> > 
> > > Moreover, the kernel cannot determine whether rdma-core has actually been
> > > adapted. A locally cloned version of rdma-core can set the new adversarial
> > > flag without changing the old, legacy version.
> > > 
> > > Once that flag is set, the kernel allows the patched rdma-core to proceed.
> > > Therefore, saying that it “should not permit” this makes no sense.
> > 
> > If someone makes a non-official version of rdma-core that doesn't work
> > securely then I don't care one bit.
> > 
> > I care that the official versions are not improperly mismtached to
> > give something insecure.
> 
> You explain why rdma-core needs to know about adversarial mode, which is
> fine. However, you also say that rdma-core MUST send this new flag back
> to justify the statement, “The kernel should not permit an old,
> non-supporting ...”.
> 
> However, in your last reply, you said that the kernel does not actually care about
> the rdma-core mode.

What do you mean? This is a mechanism to help the user manage software
versions by not accepting incompatible rdma-cores.

It is not a security mechanism to hard guarantee that rdma-core has no
bugs.

Jason
