Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795739841;
	b=hh1ngW8CjZ+qqtF7X1rsduKHNYzJdrFnlt4BuY47HgYjBOfMLN75W6o9anPiDy2CP4Q9
	 Xq0tzGnKQaDeR+362f7Y+zqotcI2qNPGq0jlhD25fiuZzMB84gF5HWi4zq0zHJAzrwNUN
	 FaoUBmICjSZid04uORDNkVa4LXFe42/hK1uBLoXfSDltsuonVX+4VU9T4+wBJh111OVWJ
	 Kh3oeIwLfSg5693iUouqgUjBMk4AfWbX8K5QQITpiT8sr4Y6I2M3L0fULpU8jydD4I9+g
	 6OL63VagkYV/5iEcW7yPlQkcmcdb7MaAHtycRbRdO0p9xWljU+NwNYbOJXMlZLsPFXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795739841;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=BYEpToCdu/Jrl7504w/3VIKWXqy3i8TunCn9olVHqm8=;
	b=AGI+h48TIiwkqlSbDtXSTyEdzfOyVc6L6079FU+j3TRiYb0IlokxKdDIaKZFEoe1Le0i
	 UfN0ug47wwhaPN8Mt2ZSpYPc0sNyoFRcm1iay2ZXqziMBLtp/Mg91LVJy3G9Qdf7BNgBT
	 FYx1mYuYpYvmoeccXweoR+jwTFja+VbqO1lmRzVfOZ5TQcMqVbf5V9lLHmg0xbRzSG0MX
	 lS9OoPw6BzoHuoPUCRkKpX3kY4IeesacmvD2r6mh5NwxYA8YSY6jlnQJbuuy8dsXCaZVB
	 JQcnUOURJKsFqtDNbU5VZ/fK6Hr9xVGGgTz7ur1SuLH1jPLnU+b9Z11Db86sk9TAQzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=RYi3Edqp;
	arc=none smtp.remote-ip=209.85.160.180
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6A2606A323
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 00:37:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D6A2606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=RYi3Edqp
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5363c8de563so76138911cf.0
        for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 16:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795739839; x=1796344639; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BYEpToCdu/Jrl7504w/3VIKWXqy3i8TunCn9olVHqm8=;
        b=RYi3Edqp0iJYoWgnyFakqRlcBMM8VcDiE8d4VlY5bSzWrQs7C3jbXpEvdsf5xbs0HR
         k8SJFejOERTl3boet9eADaubxky0nrElyxMPXPWpVpP4P4sFBNoLT0vNQZStolAgoetA
         AVu2Mh8zCbpacWNyUVPHGl3RGM6A9CQHETQIX4aOfJBdNhGQef7KqYfIDR6ufufdP8LP
         5jHoiOvsTjxDjWW0L90H9rgfkvqlxNkDfm7h3cX67l/8MpA/9M1cz2dLCiNt8o5kr/5Q
         JdnVCeij4xVh62dHP4PJZYsGnouQAS5wg9J0Y6QCTQui72S1909B3CcTDDr25xXeCo8X
         2BJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795739839; x=1796344639;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=BYEpToCdu/Jrl7504w/3VIKWXqy3i8TunCn9olVHqm8=;
        b=X2Zugf4Cla7jbC1FjGPE+JQxkxe1kFoUhdm799cDqgjik2m5Nq4IFdRWYW1rd65Vtx
         MinhYmx9DtqRVqqRrz04Bi7Q48ShPvcyVFRstSZBM/XdReJBvnbc1Ex2lWRS0hJb+CU9
         3fzOzBH+8VfVCfBT4NRNeFqxCT9uQ3VGZqMutYA/3Wcu/58dJsFRXGUr1mjDbPaKt3ff
         WfAlz6kgvOsjhaguoPG3QT+gZqAUw9Mn0PXu6tavU2PwOxB+84DWI2gWJVStG3o9a/NW
         5C8zm7cjfHGZyVDKQGSH55B2rpC1v3L88xT3/Yq9yglJOVcrnMI2uoL2wrSkkzZGJub6
         WN7A==
