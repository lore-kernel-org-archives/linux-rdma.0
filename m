Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC062BE7D1
	for <linux-rdma@vger.kernel.org>; Fri,  6 Mar 2026 00:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772757142; cv=none; b=FsbX76WbymMUqC6p79Tq4d+j7nKJxeK1ar4BOxLwYpgAgxTe0tF+KPxYU/PWg44HPecOnhAPOwXA7CGLUx3mYlDEOcboHSd+aSGcnQD+zhF28y0MtuGp7hpuS2VaJw7ZRmVsFhQQYgTRuhzPquhpWgPf1CjG/ecgXDRBtc+nZUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772757142; c=relaxed/simple;
	bh=nmQHG+4AnyrSSsTzc8B4eGsexpvES3uR3ESxYjP8gGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t7RmhpMdEbtQPBU1PfAAzfuvWPiZeOinNAiXFKz4pL8qPG/fPsaOm1ZTmyzBpYzNfniwNPp6Ww8q6G+AlhnxA5FDvsPcI4f1WTAI5XaQ7L0nkMCCaJ66hXu/T1tjGyPEDZZDUU5xog29tBDyUkCHcUkxTD6mugA58avhSgenNKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=lW9bcmfJ; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="lW9bcmfJ"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cb5138df1aso841228685a.3
        for <linux-rdma@vger.kernel.org>; Thu, 05 Mar 2026 16:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1772757139; x=1773361939; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KCNCS1facBK4msNGTEPROi9xyZQiv1TuHRy7zkEiK2Y=;
        b=lW9bcmfJOXRcl1wLtmCzgwKLXB+GRjOQIl2x5BbvMWyQIijxXPUN4kLyDZOoSxNX/V
         Ksx1lrWzGYrUXYtsOsDLHaedA9O5tuL5Oq7bDCmBbA47aMv4EZp7gJ+LpiEeSS/FnAHa
         4SHX0eob9JE57WZ7+wxhAvV84oD5JLkg9tFNr0p6uJkn6xvxPiMOugeD0Hfe1BssdR6g
         Mtb8LWj/qlHrCCjTIfg7Zo5zb4KJgdasWsAM74OrjaQGMle+66hOijYy3N7bf+cMKrn6
         PtM5ESg0RoWtrPXIYOP144yeOS0MWKnv87rARYDnHEVHInt/Vr1ir8miul+Iz5tl41AC
         VmHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772757139; x=1773361939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KCNCS1facBK4msNGTEPROi9xyZQiv1TuHRy7zkEiK2Y=;
        b=I5A+su2TOo4qchhmP72oxcn6Pv+CBZm+jkJSb+ux8s8e+BtmVOD8Unk9p7rP48fZ+c
         5cdO94GSTl/ONxoLL0thzLKyWxjPDtzm0RrDfl/c7mYGXbSNSZw2ddjkHb+ul5ybH74i
         GEFJQ/f3CeaimN1snIvXbZpd2HrbVRzWR/sdVQmFP86xnrspEk4663IZ40BezQg2k8V6
         O9VM4NZRSNqhTUc2xg65UZr4odx8I5ehRNuxNk8c5APbdQ9riGXk/WfIsorP1IQJIEUB
         ss/rLx9gz1W1bqCB0nph8ERVu8i2NrZ5AFFC028DU4Y+YdYkSzYPMa47QhL1zrjB/1/M
         /28A==
X-Forwarded-Encrypted: i=1; AJvYcCVICPWDSG5gV0Y35r/XxDibzIEkdNq0JRf/LSaBROdW90oyqyoSuE35dGsqQ4hmZSh4cjq9xtVx8PA0@vger.kernel.org
X-Gm-Message-State: AOJu0YzfNZcQSvrpfJ5D7l/DBSgYFZ3Ew5bAfbZuFqYrHPCjVUVGtQ89
	SXRH1yjeJslDBSOlV7TiUfsuALjGUNGsm4zqA6/KIKP1Bc/ExCyvKC3HU4q6Kjad9k8=
