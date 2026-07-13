Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B3A2FBE1F;
	Mon, 13 Jul 2026 22:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783982739; cv=none; b=WqzJsvuGWz7B3vm3wdzfJmKwiSLIIuqmpWP9+XuoIKvU9xOVvL4V4kJVeSUfgiSOplpAgj6CWLDqPG3E2n71GNFWP6dLBblsd2Q7cRGs5Ckd9UeiCTACBgbms8C+tyCbnCrBaUPxaC5rDR4TzSI+viOZQ0cAsFGg6yYWFdFkyuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783982739; c=relaxed/simple;
	bh=KoZgYoV6LVbvr5a/Ri2RZeRNUucziB4DF0uxNYrmx1U=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=cN1ELu0V9pNAgivsDGp1Qq5NPvvFsfRNi9DDXz5+IHbkfFs7iD0R8tz354h8KrVq6zfOj571HsHg37/NjvnZPglJZHbv805iTmJ89G7UU+pOOKittUWZMwNSyyJ5EnLSZKs6LazAGuBygxYCsQ78wlHlLCH7i1J5upUoraZNheQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DjnhDYqH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DjnhDYqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21771F000E9;
	Mon, 13 Jul 2026 22:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783982737;
	bh=adnYTFi3hoT5aFMOesERJpy3+zRYVUFF+RkxLaSOV5A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DjnhDYqH05eQ/7HFowjW8Rg67YLnpNK8S5WnhB/Caim8Ni6IKziN7IvqqsTpwVRXT
	 PMtPLLU/mEWJPiMd3fD7JuVerRhg9R6QFlBw+PJJKVNUtuSM691nugGB6JmjFy2ka6
	 croIvxMU+tK89yt+R7GdUBAIMoJ1m8j6C4g4WY/c=
Date: Mon, 13 Jul 2026 15:45:35 -0700
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
Message-Id: <20260713154535.7656b3a630e2f6f076b4e76e@linux-foundation.org>
In-Reply-To: <alVRU38lMfvmUFqJ@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
	<20260710151151.1e193eedd0cf2591ae392f76@linux-foundation.org>
	<alG2-RSitzPWClAX@skinsburskii>
	<20260710224950.53bcb43ce7e564f07a1f6a8c@linux-foundation.org>
	<alVRU38lMfvmUFqJ@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, 13 Jul 2026 13:57:55 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> > > I rebased this series on top of mm-new right before sending it out.
> > > Should I have used a different branch?
> > 
> > mm-new is good - Sashiko attempts that.  But it's changing rapidly at
> > this point in the development cycle.
> > 
> 
> I’d like to send another revision addressing a few comments and also
> replace the `max/max_t` check with something simpler.
> 
> Which branch should I base it on so that Sashiko can apply it
> successfully?

mainline Linus would be safest.

> Or would it be better to send fixups against `mm-new`?

That should work as well, but it doesn't give us a Sashiko scan of the
whole patchset.
