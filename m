Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6067D2BE03B
	for <linux-rdma@vger.kernel.org>; Tue, 30 Jun 2026 15:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782835165; cv=none; b=NGZSAD5RgPpBc+HS34flrwA11QYPzifsYdeq2bVfI7i2oVV1aCBpxht9HExegfexuZhtYCHinw4lMDJ8NR2DiKkEGUcswsTKoqh1JuOEsiPOPusX2xTOUMbnXkCyfZkSnYMSTo+z1OVTkN0FLxTEaarhG6hMLrFjIVNQvhEU/3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782835165; c=relaxed/simple;
	bh=jb58tW3jZnJBAc776WYbGoGlzW+AAj7i6z5zYVfqrLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IE05mky9XHGd2yw9x+qk/pLxJPMEaY7pcB/f3d455xxImEgW1hDwmw2cPE5Cle2g+cWxhIiT64LZy5I55F7cz+zm5HIRHtJBRV70mHZH48SkFDL1pun7UoEQqtMct8sznrQnuAw+SHyKyHn07vb3ugPJGomXsBWjNw+Y/QpwN4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=aLgH5kc0; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="aLgH5kc0"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e50c5d14cso153370385a.2
        for <linux-rdma@vger.kernel.org>; Tue, 30 Jun 2026 08:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1782835162; x=1783439962; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jb58tW3jZnJBAc776WYbGoGlzW+AAj7i6z5zYVfqrLo=;
        b=aLgH5kc0QlKjN39Uyg20j4QfKbMxh1+cXwYBKT+0hblicseOsWJx9sJ/Dlams5CEAG
         CJnCWxFmIMzUx36HhzjN/ItN544upw4mDIZp9J6XTfOKI1/tx99O4iMzzva+NWL8ZB4v
         wa/TtPtmxXWHZxpczp3zRJsYYZZ8Icg2zQu6FQdab86zuqarHOvdzJZ59F2IWSTUHEJY
         XXMFJagUUdbLpF5wyAk0vOyi6xAVlMwgAw984JizV+qbp9248IbnNYsg1eq6ZUFnhZg/
         oRv045lg/vy/aP5hQMiI6QYxUwi3b4vXd3Tu0wj3TEWBgbORH2ZpHvKstDsy2ywoG0cM
         QzUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782835162; x=1783439962;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jb58tW3jZnJBAc776WYbGoGlzW+AAj7i6z5zYVfqrLo=;
        b=qSHQntoeQTmABoZgNccuiU3pEKbCy+vvIX0QBiBkPzJA2szQxMi0O0aRSGReBJBHwq
         /1hHrPqhBa7fJdyLSGOEI1GvgJYzMhci8LOHke/9or6+bX9MB8X5tqLTzYC3AkhPaDL1
         5DRc1EFJkF4YZ5lV5BOHTjptN9o4HabyICBEsUBaiohjXGYLFaeGkdRHthVSP06K1+Rg
         WXDxi+JZBfn1id6gNYhB8gqjeI4FErC+LDI5wpIfz2FMGxUfUodpW72nXUNUOGV2FAOS
         hwD1GLHeNgaDbauyTb7LjLLhJfaZLKjAtZmH/vjFCTaLKkPwtr+CicEQBC1tu47Yjg3e
         FaBQ==
X-Forwarded-Encrypted: i=1; AFNElJ98ACH6+ZzI0jM/ItJuIDW9IyTnqhIHrJErMLb9kuWlcmayEepqG3D+ck3MMWbUpMDC7IXUg1CIYr+e@vger.kernel.org
X-Gm-Message-State: AOJu0YwiMTQWABYb11KNGtHIphWYqG+/xuySGgp3sZqsoz9X8gSY0Wf2
	dWtJFitjWDQII9q/hB39UJt4UqHe6j7rJ3oXdFplqJ0ezEJUIg1J6SVfL60f39nSJ97HR2s3rxT
	aHw9O
X-Gm-Gg: AfdE7clTjIjjYvdifHlsR1LGwuphQ8r8yb+rTw+DxagH6KVvoC+MsWNkUQElvRI/yfz
	aDU3eGU+QSgRN/S/POvIB18qnuPtAcCNn67mjNmim0y3lMS8pZMDtqrHrguKEm/nF3qdD7aIANk
	rU85nLlj2CzSP41DZZtY6AR2h08LNueWh5wMuvcpv/6SzrXQFniwM3TkAxuenfYM0R2/923hb4e
	PeSVSjUlnxU9sJhzQgoc+jPCOO+DUO+o1yp4PcJ4FST3FTV4VU+g+QRjuu1f71Dmur+JpOTitBD
	1vTibO8YKyJJyHdXha78GDtt9V6REVnx7Ib8lb6SNE/bX1E0vNXolgacPISwaTmSbnrWa9oYaPe
	BXE879wIS10DEsvjetz1V8p6R0qySIrHMu6dbLr3nTzmVH5iwrJp/gl50QOq23cwStoMYeHEeTW
	TSWfNXHowDJLXSgotzkHnqC3fy3uwNfhiC02HnaNlWmIadwzmFTM0Ed2/lLl4Vj/mI6Mc=
X-Received: by 2002:a05:620a:4101:b0:915:d5cd:8ce3 with SMTP id af79cd13be357-92e62637337mr649818685a.14.1782835162262;
        Tue, 30 Jun 2026 08:59:22 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f1a27e6931sm27413446d6.9.2026.06.30.08.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:59:21 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wearp-000000026qN-0gd3;
	Tue, 30 Jun 2026 12:59:21 -0300
Date: Tue, 30 Jun 2026 12:59:21 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jacob Moroni <jmoroni@google.com>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/mthca: Check for null udata during reg_user_mr
Message-ID: <20260630155921.GH7525@ziepe.ca>
References: <20260630155505.1707193-1-jmoroni@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630155505.1707193-1-jmoroni@google.com>

On Tue, Jun 30, 2026 at 03:55:05PM +0000, Jacob Moroni wrote:
> The mthca driver was unconditionally checking udata->inlen,
> but udata could be null if the user intentionally triggers
> the UVERBS_METHOD_REG_MR ioctl. Prevent the potential null
> deref by adding a check.

???

reg_user_mr should never have a null udata how does this happen?

Jason