X-Gm-Gg: ATEYQzx6lM1YvlTWsHDVDJz3jZTgEQe17pndpL9jet0uTLTneCciUyMptLL8xcYUwPH
	r50ePjjv3vJwfIpU9Yq5HBFSIKf2amMRD6hm/nsl//MdWJ99dXCx8TPDjNPyt3YwdlrCgLTW66y
	c88HjAXQly1wve9v+H7c3MEKfjqpNgiNCzFEI5dxZ2/ZyNqBjxmPCbzKSrCTHSzJ6HzVPwfCKNq
	f3RT4B116/gXWisQvqyJ1KK/CcnaIj0kkOzTX7PlimJGFMVLnoG+hifulGRDiMPc1OjH4X++VTr
	57KOusTgl5R4G9Oyg7kyG6Dlop2fDk+jULNXb6RQgu83sb75brJwtboUh8cWROQa9lXtmfnL5RG
	fzWJ2YUrK8B590mrg4gpJK9g1+zD2yGh07u4A36PueTCgKjTovYeH94tO9TalxRKlsa2b3akOAO
	1u2ncLwzQ8T/wBBcG9jdFkjplxhJfQ4fbnmAlWxp3KB+MicTncZ2mKra8kk5Xfr+K4OVtE1/KSq
	oCqxnlV
X-Received: by 2002:a05:620a:2a15:b0:8c7:1b3c:8e8 with SMTP id af79cd13be357-8cd6d4fb35dmr55157185a.40.1772757139456;
        Thu, 05 Mar 2026 16:32:19 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf66b9d9sm2001104885a.12.2026.03.05.16.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 16:32:18 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vyJ74-00000008rF3-01pZ;
	Thu, 05 Mar 2026 20:32:18 -0400
Date: Thu, 5 Mar 2026 20:32:17 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Praveen Kannoju <praveen.kannoju@oracle.com>
Cc: "saeedm@nvidia.com" <saeedm@nvidia.com>,
	"leon@kernel.org" <leon@kernel.org>,
	"tariqt@nvidia.com" <tariqt@nvidia.com>,
	"mbloch@nvidia.com" <mbloch@nvidia.com>,
	"andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
	Manjunath Patil <manjunath.b.patil@oracle.com>,
	Anand Khoje <anand.a.khoje@oracle.com>
Subject: Re: [PATCH] net/mlx5: poll mlx5 eq during irq migration
Message-ID: <20260306003217.GB1687929@ziepe.ca>
References: <20260304161704.910564-1-praveen.kannoju@oracle.com>
 <20260304201151.GI964116@ziepe.ca>
 <CH3PR10MB7704DD1E6B9A671796FC6B528C7DA@CH3PR10MB7704.namprd10.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH3PR10MB7704DD1E6B9A671796FC6B528C7DA@CH3PR10MB7704.namprd10.prod.outlook.com>

On Thu, Mar 05, 2026 at 05:08:52PM +0000, Praveen Kannoju wrote:

>    Regardless of the underlying causes, which may include IRQ loss
>    or EQ re-arming failure, the TX queue becomes stuck, and the
>    timeout handler is only triggered once the queue is declared
>    full. In scenarios where only specialized packets, such as
>    heartbeat packets, are sent through the queue, it takes
>    significantly longer for the queue to fill and be identified as
>    stuck. A proven solution for this issue is polling the EQ
>    immediately after the corresponding IRQ migration, which allows
>    for earlier recovery and prevents the transmission queue from
>    becoming stuck.

I undersand all of this, but for upstreaming we want the root cause,
not bodges like this.

There is no reason to do what this patch does, the IRQ system is not
supposed to loose interrupts on migration, if that is happening on
your systems it is a serious bug that must be root caused.

Jason
