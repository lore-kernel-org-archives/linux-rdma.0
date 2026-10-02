Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DED947A87E;
	Fri,  2 Oct 2026 12:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790943164; cv=none; b=kzBadtFVTU6mO58DnBYSuQCPvhX7kr2gYJl1Jlji3q0/rMj+0CHm2hznCtUXgBo0Nb7rrVuLReOkfLF+RU+RqzWMR3i9BhI+ijULje3GLyyyuNTWnMdrQslM79OruX9qRl1UMC+LmTmYLKW7rN/DglyiY0ejJ/8zCKYaiPBlFUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790943164; c=relaxed/simple;
	bh=ZJ0Z/r4AiXTZAF8k8QwJ7RvpIWIKMzp9yZ5KsTu0k1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nOeQQAfo1YyH7hFaDJJ8pUQXdVynPHoc8tLxW9kq3ePMtfBKZK/rDD7Xo3w3sZmOp34S8X8QbKtRPV+9IsYz4w9tLdNl/Up70FryHz3SJsorSkeHKbyvrzcfxiNxq6q371iQyNZjc6+Hgixb+kOfHbsbELyhgHQL217XOpvro+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c4yl8biB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c4yl8biB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7891F000FF;
	Fri,  2 Oct 2026 12:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790943162;
	bh=nX94dzJL8Kj3ESX88e5wjImNlNtcKNqoM+7SGcE8uW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c4yl8biBSZCOSz8O02PAfeH7eOGxEphl+j5zx68yHK0rGgywavDJhETeCqFXtb525
	 drYTuH322sqP8NPQ5ZewzHTnVOIMhBthJu+BRfYK/9P82Fewt1qESLmLaBje/QXlbU
	 DwFWnhrzPDhC7iHk2BYxuuux04WkpQ1QaA4z1giCRe1/CYf+j/udPDx9BpMRBgE+zE
	 0Pp4Nr8nepmdcGz6T4V/ZJP/q0Yksmr01oznoU9EHFYDe+Pybk4DVG6cBSpehyP9Up
	 XaZfWzb0H55uTLR1CMcTUrzHQC2okp7EhDFf3/godjZFN6JSYYuusCC9eACzBjmltf
	 QSU/lT7DTm+dw==
Date: Fri, 2 Oct 2026 13:12:20 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Paul Moore <paul@paul-moore.com>, Leon Romanovsky <leon@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jaroslav Kysela <perex@perex.cz>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Thomas Gleixner <tglx@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Eduard Zingerman <eddyz87@gmail.com>, Zi Yan <ziy@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Namhyung Kim <namhyung@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, x86@kernel.org, 
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, 
	"Martin K. Petersen" <mkp@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Simona Vetter <simona@ffwll.ch>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Sebastian Reichel <sre@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Helge Deller <deller@gmx.de>, 
	Mark Rutland <mark.rutland@arm.com>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Nhat Pham <nphamcs@gmail.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Maxime Ripard <mripard@kernel.org>, 
	Nick Piggin <npiggin@gmail.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Arnd Bergmann <arnd@arndb.de>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Paul Walmsley <pjw@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Vasily Gorbik <gor@linux.ibm.com>, Baoquan He <baoquan.he@linux.dev>, 
	Andreas Larsson <andreas@gaisler.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Gregory Price <gourry@gourry.net>, Rakie Kim <rakie.kim@sk.com>, 
	Christian Brauner <brauner@kernel.org>, Alistair Popple <apopple@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, linux-doc@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Brost <matthew.brost@intel.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Byungchul Park <byungchul@sk.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Xu Xin <xu.xin@linux.dev>, Chris Li <chrisl@kernel.org>, 
	linux-usb@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, Yuanchu Xie <yuanchu@google.com>, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, Youngjun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Wei Xu <weixugc@google.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-sound@vger.kernel.org
Subject: Re: [PATCH v3 10/40] drivers/usb/mon: update to use mmap_prepare +
 map kernel pages
Message-ID: <ar-e6Njx2MHiGs7G@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-10-4583d8a23bca@kernel.org>
 <90811f7b-1751-49cb-bf0b-3d5ee7f10e45@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90811f7b-1751-49cb-bf0b-3d5ee7f10e45@linux.dev>

On Fri, Oct 02, 2026 at 05:55:56PM +0800, Lance Yang wrote:
>
>
> On 2026/9/18 00:22, Lorenzo Stoakes (ARM) wrote:
> [...]
> > +static int mon_bin_discontig_init(void *vm_private_data, void **private)
> > +{
> > +	struct mon_reader_bin *rp = vm_private_data;
> > +
> > +	/* Dropped by mon_bin_vma_close() on unmap, including on error. */
> > +	__mon_bin_vma_open(rp);
>
> Em ... If Coda uses a usbmon container and the first page insertion fails
> (e.g. -ENOMEM when allocating a page table) after mon_bin_discontig_init(),
> where is mmap_active decremented?
>
> mmap_action_finish() returns the error when is_compat is true, and
> mmap_file() then replaces vm_ops with dummy ops.
>
> Am i missing something?

No, indeed, the contract isn't honoured in the compat path.

It can't actually happen in practice - the compat layer is only ever
accessed from a stacked filesystem and those only stack on regular files.

But I should probably update this to be strictly correct regardless to be
consistent with the non-compat path.

Let me see if that looks sensible and rejig for v4, thanks! :)

>
> > +	return 0;
> > +}
>
> Cheers, Lance
>
> [...]

--
Cheers, Lorenzo
