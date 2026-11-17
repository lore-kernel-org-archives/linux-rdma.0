Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794918106;
	b=ceV0KWrS+OMmFoD3soPAYdltwRw25o7BFUiuzFDnsGPfkIFr6ZPIyyiNxmrLya9XPPhq
	 5MNJyfV33REJlFI61Pood7hu9uuxECugp7lbz9LJH0SVZgScXRNg651iXNcEhpggmEG6r
	 Njr8ARiESibZmM4JpxK/7ZMwwrLlN5dcf7yPmrrvSiHdGIcixboNozQZgqbrU9SgIL8xS
	 KYgwOh8unVedIe6YATktYjHDstZfWk1hEdVWxwhQqDb4WrRMsLEPQEexB94Xg2humXdnE
	 nQBG6NWEvblRvln57YOOXGLbjX3TL/BT6ijY6Bpkl3wwY4qU5nU5KL+FdI2FAEiT8JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794918106;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=GttENf4AQLKGgaT2xtnMonfh7k3XNqVVFPtXzQMChjU=;
	b=zBE8wifi8n5zIWcipjjvGOZtocXnOCb2Bi1g99ZyjMJl1YQRLviSTlIvY8cvBKMoHvJo
	 bCxmWDLVYv5+Ht2+E7FNde/0hQRnFSCS6sA39rVjFSgXn/t1FXfuZcXijeKL97CAhjLh8
	 JoSUelX5XJSpkQ6Wa53tLsojrCsF5PqqaFrVoPtr48ljTgpoqR7XccI9FZ2YDJxuBwg37
	 dKZ/JMUBb28itFCVAn55TPR/CAzh6nexI3vfF7jq5vVrfFnS9PmLLCX+VHoRwCz50U2nh
	 VrYqp0gXgTr3PD9uUDvcuLEiB6UZoHdP8zHaSZIV5aHFq5iI3vCpoV5tTw6UlA4Jr6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C8lhV+Z6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455F8606A31C;
	Tue, 17 Nov 2026 12:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C8lhV+Z6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023021F000C9;
	Tue, 17 Nov 2026 12:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794918105;
	bh=GttENf4AQLKGgaT2xtnMonfh7k3XNqVVFPtXzQMChjU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C8lhV+Z6SJ8XgHd/J2EKI1U6pcb4wnoZF8dID2gB43wsYDa8pyqcBqXoFMBN0xEPN
	 iDxWYqie8JE0pWF2f1kyXnCQ6L5jOHuyZy6Tob4n2/xEewU+wXTHgFe8AXq06KvIs5
	 DaKLlL4gqZ6+qRwK1mKZ/oot5DCjLn7s3MFzjm1k/2LnjoEDqxFy9MeMqgtd9sG1U4
	 fQ+kCnZ+V0Jbj9XU6dxdgPvt0chSQtjPt0YC28YBiFO312AJ3WmUWkDdu9jidpWQkp
	 kL1OZE7zrbXx1g+ZVCa5SBXHy/BmdjHWUII37KVWw/6mK+HD8vNfHhCkVxfVbbv1A4
	 ZC6mh0URIBSIg==
Date: Tue, 17 Nov 2026 12:21:28 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jeff Xu <jeffxu@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Marco Elver <elver@google.com>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Chia-I Wu <olvaffe@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Evgenii Stepanov <eugenis@google.com>, Ian Rickards <ian.rickards@arm.com>, 
	Jann Horn <jannh@google.com>, Jeff Vander Stoep <jeffv@google.com>, 
	Jeff Xu <jeffxu@google.com>, Kees Cook <kees@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Peter Collingbourne <peter@pcc.me.uk>, =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Tomasz Figa <tfiga@chromium.org>, Will Deacon <will@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, Baoquan He <baoquan.he@linux.dev>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Allison Henderson <achender@kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, linux-mm@kvack.org, 
	kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, kexec@lists.infradead.org, 
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 5/7] mm: kasan: skip KASAN for GFP_HIGHUSER
Message-ID: <avxFYRBid_VUp6vo@gremlin>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
 <20261116230627.3537051-6-jeffxu@chromium.org>
 <avwp1ZpVudiT1Gux@gremlin>
 <85ce1f24-8b49-4cd3-a9f7-02d1be69708e@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85ce1f24-8b49-4cd3-a9f7-02d1be69708e@kernel.org>

On Tue, Nov 17, 2026 at 01:06:54PM +0100, David Hildenbrand (Arm) wrote:
> On 11/17/26 11:21, Lorenzo Stoakes (ARM) wrote:
> > This commit message is just inscrutable. It's like reading Finnegan's Wake :)
> > LLMs are obscenely terrible at this stuff unfortunately.
>
> I truly wonder how some can decide to submit something like that with their name
> under it :)

Have you seen mseal? ;)

--
Cheers, Lorenzo
