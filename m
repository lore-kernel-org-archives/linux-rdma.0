Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F473D8907;
	Fri, 10 Jul 2026 22:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783721546; cv=none; b=h4R1xQRsxwYWExI/OxNuzlNm5/tNiLjLpRHjr2Klo3eOYmuaVWn4wQMB2DZe+JXO4/IWfVVdaIIx4V9OP11R2S6+o2N7Y8UKUkl2By7br8yllE5cOgSQzNW2UETSNV5ejijmud6PPvXxj2PAEQ8DdRRFhie0DRFKDgoZibWw7Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783721546; c=relaxed/simple;
	bh=Bvo3BBYIfYfnIocNC/TX96Ycnc2dBwJEFYKQSta3yr4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=HWE30Q34UQ7WffIDZrXiWildCT75GiK++QpSeN5VU36ZUq/jkUu7XwWg8GqCnKSP236leaCbr0z+KZYpZcc0hFZb8H2Syx1Cpw74C1yPI86apraRKQhJOerGz7cVTHkKUpJXvM9+HFyX2Bt/641yX6UaeoZTNdeyc1wdkPl+bSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VJe81GYb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VJe81GYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32471F000E9;
	Fri, 10 Jul 2026 22:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783721544;
	bh=2wQB/oFYBFS3GQeSmu/3oRAdk1WgygnNAOd7kwV5jaQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VJe81GYbWd6zLU/0Oy3lq6fNYK/xvVwqq20qidN2/oL2icncQaYqK1Fe+uvqBiFrT
	 IBcwSe/+HNIab8r7fGPOpavS+7+qhyYVJipwSJrqT9iWJDM6ku4YDxNdGO4WQA2ORB
	 9VskKFPVtZ6W0Ang1vDmufbj4+l2UBAJGLgWU3LE=
Date: Fri, 10 Jul 2026 15:12:22 -0700
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
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 5/8] drm/nouveau: Use
 hmm_range_fault_unlocked_timeout() for SVM faults
Message-Id: <20260710151222.ddb35eab9c81a8720491464a@linux-foundation.org>
In-Reply-To: <178371881847.900500.8789369230260725500.stgit@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
	<178371881847.900500.8789369230260725500.stgit@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 Jul 2026 14:26:58 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> @@ -683,15 +683,11 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
>  			goto out;
>  		}
>  
> -		range.notifier_seq = mmu_interval_read_begin(range.notifier);
> -		mmap_read_lock(mm);
> -		ret = hmm_range_fault(&range);
> -		mmap_read_unlock(mm);
> -		if (ret) {
> -			if (ret == -EBUSY)
> -				continue;
> +		ret = hmm_range_fault_unlocked_timeout(&range,
> +						       max(timeout - jiffies,
> +							   1L));

"1UL" here?  I'd have expected min() to warn, as it likes to do.
