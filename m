Received: from outbound.baidu.com (mx15.baidu.com [111.202.115.100])
	by smtp.subspace.kernel.org (Postfix) with SMTP id CDBC2314D1A;
	Wed, 12 Aug 2026 12:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.115.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786537994; cv=none; b=has5GoVyodJomJv4CSk7MBy6bzqL7U5tS3LCsas1BahnT12JULj+UL6xjU/3ZqlpqXD+fvziUpA/O208aPZ3TecJ2oTLWNRg0K1+pCsW0RC/tLBO7gPdLyk06oFiWNk0ORDQAVxIuZoX6uTVVB/HrYosp8Xf3ElxZiiPIveSdsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786537994; c=relaxed/simple;
	bh=mUFGC4SozKM0kpLky3qUkKZTOMsZkINTmWeB3XyWDWA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q7NRfXlmV2lmzONnRbUWdx6Ye8DfU2pHM3doyPQ5DZiRPWVV5VnIuTIfwBolQvWN23z4VNUZygfc+wMiKDyTkfk1MdR1minihVOO7Zo/WzMzjmhqJX2jGohNy/Wfj65ImmgJlLdxJ/iosx3bdhyxc+t5uqxo6orRq/ESbujQwv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=TQ5ns/sQ; arc=none smtp.client-ip=111.202.115.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="TQ5ns/sQ"
X-MD-Sfrom: zhangyili01@baidu.com
X-MD-SrcIP: 172.31.51.15
From: Yili Zhang <zhangyili01@baidu.com>
To: <jgg@ziepe.ca>
CC: <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <zhangyili01@baidu.com>
Subject: Re: [PATCH 2/2] RDMA/nldev: Guard against NULL ucontext in resource dumps
Date: Wed, 12 Aug 2026 20:32:49 +0800
Message-ID: <20260812123249.44247-1-zhangyili01@baidu.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260811141909.GF544626@ziepe.ca>
References: <20260811141909.GF544626@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc13.internal.baidu.com (172.31.4.11) To
 BJKJY-Exc19.internal.baidu.com (172.31.51.15)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1786537979;
	bh=sXUkQKflkXUhyuxAt6Tp0Gxume4qGEv/stJVyVWoR1I=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=TQ5ns/sQad76oR0vxVdS73u7MByXjRJ5FRSgGZd8nYvRV5m0zEbu14/F/QqrQsEjy
	 kyHPo+qBODwtwx4hjwuSkGp1o1S2KrZhQHsXLQStH/FiJz+OxDCGDtNqaC+WV756IA
	 PNNGAaBK9f9g/s3o+gm0uR5S2oAMA42R6sMfi8mD4Jt6FqZk89kE6Vq0xsQEIllFxS
	 Y86bGzaljWO1dw8Z3xKWuG0Sv1IAjKSKSKWFCRM9P/fbLooqzNZ9lWtZqsqOi8r6JX
	 PS0MIuuTkznkrl/OHM5epQoVXQp+uVSIcQvwMmqdEZbZ9e/3n4hFc5cPu+OKBqXntb
	 Jqg7h6p0J3Eug==

Hi Jason,

Thanks for the review.  After re-reading your feedback and re-examining
the crash log, I think I mis-characterized the root cause in my original
patches.  Let me lay out what the log actually shows, because I'd like
to get the fix on the right track.

The crash is a three-stage sequence, all from the same host
(6.1.52 + MLNX_OFED 24.10):

  Stage 1 - a create_qp failure:
    [24805924.400] mlx5_3: create_qp:3323:(pid 2758615): Create QP type 2 failed

  Stage 2 - on process exit, ib_uverbs_close() could not tear down the
  process's CQs and fell into the DRIVER_FAILURE fallback:
    [24805924.747] WARNING: ... rdma_core.c:945 uverbs_destroy_ufile_hw
      Call Trace:
        uverbs_destroy_ufile_hw
        ib_uverbs_close
        __fput

  Stage 3 - 23s later, an unrelated `rdma res show cq` tripped over the
  leaked CQ:
    [24805947.514] BUG: kernel NULL pointer dereference, address: 0x58
      RIP: fill_res_cq_entry+0x15e/0x180
      Call Trace: res_get_common_dumpit ... netlink_dump

So the dereference is not a disassociation-time race: teardown ran to
completion (the WARNING fired, uobj->context was cleared to NULL by the
DRIVER_FAILURE fallback in uverbs_destroy_uobject()), and only 23s later
did the dump read it.  The leaked CQ sits in restrack with
context == NULL as a committed state, not a transient window.

To be concrete about why it persists: under the current code, once the
DRIVER_FAILURE fallback runs, the leaked object's restrack entry is
never actively removed.  The CQ case:

  - First pass (RDMA_REMOVE_CLOSE): uverbs_destroy_uobject() enters the
    destroy_hw branch because uobj->object is non-NULL; destroy_hw_idr
    calls ib_destroy_cq_user(), whose driver destroy_cq fails and
    returns before rdma_restrack_del(&cq->res).  Entry stays.

  - Second pass (RDMA_REMOVE_DRIVER_FAILURE): __uverbs_cleanup_ufile()
    pre-sets obj->object = NULL before calling uverbs_destroy_uobject(),
    so the "else if (uobj->object)" branch is skipped entirely -
    destroy_hw, and thus ib_destroy_cq_user() / rdma_restrack_del(), is
    never reached.  uobj->context is then cleared to NULL, and the
    object is removed only from ufile->idr (remove_handle is not called
    either, as reason != DESTROY), not from the restrack xarray.

So the restrack entry is removed only by rdma_restrack_clean() ->
xa_destroy() at ib_dealloc_device() time.  For the entire lifetime of
the device after a failed fd-close teardown, the leaked CQ sits in the
restrack xarray with context == NULL.  That is exactly the window the
crash log shows: 23s between the close-time WARNING and the dump oops,
same device still registered.

On your two points:

  Patch 1 (move rdma_restrack_del before destroy): you're right that
  this breaks the legitimate case where destroy is allowed to fail -
  withdrawing the object from restrack while it still exists is wrong.
  I'll drop it.

  Patch 2 (NULL guard): you're right that it's missing locking against
  a concurrent disassociation teardown.  But the crash above is not
  that race; it's a fd-close path where context is already NULL.  A
  NULL check would stop this particular oops, but I understand that's
  not the synchronization you're asking for.

Which leaves me unsure where the dump-side fix should live.  Two
questions:

  1. For the disassociation race you pointed at, I can hold a
     disassociate srcu around fill_func() in res_get_common_doit/
     dumpit (it would have to live on struct ib_device, since nldev in
     ib_core cannot reach ib_uverbs_device).  Does that match what you
     had in mind?  This closes the concurrent-UAF case but does not
     touch the fd-close NULL case above.

  2. For the fd-close path - where a driver destroy fails and the
     DRIVER_FAILURE fallback leaves a leaked restrack entry with a
     NULL context - is the correct fix entirely on the driver side
     (destroy must not fail on transient HW error; wait for FLR),
     as you said on patch 1?  I.e. should the core/nldev side not
     defend against this at all, or is a NULL-skip in the dump still
     wanted as a defense-in-depth?  A driver that never fails destroy
     would prevent the leak from happening in the first place, but
     would not help with objects already leaked before such a fix is
     deployed, or with any other future path that leaves a restrack
     entry behind with a cleared context.                                     

Thanks,
Yili
