Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792470649;
	b=ecDM6WE4He8N3D8NK7Zsd6tOqOA2gQILPSJaCtWwQhggKPYrwYgkYmFrhGt6n7F+8hRa
	 EJOzEg5pW1U7kiite0J1O+k+TPHBvMQhnGNdfApA3XXL2YmT4d6NXofF0L7m9TI/39oK0
	 xsLdBQs5bYixcDgfT08lCqIDnAwPj3uyTR61t3a+spkSGpKPVP/KOLlIUZqzJGgb444zD
	 sCmkri0CyUhvLZBNMz9vj3ejRv5ZW7HFSS8apf5rlH9Dm2azfzic0izmUIBI5ReqIt07G
	 x1iROypn9ou4lBJeEsRIbooT2CXGbVWAb606F2DssMuAkNhwFhPr5g6eksHU6BDRomQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792470649;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=Zk31WB9hWO6u3WrXVB/NaCBT17Dt1bBOz+6YIxm/s7Q=;
	b=qNM0hmaUH3eDwlsdan77BVH/kZ+lgwrZmOyM9/sWrAlSict9Dlx90CxCI69Q8mm/BlCD
	 mH0HYs41t0niJKwwpC4/we3C7YrosQm5lljidNft/E/st7vNg37Z+/jauSOCJmn/5kZHL
	 JKvv7L6TQKScL0wy2ofz2t0bax2en/g/wzkbyUODlNsLXTadCCmhaxybTt8kycuN9V872
	 hWYP5kPzRcp2JVF2Wg00KVlVQhJ92b30pY8Uzo+nGSBUI98QY/gQ2fvizqUaA3rFIqHqU
	 LNmKqRXw4lwiBudNgnv1xxMUYT/a+/9mVE2gj3T0MHvgYDe+IvGkVSptpN8Lh9Ozb8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=IgKhvKyx;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81502606A322;
	Tue, 20 Oct 2026 04:30:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81502606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=IgKhvKyx
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id DA91320B716C;
	Mon, 19 Oct 2026 21:30:41 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DA91320B716C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792470642;
	bh=Zk31WB9hWO6u3WrXVB/NaCBT17Dt1bBOz+6YIxm/s7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IgKhvKyxc5KLCUSw7mgVUncddKva54C4YGP7Dn6+XzJycpo2iJCJDezXQruS5pb15
	 7Y5DFZTbecNVQpUjn5KTn6OczPjo1nIVbWaKkV7CBfg6GxktMZY0CS0codeVcDLiJW
	 +wqX2jPNAJf9DMcZEsYRUCNKhZV5xkWZtUhnf5MU=
From: Wei Hu <weh@linux.microsoft.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	weh@microsoft.com,
	kuba@kernel.org
Subject: Re: [PATCH net-next v7 03/13] net: mana: keep per-queue statistics in the port context
Date: Tue, 20 Oct 2026 04:30:39 +0000
Message-ID: <qset-v7-sashiko-03-v8-plan.20261018.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-175603@kernel.org>
References: <cover.1791710735.git.weh@linux.microsoft.com> <b27034466c0db8228409db5473e747db7c3177c5.1791710735.git.weh@linux.microsoft.com> <sashiko-outbox-175603@kernel.org>
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

> In mana_remove(), unregister_netdevice() unlists the device but does not
> synchronously wait for existing RCU grace periods to finish.

I will leave this ordering unchanged in v8. The premise does not match
the unregister path in the target tree.

unregister_netdevice() uses the NULL-head path, which performs unregister
work immediately. Before returning, that path unlists the device and
calls synchronize_net(), removes its sysfs exposure, and performs another
network grace period. mana_free_queue_stats() runs after that call.

Some final netdev processing is deferred to netdev_run_todo(), but the
grace periods relevant to the identified proc/sysfs readers are not all
deferred until rtnl_unlock(). The same ordering is present in the v6
counterpart and both upstream bases. The reported reader/free interleaving
therefore does not establish a UAF requiring a statistics-lifetime change.

Thanks,
Wei
