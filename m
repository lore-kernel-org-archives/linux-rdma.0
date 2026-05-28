Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F7F3F0AAC
	for <linux-rdma@vger.kernel.org>; Thu, 28 May 2026 13:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779973587; cv=none; b=AADPzmfqpDKF5BXrCMt61lMWxmp98KsXxnWt7Lw7CZeTGJXarCu1IDXbrDzrLaEfXOdpAqxnpBgtN/yce1O9mWmWAl+ZjoXeGqB6o9UWt3AI8RTRNIFVkRuG+wwjDlZF85rz7hdzgpRNcFSeEH5n3A4A6oEnwI75KVM1pCC86+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779973587; c=relaxed/simple;
	bh=kXTeFcIvsmks7vWrM0laQ4OaSYv6Ip+x11G2+E6NIEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P2C3hS/Zh6H1kwUqm06IxsInlhpLuAXtCty3/2peWk/NhAZ6awAsf/isOOrX1Qwytav8ys4kQjMyKEjS823G1YuovvV5a9z3128Jg/Ri7u2AzR8W3AX+hdy8kwPaKs9PT9a+yucB3V8Lu6zNi19Wuq2Rd5VmK1dSfWBppENEdM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=DjwL9+wb; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="DjwL9+wb"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-9144163319fso1337220485a.2
        for <linux-rdma@vger.kernel.org>; Thu, 28 May 2026 06:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1779973584; x=1780578384; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=O4QLun+491Deibj/fLSmdMHafxxrHsY5pSpqns2mubI=;
        b=DjwL9+wb5P7ImW8/0dqV803QfstLwp4Z3LZLFcZSvAawXdsFHMIBlnXKSnT5h1+5SP
         olP8zO19xQzrbgsu1kSGTJzrSk8GWTKm0pC0C+t7xi8QlXYfC1DQ2dkYHAyFP2teQGKH
         Ro1yHn28UcUavBexelrsdoVgW8yHwDV6P3+EG6z9DcuuxpvUxYp0O+Ed66vnitRmDahJ
         JI9B7csvKx6oTiJCss3N1vjI6NSGQSq4NLzWZ4YrZvMfcgeuFyVG7zvPyVHExEETMCOu
         A8lgEsHeoNnbfdpzS9PJm6bKcLfIBEWldZlIf6x5Zt52BmgEjU8xF8PoVrRVKQVwPO9t
         EljA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779973584; x=1780578384;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O4QLun+491Deibj/fLSmdMHafxxrHsY5pSpqns2mubI=;
        b=XOXS3o9qo8bDaGHfotbWoPMwIm985AMsURcF+Y19atRHZkTsFkzVGt+c9kXES1CaH1
         d4I68852OfrIzVVUwm3+U2/camzaYPTUUlLGw0PP6nTvLNFvuGX4xGChXCNHiMac5XRO
         w3y13FPMpG/miBprvOAAU7SLv5QIJb6+UekL2FFvmQOFNSkdE6x/EXgEAyxY2vDT0Upw
         fiWRorqSt5B4rAHELPiN2yui2c3oIl5mlGkPgQOIvB6vtoz94p78j2cEELW21MCTZuFo
         QT0RAEFEwVWi2rMRbWWa20SZsPIaWZdxe1pb64G8PIpOWEzDhjm+xgfLRPPDhP3f+7Jf
         m9XQ==
X-Forwarded-Encrypted: i=1; AFNElJ9I9/RLTs3CDRB5+AYrP/8735QQkMk71iGb7JcVJIkmnSpujcAp+Z2Q8xyKDf+Ufl3Rh8xqS9ACVL+x@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4Bp2TuFT/IdltwWz1/xODwi3ojr+V1QnK0WOFDanjtNz3zcmO
	x642CI05pfKkh17ZmdVuUcP/vdM/GUqXOWEN2rHzic8NjpxQ8AbgJ0UO9kiMBBVEn4c=
X-Gm-Gg: Acq92OEgq2Ta/lBxkUAAMFrYXAEm1uRxvDapMTrWTQrud8PgkP8k8RFCetG/GsHMLpg
	A7aD233d3z4lVn/KcELWCyqkqkbYjNsjm+l84DS6Q+dNBVfl9Jj5FNzVlQiym4Dvl6M5gNEGdHY
	U9fgfz0HgEtto5fPf4dXLugZYgj5XYyAovbdaiBuCpkIY89+A1hi8grEiqaSLdBFg0Xav/FTg56
	RZoRRHTc6NoSvR/22ggC3Ob5TQ4hDzXUao/cYgTICBotEjJ7M7l9ynbzN4ZJjtHY4pKajS+Pwpd
	Mw6OPwfnCIIS95yQmf2rNX/SXK91C3d71SilMWdJVZpxmKknnXqf6phQw3od3HgHkurPMf9SbN5
	aqlnPt6lFf7OVpaIIE5lKb6iLnKFA8PyjpyxZDbq3qoX8eWWsFapGX5+aARbDAmY4Q+hiRoEWPT
	BKAwMSX+wH3tDWeDhg1bX66o7a8i9f4h5NpnH564KaxTOS/aAO+l+QEuNmqJ4VgGcJF5ooFTET7
	FkvD7tTa2lNyxlF
X-Received: by 2002:a05:620a:7106:b0:914:ec97:5457 with SMTP id af79cd13be357-914ec97563cmr2041801785a.46.1779973583681;
        Thu, 28 May 2026 06:06:23 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914f87d1a90sm869386785a.27.2026.05.28.06.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 06:06:22 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wSaRK-0000000GYDV-0CFZ;
	Thu, 28 May 2026 10:06:22 -0300
Date: Thu, 28 May 2026 10:06:22 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Tao Cui <cuitao@kylinos.cn>
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org, leon@kernel.org,
	linux-rdma@vger.kernel.org, mkoutny@suse.com, tj@kernel.org
Subject: Re: [RFC PATCH rdma-next 0/5] cgroup/rdma: add per-type resource
 accounting for QP, MR and MR memory
Message-ID: <20260528130622.GO2487554@ziepe.ca>
References: <20260527133400.GM2487554@ziepe.ca>
 <20260528075537.2170697-1-cuitao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260528075537.2170697-1-cuitao@kylinos.cn>

On Thu, May 28, 2026 at 03:55:37PM +0800, Tao Cui wrote:
> Hi,Jason
> 
> > memory pin accounting should ideally be limited by the cgroup directly
> > but we argued about that for a while and could never get an agreement
> > of an acceptable implementation. There are many nasty corner cases
> > around cgroups and fork and other cases IIRC
> >
> > So I'm not sure if making it rdma specific can easially solve these
> > problems
> 
> Thanks for the detailed context.  I understand the concern — generic
> pinned-page accounting at the memcg level has difficult ownership
> semantics around fork(), cgroup migration, shared mappings, and page
> lifetime tracking.
> 
> The intent of mr_mem is narrower and RDMA-scoped.  It is not page-level
> ownership tracking — it is object-based accounting tied to the MR
> lifetime:
> 
>   - charged at MR registration time
>   - uncharged at MR destruction time
>   - the charge lives with the MR's creating cgroup for the entire
>     lifetime of the MR object

Okay, that's an interesting framing. Perhaps it can work, you should
include this in the commit message and be sure to CC the cgroup
people.

Jason
