Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D49350D48
	for <linux-rdma@vger.kernel.org>; Fri, 30 Jan 2026 16:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769792047; cv=none; b=tVB++MDEpJiBWcu+Td2u0J4tRfOn07C3nQ9TRM1LVBMkoX93rJ8b3SmJCQFSr5wJ4W2ShVV/I+238dS6OtAdHTT5goddiZME2XTQFDxn0RTpptOhC5DK+xxJJHFFaTeS45SoR/UcFb54iT1KTUof8tqiLxJ4RTF2A6XCKTmRAic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769792047; c=relaxed/simple;
	bh=P29ozWDvU0n0V6XeRYb6BkKR+4vP4gjB/XY+9W6jGdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oW3ghnRYH/uqqUMKPxeZcgQnMhOMU95EUv29j4kRIUtujD3zdND73vMp40NdioTpiCWc2NNISyLXd+URn56Cx5vwyRRZt0fFoF3uKd2NxaGWy8iww+BHJEbMDB+KIIOykm1nsCSy5SyvMc042rBOzMGz8lME4vEk0K+hJDOUnJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Elf4lDez; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Elf4lDez"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769792045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KS4/gkGq27/8plMJdM75D50Du3giTwG6upf6vajwDBo=;
	b=Elf4lDezOmGPbb1ddyNFRPmsKa5cEQe0gXtMinr1TVr2L8LwleKicQD1OUkw3nUXx+DtA3
	pLl9m+609oWv5qpOR3VSsoHOGlZ3W4gXUq9h/ER927pywy8XyqUBTfGb0nmG5Ogsof1sdn
	fIzcRfCp2BOLGSFGkvVk7fWrMvx+q5Q=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-156-AI02PA9LNF-IYQ25Ct1uXQ-1; Fri,
 30 Jan 2026 11:54:02 -0500
X-MC-Unique: AI02PA9LNF-IYQ25Ct1uXQ-1
X-Mimecast-MFC-AGG-ID: AI02PA9LNF-IYQ25Ct1uXQ_1769792039
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C71118005AF;
	Fri, 30 Jan 2026 16:53:59 +0000 (UTC)
Received: from p16v.redhat.com (unknown [10.45.226.27])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 65C9F1800109;
	Fri, 30 Jan 2026 16:53:53 +0000 (UTC)
From: Ivan Vecera <ivecera@redhat.com>
To: netdev@vger.kernel.org
Cc: Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Mark Bloch <mbloch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Prathosh Satish <Prathosh.Satish@microchip.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH net-next v3 2/9] dpll: zl3073x: Associate pin with fwnode handle
Date: Fri, 30 Jan 2026 17:53:31 +0100
Message-ID: <20260130165338.101860-3-ivecera@redhat.com>
In-Reply-To: <20260130165338.101860-1-ivecera@redhat.com>
References: <20260130165338.101860-1-ivecera@redhat.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Associate the registered DPLL pin with its firmware node by calling
dpll_pin_fwnode_set().

This links the created pin object to its corresponding DT/ACPI node
in the DPLL core. Consequently, this enables consumer drivers (such as
network drivers) to locate and request this specific pin using the
fwnode_dpll_pin_find() helper.

Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/dpll/zl3073x/dpll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dpll/zl3073x/dpll.c b/drivers/dpll/zl3073x/dpll.c
index 7d8ed948b9706..9eed21088adac 100644
--- a/drivers/dpll/zl3073x/dpll.c
+++ b/drivers/dpll/zl3073x/dpll.c
@@ -1485,6 +1485,7 @@ zl3073x_dpll_pin_register(struct zl3073x_dpll_pin *pin, u32 index)
 		rc = PTR_ERR(pin->dpll_pin);
 		goto err_pin_get;
 	}
+	dpll_pin_fwnode_set(pin->dpll_pin, props->fwnode);
 
 	if (zl3073x_dpll_is_input_pin(pin))
 		ops = &zl3073x_dpll_input_pin_ops;
-- 
2.52.0

