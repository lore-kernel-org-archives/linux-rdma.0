Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93BC35E1AE
	for <linux-rdma@vger.kernel.org>; Mon, 13 Jul 2026 20:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783976281; cv=none; b=rTlGo2WTUcW+F5/zKN74LlJhrFJt28ejmpmHkrlbLgxKN83C0bAFWsBjEMCvD3CXbpxuJqcEfGh1CvqzSs0qg1ATNXjwkrvVshIkpJYHchiP1bpLjzUid/47Mt7IzbeJXKwCBFzQ2L5jJQueEFwx/Tyl3m7/8GRcr1SlEiBi974=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783976281; c=relaxed/simple;
	bh=D3eahPIAIk1fvhyOZkYEJP6bQ6n0at+bhFjOvvkmzpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZUnr3sIqyRU0OHbp1QRBE77py2vECuVMuh3dnW7GuSbw/J/qBE20TWvNn/84STTt+8KZWZ/1qus83jiGVfEqeBTbEkzV9rlEBSLUUsDjXAIltTMtQvf4Xd3AVLhSVqJcepNDSVCFRd+ub387/ke+3fdn2JgX92l6SQ5tRS0F4Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NgBrxDlp; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NgBrxDlp"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-384c94c9414so272113a91.3
        for <linux-rdma@vger.kernel.org>; Mon, 13 Jul 2026 13:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783976279; x=1784581079; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oNqruOZIzwruIpGvkzB4DJORZxeTGWU0clCn+vXfCzI=;
        b=NgBrxDlpDoknd6Zv5Ca/Oeewg5yuANlXmHDRnnhqXDWhgDP2P44OrR0s0/MTMy34mZ
         n3zXMmcIfGoNR7Sd680LfEr1/geQl8EGetahP7W6fUt1MxIqIdI/L1VUVBggJAmQ51v0
         jXoSwvwvp/CrIoMSWg71PL3DRpm2hdJGate6aUcUOOKGl8xTstjSeqi6gEKS96UO7Zjd
         lb2a22B/uNSSHg5FZmQ48yi/TVkiA9sVtHA1/za6mSwdA5n6CL1pr/nmcJGtyJ1Z/Prh
         VUKEcE5b/3E9zbq5R57HBRuSsc33Y7ePwJV08k/0UBOriBpPl9MhiDN0KZiEmLww+N0n
         mgVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783976279; x=1784581079;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=oNqruOZIzwruIpGvkzB4DJORZxeTGWU0clCn+vXfCzI=;
        b=FN0HRDUz3Ax5Z0MDmlJUOHsRuMlQY5d+UheFHV6b551rqX6B19BMX189Ap82GuL4hR
         fgpzBRetnrOmumFWWYsAt1v/Z9Zop7UB1hhLoCKFMgCeBxjrb6Ds8ByMJoUSLWRDGSkc
         YBb4DYv3kDQk8jL4LPKlAlwu1/hfM3oDoA8r+Wuik2pNC7de5YMXyQ48JCalYpkC2UIg
         tu9ReUCHCksEgu/pf3rBqu/tPG+Nxa9twZBbwVkbA1Bu08xC4NBhgSuPVz2lVnDhFwZU
         MZIAwEySOCJ+2gZC0tsTyJni3PLF1ZdsLwx5m/Mlt3jW+L2fj+NS87IHecbxI6e8qf+O
         8YgA==
X-Forwarded-Encrypted: i=1; AHgh+Rr05gYbXnNrF1pPKLOZsgR598cSoyBUZLiTnOkVLG+pRfzeA4qIfvqm8HgU1Ix2JGI2lIHrwE5mY3Qn@vger.kernel.org
X-Gm-Message-State: AOJu0Yzogi+qlWtl1Kx/wItxmuAzKc+6j85zrwWdwglSP7bnRmvNL2+z
	Wlbx13kPLFT2KkCZApZhRrvKlN2dvePzOP+HNsLP0h4PEj3MzqzHEm0k
X-Gm-Gg: AfdE7cm6aYc6hVnprNKesL34Ll9VPsidFuNq7v33lxXnsAvS/KlQfnaR0vYsSfX/yk4
	9gmH9iLn6hVlJJIin420XbEdMcU9xQmzh9CCLFeZdf5kP6qJkdgcxljRP5Y6L1OIHg2CSTgtw/R
	Y9j9+bJ8PnFEVL0Ng969FPEPZxy5BJ3h7mpcE7d2a5UWD/lHMaVjm8Xtnuj6yEHlv+iP0W5mw8d
	xMGpOc4HGj1Nd+kFhISLeHKEhbv9i8GJGb3jf/aGWSM0uZsA8klKobp04tz3Qfk1Ssin7dYRdKw
	aPonClum6hmwhmwLM9zfpEwnrP/q3x1g8Nf/J1N7FpdTBEtVjvfKLSOjWLs6eW13ONBWmThz/QH
	AfwmUHeiOnojPWdec0skqvfKa0g3RstL/qFl0uaV7ZDDggtHOj9kEDVbqIzBrRjYdVw+fXhqfRg
	t7xwVLOmkzyL895rkOIbzDU1Ww9blmo8gS4jXfewjiT48yDY+eHLu/wmXAmpHJ+Y5+XQ==
X-Received: by 2002:a17:90a:d88b:b0:381:528a:808c with SMTP id 98e67ed59e1d1-38dc75e3d4fmr9572711a91.12.1783976279067;
        Mon, 13 Jul 2026 13:57:59 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e172b6ce6sm403816a91.1.2026.07.13.13.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 13:57:58 -0700 (PDT)
Date: Mon, 13 Jul 2026 13:57:55 -0700
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
Message-ID: <alVRU38lMfvmUFqJ@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
 <20260710151151.1e193eedd0cf2591ae392f76@linux-foundation.org>
 <alG2-RSitzPWClAX@skinsburskii>
 <20260710224950.53bcb43ce7e564f07a1f6a8c@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260710224950.53bcb43ce7e564f07a1f6a8c@linux-foundation.org>

On Fri, Jul 10, 2026 at 10:49:50PM -0700, Andrew Morton wrote:
> On Fri, 10 Jul 2026 20:22:33 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > On Fri, Jul 10, 2026 at 03:11:51PM -0700, Andrew Morton wrote:
> > > On Fri, 10 Jul 2026 14:26:20 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> > > 
> > > > This series extends the HMM framework to support userfaultfd-backed memory
> > > > by allowing the mmap read lock to be dropped during hmm_range_fault().
> > > 
> > > Thanks.  This seems fairly mature and mostly-reviewed so I'll give it a
> > > spin in mm.git's mm-new branch.
> > > 
> > > Unfortunately Sashiko wasn't able to apply this or v7.  I'm not sure
> > > what base you were using.  Hopefully there's a reason for a v9 so we
> > > can retry this.
> > > 
> > 
> > I rebased this series on top of mm-new right before sending it out.
> > Should I have used a different branch?
> 
> mm-new is good - Sashiko attempts that.  But it's changing rapidly at
> this point in the development cycle.
> 

I’d like to send another revision addressing a few comments and also
replace the `max/max_t` check with something simpler.

Which branch should I base it on so that Sashiko can apply it
successfully?

Or would it be better to send fixups against `mm-new`?

Thanks, Stanislav
