Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792672401;
	b=pWuCM16DN+w7X1sP5dtiQUtWjTSsCaFvRgK1WB2TUvTDfN1MVYq14QSd81OCXxCQ9Oj2
	 KLdnPMgoaHD4gYnB790BeEtO41TMjfiKBPlMrOrtQlie8QPtwqDDfpytojaBZ8RBy+xjE
	 2AM1e9gk6hd1zm0kW0c21jQutdkXxBoSgzxm0DMtN83O9NoGSoIViMFaVSBmgs4vpa4dE
	 pZBJDKc+9UGCmQNk8+nJshi0ANZ6uVUorvZmTxaa/lcIpk3Z2Xtn8wrcpFGh7LDMnD1E8
	 D2qvFQfOu9so8GSpLWbvqxVOTpbWqQ190thjmeqwAqJxxKzFRXap7KTvBxFnmCrN4gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792672401;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Scanned-By;
	bh=ORzLwHM8BGYbMikpTiVo/3MerTLh128qa09MowVExQQ=;
	b=Zqyds8ye8BGjj1DZVAdkIGxcOBM5ctbqm3vSNGgV1eNv76mlvac3aUjiwtGu89JkOsmk
	 kSHz33+j21PQebEy8dD5n1tFTLeTzMeW3jqIOptAPEdeMlxxNnxSAMFGr7QzmFaDyAESV
	 7IQpHGtdrtcrHoV0TDyX7H+kC47UIg2Nqgtc4Fog6YVWajzt4G5gS6vS3DtCmR3bFcJVB
	 blIdsgFn+zkqKfSsNm33rbLS2YZJNrYSi5hcc/bfc7jiVSWNb9ZDyofLxvUDZj4lZz8Rf
	 b9bucAT9tWyV8VO7/rgBoOdizorJ5yclYI97PbaTd5U1T0fEfsOzasJMeaHKNll2AIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=EE8kwfZJ;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E95606A325
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 12:33:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61E95606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=EE8kwfZJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792672400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ORzLwHM8BGYbMikpTiVo/3MerTLh128qa09MowVExQQ=;
	b=EE8kwfZJyI/Lt5kHS1D8ovz8ZYHFen76OjNUf0pK55pdhEh8/867+xYTIJsv43RT5glBST
	ABNrvxjzyLjXIzKl0aTsZxJ1MsgL/6tcYSGVfQeFNNiEMyMjHXDYL324jrMP0Fzd6IPjx7
	AS9cn1QQusUwdlfuzV1XdNoXL3tHwTI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-344-fU_oay6oNrCdi7x5QJoKOQ-1; Thu,
 22 Oct 2026 08:33:17 -0400
X-MC-Unique: fU_oay6oNrCdi7x5QJoKOQ-1
X-Mimecast-MFC-AGG-ID: fU_oay6oNrCdi7x5QJoKOQ_1792672396
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C969718011D4;
	Thu, 22 Oct 2026 12:33:15 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 4EE071800347;
	Thu, 22 Oct 2026 12:33:13 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Thu, 22 Oct 2026 14:33:15 +0200 (CEST)
Date: Thu, 22 Oct 2026 14:33:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, kuba@kernel.org, horms@kernel.org,
	joel.granados@kernel.org
Subject: Re: [PATCH net 1/2] net/rds: do not fail init when CONFIG_SYSCTL=n
Message-ID: <atoCh3jw_1noK2Nr@redhat.com>
References: <20261021195837.142802-1-achender@kernel.org>
 <20261021195837.142802-2-achender@kernel.org>
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
In-Reply-To: <20261021195837.142802-2-achender@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 10/21, Allison Henderson wrote:
>
> Only treat the NULL return as a failure when sysctl support is actually
> compiled in.  The exit paths need no change: unregister_net_sysctl_table()
> is an empty stub with CONFIG_SYSCTL=n and already tolerates a NULL header
> otherwise.

FWIW,

Acked-by: Oleg Nesterov <oleg@redhat.com>


I'll rebase my changes which move all the sysctl related code in net/rds
under ifdef(CONFIG_SYSCTL) on top and send the patch(es) for review.

Oleg.

