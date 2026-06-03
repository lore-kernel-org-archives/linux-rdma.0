Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868E43A875E;
	Wed,  3 Jun 2026 15:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780498992; cv=none; b=ejK2LZOfUGtdYyV1Qmd/4x8MHF1dkCh+LcVHhfAaMFfDr23oOaSCXKnN3+sJAvtQ0pb0TznbDaQZFR7zZTaMI/YGK8YalxgmdEQBPAsceaWwljtjQusq9Swja6obzH9HK5mXFuwMO/wcRw2RuHad041YZxALEBzXPDotWkMP9Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780498992; c=relaxed/simple;
	bh=fVStYaPDFPkaF/zE2ALMb76pTMOs+EcNbjFty3BTAmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DEOw03npKiPBWNBhUvaKSCyAYHMJWuY/cNSWisXEdd1PPp0TaoYi7GnBqJD5cMKj+pO4mpvAxryoyAaf2X3QsNrJyW9f5mDP3wED6gBmz2mh89QLTI2GdznMtJrwIUsmCgIoZ0fi3g82uBroh9Lh0TkKF6azu1sk5PUW7fzDh+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=leHXl3MO; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="leHXl3MO"
Received: from localhost (unknown [10.10.165.2])
	by mail.ispras.ru (Postfix) with ESMTPSA id 851D045F7992;
	Wed,  3 Jun 2026 15:03:00 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 851D045F7992
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1780498980;
	bh=QchPKXbbQw3rf90KpShXn9iijaSWPXuapINO6GIxiqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=leHXl3MOb3uUUUoy5H79bC1XYrP/PqNU/WACFpwRiwOtwdW7M87ykElOGofbg9TQp
	 EzfY+nwHOa75wCIbrlLVwJ80bqlHNU9X/Z/bQKLMblSZxI4KmQvex+NulcFsZTFy/L
	 kwEfUFZEFASV0Fdekha8swt5TvHQ0OHfndsczo5A=
Date: Wed, 3 Jun 2026 18:03:00 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Vladislav Nikolaev <vlad102nikolaev@gmail.com>
Cc: stable@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Haggai Eran <haggaie@mellanox.com>, lvc-project@linuxtesting.org, 
	Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, Zhu Yanjun <yanjun.zhu@linux.dev>, 
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
	Doug Ledford <dledford@redhat.com>, Zhu Yanjun <zyjzyj2000@gmail.com>, 
	syzbot+cfcc1a3c85be15a40cba@syzkaller.appspotmail.com
Subject: Re: [lvc-project] [PATCH v2 5.10/5.15] RDMA/rxe: Fix the error
 "trying to register non-static key in rxe_cleanup_task"
Message-ID: <20260603174551-bf141bed5d94d0d92337aae2-pchelkin@ispras>
References: <20260603121902.274-1-vlad102nikolaev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260603121902.274-1-vlad102nikolaev@gmail.com>

On Wed, 03. Jun 15:18, Vladislav Nikolaev wrote:
> From: Zhu Yanjun <yanjun.zhu@linux.dev>
> 
> commit b2b1ddc457458fecd1c6f385baa9fbda5f0c63ad upstream.
> 
> In the function rxe_create_qp(), rxe_qp_from_init() is called to
> initialize qp, internally things like rxe_init_task are not setup until
> rxe_qp_init_req().
> 
> If an error occurred before this point then the unwind will call
> rxe_cleanup() and eventually to rxe_qp_do_cleanup()/rxe_cleanup_task()
> which will oops when trying to access the uninitialized spinlock.
> 
> If rxe_init_task is not executed, rxe_cleanup_task will not be called.
> 
> Reported-by: syzbot+cfcc1a3c85be15a40cba@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?id=fd85757b74b3eb59f904138486f755f71e090df8
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Fixes: 2d4b21e0a291 ("IB/rxe: Prevent from completer to operate on non valid QP")
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> Link: https://lore.kernel.org/r/20230413101115.1366068-1-yanjun.zhu@intel.com
> Signed-off-by: Leon Romanovsky <leon@kernel.org>
> [ Vladislav: match upstream cleanup order and add the missing
> resp.task.func check. ]
> Signed-off-by: Vladislav Nikolaev <vlad102nikolaev@gmail.com>
> ---

Thanks for the update.

> v2: Move rxe_cleanup_task(&qp->resp.task) after RC timer cleanup.
> Add missing qp->resp.task.func check before cleaning up the responder task.

I did actually suggest only adding a corresponding check for the
rxe_cleanup_task(&qp->resp.task) call which the upstream commit performs.
Moving it a couple of lines around requires some explanation why it's
okay in 5.10/5.15 kernels.  Note that in upstream it was done by another
commit 960ebe97e523 ("RDMA/rxe: Remove __rxe_do_task()").

[ yeah, it should be safe to move the call but it'd better be stated
  explicitly in the backporter's comment ]

Worth saying that checkpatch.pl for the current patch gives:

ERROR: trailing whitespace
#52: FILE: drivers/infiniband/sw/rxe/rxe_qp.c:771:
+^I$

You might also want to consider porting 1c7eec4d5f3b ("RDMA/rxe: Fix
"trying to register non-static key in rxe_qp_do_cleanup" bug") which fixes
the similar problem for del_timer_sync / timer_delete_sync calls in this
code.  This all could go as a series now probably.

