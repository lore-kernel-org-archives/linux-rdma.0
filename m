Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365F826738C;
	Wed, 15 Jul 2026 21:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784150260; cv=none; b=IGU2jiSxAS2S1SS/9WFcSdE8MdlJAnG8SvU+xoVKKwq6DQPPMRdLm+FWsolAuqAtmsvrOU5iCkd3MWxtUtXDl4ROSyfhEJqZAma8p6K4xFJVwy9z1tc/nsHrFmhrXOLkgyi9I4NNLL0MvxvYZ2xKyBPsfEaLXw7iD2anp4RIvAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784150260; c=relaxed/simple;
	bh=VVePxeXkdKZk5HClfQ8GUU7FzfH1Oi5VU2e3L2YfQGc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=q81P5YVQQFDOnytSKGUIc6Klgv1sxaOXDjISpQvMhkiw2EG9bhi1SnP4kpObMIp6UR2ixWmCY1Qo8utw9VlIDfgVJNfFfW7RWQKgyhBDmgUCTvsotojJ+1fFM5CLxchjXeqetckn+Q72hMGyB+kGPKI57BonAXXWajY974J3m1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lw1aE0Rl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lw1aE0Rl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56601F000E9;
	Wed, 15 Jul 2026 21:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784150259;
	bh=UU+zPW9iRvCJbBM3XKZCH/KKzyu8mkExGEFSmL1gNYg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=lw1aE0RlWxmrVX1SBFRJgy1UyPRTg4K6nP+DEjnY9dlEAsFMk2L2RNTreb0d+vs/k
	 1gYgzd2yzaN3XobC7uyRdh1AW0rjf0Olb3qRLd+W/Q1HYfJhedn8GiXr9Nt0CNftbb
	 PL/NA8rFtyplykMr0XbJ7OZgExm1aHBfS+hm1Ecw=
Date: Wed, 15 Jul 2026 14:17:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
 dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
 vbabka@kernel.org, wei.liu@kernel.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Subject: Re: [PATCH v9 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-Id: <20260715141737.4097a5c7d74953ffd8ed66c9@linux-foundation.org>
In-Reply-To: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
References: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, 15 Jul 2026 11:15:50 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> This series extends the HMM framework to support userfaultfd-backed memory
> by allowing the mmap read lock to be dropped during hmm_range_fault().

Thanks, updated.

> Changes in v9:
> 
>   - Folded the fixups into the full 8-patch series instead of sending a
>     separate fixup series.
>   - Clarified that the HMM timeout bounds repeated HMM/mmu-notifier retry
>     attempts, with the helper refreshing range->notifier_seq internally.
>   - Kept nouveau’s explicit outer deadline because its retry loop runs in a GPU
>     fault worker and cannot rely on fatal signals from the faulting process.
>   - Converted amdxdna, and GPU SVM callers to pass the shole timeout budget to
>     hmm_range_fault_unlocked_timeout().

These are all in your fixups for v8, so the v9 series made no
alteration to mm.git.

