Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE5E39A4C5;
	Fri, 10 Jul 2026 22:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783721556; cv=none; b=cNOklJLd44JKtjcQmrqJux5qaVebP2PMh+6C7H0ujMjecfd+NBONo2zFm5lSsPjWk5BFLxcjuBHoQ0Qk6qSC/HT+VVaP0ViUbt/ZD6gFWiZ0WZ3FbRP1GwE/FXEQcwBYrP+PIB7QwDmYBBlo4v935SAnsgCg4ep6keeBz/JNz8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783721556; c=relaxed/simple;
	bh=X0stR2f0VGJkXuh5kC7chlv10FGoKWcObgkKeBXKM9E=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=V6oHXbSoUoosmEK0wGtmW3EYJzq9UTItP89Z3X53iGeuxa9soVCjMzYaPwknoezb6IiYogPxw5SrGWdBLAqMTGOLUAkdzrBkLsz+PCvqk6l58OxnpV7ljL21+c7RmhwM8O8d72T1naH9839cb8i+HQrVfRNdmZsQ545pBjTe8OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AeTioDYW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AeTioDYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A1C1F0155D;
	Fri, 10 Jul 2026 22:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783721555;
	bh=h9zolevYOr3IrqkJ/ylvovmm1VXhDuPtRxmyw6CyQR4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AeTioDYWrCLtodpdLKC5SAj9nqcYsbMSqw9BPHz7Xp2PX5apYbRRe+siKb7EjWd0t
	 QIIb4EtviMqnln6uNXpWNIHF/AvpVC7rQIw6R6ljeF9y12krwGSjA/IkoF5qty/C3W
	 mx6Rw+J0PVzeRUM3qJZMk8JGx3kO2l6ngA985HRY=
Date: Fri, 10 Jul 2026 15:12:33 -0700
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
Subject: Re: [PATCH v8 8/8] drm/gpusvm: Use
 hmm_range_fault_unlocked_timeout() for range faults
Message-Id: <20260710151233.4ac5ca774cae46dc725de505@linux-foundation.org>
In-Reply-To: <178371883977.900500.2198446134676328631.stgit@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
	<178371883977.900500.2198446134676328631.stgit@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 Jul 2026 14:27:19 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> +	err = hmm_range_fault_unlocked_timeout(&hmm_range,
> +					       max(timeout - jiffies, 1L));

1UL again?
