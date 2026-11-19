Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795081338;
	b=FQpIpwE0PbhfKgJiN4inpRLX1VH4D40KgUZWdwDDFUZCeBD9ufxysQCJlsa4dImhCzq6
	 GPw7lxUQGRuyrK3mZSZaf5Cl30wTeh5MqNja/qiAqDp9BEmIWq0QaO46X6i2l5Bhp0Mm+
	 aOBsjSBkMUyHXCfuo5p8lMs5eWqe/EWdIQJ55gPCkXjP5q/VjpghftyMorKRO9Bi2uJLa
	 0i70ZH0Xhr8q2iPKCnojm18rGOpxUJqSuZvQ+ptdjahPzdEBvnE2QvEtV7+QqotEQZw8/
	 2w7eXJSYFDZPUlPmDx3w85JtEIbYuQBaDvH6Snuf8q6x83OBcG89gp3f4bEOoipVZ2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795081338;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Scanned-By;
	bh=9eV58bQMhX9Am98vKMtGdiSfZp+vJZsY8YTzTf6KgXQ=;
	b=TVUUwueCvQB40oBxgqTnWP7fS0YKO9LyD9/uqTl7A0A4+8RHhpNr/8vDr5kxGTXlUmK5
	 n8aQQDEiHHeA1qgJV4PdAfoEG1RaWj6yKGv1u4wMxoBDk8D3b+3rzDMP85D1m87yHMAjT
	 uX1D7y4Lw0945CUezFpA72BHvrdr8PTHM+2KVeBWuaPLyUFbA4mdcPG+R+CT36GJ4Uz4S
	 dsQ5LWLfmgSa6NXrCsbQMrspstTUSPrwiBcbwUbHbrsjBI3cu9Y2PX8dPdqhq1Qb72ajK
	 BzEWXAwSPYus+p10ni32MofKtAceBISj6xFHrxP0cqFJlhqiePPT0r0pWaFHgRg7Kng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QVlRuZ29;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60308606A32A
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 09:42:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60308606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QVlRuZ29
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795081336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9eV58bQMhX9Am98vKMtGdiSfZp+vJZsY8YTzTf6KgXQ=;
	b=QVlRuZ2953tuTU9WBqTbZeJSe3/QWp1962HFB292T6QUiqrZDmb8JdkSNxdu7jAmSp9qO0
	bbWIHY4wMAL3b9U8gH+N6QvSi7IXG2NPrCOXZJPs9v8lCM7iUyDdzMAk2UyVnE8HFCHJ8l
	C+D3t21kCP6U+DwkvuwIcVACdMpMWww=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-211-w81Rv_zLNRmhwbRjzVrpPQ-1; Thu,
 19 Nov 2026 04:42:12 -0500
X-MC-Unique: w81Rv_zLNRmhwbRjzVrpPQ-1
X-Mimecast-MFC-AGG-ID: w81Rv_zLNRmhwbRjzVrpPQ_1795081331
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0FBFB19560A2;
	Thu, 19 Nov 2026 09:42:11 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id CDC77195B3C6;
	Thu, 19 Nov 2026 09:42:08 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Thu, 19 Nov 2026 10:42:10 +0100 (CET)
Date: Thu, 19 Nov 2026 10:42:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Allison Henderson <achender@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Joel Granados <joel.granados@kernel.org>, edumazet@google.com,
	horms@kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/5] net/rds: move sysctl-only code under
 CONFIG_SYSCTL
Message-ID: <av7EbwREaye6QQnQ@redhat.com>
References: <avmymGvelu00X5EH@redhat.com>
 <20261118181936.2f6e9d7b@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118181936.2f6e9d7b@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 11/18, Jakub Kicinski wrote:
>
> On Sun, 15 Nov 2026 14:24:40 +0100 Oleg Nesterov wrote:
> > Compile tested with CONFIG_RDS CONFIG_RDS_RDMA CONFIG_RDS_TCP CONFIG_RDS_DEBUG,
> > the kernel builds with or without CONFIG_SYSCTL.
>
> Why tho?

Well, initially I proposed these changes to fix the bug with CONFIG_SYSCTL=n
but Allison found a much simpler solution, commit fbea154a86641d25

So I sent V1 on top of that fix with the following note in 0/5

	Allison, Joel, I am sending this mostly to "complete" the previous discussions.
	I won't argue if you think these cleanups do not make a lot of sense.

and you suggested to rebase on net-next/main and resend after
the merge window.

That is why ;)

> Who cares about this? How much is this series improving
> the life for those who care? Otherwise it looks like pure noise
> and a bunch of ifdefs we were happily living without until now.

OK, please forget then. Cleanups are always subjective, and I agree
that this series doesn't really "improve" the code.

Thanks!

Oleg.

