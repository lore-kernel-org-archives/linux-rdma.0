Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5761D1DFDE
	for <linux-rdma@vger.kernel.org>; Sat, 11 Jul 2026 03:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783740159; cv=none; b=lPGgd9pqTVznnrL8PdYkYyQu0CtJN5xqc707nN7owF83Nawu545Ho4srmWgCw7SyGcHN8Zetw93C1k1GVx0ucdr8N9Op/nLhuzyLXErs0c2nWfdmqEgWkXS6VlIVdLJsEAomvC8nWNQfqu1IKf9wHApkUWBSqkdFjPsC4iP7kYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783740159; c=relaxed/simple;
	bh=Sus7BKnPvFUSij7CjYjdJ5SdK+WtzY+EQEDkUmlaEDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pzm947NXrkeSt9I0y02OwhNTL2cQYYthE/k6yAP4XSceamfekoNT5KNnUtqtJ38iGnzOQ3IFUD3NrlEfh8r13BGZROm/PbJyLDmdfuQ/tlU6BgujBw4U7oFAhsNRcztocVBk/iADbadtZRzGZIAIf/5NaXWTM7gX7vpdyVFOHbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y+T7qVfQ; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y+T7qVfQ"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8423f236418so1166435b3a.1
        for <linux-rdma@vger.kernel.org>; Fri, 10 Jul 2026 20:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783740158; x=1784344958; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZoRTmK7mqG76n1GL0uhVSS5eZwslPyOiLYDvdkV1GQU=;
        b=Y+T7qVfQB2TUolswh+PJg2roQbg2dl792e74RhbyG/9Vj8N3+WvCQ3UIjHx98pcPsv
         is2mm7ENnYmfoaDc5bE7/gq6fEKu019fp4/gbj9/v0igV96h2UO0N/1BiaC065sk8ylr
         lF8EDEi7VXvTRm98EXSCwfFSt/ImJ636rlG3ntOjBtH05FFfcE5YWPgnFnTRrAObJ9Oj
         aqesQhIYU64Em1aYmKWuSyG3xbGMAbIbH0yzO53DzB1Srir/r4KHX5GTvBRArbmp7/7c
         cUGiE5LIe23VkhT+2v07URqgvcMoex+PNjQ2n70OnLg+zdPTlwfIENkTQvj1WG5PAEtQ
         DCXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783740158; x=1784344958;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZoRTmK7mqG76n1GL0uhVSS5eZwslPyOiLYDvdkV1GQU=;
        b=JGIqmDZqYiU23EAFTze4rWDV3qsi8V9RXrfYIY/4hOCiI1leKe6IhrWohg7rF78pwj
         6mu1j5gho7UyPNI0GKc+7oHYmsqSRiKk5hurfBEp9UtWMH9jwShvfnM6azhPYvZG7JBu
         Oqko22HUKG67mXRXSHZ2SYq5jCWgxcak+/4VkMdmGLY2fMNkMBqdpIEJ8J7+l3TpO1xg
         e6YHcBj4SXK5Gm53YL/A6YtogquNotUUHDB10d+a9Yg5pGqHaV4E1BbmCQH5p1P5xBvS
         AaSoPnBbbh74EXMd1oNQXyN05Uz6Ip94nlvjEiAxkjH4AxdDq92ovuHlzA2OvgPEEejj
         4UzQ==
X-Forwarded-Encrypted: i=1; AHgh+RqzcBPVSh3xI0NbbPN9vMTe5zzL8SlS321IJCoduV2v8tPzoGyO+4672ov6Ei9yN85N+HHORIgrcTC0@vger.kernel.org
X-Gm-Message-State: AOJu0YyHph7/2kdu3fAhsNUctko5R4+zzZp2HiNmdpqw3re5f1dbHdS1
	FXlDXyPlYtyl2vEJrLSCXEWvy923TOcT19TGon/I0xrCbqRC+akEkUKd
X-Gm-Gg: AfdE7ckz+EljpDJtxfMq4rJRhQUL4NMocy3Cf8myOc4Mc+He1tKXolUeq6Ii6laZ4uJ
	yvKoqLrIzTD/nsyLmPMIDn1d6jaRc0zkpt5k80XRxurH66QxsiYXov10w2ejFvKspxz/J6u2nBV
	EuohkaPioZPBKz45B65iN79hgQf/lpzLcbQ0ON7MZNqCN+LKPGlOVQ/a3fhHUzdpa2Sy2QzHa1c
	8ii7HTxYFez7l5KKi7Wr2CgRZhGFtxxHQogp3Bf5Ob/0jUt9/Nu4+fK1jQE9/VBhBbbtXgHhxpw
	W2WbU0JoR7li+na+VHevRf44SoCuQpzzLHMFeFX1wJp8jk+Tk2iUzWHI3LFQyCdQzA9pkRTIeXc
	NjA1jH6DLkS0mt+eUWNSas9QxjVAYyY+Ki/UrBPCQl6qYiRAy+emzfPw7LmGRaNVakepqIw8gSI
	AIsyRCSMV9rb5moBo6vfxGtSQXTJGVwY3SEf7IlnCCiNe8v3Vx0DD5yvE=
X-Received: by 2002:a05:6a00:2303:b0:848:2f74:1d68 with SMTP id d2e1a72fcca58-84889750a60mr1542258b3a.78.1783740157808;
        Fri, 10 Jul 2026 20:22:37 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84856e7c8edsm3652647b3a.36.2026.07.10.20.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 20:22:37 -0700 (PDT)
Date: Fri, 10 Jul 2026 20:22:33 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
	dakr@kernel.org, david@kernel.org, decui@microsoft.com,
	haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-ID: <alG2-RSitzPWClAX@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
 <20260710151151.1e193eedd0cf2591ae392f76@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710151151.1e193eedd0cf2591ae392f76@linux-foundation.org>

On Fri, Jul 10, 2026 at 03:11:51PM -0700, Andrew Morton wrote:
> On Fri, 10 Jul 2026 14:26:20 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > This series extends the HMM framework to support userfaultfd-backed memory
> > by allowing the mmap read lock to be dropped during hmm_range_fault().
> 
> Thanks.  This seems fairly mature and mostly-reviewed so I'll give it a
> spin in mm.git's mm-new branch.
> 
> Unfortunately Sashiko wasn't able to apply this or v7.  I'm not sure
> what base you were using.  Hopefully there's a reason for a v9 so we
> can retry this.
> 

I rebased this series on top of mm-new right before sending it out.
Should I have used a different branch?

Thanks,
Stanislav

> I have a few niggles, nothing major...
