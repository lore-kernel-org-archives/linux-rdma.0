Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA9C320CB1;
	Fri, 10 Jul 2026 22:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783721514; cv=none; b=WKdVoNQ3Dmvaxjl5TuoQZCxNV6aZVpZmRlXx8eMUQNWrWEwmTnyfI7JUZe8juJgZEtr40hNT6lnWWzE8jJ9st2nvFpbmGUa44zZ+PwzgWQHgGLIAOXy0rTvlgj8ggmg3f2eK/3tbtW5htsPcyQJnqh0Mew2PbfHZbicNgpEYRvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783721514; c=relaxed/simple;
	bh=naM5Jxp0pAiHPL/CzBxLvvWlgl0VyG5fCmsLj54Q2XQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=CexhhyOACnNVMVgfVvhjiWUxcGDMLbakXEXKG9O8VojKUvErRrazpVg+NaeI3bdAFOy1yMFhRIi+gmF5uCw8LzjcRFYIPOWvfNioLSLzwxEtJP0xKIswQvhDuDgBEVVVYxy53/fWkC1y42HXSzdfFwHWELHZdwCL8UA27iUlPHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=isSd+YdI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="isSd+YdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABEA1F000E9;
	Fri, 10 Jul 2026 22:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783721512;
	bh=vJbMePxYpylcp4oMY5TEvTIXxy0y15lVec2d7nGNr/0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=isSd+YdIk2oKRkj18Y+rPxVD68aDvGRkC3Gfz17Do9Znb6noKkhNVD6qZ2vomkJnV
	 Vz3mMRKNl/P1Rv/PJH445qJc6+MsAE7TmU46muPg/2k1wbFohRwIe8WbSdXx1BmEdU
	 TG5W4PVDlLUdPHejARtAkCr9JonW/gFOE5KBW7kI=
Date: Fri, 10 Jul 2026 15:11:51 -0700
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
Subject: Re: [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-Id: <20260710151151.1e193eedd0cf2591ae392f76@linux-foundation.org>
In-Reply-To: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 Jul 2026 14:26:20 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> This series extends the HMM framework to support userfaultfd-backed memory
> by allowing the mmap read lock to be dropped during hmm_range_fault().

Thanks.  This seems fairly mature and mostly-reviewed so I'll give it a
spin in mm.git's mm-new branch.

Unfortunately Sashiko wasn't able to apply this or v7.  I'm not sure
what base you were using.  Hopefully there's a reason for a v9 so we
can retry this.

I have a few niggles, nothing major...
