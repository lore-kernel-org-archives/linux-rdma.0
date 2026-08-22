Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A90838AC78
	for <linux-rdma@vger.kernel.org>; Sat, 22 Aug 2026 08:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=183.62.165.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787386364; cv=none; b=My7MxFEXqOZwlp7KkU2bygQ9TUQeYXW9ETEyfvfrsMoGxxig1H27d7WXYg/UZ+6ctfDfjrkOJ+BbB1M4DeXkHqVjjbosDajXerN7qq44wVClDbikOHTLwj30ORY7abw7DEaUIhlcdc1sY1qvchN/uNp+37Z2Hr/AB2Rq4gZbA7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787386364; c=relaxed/simple;
	bh=TsOW7YinxpIpHG6HELDTGJzLZerxcbcpjk47P9nhP9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5VOgqoMxRyi39xveaI9f83CyydF/8rgEFiXs2LEVxXlu0zwHrUb899p51sUPHyWUgxiA7E1OE4gLKVFXUfdrNBTzon+uwGp6ylQBYKN7BTxLewjoDTs/eQIiszuvDqVMTmC9DDGojhl2OATY+5G0jAjpuQnj5yqB0nRYO6MwAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=183.62.165.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4hRqfX4wp1z52Rpb;
	Sat, 22 Aug 2026 16:12:36 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
	by mse-fl1.zte.com.cn with SMTP id 67M8CRZu013741;
	Sat, 22 Aug 2026 16:12:27 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Sat, 22 Aug 2026 16:12:30 +0800
X-Zmail-TransId: 3e816a8959e4016-92fd5
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Yanze Zhang <zhang.yanze@zte.com.cn>
Subject: Re: [PATCH rdma v5 0/7] RDMA/zrdma: Add ZTE Dinghai Ethernet Protocol Driver for RDMA
Date: Sat, 22 Aug 2026 16:07:23 +0800
Message-ID: <20260822080723.3166603-1-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811093740.2607476-1-zhang.yanze@zte.com.cn>
References: <20260811093740.2607476-1-zhang.yanze@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ZMAIL-USEORIGINALEMLTOOUTBOUND: 1
Content-Transfer-Encoding: 8bit
X-MAIL:mse-fl1.zte.com.cn 67M8CRZu013741
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sat, 22 Aug 2026 16:12:36 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A8959F4.000/4hRqfX4wp1z52Rpb

Hi Jason, Leon,

Apologies, my previous ping was sent to an incorrect address for Jason.
Resending with the correct maintainer address from MAINTAINERS.

Gentle ping on this series [1]. I understand we are in the rc phase
and new drivers will likely be queued for the v7.3 merge window.
Just wanted to make sure nothing was missed or needs further action
from my side.

[1] https://lore.kernel.org/linux-rdma/20260811093740.2607476-1-zhang.yanze@zte.com.cn/

Thanks,
Yanze
