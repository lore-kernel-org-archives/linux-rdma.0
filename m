Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795444643;
	b=EI9QU6ATCnPLMLpaKWzbw9+je+5yLIyKtimM37NtQXbaLwt33mF7KihqQXidfWNCWTe+
	 uNWug0UZ9rBURDc8qYVprSkp+TEpCwgfkdQvfB+3v/p4P7+0RJ38/FCbY59TmcvwnHWwi
	 IBKaI62MIT9b0hCCcrv6eqJni6u2vVjqx89eTDgZzMlmTq4vho+DYp8sUPZ+usbJX59Ic
	 w3gQgps5cLEZdWGlajMolYJ6GZRmq4EoBWrbMkSWW1/92bkhsMjSnw2/ptMRDSmwN7Ho9
	 /LbyRdnrEHT6e3k1w/PSur4rxvgjNurqQZq1qeWimClK7AI+BU+FkoB+kQxWnkO8dKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795444643;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=PAMui72+qSk4SyjTK33lYNxT3gN5RiIXUp+yRlSdhmc=;
	b=Qx+HkeHbsSnKqDnTkE5YRvK7Je4cepM0e1tUSYDFo7UMGZQ5qaeDWjZ7qniP+XWDCeDx
	 l6yUFMVHwxvMA0UfDYu9l5XIwbL/2QGsABa8IhwS3dQuBIOSUuUcL1bCZEXl+lXsZTG0E
	 kuO3XzENSlW9zdJks26PvV34/i+1BjCS7m+Y7NUB6zzzk0l72N/wjCWRGKtO6teGbroje
	 CGK0G1W9H0Y8xiztv/A1a9+5fwi0U6n8AlHcCSxSRUHu/cMGWtFCX1PsrmIGcKLIuc2hA
	 d/zoOUQrF0F4HWGfmg7fr1Kezs0UShYSGWrm8QnuflRr5r9A8A3pAc8JBqKgXITx/AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=FB94iW1X;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E302606A31E
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:37:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E302606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=FB94iW1X
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4aa5833c263so3209803f8f.2
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795444641; x=1796049441; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PAMui72+qSk4SyjTK33lYNxT3gN5RiIXUp+yRlSdhmc=;
        b=FB94iW1XlNwMd8qGE/S/0okbCXuET6VDIR5SQN9bbi+a3Y21qq9NYtzzUhzMGNrxJf
         uMxiXJnequeOMNSxHQFij7vIpUwAzZKrwV7AmTtuYMEsi2WiaFFeQDVb0DmZ0YzGedUn
         DnV9KLlamtY8imLwRBQQGo3GjSf7rzWKkH6Iarwm6c7YYXIkM6/RNTw8MyXLZ+hyGGxL
         9I5NDsGyeuBSm6yZHMqackjVdL4U8E/bkggsCspTKbhRLMKh2XzYSBgsf708elHpFVNu
         UPDp0+IgTl2dfhfqgm/J3cA9Qgr1PPIrw67oWFP+2DSPTUjcSre4QRX/9HyqPaWQNYTZ
         GShg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795444641; x=1796049441;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PAMui72+qSk4SyjTK33lYNxT3gN5RiIXUp+yRlSdhmc=;
        b=JfmkvZn02kXGstAlusQTeYxDyG9MqZkjMs96A7H0wWjPfK2UYxECXfgDuWKMi9N8u/
         BQXLB63KzWf/PR9pEQfvWHzmR8b3ryjgRG2vqelZyhAF4M0DbGugYCrmaOQT7Ep2KouA
         SXQcmKTL8Wd7uy0v8NMoGpBrzwbW7HT89npxEjkCll30oIXM2DRKKiEEIenz1UkVW9md
         8uHMJ2sd4MWRzBF/chXJHxTz2+TLHms/dKSuHY71ReRPBnxj0Cji+JoffHEVmPTq+MtZ
         wTEct2cj++CjtKqlSFutZxxOked/k2ZldTSQCsPtlMaGU9kRC7tW+4/trthpXofdz8yQ
         8f/g==
X-Gm-Message-State: APuU4Z/L+w6Lem2ujiNZHoTgpEDKvD+TsT6I6P9mwSrusn2ns8xCeVrx
	2ZaD4qAFRrsVXLJtX35XFc7hiuMMTMe6bk02C7KRyKKA4Up0Yj8+dxruBfLqVKEcfjgTvrDziAd
	onnbe9ok=
