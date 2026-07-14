Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869E44EA386
	for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 20:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784059556; cv=none; b=XhDxGJE9atgkuxewL6B9QxQKH2FITiHsr1bBKhK7M7SlWv+SG/+S+JdCwfqg/1Anbx6WU83JvxvTk+gmJV+n/uHNvnUbDspZOS0FZlSG6uBX5V79acUmwiJUIKrO01SOM2o/Xt+NdaInlZ+1S3EzJ45d7SyeboBDaiWCjVYBWjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784059556; c=relaxed/simple;
	bh=1uIy+Qd4I0VZk3IKsXvjdEcJk8DHXM5OZO3Y2c8nsVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mAWewHTSMnD4Qh+UmxFtOtQigYC5jWPpcVAV6EEN9Tt3QcyGFBz3TWj6CEOyTnz4EDGi9g80t2nTXWM/oq3alDj2IMhX0qp1D/u5BLCZQoKx5Ri2s1KnJfLnJGdkX2hnbaCbLc/DSkoTL39pJehz/VV98BEgwcrHK3M6XCLkB7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lXiePRH7; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lXiePRH7"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38e1a9d9105so984617a91.1
        for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 13:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784059551; x=1784664351; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2TZmO5aEOGXmRgWMClTIlhAZCzNX5InAxzEzEi9D4GA=;
        b=lXiePRH7w9MGJyqOlo8uTDd/4y5uBW1g0tMgC14az7iiCSEzd7Uanjh2r4CT+ZOxho
         N8gZWIs0YIb63jXMothAfdUBtw63WXZe7XZcAvg5cY3vmUxArdpfSrW5u2JADEtjKBoF
         2iOJYOFo3CqJT6wBKO4xdX152LvIB5PKMLDyBN6X9a7AcvQsjL5wwttKWm86EAanDZ/f
         krk3xhjFZk7igPScYtg5QMvaGzI4GGziMJOwh30dA92QyhPkR3pT0XJCCemQ/GuX47wx
         JWjSvKGPRE61v1Oojp3XpYrvuNvqjiXK8QT4+U4DSOe3aHnPkciSg9DtO/23j5ZSqfeH
         gEdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784059551; x=1784664351;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2TZmO5aEOGXmRgWMClTIlhAZCzNX5InAxzEzEi9D4GA=;
        b=UuoTTAj4WGD+XQ1jCjyrqJG6vPlNIAOTtVF4Q2VFBqjWeZen+xujetyC1YRwvUzBSS
         7wsshPmKplJuM86C32XMVTB+SAbCPHfiJLaa5fVnNTEdCrnJDxINelByrVww5DL01KBW
         LW/7GIq95HnJzqcVx7MqrkKOyKKlHxnnmgO0LVJpsDGPVR8tsfqGgftnhdtbVsySNi/6
         eEH+WGEAW0ZtiH7QiaFm+h5Y5+n8PHjYrHV1ylZoxNAU1DhfQZaGKOdq77QOW8inuloY
         2ko7cOTbSwuaMGaT6e+4kW50I5BM8wO+lUNDUQRclq6UxNAO1jRIsUwvlgv1yWPMt9I0
         pehw==
X-Forwarded-Encrypted: i=1; AHgh+RpC+ja40oMsz9eBYQ5dl9vKYeGa6RpNcWeBjdS6u1yj3WkiJrty5l6+2MXxFIXrWsBRDJ4Aoyf/MGYt@vger.kernel.org
X-Gm-Message-State: AOJu0YyOMfGA2bZIEiIihpoNJFU9b5vtegB4GZdcztC0FnR7t/fSxK9g
	RGMBMpe5JghM3JsWDCJxUbe58CPRmBo9QalvYputs994K/tCRE0+pO5/