X-Forwarded-Encrypted: i=1; AL+hErFxQHUESEFr10tcvKpi5E3RLxuAI/fJ7O77l0eUgPpUPeQRGYw7O+I7f1W/WLLZBDYhaE43vS+j6nY9@vger.kernel.org
X-Gm-Message-State: APuU4Z8J5nABeDQHM52lyXE7swgq/TVIOTqFiiHAI614Z7WRzY0HIfef
	a0+K9VROYXs0DA34H7zLUnqabDG9YaCqakBB98Oo+ZS6LvODnvrrx9deBeNatRKdVik=
X-Gm-Gg: AZFdTZd51LZ4YeVURncISKRIbZNYh+6DrszH1TbGPtlDO8CB/mfyyCHw2XWfL2qI96+
	eKlJEqBZkske4BQ//Vqfs7ErStO+vp1AEAM8BXQ/GKkR70ZBJmbjCzBgdES9Cmm453VSHOpHi6Q
	hdQ/3ekG4m0uwPVb1QBXUqaoUbMxcWQm2TJQwF6Ah8GlzV/L8uMbwz4FhBekgcmzcLLPE5cCnEM
	gb3YMxDLD5FNkMYlxGS/29kimmv8Gwf94iMQQd27Cz88nPPHMoE/PiwQPIVy3KdQR67e+/o0GG9
	Eb6Cmqev7lrG8c3YSmt3ICUwCqY+7rzeAcQFGDav9/1Alm1XPOf1TsOZGPWhDeuSx567egbuPPJ
	UpLgzkdK/QYtZs0UL2HICsDDo6qcoPAOgKAbZBMJxmiC3vhYP67JuZrvOB279duiOviQHTnhj7Y
	ZVvLBWWFV881AaR2Cj0hCSD9KwtUUEXE8OGbySXuXto0JYD8kN+PW7Vu8ejueI71pFwvxF4OZoM
	kmjh+CNBtAzK88iw+Eq6yz072WSJBCRkW8Hd+d3+souXUnlPGQESZB/rKoCdwaZYK43o64fYC01
	yWVHNA==
X-Received: by 2002:a05:622a:1f13:b0:533:8900:4eae with SMTP id d75a77b69052e-55d76a168d0mr403124891cf.13.1795739839275;
        Thu, 26 Nov 2026 16:37:19 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d788506b0sm192115611cf.17.2026.11.26.16.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 16:37:18 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xWjxm-00000005OdJ-0d4j;
	Thu, 26 Nov 2026 20:37:18 -0400
Date: Thu, 26 Nov 2026 20:37:18 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Matthew Brost <matthew.brost@intel.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dongwon Kim <dongwon.kim@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org,
	Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com,
	treding@nvidia.com, jhubbard@nvidia.com, chaitanyak@nvidia.com,
	Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v3 03/24] dma-buf: Add the SGT DMA mapping type
Message-ID: <20261127003718.GR246011@ziepe.ca>
References: <20261124142032.GN9566@ziepe.ca>
 <7a5a2d3a-e42e-4dc0-8d22-8dd1bd249501@amd.com>
 <20261124194618.GC114530@ziepe.ca>
 <awZ_Os1pXelOGaFP@nvdebian.thelocal>
 <fb9a6b12-c134-4e40-86a5-dbcb59c0b91b@amd.com>
 <20261125155559.GL246011@ziepe.ca>
 <5fb8bb60-7d9f-49b1-899c-40a890fdc14b@amd.com>
 <20261125190705.GN246011@ziepe.ca>
 <awfMy1d8ICL6mr9i@nvdebian.thelocal>
 <a8c00bbf-dddb-4207-bcdf-af58d27116c5@amd.com>
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
In-Reply-To: <a8c00bbf-dddb-4207-bcdf-af58d27116c5@amd.com>

On Thu, Nov 26, 2026 at 10:58:13AM +0100, Christian König wrote:
> Would it help if have a call on Teams or similar services to discuss the whole thing?
> 
> That might be easier and especially faster than by mail.

I think that is a good idea, I suggest you and Alistair should pick a
time and see who else can come. From experience eu/au/eastern na
doesn't jive :)

Jason
