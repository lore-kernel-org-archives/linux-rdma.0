Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D821234EF07;
	Fri, 31 Jul 2026 09:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785489946; cv=none; b=ZhCxiWipPby7vLsYyfMzXztO1q/uDRof8EL21GiBTTDeWqraSkJiSrBvsbQ9CffvdIcC/Yg9eG6Yiz8RWWWEvNebRplK/EGDArUQ3Nrj4AYWJpto6rxecHIHzAxUbneItvBq5hga0oDMHIY4a3EGBUH77CjwGzFRLP3AYYqp9aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785489946; c=relaxed/simple;
	bh=yVbIrq0JGJ/tqGL3Y2ZY9dwrwUyLWURgmK/GfIDOQUE=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=CM+uawkSrmVXbiv1ntMLthzBi8LGpL534t6lvChVy5qSoubtfl8ds0Opsu+n6efecapdqaSMmyhBgTyq/Tzhr2kcyEqqH0rMWTs7dW7QRTcgkFqrCw226rusZP+s4Q7TrDTDHVPNxJGgpdpk3A3NncIgtKmvfW0ZRhe9Ao490NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=pGH/iuBq; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="pGH/iuBq"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ezWBjEQSDcXQyHNe5BtmlwrccUN5BrvMs10Em0adCSs=;
	b=pGH/iuBqURK83Z9lqsED7R+rUKVpsyDWjl2LbSCMHb2XBN7DYhttOPvhP/sgiSnPBvN9k8Kv+
	1vwaN6cVm5mLh96ZLRwrDGQy1ctxHKpM4Sezks2e6Kj2oImPH2Y1LtP3AOB916FEbd3grAXOjNN
	prlqTCjU1tgOYVoGnHZ/zZ4=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hBL660wbZzRhR0;
	Fri, 31 Jul 2026 17:16:14 +0800 (CST)
Received: from kwepemf200012.china.huawei.com (unknown [7.202.181.238])
	by mail.maildlp.com (Postfix) with ESMTPS id 19F504057D;
	Fri, 31 Jul 2026 17:25:41 +0800 (CST)
Received: from kwepemq500011.china.huawei.com (7.202.194.193) by
 kwepemf200012.china.huawei.com (7.202.181.238) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 31 Jul 2026 17:25:40 +0800
Received: from kwepemq500011.china.huawei.com ([7.202.194.193]) by
 kwepemq500011.china.huawei.com ([7.202.194.193]) with mapi id 15.02.1544.011;
 Fri, 31 Jul 2026 17:25:40 +0800
From: shimiaofeng <shimiaofeng@huawei.com>
To: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de"
	<hch@lst.de>, "sagi@grimberg.me" <sagi@grimberg.me>, "hare@suse.de"
	<hare@suse.de>, "saeedm@nvidia.com" <saeedm@nvidia.com>, "leon@kernel.org"
	<leon@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC: luolongmin <luolongmin@huawei.com>, haoweiheng <haoweiheng@huawei.com>,
	"chenjianfei (D)" <chenjianfei3@huawei.com>
Subject: Nvme-rdma: Long IO HANG (~4.8h) during link failure with dm-multipath
 (Kernel 6.6)
Thread-Topic: Nvme-rdma: Long IO HANG (~4.8h) during link failure with
 dm-multipath (Kernel 6.6)
Thread-Index: Ad0gzmSELVSC6brVS1yCYXt27TkCxQ==
Date: Fri, 31 Jul 2026 09:25:40 +0000
Message-ID: <2139a37510154a98a614c3c37941a13b@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi all,
We encountered a severe I/O hang issue during NVMe-oF (RoCEv2) link failure=
 when native multipath is disabled and dm-multipath is used instead.
Based on our test results, this issue is highly likely located within the r=
econnect/backoff mechanism of the vendor's out-of-tree driver (NVIDIA DOCA-=
Host 3.3.0). The attachment contains the logs captured when the fault occur=
s.
We look forward to the vendor analyzing this driver-side issue, but we woul=
d also like to seek advice from community experts regarding potential optim=
ization suggestions for the block layer and NVMe-oF (NOF) collaboration mec=
hanisms to guard against such behavior.

Environment
*	Kernel: 6.6.0 (openEuler 24.03 LTS SP4 baseline)
*	Hardware: Intel Xeon Gold 5220R / Mellanox ConnectX-5 (MT27800, FW: 26.01=
-1.0.0)
*	Storage: Huawei OceanStor Dorado (NVMe over RoCEv2)
*	Configuration: nvme_core.multipath=3DN, dm-multipath enabled.
*	Fabric Parameters: reconnect_delay =3D 10, ctrl_loss_tmo =3D 600 (or ctrl=
_loss_tmo =3D 10 for testing)

Problem Description & Observations
When we manually inject a link fault on one of the paths and restart multip=
athd, the multipathd process gets stuck in the D state (the path detection =
I/O does not return). Application I/O hangs for a very long time due to a r=
equeue ping-pong loop.
1.	The Requeue Ping-Pong: After the link goes down, the NVMe controller tra=
nsitions to the NVME_CTRL_CONNECTING state. During this time, nvme_fail_non=
ready_command() returns BLK_STS_RESOURCE. Upon receiving this, the block la=
yer (blk-mq) immediately requeues the request. This causes the I/O to endle=
ssly "ping-pong" between the block layer and nvme-core.
2.	Abnormal Retry Interval: Based on ctrl_loss_tmo / reconnect_delay =3D 60=
0 / 10, the subsystem is expected to retry 60 times. However, the actual me=
asured interval between two consecutive retries is stretched to 288s - 290s=
, completely ignoring the configured reconnect_delay =3D 10. The total hang=
 time reaches 17,340 seconds (~4.8 hours).
3.	Single Retry Test: To isolate the issue, we set ctrl_loss_tmo =3D 10 (wh=
ich triggers only 1 retry before tearing down the controller). Even in this=
 case, the I/O still HANGS for exactly ~290 seconds. This indicates that th=
e problem is not cumulative retry multiplication, but rather that the very =
first reconnect attempt or the single reconnect worker itself is being bloc=
ked/delayed internally for ~290 seconds by the underlying driver stack.

In-box Driver Contrast
If we switch back to the kernel in-box (mainline upstream) mlx5 driver, thi=
s issue DOES NOT occur. The NVMe controller status updates rapidly upon lin=
k failure, and failover finishes within seconds. This further confirms that=
 the 290-second blocking behavior is specific to the DOCA driver stack.

Technical Consultation
The most appropriate solution is for the vendor to fix this issue within th=
eir driver. However, if the vendor driver cannot technically resolve it, ar=
e there any potential optimization mechanisms within the block layer or the=
 multipath subsystem to mitigate this?
For example:
1.	Block Layer: During the NVME_CTRL_CONNECTING state, if requests continuo=
usly receive BLK_STS_RESOURCE, should the block layer introduce an exponent=
ial backoff mechanism or a maximum retry threshold? Blindly requeuing these=
 requests seems to create an infinite loop that leaves the system vulnerabl=
e to worker starvation or long hangs if the underlying driver blocks.
2.	Multipath Subsystem: The multipath subsystem's path detection mechanism =
for NVMe devices could be optimized. I believe that path-checking I/Os (suc=
h as those sent by multipathd to verify link sanity) should not be allowed =
to retry indefinitely under these conditions, as it completely stalls the f=
ailover process.

Any insights or architectural suggestions on how the block layer can better=
 handle or guard against such non-responsive driver behavior would be great=
ly appreciated.

Thanks.