X-Gm-Gg: AZFdTZcGG7OwAdhFTiLaJCEofxbh8pHJw4cFPWKPo0kkVsTN3Ocsdg18nl+y/a6jFj9
	ZI8pIFfQh/LvPY1mF0f4AzIzmAAh1Tb3budV3AsELJO4AjeIkepxiioXFKC/T15bpB8Yc5O1Ifg
	TBFt/P+oKmK87nQHgWEm86JTC7y2JDNIsgpKf58HGupasE3pghyTzwBjzUNxW/0QyQBYTvdlutM
	LPqrlJRGAWmB9a7MmcreTqF3CR41z/tGfbmimCBHwE4hDeZoVwfCGTqTX1PrU9tTOCUGGfoE579
	Y+k4ezpT9fOUzJsHrfUwP4xMiJEqYxGEriGrPj1Lut6hnMMEswBoktAyr+irLKAzs15IBV/N4/h
	MQsKR9Wr3FTe0bfaasC2vGjYJtRPVcxN6RRqxoogwRSQXyup3edagNY/wYqr5KvMq5uBmYoOzX/
	QErQDE1JUUdxCEXlktkln5MsXtBtVungjO8y90FTlv+PCIBd9n5OcdNYzOXiyJ7ZzE4E7/VDC8/
	kwcKmX3AwfiIbf0U33o+vL2ndF1is1NOzxm0bkOEb/TskR69VAG8VBcfNC0c2eTrrmHaUqLavR+
	aBCMBZQdBi20yShJIN1mbmwRExMzJ+ZXZcT7gGI/lr6SBpwUk8NEVCoT6LdJuHSmcKwTGW6AvHx
	96PtgTk/opVJygBNsnHEE0gn+WDq6VpTTk8Wm/DSSs4RPyZYup2CtFcylLwfoBYYmoamrLIHOkw
	0WKpA+nckbJ65QBtwhIcJvSujYuJc1+Es+xi1MjPazXlPxuJs7T0Hj/Mks
X-Received: by 2002:a05:600c:45d4:b0:4bb:6994:abf0 with SMTP id 5b1f17b1804b1-4bb88817d91mr259121545e9.23.1795444641569;
        Mon, 23 Nov 2026 06:37:21 -0800 (PST)
Received: from lb03189.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906d6a13sm172562325e9.3.2026.11.23.06.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:37:21 -0800 (PST)
From: Md Haris Iqbal <haris.iqbal@ionos.com>
To: linux-rdma@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Md Haris Iqbal <haris.iqbal@ionos.com>
Subject: [PATCH 0/9] Misc patches for RTRS
Date: Mon, 23 Nov 2026 15:37:10 +0100
Message-ID: <20261123143719.938876-1-haris.iqbal@ionos.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Jason, hi Leon,

Please consider including the following changes in the next merge window.

Benjamin Stürz (1):
  RDMA/rtrs-srv: Snapshot the READ request header instead of reusing it

Danil Kipnis (3):
  RDMA/rtrs-clt: Add mpath_policy module parameter
  RDMA/rtrs-clt: rename pathname parameter to sessname in
    rtrs_clt_open()
  RDMA/rtrs-clt: Back off the reconnect delay exponentially

Grzegorz Prajsner (1):
  RDMA/rtrs-srv: Fix processing messages for Big-Endian archs

Jack Wang (2):
  RDMA/rtrs-clt: Fix refcount imbalance in rtrs_clt_write_req error path
  RDMA/rtrs-clt: Trigger error recovery when posting LOCAL_INV fails

Md Haris Iqbal (2):
  RDMA/rtrs-clt: Fix reconnect jitter being applied in milliseconds
  RDMA/rtrs-clt: Close all paths before freeing any in rtrs_clt_close()

 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 132 +++++++++++++++++++------
 drivers/infiniband/ulp/rtrs/rtrs-srv.c |  38 +++----
 drivers/infiniband/ulp/rtrs/rtrs-srv.h |  13 ++-
 drivers/infiniband/ulp/rtrs/rtrs.h     |   2 +-
 4 files changed, 137 insertions(+), 48 deletions(-)

-- 
2.43.0

