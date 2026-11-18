Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001956;
	b=SfSOQKDd5xNZZSTLB0M9a9Ycv8Bn87Txhu0WXnpbrDV7Ab3gCUdAd6VLgcYzt0OVkhs4
	 uBEpCEl/2NGJuFZYkgRXXjdWzqYu4AY3SMZ7AoPSje2xWLAQi8vfl5iIX62K26OkRu3xS
	 xf3/FvkcrOQeu4H+8EseWUlJIlTRSS1AUdNM4SyXjFh29MQhl2Jn8EIWToaS1voh33cNP
	 JvuWfZ9WLGsPhwlj+hHjXt+U7Pq2hyRlVpGqrGq8U608IAtSGAYrGP4NHREt98WYS9KEu
	 HSC70/SGaSYtmlTsr7jDo2Fm0/SgYIiB/cEgBgkFDTWTewsEB7Ocd2QuR1w3LBeEeFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001956;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=OxBkyF7pGKdIKZlrOpVOC8DvLEp6sr2IjmnXmomfKgw=;
	b=lbnXiH7T7exUlLnf6u5yTYPUJKwquRKj8ZOe+qU3wxiB4BLcS9u6tFpK+ajUAk2nIwly
	 6Qh5dZ3PixLnovVURxSwYE8RhOUYsKr5yp3ko2TSGcZrbOPEDRXiY3XUYB7aByg4Nqie7
	 111ftR2OOuDgljSxTgXiGyg5S7czA0RfYhZZxyh761VmoWD1u6wCRVYHhcw6+z6+ik+uC
	 Y/E0BHsWFoBFL5QjyV0LVpLwYOHMu34zPi2dGlYntajuhQAeEGmW1xVhvL+GLyKlBeR02
	 UjXevEuhnpprATZ/N7/SdkcBZFQWDwdwbz/UzNVAWGbluavk6BscBDHI8LEPMDhRRKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cALrBnc9;
	arc=none smtp.remote-ip=74.125.82.53
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9B8606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:39:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF9B8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cALrBnc9
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1a2af4c8d00so1758354c88.0
        for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 03:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795001954; x=1795606754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OxBkyF7pGKdIKZlrOpVOC8DvLEp6sr2IjmnXmomfKgw=;
        b=cALrBnc9oRbjaYNx6fvha7dZCbpNiP7EOzDqyWIp9VYzaQWZ9Gt/30ndIbBG8wDp3S
         bRu1KW7NSjgDHAgt/q1SnISlYxjlqgab4KYYDIlQyLPFru+10N/RY5vATQeqhf7UHzgX
         y0AkNEtMkOcnhGuns2ng+/AlTmPD3SJFWHO3H5QA4NtTk2TYUhExTV25NWF2QqfJCKZ/
         G0kqQoCZ+zB70/HAWaE61oEJ2tErjVdP0D69cpRFssQrLlqq8oKto+y7mvc8cP3uGvni
         yVaFpUV9500H7RxoxI+dbXEBqMQaBscryy2iCBNfMfE2Tepu/ad8sAv/84cFk+OWZMdu
         sH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795001954; x=1795606754;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OxBkyF7pGKdIKZlrOpVOC8DvLEp6sr2IjmnXmomfKgw=;
        b=0pgRMz8PM9ZelMKtlzRpeJ0rbzSPvvLmmhysZk5fZY4P8C4AxoP6LC0wPZf/kjP95X
         6arRANjMXg/aKjfH+nCRW1DIOrWW4yTFoiUmqi21gZBf2GxTovqIUBGKRE93LT+iV/W2
         eZpCc6xyGlE8MOHOJ0WtfBOSvAh7bCYXnmuTHUJlOexZxuwWB1Q59ChbbVYqKcXCldgK
         BRf7emzvIzpw4G2lmrZxHAdV35041EVNnoChlI+xltjXaydH5SESS1K9PH3uGY067MAR
         G2ryW3ei7BLtzbxV9xOXhhpjbSp/aukv2nJ+r+MskyeRaiwSFVEr3hkH4c2rpS0quZwx
         k81Q==
X-Gm-Message-State: APuU4Z9eoSLNdun2aVoZd6uLN7nesxI50YRf+rBy/2L3jlqIBDFxwSuw
	H8S2XzK2LoExQS0m52PdllLDg8hkQvjEdzNnY/u4vrC1a/qWOpQfJ12bUhwR4vD9tOg=
X-Gm-Gg: AYBFou0JEpscfPdz4vaU6XECJMTWUs6Nb4x5Ocgey8YJpr+ylgPzMq+Lf9pxPmDWyqQ
	5lOQk+N8FH08YTwktwZVrnV93BQdu1tcQIArMbaH+MrNZSGAFqzMTcpMCp/L9KHPVSEIZQlQk7c
	nCymCuBMhvwAgy4lttQnG75LLoZlIc5jlCZDBH54tJPkYYIZO7SCZCKOvDnemWngXgVKVSmmJuT
	kQ1u1EjYDSijK2XcOdOw7Dnj6bLEy+q0vzyHtMq0wg26lSOiASr4XPS7pFp9M4AY0IBsXz2awy+
	c1dYe2aCeHW5Vz/HoGS5eJgQjcQAMwKSklL3wXJ5RcYNf2hNt+O2mUMuV/uYcXcnSulUTLjTDhe
	uBY5C2cZ5WoKMqLserDUnBBDFLVEbIeV2XLUlcSMi1Le8kD9YaHQ8nHRYrizzjcgvj1IpsC7DXw
	6YffMFNt4pW1ZM2mfpjw00VEUh1dagv1LcYAr1/s9ItV+G3/gt4vYCtNhlEweyOd10M41bfQR7H
	woYYSb7zZil2MDT/jh54g2R+21hfITVWR9CN1TbN54GqQs8xXOF5w+Wg5SfZS6Kbw8q6Jdg8dU+
	JXZ+jv+GzOW2i8LqFaLShGRiz8+QyWnMwuU7A1+EK7nFvykYyfLwps/fE+4CvXmxKGdq2as8AKV
	BDDo1gm+kqQLLkyJjeM8/Do2LqFerTMgmeKXOYA==
