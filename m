Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570A32EDD52;
	Fri, 23 Jan 2026 08:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769156641; cv=none; b=BvqBxZW6wbDvz1C4YIz/W7j/0H3zZ9cKHJA6C5eJAXvBw7Uxg6+IZ+yA0bu0jfm5BKNVieYGMwoxwtke8XCRa53WaPFyFUnVlIeiPKadO9hKBvoXb9OG0ZuaN94l+QrACbTLk5B9u/66VuGocEU0+pESJ39hbORIcNI106E5jz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769156641; c=relaxed/simple;
	bh=12BYwHefeCHvg6DzgrKy0FPgd9W5v3eEwpoFFWFX9Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbiYhHaiOViPayADtMY+CWmGJrAwR+S6iRQHoO/Nu++HeInlnf9elKK/X/tZCCNhC3GahVLvkDNf8JpKpuQU6rczR7VjcUTFdZMVxBAF4+ssIvp1zxr6eg9F0KsmthfpQRdm7NEwI2qiFdrsym2jKQQrErsZaX3OgKJTlPqwGE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=iThvwSmC; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="iThvwSmC"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769156636; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=hBm0JDk7EhK8byASx/pot4VMZ/7c5vuPMnvsfOBUnCE=;
	b=iThvwSmCe9zTcBWIDB1rbrn1vrh94TL4bCYPVBTMxdUevCygeT6x8Ap5G17RYKMSlLRReGp2R8UqAnE7phsCgTiYhai58xbGeG+AmPziVjMEAehhoKQ657R1jkugzvEFLqyzGslvoDW0kLkkC43dLSCFwvE7a6wH59MhfBxNdaI=
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Wxf8ovm_1769156634 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Jan 2026 16:23:55 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com>
To: "David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>
Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: [PATCH net-next 2/3] mm: vmalloc: export find_vm_area()
Date: Fri, 23 Jan 2026 16:23:48 +0800
Message-ID: <20260123082349.42663-3-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20260123082349.42663-1-alibuda@linux.alibaba.com>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

find_vm_area() provides a way to find the vm_struct associated with a
virtual address. Export this symbol to modules so that modularized
subsystems can perform lookups on vmalloc addresses.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 mm/vmalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ecbac900c35f..3eb9fe761c34 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3292,6 +3292,7 @@ struct vm_struct *find_vm_area(const void *addr)
 
 	return va->vm;
 }
+EXPORT_SYMBOL_GPL(find_vm_area);
 
 /**
  * remove_vm_area - find and remove a continuous kernel virtual area
-- 
2.45.0

