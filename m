Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469892FF164
	for <linux-rdma@vger.kernel.org>; Thu,  9 Jul 2026 03:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783568056; cv=none; b=iJnrCl21RwMaeZEegQEwPM72nInu9Hlo1F8KH1xVQQc8pTMifJvJMwaPbwF65A6pDNKZcClkLUyRcAGPxT/llWBWvDMMfMYWojGTqgsoaZv3vZJO3WrZhT/r1OeNLAPa5Ai+bOCgTd+tJSRnfKH0X+V9sC1JB19rqctnOlLU5oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783568056; c=relaxed/simple;
	bh=c/9C65L/Y62CiS+tgFE+PSGs8N9QvDdN2iAtGSfSx18=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gAFPXlysAcEmXBXg2mcwtUaaVzAW49iFndpdqIG4VUa2SXyaN3O+I+DMpL2xNPBMSrFLiZYI6i0P0fKdE5eMOZVzmm4df/MbGvPbglbEoljbyNN6XgyGWL756rEH5v3yNGYBaNN9QZcPtXQbaOL8uNfPE3/XzmZVg4YzcDweAps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FUyyfySo; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FUyyfySo"
Message-ID: <fdac9d3e-62ef-4009-aa55-19e4625a5ced@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783568051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZI9NFGuV2KTyn9QZOEN5iVcrDtZRSWDLYCTh0pv99Ys=;
	b=FUyyfySotZV13aex28zcpx3gtY2W4xgJ61v/o/lRbDT44Lo+CPAGcoUcm2Aw+8oByymax6
	7suf7HGVjfUGqE2xlxJKzEQHvdo4nbnq7E6YxMVYiCfEGbOzFv8i652EAgJbLJ25MPyOXr
	5DUh0o03Y0leqZfKHgAw2ISVZxGHGdU=
Date: Wed, 8 Jul 2026 20:33:53 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3] RDMA/rxe: rework per-net tunnel socket lifetime to fix
 refcount underflow
To: Serhat Kumral <serhatkumral1@gmail.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: dsahern@kernel.org, jgg@ziepe.ca, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 syzbot+8c9eede336e3a843750e@syzkaller.appspotmail.com, zyjzyj2000@gmail.com
References: <6ced0145-30ab-4af5-9005-9da024933fff@linux.dev>
 <20260708181007.24280-1-serhatkumral1@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260708181007.24280-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 2026/7/8 11:10, Serhat Kumral 写道:
> Hi Yanjun,
>
>> However, after the network namespace teardown, the associated netdevice
>> is still unregistered, which
>> triggers the NETDEV_UNREGISTER notifier. In rxe_notify(), this event
>> eventually calls rxe_net_del() to
>> remove the RDMA link.
> Isn't the ordering the other way around? The netdevices of a dying
> netns are unregistered by default_device_exit_batch(), a pernet
> device op, while rxe_net_ops is a pernet subsys, and subsys exits
> run after all device exits. So NETDEV_UNREGISTER (and the notifier's
> rxe_net_del()) should have already completed before rxe_ns_exit()
> destroys the mutex.
>
> Am I missing a path where rxe_net_del() can run after rxe_ns_exit()?

Hi,

Thanks for the clarification. Your analysis is spot on.

The assumption that pernet device exit (default_device_exit_batch)
always guarantees a synchronous NETDEV_UNREGISTER notification for all
netdevices prior to pernet subsys exit (rxe_ns_exit) is indeed flawed.

There are two critical blind spots in this flow:

Netns Migration (The init_net fallback): During netns teardown, certain 
stateful or persistent devices like loopback
(lo) or stacked virtual interfaces are moved back to init_net via
dev_change_net_namespace() rather than being fully unregistered. This
triggers NETDEV_DOWN or namespace change events instead of a standard
NETDEV_UNREGISTER. Consequently, rxe_net_del() is skipped, leaving
stale RXE resources bound to the dying netns.

Module Unload Race (Parallel Cleanup): When rmmod rdma_rxe invokes 
unregister_pernet_subsys(), rxe_ns_exit()
runs concurrently across multiple netns. If a concurrent thread or a
deferred RCU/workqueue task (e.g., net_todo_list) is simultaneously
processing an asynchronous netdevice unregistration, rxe_net_del() and
rxe_ns_exit() will race on different CPUs.

In both corner cases, rxe_ns_exit() can proceed to tear down the pernet
infrastructure and destroy the mutex lock while a lingering
or concurrent rxe_net_del() invocation still attempts to acquire it.
This inevitably triggers a Use-After-Free (UAF) on the mutex.

To fix this properly, we must ensure that:

rxe_ns_exit() explicitly flushes and tears down any remaining RXE
devices under the lock before the mutex is destroyed.

We handle netns migration events properly in the netdev notifier to
trigger early cleanup.

Could you please a new patch to include this explicit ordering in
rxe_ns_exit()?

Thanks a lot.

Zhu Yanjun

>
> Thanks,
> Serhat

-- 
Best Regards,
Yanjun.Zhu

