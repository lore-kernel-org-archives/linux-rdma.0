Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E59935203A;
	Fri, 31 Jul 2026 21:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785533856; cv=none; b=DfPkqFnroowS0334irsdAHO7IO7EwVyFm2PMzZLClqwjIQcVPisQzNrI2Haf/7vccJiIl3QjtsfNhe/ffvnho6X4pTHnx+dmgqxymUAZmN88C8nCOdrAcc7+f9/eABSWRirKunVTVeYVuho6jYGyykglukHaiV7jvFH6Me+G95A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785533856; c=relaxed/simple;
	bh=pk9f3iIsJJZYqYPtFaAxp1dffLct3ichWT0EgO1tYj4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=CVCxS3pLh9jBSSDtAB4+uERexivCj9axC3HBYHLcfljFE1KRqaaK75edQdbYx/nXOD4IeLR2S9n75k2mR9P6sZjHcGCfJcgK2fur5M+kcNYJIa0T42BjbgJ+ukaG/6RZoJQixKy7XbD9CIM6a70jCUtOorjC04nDJUeOaF8Y4uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bsu9prvl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bsu9prvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098FB1F00AC4;
	Fri, 31 Jul 2026 21:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785533855;
	bh=O1+5FJ+vsFbhTS3uy6QvGBbTfrl8nRF61DS//Z1gGs8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bsu9prvliEAtWl9141QWG8ktEUrv3SrzZW0TRFfh52pvi18ypE6LALcgP5+/3tl5p
	 chd7Y8huQ3OCgGlD/A9nlhMZoYfi1Iu1y6/OkpTPWSKlaEZNueaXh2uQfIC1pvoBtY
	 SewvgNsJYjVN6u7HfHbW+4sjXANpuiXr+fCVombQ=
Date: Fri, 31 Jul 2026 14:37:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Liu <wei.liu@kernel.org>
Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>,
 "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang
 <haiyangz@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li
 <longli@microsoft.com>, Lyude Paul <lyude@redhat.com>, Danilo Krummrich
 <dakr@kernel.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann
 <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Min Ma <mamin506@gmail.com>, Lizhi Hou
 <lizhi.hou@amd.com>, Oded Gabbay <ogabbay@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-hyperv@vger.kernel.org,
 dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
 linux-rdma@vger.kernel.org
Subject: Re: [PATCH v11 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-Id: <20260731143733.6f74ec9b9023f898c3c260e1@linux-foundation.org>
In-Reply-To: <20260731211728.GA3243658@liuwe-devbox-debian-v2.local>
References: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
	<20260723142242.5d3f87208d47819d873ae458@linux-foundation.org>
	<20260731211728.GA3243658@liuwe-devbox-debian-v2.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 Jul 2026 14:17:28 -0700 Wei Liu <wei.liu@kernel.org> wrote:

> On Thu, Jul 23, 2026 at 02:22:42PM -0700, Andrew Morton wrote:
> > On Thu, 23 Jul 2026 10:36:32 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> > 
> > > This series extends the HMM framework to support userfaultfd-backed memory
> > > by allowing the mmap read lock to be dropped during hmm_range_fault().
> > > 
> > 
> > Thanks, I've updated mm.git to this version.
> 
> Hi Andrew,
> 
> I see this series in linux-next now.
> 
> I'm curious to know if these patches are going to make 7.3.

Probably.  The series is incompletely reviewed at this time.  Perhaps
you can assist with this?

> We have some work that's dependent on this so would like to plan
> accordingly.
> 
> Thank you Stanislav for continue pushing this.
