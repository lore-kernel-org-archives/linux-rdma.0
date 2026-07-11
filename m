Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E013313D51E;
	Sat, 11 Jul 2026 05:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783748992; cv=none; b=Qg/PtH1ZVVx0KJ3fMKGgpMdg1e8E8deuIn3KcHaAKOTGpVldkySjnVFwr30Ju0LrISzTb+b84YYHNoIsCOH+LKUpa9Cwhhvnku14CnPq+7u9rxXs2bmpNel9QUfW5lZeY7VQljxhRe61uoTGzMazH03GAdNjwsju4rTZNHLZVEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783748992; c=relaxed/simple;
	bh=KslYtVd6/FiSNgaU6k/vDiT76YGKqUbQU7/K1vnmVGs=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=d7GGkXSg8dBJJOigfZkRLU3oylpX7eUr9v7PPvB3IpVsjNFuhbYYtehCuPDXVsaxO4pRAGN/LDkdeyY62N4ELM/kTDxd6PLn/pxxPrggNVOShWgdlr3lGXTK3wYu6BRTYjisj9A9RcF/SVvUtm0t4RXCpAbj/VIjrzMjKSSLmsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kbiBT4UI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kbiBT4UI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C7C1F000E9;
	Sat, 11 Jul 2026 05:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783748991;
	bh=ORvew2lmZPoxsW3E1uuEKYOedhDenWUn2ruaSYxV7Zw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kbiBT4UI8EsOzp5Z6jcjE98+zJxsZeeKjK7DQ8Q28feKtSsl5P2ADzs/pTEcqC0/J
	 QY82X8hqbvOUNwXy7z96UyQ9MiH9eTOe4kxzhnxuDvLyE2M7RAXChoKV7pn9eSdotM
	 zjLpw7SDmjk5NIon4EHpDP7oKzGvYv+jnEP2DHoA=
Date: Fri, 10 Jul 2026 22:49:50 -0700
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
Message-Id: <20260710224950.53bcb43ce7e564f07a1f6a8c@linux-foundation.org>
In-Reply-To: <alG2-RSitzPWClAX@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
	<20260710151151.1e193eedd0cf2591ae392f76@linux-foundation.org>
	<alG2-RSitzPWClAX@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 Jul 2026 20:22:33 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> On Fri, Jul 10, 2026 at 03:11:51PM -0700, Andrew Morton wrote:
> > On Fri, 10 Jul 2026 14:26:20 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> > 
> > > This series extends the HMM framework to support userfaultfd-backed memory
> > > by allowing the mmap read lock to be dropped during hmm_range_fault().
> > 
> > Thanks.  This seems fairly mature and mostly-reviewed so I'll give it a
> > spin in mm.git's mm-new branch.
> > 
> > Unfortunately Sashiko wasn't able to apply this or v7.  I'm not sure
> > what base you were using.  Hopefully there's a reason for a v9 so we
> > can retry this.
> > 
> 
> I rebased this series on top of mm-new right before sending it out.
> Should I have used a different branch?

mm-new is good - Sashiko attempts that.  But it's changing rapidly at
this point in the development cycle.

