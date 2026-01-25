Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316AD31A7E1
	for <linux-rdma@vger.kernel.org>; Sun, 25 Jan 2026 16:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769357255; cv=none; b=gmHo/Tm2STSndZgZDQJrxnt2k4t0mjPLXETXK5JQEf2jFCqwd6btmGawc2IdAcwmYzkEDPeakLe8XHYgxaSTLiu1yNocqwa6mVQXwTS2SFat1uB82NByI0s5r6PJsQhFNiDdrTDpuFaoRigd5gPsCrLRpN68PponilHR7p9oKNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769357255; c=relaxed/simple;
	bh=ygLKWd6lxdZdqlsr5rDJFC+BbK0FTEd19vN6oRrtlsg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Me7mrJ93C9z4OYcE/xDIgkZ5R9OL+VL+FCSQvdU63Gq04kb6FKWBirvuC5rqSLmLiSZMfHCMTBwhGo85QnGQJUdFigTZzUE2LPM90sIMvk2om5z797jzo8BLaQ83fzloFXezF0WeAfLKaJ0+VKpLAaWOHtDqcjwMttfBa6jiOD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AehH9jMD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AehH9jMD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769357253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=UzFafadD/xFA5DaIbLPJfWcnaK2KSCnXdhRnlT6y1nw=;
	b=AehH9jMDvitEZuFIDpQNwHMHs9rsLfSQnXelWqg7d5Egj4kIWjogmvC8g6oUj1GHWh7+dv
	GIhnHyWb/0DF0ybaplqfD715EHXwR+s9Z2gpBrgq8xOivelJixlqAywr+EkBMu7xrTMuSi
	Zo4mDxwmixhqVePaWOb3pxGrywyhKDU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-544-3eIJo3prPQijK62EceRZWA-1; Sun,
 25 Jan 2026 11:07:30 -0500
X-MC-Unique: 3eIJo3prPQijK62EceRZWA-1
X-Mimecast-MFC-AGG-ID: 3eIJo3prPQijK62EceRZWA_1769357247
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFB261800342;
	Sun, 25 Jan 2026 16:07:27 +0000 (UTC)
Received: from fedora (unknown [10.45.224.8])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 0EC9930001A7;
	Sun, 25 Jan 2026 16:07:21 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun, 25 Jan 2026 17:07:27 +0100 (CET)
Date: Sun, 25 Jan 2026 17:07:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Leon Romanovsky <leon@kernel.org>,
	Steven Price <steven.price@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 2/7] android/binder: use same_thread_group(proc->tsk,
 current) in binder_mmap()
Message-ID: <aXY_uPYyUg4rwNOg@redhat.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXY_h8i78n6yD9JY@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

With or without this change the checked condition can be falsely true
if proc->tsk execs, but this is fine: binder_alloc_mmap_handler() checks
vma->vm_mm == alloc->mm.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
---
 drivers/android/binder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index dea701daabb0..b3b73303f84d 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -6015,7 +6015,7 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct binder_proc *proc = filp->private_data;
 
-	if (proc->tsk != current->group_leader)
+	if (!same_thread_group(proc->tsk, current))
 		return -EINVAL;
 
 	binder_debug(BINDER_DEBUG_OPEN_CLOSE,
-- 
2.52.0