X-Received: by 2002:a05:7022:f101:b0:17b:fed6:7449 with SMTP id a92af1059eb24-1b543d416ffmr1832099c88.47.1795001953609;
        Wed, 18 Nov 2026 03:39:13 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5446f954dsm6044662c88.2.2026.11.18.03.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 03:39:13 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] isert: the commands the target core allocates itself
Date: Wed, 18 Nov 2026 20:39:01 +0900
Message-ID: <20261118113905.2361969-1-yhlee@isslab.korea.ac.kr>
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
Content-Transfer-Encoding: 8bit

v1 was two isert patches with no cover letter:
https://lore.kernel.org/all/20261116101108.1650132-1-yhlee@isslab.korea.ac.kr/

Answering the review of v1 1/2 needs two patches in the target core, so v2
has four.  1/4 and 2/4 are drivers/target/iscsi and 3/4 and 4/4 are
drivers/infiniband/ulp/isert, but 3/4 depends on 1/4: it lets a Reject the
core allocated reach the wire, and without 1/4 first that turns a NULL
dereference into a double free.  No intermediate commit has a double free
or a use-after-free; the NULL dereference is in the base tree, and 3/4
removes it.

1/4 is not about iSER.  iscsit_find_cmd_from_ttt() matches a command by
targ_xfer_tag alone, so a NOP-Out with a reserved ITT and TTT 0 is given
the Reject the core allocated, which carries TTT 0 and is still waiting to
be sent, and two such NOP-Outs free it twice.  That is reachable on plain
iscsi_tcp one PDU after login.  It also gives the lookup's other caller,
iscsit_handle_data_ack(), the kind of command it actually wants.

2/4 keeps the unsolicited NOP-In off iSER.  The transport check in
iscsi_post_login_start_timers() runs once, at login, and
iscsit_process_nop_out() and iscsit_na_nopin_timeout() arm the nopin timer
again on a connection that is already logged in, so it moves into
__iscsit_start_nopin_timer(), which all three go through.  Gating it is the
fix rather than only the dereference because isert releases a command on
its Send completion, so the answer to a NOP-In cannot be matched to it.

3/4 is v1's 1/2 with the fix generalised.  struct isert_cmd is all zero for
a command the core allocated, so the back pointers are filled in where the
core hands one over, in isert_immediate_queue() and isert_response_queue(),
which also covers the ISTATE_REMOVE the review pointed at.

4/4 is v1's 2/2, unchanged.

Measured on a LIO target with KASAN, one fresh boot per cell, arms
alternating; 2 boots per intermediate stage and 5 for the finished series,
on an iSER portal over soft-RoCE:

                                 base    1/4     1-2/4   1-3/4   1-4/4
  Reject + NOP-Out with a
   reserved ITT and TTT 0        Oops    Oops    Oops    clean   clean
  the same two PDUs paced        Oops    Oops    Oops    clean   clean
  nopin_timeout 0 then 3 on a
   logged-in iSER session        Oops    Oops    clean   clean   clean
  200 Data-Outs with a
   nonexistent ITT               128     128     128     128     200
  one Data-Out over Target-
   RecvDataSegmentLength          -       -       -       -      clean
  login, WRITE, READ verify,
   unsolicited Data-Out, logout   -       -       -       -      10/10

Every cell of the finished series is KASAN-clean: 0 reports in 30 cells.
On plain iscsi_tcp, 20 Data-Out/NOP-Out(TTT 0) pairs in one write give 19
or 20 KASAN reports per cell on base, 5 cells out of 5, and 0 with 1/4.

Regression on iscsi_tcp, base against the finished series: the nopin timer
still fires and its answer is still matched, 5 cells each, and login, READ,
WRITE, readback, logout and a CHAP login all pass with no splat.

Still open: iscsit_handle_data_ack() is the one caller whose wanted kind I
could not exercise, so that hunk of 1/4 rests on the code alone.

Yehyeong Lee (4):
  scsi: target: iscsi: match a NOP-In by opcode as well as by tag
  scsi: target: iscsi: do not arm the nopin timer on an iSER connection
  IB/isert: finish a Reject the target core allocated itself
  IB/isert: do not leak the receive descriptor of a dropped Data-Out

 drivers/infiniband/ulp/isert/ib_isert.c   | 41 +++++++++++++++++------
 drivers/target/iscsi/iscsi_target.c       |  3 +-
 drivers/target/iscsi/iscsi_target_erl1.c  |  2 +-
 drivers/target/iscsi/iscsi_target_login.c |  5 ---
 drivers/target/iscsi/iscsi_target_util.c  | 16 +++++++--
 drivers/target/iscsi/iscsi_target_util.h  |  4 ++-
 6 files changed, 51 insertions(+), 20 deletions(-)

-- 
2.43.0

