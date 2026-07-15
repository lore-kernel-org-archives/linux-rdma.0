Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB9E235358;
	Wed, 15 Jul 2026 17:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784135682; cv=none; b=EXJaIaB9QTuKHLh9r8Ph2HJA1jyxkXEBeIQ876J0pX06iOBbllpWza/qnrVsJ0IPg5TFU1FVRnc7O0RuE4U31TGHWgPtcK/PvrOOuQDZBTP/ngiVF0a5FbfynRE0I/Q1bGNlpEHhUMQGwmycMMEsXs0Fkr1qmuVmqaphjKK9KTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784135682; c=relaxed/simple;
	bh=rkNgM9cdEtc6HsLFMF1hAMOxPt/WPsEUMbu+lmY0H2I=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=O5cLPfKW1ElMT54JwLd2CWf3mjsRDCXgzSJ0vOFaI2bsf1lfnSq8p+On44q46axL/t4QLS9nE+DMr3yCx5yTIyyWzvL8PFhR/90+W4uIogCotKvPk83ISazYtOX1UnqVDtunoOuTvE2sCq7w9cnpzp4yoC5pEaB9+OmHtHpVJDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2QLj0B/E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2QLj0B/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F26D1F000E9;
	Wed, 15 Jul 2026 17:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784135674;
	bh=TfHHEaVjP268tDYxyafxZXD74CF9fG6Fu7sb5cedFpc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2QLj0B/EWa4lYbwGV5I4Q8S6EE2h+YoSscnlwHTueR2CgkYheQri+8JcigQG4CilI
	 gBtr1vMmIm2RnvVB9VFHABy+xQcmM99eg1Qt5ThrQfI5xX4O1/+LDp/iHJwv379AK4
	 UVN02ASUZrntaUlHn1ZMkt1GZEdVN+Y4TeFWC3h8=
Date: Wed, 15 Jul 2026 10:14:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "David Hildenbrand (Arm)"
 <david@kernel.org>, airlied@gmail.com, akhilesh@ee.iitb.ac.in,
 corbet@lwn.net, dakr@kernel.org, jgg@ziepe.ca, kees@kernel.org,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, lyude@redhat.com,
 maarten.lankhorst@linux.intel.com, mamin506@gmail.com, mhocko@suse.com,
 mripard@kernel.org, nouveau@lists.freedesktop.org, ogabbay@kernel.org,
 oleg@redhat.com, rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
 vbabka@kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 0/4] mm/hmm: Clarify notifier retry state and scope
 HMM timeouts
Message-Id: <20260715101432.99957d2d33203fafe4af2e1c@linux-foundation.org>
In-Reply-To: <ale3ydkx1xt6ruuP@skinsburskii>
References: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
	<4300f09b-8f93-4605-b072-7c09a82cb16e@kernel.org>
	<alecaJ1FUso39D9k@skinsburskii>
	<alet21wLwM6P_Km2@lucifer>
	<ale3ydkx1xt6ruuP@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 15 Jul 2026 09:39:37 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> > > The goal was to get a Sashiko review, and v8 has already been applied to
> > > both `mm-new` and `linux-next`.
> > 
> > Please don't do this, this is completely impossible to track for review :)
> > 
> > mm review is currently very difficult based on volumes, it'll become impossible
> > to manage if people sound fragments of series.
> > 
> > Please just resend the whole thing at this point.
> > 
> 
> Well, I followed the guidance provided by Andrew, and I believe he
> applied all of the changes, including these, to the `mm` tree.
> 
> Do you still want me to send v9 under these circumstances?

Sure, if that's what reviewers prefer.

This is a bit unfriendly to people who have already reviewed the code. 
Which is one of the reasons why I respond to a new version with a
single diff showing reviewers (and the author, and myself) what changed
since the previous version.