X-Gm-Gg: AfdE7cm49Gsjp/K57nKlURf7BGzhsBls3Qx471Vt0p78DYi4Ft+mKPx52331mURi9Gn
	m/h58MzqLd/O9d/qhXDYkttxG7qF4lx8RRKZQEKYVX8YF9bgfKuoSq8NzNt9snZwDQw/60Fh/80
	uwjyw2vrIv7l54RTfrOPDbjhJJCy07Od+2GpJKZszwulaQoL+GVilWD7iFpy0FNyvuUuOSB2/2Q
	BDO0xAQIVCGeJDExykgTfNE7qaFJCrtCiNuS7Mczcl4YZhS4o5+m+Lvi8cipd/FLlz0wWZMD7Gh
	RDTSotnPWNOWgUD3J223XLkSfkTmtOuatkrQYbmSRiGl7VbRJ4ZtNrcNlwL8HRAr4/pStNN8kPm
	fSnHwV5wahUcStYoP0WqHAhJFOFUtghdvkZ9h4yKbDIH3ovSxGe04e5FTP3+cHVKIynGPRA7tgb
	IQ18jdEmoXs95CgfvL3MNLGDAdaUz/0uUFDy4zM4AUQPHZcQs63faEero=
X-Received: by 2002:a17:90b:57e5:b0:37f:be6c:f3f2 with SMTP id 98e67ed59e1d1-38e29ff93eemr138372a91.2.1784059550783;
        Tue, 14 Jul 2026 13:05:50 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e172b6cfbsm2007674a91.3.2026.07.14.13.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 13:05:50 -0700 (PDT)
Date: Tue, 14 Jul 2026 13:05:45 -0700
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
Message-ID: <alaWmUEeIBeSkmO0@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
 <20260710151151.1e193eedd0cf2591ae392f76@linux-foundation.org>
 <alG2-RSitzPWClAX@skinsburskii>
 <20260710224950.53bcb43ce7e564f07a1f6a8c@linux-foundation.org>
 <alVRU38lMfvmUFqJ@skinsburskii>
 <20260713154535.7656b3a630e2f6f076b4e76e@linux-foundation.org>
 <alZfTxfypj39OrCE@skinsburskii>
 <20260714105751.f45ec4c70702c222febdbf07@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260714105751.f45ec4c70702c222febdbf07@linux-foundation.org>

On Tue, Jul 14, 2026 at 10:57:51AM -0700, Andrew Morton wrote:
> On Tue, 14 Jul 2026 09:09:51 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > On Mon, Jul 13, 2026 at 03:45:35PM -0700, Andrew Morton wrote:
> > > On Mon, 13 Jul 2026 13:57:55 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> > > 
> > > > > > I rebased this series on top of mm-new right before sending it out.
> > > > > > Should I have used a different branch?
> > > > > 
> > > > > mm-new is good - Sashiko attempts that.  But it's changing rapidly at
> > > > > this point in the development cycle.
> > > > > 
> > > > 
> > > > I’d like to send another revision addressing a few comments and also
> > > > replace the `max/max_t` check with something simpler.
> > > > 
> > > > Which branch should I base it on so that Sashiko can apply it
> > > > successfully?
> > > 
> > > mainline Linus would be safest.
> > > 
> > 
> > Looks like linux-next/master has been updated with the v8 of the series.
> 
> That's because v8 is in mm.git's mm-unstable branch.
> 
> > I have v9 with a few small fixes, but it is too late to send it out already?
> 
> It's called "unstable" for a reason!  Material in mm-unstable is still
> under review, test and the latest stages of development.  Getting
> things finalized for movement into the non-rebasing mm-stable branch,
> then into mainline.
> 
> So altering or replacing patchsets while they're in mm-unstable is
> perfectly OK and expected.
> 
> > If it's not, then what should I base it on?
> 
> Well it's a bit tricky to replace a series when it's in mm-unstable. 
> One can do a git-checkout of the commit which precedes the v8 series. 
> Or base on current Linus mainline, which usually works out.
> 
> Sending little fixup patches against what's presently in mm-unstable
> also works.  I'll queue each one immediately behind the patch which it
> alters then squash them into their parent patch before moving the series
> into mm-stable.
> 
> A third alternative is for me to drop v8 from mm-unstable, then you
> wait until that has propagated onto the servers or into linux-next,
> then base on that.  This approach is OK but I kinda unprefer it because
> there's a bit of latency and it makes it harder for me to prepare my
> "here's how v9 altered mm.git" summaries.
> 
> 
> Which would you prefer?

Well, given that Sashiko didn’t pick up my series based on mm-new, I’d
prefer to send a few follow-up patches in the hope that they will be
reviewed in the context of the original series.

Thanks,
Stanislav
