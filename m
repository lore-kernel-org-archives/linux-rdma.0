Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7362F8BC0;
	Wed, 15 Jul 2026 16:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784131439; cv=none; b=Np1MEZwZAdvYEkV7wlkykNBYAIurOfaoFMRZzItwGlAhv8T1TU9GjPkHenXL5cUmedSy9UP6FNxR4u/g3dt6rU/NVMMA52c1qXA4e7SAwj/dkXrMHBNDLdhpOFJhCi1S95W7T9KH3SnwOFCB8whcoOZjZVWHW7RjoNurLWpu4tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784131439; c=relaxed/simple;
	bh=+iNIANSaFwXfEns2LbTLi0Bxvbsii1jRkrV5zphbfqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=myL/RJsHa/WKDqwjs/T2Xi5grg5Z0XrZg1928EftBrBrdAjYfPjsxLu1IB5x3jsi7RTx81bJvNGn/WAYb9hAtfOWWI9i8OIDZns4oPGsXd13cfLUd8jai+AbHQ5pdUkft1oRXCo3UO8gHDfUwSACuAx4aNsupQVY1fRqRNp7LMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DJzFvsXq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DJzFvsXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C614E1F000E9;
	Wed, 15 Jul 2026 16:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784131437;
	bh=md/jEk0jwM/1EpvL4aXiOB03sTXekaC75/GjnFjny7s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DJzFvsXqDbNcfu5SjVj50xj+C83jpeSUODs9GeJaJ6gN6jvCtPFRttyMbHY4U+Li+
	 XdaKxNow5RNCa9sobV54MKYxfWym3ZKF+pVy5bCA1nPBwMWoN0+8ffR2s65W6xICWb
	 dp3cxeJv/n8gDCn6/lgnfESgr+OkJoBnSotjDJZzt2hTNu9ShV49YS98ZJlKxu2IBp
	 9104JoS/X0nPf4K7pd161nDup10h5wtw4W+BR6/zykBWFLSM4qUPdl266itlS5fw1R
	 kvJ1hxkiTXfaRNtFHQvYfUm8jrb94jP3iV7ELRPHU4cfCVd6mVtStHTJ1ArR5GuQuK
	 bsCtqAfKsCYPw==
Date: Wed, 15 Jul 2026 17:03:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, airlied@gmail.com, akhilesh@ee.iitb.ac.in, 
	akpm@linux-foundation.org, corbet@lwn.net, dakr@kernel.org, kees@kernel.org, 
	leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, lyude@redhat.com, 
	maarten.lankhorst@linux.intel.com, mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org, 
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com, rppt@kernel.org, 
	shuah@kernel.org, simona@ffwll.ch, skhan@linuxfoundation.org, surenb@google.com, 
	tzimmermann@suse.de, vbabka@kernel.org, dri-devel@lists.freedesktop.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 0/4] mm/hmm: Clarify notifier retry state and scope
 HMM timeouts
Message-ID: <alevUbqdUmNkOef_@lucifer>
References: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
 <4300f09b-8f93-4605-b072-7c09a82cb16e@kernel.org>
 <alecaJ1FUso39D9k@skinsburskii>
 <20260715150210.GA3846105@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715150210.GA3846105@ziepe.ca>

On Wed, Jul 15, 2026 at 12:02:10PM -0300, Jason Gunthorpe wrote:
> On Wed, Jul 15, 2026 at 07:42:48AM -0700, Stanislav Kinsburskii wrote:
>
> > > > Stanislav Kinsburskii (4):
> > > >       fixup! mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support
> > > >       fixup! drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
> > > >       fixup! accel/amdxdna: use hmm_range_fault_unlocked_timeout() for range population
> > > >       fixup! drm/gpusvm: use hmm_range_fault_unlocked_timeout() for range faults
> > >
> > > Why a fixup series instead of properly resending the full thing?
> > >
> >
> > The goal was to get a Sashiko review, and v8 has already been applied to
> > both `mm-new` and `linux-next`.
>
> I think if you send the whole thing with a base-commit tag that
> specifies a real base commit in linux-next sashiko should work
>
> Jason

Oh so just use b4 then :)
