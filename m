Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EA02DB7BE;
	Sat, 11 Jul 2026 05:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783748917; cv=none; b=o0qhbtm23gtBCm4kFZk3ZDH1gRVDzNFPYjdnRtZobapVz7u1AijXLmYqw3z4pgJyV2yUCf8dwJYRVceStt3Q0O5r4Tno/ZRLLYlbg8f4vQ9a/ROaGdsvtTUeEq8KjeVUWJ8CJZjnjWohs3wW2+sOU7byTrXOsW9HFDF/TP3m8pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783748917; c=relaxed/simple;
	bh=2X3u/rhMdoK2ZSzI5yRlLbKzVLTeEAk7NfzAxOZxq8M=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Svv3aPSGkD1Q0veLIwbSj3XAS1SgUWDr/DbneYWlZzhh1Co2O27I0E6kX2O2A9cCmRfRSlYfNoWlNeGPKRTbRCY4UH97zZeT38wQppzri+A9lT+hpx8GhYVtMw4R1bJWpqbqPFwVIYdQ1gCdzXUTz1Ap32OFjcVG1oyIc2UD9vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zxP6H3RU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zxP6H3RU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B1C1F000E9;
	Sat, 11 Jul 2026 05:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783748915;
	bh=/bm56TdW2Rt1TzYZP4AwroZ1H/akE8N7PaZmAo9v49o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=zxP6H3RUmBd6ihlhUQIdRJzfv+dWAy7/NIa1aujz+UJUigwYO9G60/3Bm1HoqfjnX
	 DZhiti+OpHf6AgYSszNldBtjYCKgg5QG6160LxG4/45mDd4arD7V/RUmAhgcW9bWTx
	 E9/cf5f5XfN6+ulL7h4VwT+i3BR5zKS6NdueS7go=
Date: Fri, 10 Jul 2026 22:48:33 -0700
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
Message-Id: <20260710224833.9caf2a0a9906f0515e326a45@linux-foundation.org>
In-Reply-To: <alG1k3JsoywE2CBM@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
	<178371881847.900500.8789369230260725500.stgit@skinsburskii>
	<20260710151222.ddb35eab9c81a8720491464a@linux-foundation.org>
	<alG1k3JsoywE2CBM@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 Jul 2026 20:16:35 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> On Fri, Jul 10, 2026 at 03:12:22PM -0700, Andrew Morton wrote:
> > On Fri, 10 Jul 2026 14:26:58 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> > 
> > > @@ -683,15 +683,11 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
> > >  			goto out;
> > >  		}
> > >  
> > > -		range.notifier_seq = mmu_interval_read_begin(range.notifier);
> > > -		mmap_read_lock(mm);
> > > -		ret = hmm_range_fault(&range);
> > > -		mmap_read_unlock(mm);
> > > -		if (ret) {
> > > -			if (ret == -EBUSY)
> > > -				continue;
> > > +		ret = hmm_range_fault_unlocked_timeout(&range,
> > > +						       max(timeout - jiffies,
> > > +							   1L));
> > 
> > "1UL" here?  I'd have expected min() to warn, as it likes to do.
> 
> I'm not sure... The "timeout - jiffies" can become negative.
> Won't 1UL convert both of them to "UL" and thus make the comparison
> overflow?

`timeout' and `jiffies' are both unsigned long.
