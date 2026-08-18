Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9283793DC
	for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 16:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787070286; cv=none; b=NKndo16SLMxsl3v7/0RNaUqkDKsAMhqcUihUpEejl6pd06Vskks42qeN6KRND3ISTK6eHw0YnXKGyQn2wCyt0BlCZ0TPGOUrBIkkqlhru5ak9AwV50/KAGP8JHU05dBR1dkUBFHu0BGwv/yCcSa324WnaJJgswg18oURFPD37MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787070286; c=relaxed/simple;
	bh=u8X2b9oN8tGYQ20GKzk/5GBQBQdMcnfzccnYIq0O5JE=;
	h=From:To:Cc:Subject:Content-Type:MIME-Version; b=LRH+W3VwVXDTUSSLI/B09cEjfMsKhLbNHEUFWkJxYxBcQl/gUCcwqQM4fKjreNUv/D0OPpt3jtZY1KK8j9xHbdGtUeh0E/ScHkoDimujx5wiR8cFzsehR2L7OKXU1t7Xh6CokSRYHXXchpqukzmh+Jc91/19E7dpDD49XF0lsb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=HxvZMy/G; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="HxvZMy/G"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787070281; h=From:To:Subject:Content-Type:MIME-Version;
	bh=osF6GssgP09SWPxGeP6Z2isl8JNWuscxm6joyP3fUsU=;
	b=HxvZMy/GN0Zt2c+Q5/3OakjizghXeYQlJgTkaw5cJaljfXFPhrId7Z/ZNc16v+V3rXlf18f/i7Ai8+MdtHHwD+K6znCkbM+5NGGUN2PASseG/XAsybnhUXPn5zlzPmQQnqq91OLcakiKHRYLh1YZmpeZ+6j44J8jm0QFEhK1pZM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=chuyf26@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X9E5BE._1787070280;
Received: from x31j07255.sqa.na131(mailfrom:Chuyf26@linux.alibaba.com fp:SMTPD_---0X9E5BE._1787070280 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 19 Aug 2026 00:24:40 +0800
From: Chuyf26 <Chuyf26@linux.alibaba.com>
To: Md. Haris Iqbal <haris.iqbal@ionos.com>
Cc: Jack Wang <jinpu.wang@ionos.com>, linux-rdma@vger.kernel.org
Subject: [PATCH] RDMA/rtrs-srv: reject info requests with a non NUL-terminated
 pathname
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <20260818162443.Jkolef0plwc8Q6RW7pMze1gOsOp_4E1gabsGV2e0NqU@z>

process_info_req() treats the pathname received in an info request as
a NUL-terminated C string.  Only the minimum message size is validated
before it is handed to strchr(), strlen() (through exist_pathname())
and pr_err("%s").  A client that sends a message whose pathname field
is completely filled with non-NUL characters makes those functions
scan past the receive buffer into adjacent slab memory.  Since RTRS
connections require no authentication, this can be triggered by any
host able to reach the RDMA fabric.

The path is: a client posts the info request as an RDMA SEND, the
server's receive completion runs rtrs_srv_info_req_done(), which calls
process_info_req() on the received message.  The receive buffer is
allocated with kzalloc() at exactly sizeof(struct rtrs_msg_info_req),
so after scanning the 15 reserved trailing bytes of the message the
string functions walk past the end of the object, which KASAN reports
as an out-of-bounds read.

Reject info requests whose pathname is not NUL-terminated within the
pathname field.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Reported-by: Abaci <abaci@linux.alibaba.com>
Assisted-by: abaci:qwen3.8-max
Signed-off-by: Chuyf26 <Chuyf26@linux.alibaba.com>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/=
rtrs/rtrs-srv.c
index 10061b218758..b500ec0be82e 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -811,6 +811,11 @@ static int process_info_req(struct rtrs_srv_con *con,
 		return err;
 	}
=20
+	if (!memchr(msg->pathname, '\0', sizeof(msg->pathname))) {
+		rtrs_err(s, "pathname is not NUL terminated\n");
+		return -EINVAL;
+	}
+
 	if (strchr(msg->pathname, '/') || strchr(msg->pathname, '.')) {
 		rtrs_err(s, "pathname cannot contain / and .\n");
 		return -EINVAL;
--=20
2.43.5
