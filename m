Received: from mta1.migadu.com (out-2.mta1.migadu.com [95.215.58.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6433A47DD7A
	for <linux-rdma@vger.kernel.org>; Fri,  2 Oct 2026 09:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790934999; cv=none; b=hVb5LPkvSpxli/tyYG9DZNE5GXrpaJzFCU+/Mu8LpGKOVxjwet1tFLkbsrpiOXsTdVXdo2NY1cGPAz10styUEzVYKEhMkFwVIfuEHi9Nbg5Y22zxyQQtNW/vKalSYOPDQ5hLfXx7hroIkEmRye18/gEXsk7YvYRxIbpypuLT/CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790934999; c=relaxed/simple;
	bh=92W4VZCSKNhkkdED6V3xajazvmttQRmFoqQ3AYY4EWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JtEB1ZyKP5/DOb3ObYAW9TZcc1Nq1rY8L8haxELgNKQoy4aFFYNfsGpVRnIRx5ZQEdlETQGEr5Nlb45YVSHZOzuYR6v4J3WiUWECrotBDKT7fWX6dN+hUwsIyWFG88k6lHW7f5KwxI6n+LDi1xyQn1Zomxgrc7pmxiDFc62m9o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H+RRj5jM; arc=none smtp.client-ip=95.215.58.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H+RRj5jM"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=92W4VZCSKNhkkdED6V3xajazvmttQRmFoqQ3AYY4EWM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790934995; v=1; x=1791539795;
 b=H+RRj5jMfyY5EiX9+rlut0MOhxhNeJD1y/XtZjIq8MZBZZULb3mSJ6xTH9JihyOKUmn747wW
 Zi1edo5Zvv2ht5X2yKTHd1I6SBeMyICbpDqsDglDULJqQY6LrpUhHJg4vO8dhcaAssbEdKzdAMC
 143b0C2OWtRG6tbRPmqQTIy4=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5ac8ebf340b273e0;
	Fri, 02 Oct 2026 09:56:30 +0000
X-Mizu-Trace-ID: 5ac8ebf340b273e0
X-Migadu-Flow: FLOW_OUT
Message-ID: <90811f7b-1751-49cb-bf0b-3d5ee7f10e45@linux.dev>
Date: Fri, 2 Oct 2026 17:55:56 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/40] drivers/usb/mon: update to use mmap_prepare +
 map kernel pages
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Paul Moore <paul@paul-moore.com>,
 Leon Romanovsky <leon@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
 Jaroslav Kysela <perex@perex.cz>, Jason Gunthorpe <jgg@ziepe.ca>,
 Thomas Gleixner <tglx@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Daniel Borkmann <daniel@iogearbox.net>, Eduard Zingerman
 <eddyz87@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Nico Pache <nico.pache@linux.dev>, Namhyung Kim <namhyung@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, x86@kernel.org,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Kiryl Shutsemau <kas@kernel.org>, "Martin K. Petersen" <mkp@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Simona Vetter <simona@ffwll.ch>, Peter Xu <peterx@redhat.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, Sebastian Reichel <sre@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Harry Yoo <harry@kernel.org>, Rik van Riel <riel@surriel.com>,
 Peter Zijlstra <peterz@infradead.org>, Helge Deller <deller@gmx.de>,
 Mark Rutland <mark.rutland@arm.com>, Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Thomas Zimmermann <tzimmermann@suse.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Nhat Pham <nphamcs@gmail.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Maxime Ripard <mripard@kernel.org>, Nick Piggin <npiggin@gmail.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 "David S. Miller" <davem@davemloft.net>, Paul Walmsley <pjw@kernel.org>,
 Anup Patel <anup@brainfault.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Vasily Gorbik <gor@linux.ibm.com>,
 Baoquan He <baoquan.he@linux.dev>, Andreas Larsson <andreas@gaisler.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Gregory Price <gourry@gourry.net>,
 Rakie Kim <rakie.kim@sk.com>, Christian Brauner <brauner@kernel.org>,
 Alistair Popple <apopple@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, linux-doc@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Matthew Brost <matthew.brost@intel.com>,
 Ying Huang <ying.huang@linux.alibaba.com>, Byungchul Park
 <byungchul@sk.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Xu Xin <xu.xin@linux.dev>, Chris Li <chrisl@kernel.org>,
 linux-usb@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>,
 Yuanchu Xie <yuanchu@google.com>, linux-rdma@vger.kernel.org,
 selinux@vger.kernel.org, Youngjun Park <youngjun.park@lge.com>,
 Chengming Zhou <chengming.zhou@linux.dev>, Wei Xu <weixugc@google.com>,
 Miklos Szeredi <miklos@szeredi.hu>, linux-sound@vger.kernel.org
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-10-4583d8a23bca@kernel.org>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-10-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/9/18 00:22, Lorenzo Stoakes (ARM) wrote:
[...]
> +static int mon_bin_discontig_init(void *vm_private_data, void **private)
> +{
> +	struct mon_reader_bin *rp = vm_private_data;
> +
> +	/* Dropped by mon_bin_vma_close() on unmap, including on error. */
> +	__mon_bin_vma_open(rp);

Em ... If Coda uses a usbmon container and the first page insertion fails
(e.g. -ENOMEM when allocating a page table) after mon_bin_discontig_init(),
where is mmap_active decremented?

mmap_action_finish() returns the error when is_compat is true, and
mmap_file() then replaces vm_ops with dummy ops.

Am i missing something?

> +	return 0;
> +}

Cheers, Lance

[...]
