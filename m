Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A086371CF8
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 18:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791572069; cv=none; b=MqUqkLBGvb565hyRC7htKlqtY7a41Or95svjWS0ra5jf4c1bOrxzBeKdeucKbZsQ/HfNmP1BlzuZiY04aGahjFCDAK4w0wPjXssFftaYePvtitGDf72KwHstC2DnXj0q37cMI9olkv96nwNlE7FKaDhN8ISiNUkGkH0K7GraMYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791572069; c=relaxed/simple;
	bh=lpwV0ayATDs/va0BjQrJOly6/SuSwkdZe6HYJCchMsw=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=jcsoag3WRONEI0wEG6YTV61mgo12/Qb182bH0Bi3YBM8A84Sak9gmHixMjwv6LjL17IMEzNQgcN9nYjQaDlg45pEaSoNmIfgRluOMlAzQKg0GBVmKwK5fEwoJECl1XpwWZaJpekbkcLCdvOPhX7f0fxGaBXg95DOnwDotI8RqOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=lDJLBIFN; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="lDJLBIFN"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id l0zNi0j0oDGZCzgh; Fri, 09 Oct 2026 14:23:37 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=kHvW9FPkT6K3n13eW5IDVkVOxFVjKUpItwtt3tRvuYA=;
	h=Content-Transfer-Encoding:Content-Type:Subject:From:Cc:To:Content-Language:
	MIME-Version:Date:Message-ID; b=lDJLBIFNt0TX1xnmmoT8kyORk8DUj9BbCb65Gz4YBpPlS
	5wJT5hMTGXyvOHZkTu6QFe3/5SIiPIAsmuafL5rXEdDXblN8n/Rn4kQMvtuSLPW2Pcs8Znmp+Py/q
	4Z1UOAA0TJRLJTXo6W/ZMprjGpcIeb0l6cOvlbSiBAx5q6jQs=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.1.0)
  with ESMTPS id 14984987; Fri, 09 Oct 2026 14:20:37 -0400
Message-ID: <064dfa67-8fd4-40f0-b925-6d1e0cd42e6a@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Fri, 9 Oct 2026 14:20:36 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org
From: Tony Battersby <tonyb@cybernetics.com>
Subject: mlx5_ib fails probe with old firmware
Content-Type: text/plain; charset=UTF-8
X-ASG-Orig-Subj: mlx5_ib fails probe with old firmware
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1791570217
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 0
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 2786
X-ASG-Debug-ID: 1791570217-1cf4391af94b74e0001-g2FmEp

I have a number of Mellanox infiniband adapters out in the field with
various firmware versions:

lspci
01:00.0 Infiniband controller: Mellanox Technologies MT27600 [Connect-IB]
Subsystem: Mellanox Technologies Device 0018

lspci -n
01:00.0 0207: 15b3:1011
Subsystem: 15b3:0018

Ones with old firmware don't work:

mlx5_core 0000:01:00.0: mlx5_pci_vsc_init:66:(pid 731): Failed to get valid vendor specific ID
mlx5_core 0000:01:00.0: firmware version: 10.10.5020
mlx5_core 0000:01:00.0: 63.008 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x8 link)
mlx5_core 0000:01:00.0: mlx5_cmd_out_err:810:(pid 731): QUERY_ISSI(0x10a) op_mod(0x0) failed, status bad system state(0x4), syndrome (0x408b33), err(-5)
mlx5_core 0000:01:00.0: mlx5_core_set_issi:866:(pid 731): Query ISSI is not supported by FW, ISSI is 0
mlx5_core 0000:01:00.0: mlx5_init_clock:1040:(pid 731): invalid device_frequency_khz, aborting HW clock init
mlx5_core 0000:01:00.0: mlx5_cmd_out_err:810:(pid 731): QUERY_HCA_VPORT_CONTEXT(0x762) op_mod(0x0) failed, status bad operation(0x2), syndrome (0x3590f5), err(-22)
infiniband mlx5_0: Couldn't create per-port data
mlx5_ib.rdma: probe of mlx5_core.rdma.0 failed with error -12

Ones with new firmware do work:

mlx5_core 0000:01:00.0: firmware version: 10.12.780
mlx5_core 0000:01:00.0: 63.008 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x8 link)
mlx5_core 0000:01:00.0: mlx5_init_clock:1614:(pid 755): invalid device_frequency_khz, aborting HW clock init
mlx5_core 0000:01:00.0: Flow counters bulk query buffer size increased, bulk_query_len(1)
mlx5_core 0000:01:00.0 mlx5_0: Port: 1 Link INIT
mlx5_core 0000:01:00.0 mlx5_0: Port: 1 Link ACTIVE

I can work around the problem with the following change:

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a457647edacd..4fc903c2a0be 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3611,7 +3611,7 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u32 port_num,
 
                err = mlx5_query_hca_vport_context(dev->mdev, 0, port_num, 0,
                                                   &rep);
-               if (err)
+               if (0 && err)
                        return err;
        }

This code was added in kernel 4.19 by commit b02289b3d60f ("RDMA:
Validate grh_required when handling AVs").

A similar problem was fixed in kernel 4.9 by commit f9c14e46748b
("net/mlx5: Fix query ISSI flow"), which is a source of some of the
messages with the old firmware.

Can anyone suggest a proper fix for this issue?  I can upgrade the
firmware if necessary, but that would be less convenient than having a
fix for the driver.

Thanks,
Tony Battersby
Cybernetics

