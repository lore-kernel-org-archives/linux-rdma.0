Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5DC2E8B9B;
	Mon, 13 Jul 2026 23:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783984703; cv=none; b=Q1MYIjvrN3UTSMUwMJbDK/dqzvMSzIwGDDJOJfdsxGIqp+/YegwqyTkH4nD4tjmFnBEcyUYBBkC3f92wPcIu4hTXqocqMsQCwDWVXN3OCrl2kB1Lzw3k10ynWv84/+P4iojYfUKf8pdSXxkyyDNjg+evtlieWhPpDJnwu964tIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783984703; c=relaxed/simple;
	bh=zAhTcmGet1zbfalwg6YD+G8NVjqXlIHXtbfcMxYpDwc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=SbDGOj+lNU+P/gdcPgXgrMcLSB9Jt8/P97b5EuSj4yuc3Du/Y+z8t8SUIKCwj8m7pdva2VrDvP5rZXRO8okSIF7QFupvIFfUJZ9RYSWD+tyQ4uUUY3G5esWFE6f6X+2nf/ESX/Uds+pCd+ANDza4gIia2p36dVR8d8v+k2Us8X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nZler/ys; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nZler/ys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E807B1F000E9;
	Mon, 13 Jul 2026 23:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783984702;
	bh=f5EDysaFuDNgPurWzUMZsX1j7CfSV1oHh5QC4rjPyqo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nZler/ysO6IBo934carYd2XqUDIMaFaeiUMVtZhtTP9n+0D4DjPtZs2k+yOsT1Fx5
	 TLAeqjC/pvL6zMH2/jytpd4FVcVHGbYHPanj59p1Zh69G+c1G/sD/6MLodFGtLct3E
	 XADqVu2KrZngtk7/bOTMrI43ujnTM80o4BDpBedk=
Date: Mon, 13 Jul 2026 16:18:20 -0700
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
Message-Id: <20260713161820.8f72577b91c730a2e853f6a5@linux-foundation.org>
In-Reply-To: <alUZZYIPY-UkhpY4@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
	<178371881847.900500.8789369230260725500.stgit@skinsburskii>
	<20260710151222.ddb35eab9c81a8720491464a@linux-foundation.org>
	<alG1k3JsoywE2CBM@skinsburskii>
	<20260710224833.9caf2a0a9906f0515e326a45@linux-foundation.org>
	<alUZZYIPY-UkhpY4@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, 13 Jul 2026 09:59:17 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> > > I'm not sure... The "timeout - jiffies" can become negative.
> > > Won't 1UL convert both of them to "UL" and thus make the comparison
> > > overflow?
> > 
> > `timeout' and `jiffies' are both unsigned long.
> 
> Yeah, I’m sorry for the sloppy wording.
> 
> What I meant was: will "max(timeout - jiffies, 1UL)" correctly handle
> the case where jiffies < timeout?

That will return `timeout - jiffies': a smallish positive number.

I'm not sure what's intended here.  Perhaps the code should be
using time_after() or similar?
