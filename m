Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792470655;
	b=LbzX9l4eJDorRXv8I8T/DIL+hLG25fqEAt/ipKt98BVSEHLh1yAPpR+2M5z2VHjq8SYm
	 QAqlnG+neXKMeKPYtOjeEXZgWK3clWy9mIK+a7EDYvpoyDdK2OqJxcMSiI5qT5kxwJh0T
	 GjiW0NyQ03DLWGmj3DfFUekAZr1Sio9VZkpipMJl9YyJKE0VjwEoaMWNPctCZxcp5UhFW
	 JCYXAdSOKcxgUNNldyuy8QYT9L3R5eGDzldAYxeyZPEpwkwBpeBlJ2UkKgu7lHAvjmXvG
	 LGMC3+wl0WGsC7kMeRddUDgAcZ9HwyhJNWZdobvzkbx9JwD26mC3nig4TlqIHodFYJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792470655;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=evJDRcYvjGByMN0JJryLMQYDG6jXpQjI7EC08Okq49w=;
	b=NDaaekWH4HfUuhRt6wRtpwho1ajgvOI3lg30a9RiyTG3pgeFJCrSylMB20hdCwpgjunD
	 z09bDykC+k3iNO8VrVluHyMP8nt/zhnA/8ic7JrQkTq+OYTFowtvqhbiFLP2l1WRANjOk
	 /ayQ2wtkI+xl22FR0hXvjQ1bPyHpBXF4y+xQeut1o7eEao3PBRM1nhxAhOCOkKtmihYeJ
	 yxDQE6tA9Af+2gVOYX4Bfx1k3t3k2cvQq2jFoNpiVghwWpndi3a/m2yHNbFYqoE98zNv8
	 2BfRUQ6NzcNrjm9Lc+fc/LO8G2cLyrKz1NCspClwKW+q+PTBz7jmDguYtsVtm61ZpQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=A08xQoTB;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AE4B606A336;
	Tue, 20 Oct 2026 04:30:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0AE4B606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=A08xQoTB
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 8859E20B716C;
	Mon, 19 Oct 2026 21:30:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8859E20B716C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792470647;
	bh=evJDRcYvjGByMN0JJryLMQYDG6jXpQjI7EC08Okq49w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A08xQoTBJFq7cC3uV60u/3C9wwIBY6UZVn+LNe0QfSxTYzlDvAUsDDMThUh+Uv+ar
	 qIdoY2f+fDcLXSBteW/+zwFWPbQJwatyE7cPfziexiy0gQ7xA2hIwCs9/QFW1m2gso
	 NkJUBwpvx+h7ZBj6E/DE0m+VaWlpuRBeW00vkNmw=
From: Wei Hu <weh@linux.microsoft.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	weh@microsoft.com,
	kuba@kernel.org
Subject: Re: [PATCH net-next v7 11/13] net: mana: keep a user-configured RSS table across a queue rebuild
Date: Tue, 20 Oct 2026 04:30:43 +0000
Message-ID: <qset-v7-sashiko-11-v8-plan.20261018.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-175611@kernel.org>
References: <cover.1791710735.git.weh@linux.microsoft.com> <e3a74aa4b30eb004c9a9f16168b734c563f27a15.1791710735.git.weh@linux.microsoft.com> <sashiko-outbox-175611@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

> Does this silent reset desynchronize the driver from the ethtool core?

I will leave the ordinary allocation path unchanged in v8. The stale
user-indirection metadata is a real gap, but both upstream bases already
reinitialize the RSS table in mana_alloc_queues() without clearing the
ethtool core's user-table state. It is not introduced by this series.

A hardware queue-limit reduction during reattach can make a saved user
table invalid. Rebuilding a default table without reporting the loss can
then leave the core describing a user configuration that no longer
exists. I am treating this as an independent baseline issue, not claiming
that documenting the silent reset makes it correct.

The specific later-growth scenario also needs qualification because the
inspected reattach path monotonically clamps apc->max_queues. The stale
metadata and missing loss notification are the more direct issues.

> Can we safely call ethtool_rxfh_indir_lost() here to keep the states
> synchronized?

Not solely on the basis of its initial RTNL assertion. The notification
call chain also reaches netdev_assert_locked_ops_compat(). MANA registers
net_shaper_ops, so that check requires the netdev operations lock. The
reset worker holds RTNL but not that lock.

A separate correction needs to account for the notification context and
locking of every ordinary allocation caller; an unconditional helper
call at this location is not sufficient. That broader baseline fix is
outside this queue-set revision.

Thanks,
Wei
