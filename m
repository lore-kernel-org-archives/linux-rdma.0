Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4162B4C9E04;
	Fri,  9 Oct 2026 11:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791544818; cv=none; b=F8e0iYaZ4uVW7beR99eQQcgxMttbESHlApMXMaJplZbLTy+zOTxfruQqyy4yolwa8aufaBHc4DpQAzWnzYKziN4lfRBczfyXkyw0VAFUUerJ5f8orONQlyzSeW+obrWADIq+MlxK9kC6B7I7rfiO8YL9zT7yhJtCbmT0LzXQijc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791544818; c=relaxed/simple;
	bh=gcTZyf14ssLkKwrYPJXbLcDPts9T9IBgYPP1i6hobs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TWd2OBIJs+dsLyC+MAE5Tsdp4Wwl1ZrkyK/2EQbKKlXAsLg4HCL70dh94An/RHiDwubrARLyWXTchZUxjRC2I2fAoZCSw3AkMcImQfzBAyCwhDd9fnewBWkAIalToJWlBRkkzhomZMgikbvqqGIK38G8WcFJ7GMAvL7oSNB9IS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=UmhfHzj1; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="UmhfHzj1"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6D39F20B716A;
	Fri,  9 Oct 2026 04:20:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6D39F20B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791544809;
	bh=gcTZyf14ssLkKwrYPJXbLcDPts9T9IBgYPP1i6hobs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmhfHzj1q0rtxohBwkVEyXKnx7o/9Orjzyp7iPQSeYZnJsXYJs20VXQsmd/Prcd+T
	 RpUJU/OHQae1rPi070YXfBWkfA0kEDiQlB6pTYiUmDEYum6A/6Q4/1TsTwZq6rWw20
	 tWQBpISKd8itgIDE/AOyzIomtFo3KtBk2QA5PiiY=
From: Wei Hu <weh@linux.microsoft.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-hyperv@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	weh@microsoft.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v6 1/4] net: mana: prepare HWC ownership for safe reinitialization
Date: Fri,  9 Oct 2026 11:20:06 +0000
Message-ID: <20261009112006.591265-1-weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-164177@kernel.org>
References: <cover.1790665894.git.weh@linux.microsoft.com> <901e5237127da4fbd8e14ff07fa32dec8a20fd84.1790670523.git.weh@linux.microsoft.com> <sashiko-outbox-164177@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, Oct 08, 2026 at 12:54:01PM +0000, sashiko-bot@kernel.org wrote:
> Can this dereference of cq race with mana_gd_destroy_queue() and cause a
> use-after-free?

Thanks for the review. I agree that the Ethernet CQ lifetime gap described
here needs to be fixed. However, it is already present on the base of this
series, c66d93e68728, rather than introduced by this patch.

On that base, mana_gd_destroy_cq() clears the CQ table entry without waiting
for existing readers, and mana_gd_destroy_queue() subsequently frees the
queue. Both functions and the Ethernet CQ-before-EQ teardown order are
unchanged by this series. The original completion handler also obtained
the CQ pointer and dereferenced it without a corresponding reclamation
grace period.

The reader changes here serve a different purpose: the acquire-load of
gc->cq_table pairs with HWC's release-publication of the initialized table
and its bound, while the NULL checks handle an unpublished table or entry.
They do not provide lifetime protection for an Ethernet CQ that another
CPU has already obtained from the table.

For HWC specifically, this patch destroys its dedicated EQ before freeing
the CQ and callback state. EQ deregistration removes the EQ from the IRQ
dispatch list and calls synchronize_rcu(), draining the existing IRQ-side
readers before the HWC CQ is released. This does not protect the separate
Ethernet CQ teardown path described in the report.

The reported CQ-destruction path is fixed in an independent MANA queue-set
replacement series that I plan to post shortly. That change unpublishes
the exact CQ pointer and waits for existing IRQ-side RCU readers before
the CQ is freed. It adds teardown-side synchronization without adding
per-completion reference counting.

I am keeping that pre-existing-bug fix in the independent series rather
than expanding the scope of this HWC concurrency and queue-depth series.

Thanks,
Wei
