Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75201E1E16;
	Fri, 31 Jul 2026 09:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785488765; cv=none; b=Gn3VpJYhJTrsVylxm/2AYReVzCBsuW7dV9Tw/25gql9tmF8gy0Jlr+jIN3zarOQ2954BPf0l0UsE5gA9PeXiJc8/M8I6IqKwmqgcfQTO+Ob6Fdi3F8jxFRqQIx8hXCZtvgCeoJagBACiKx0M+Jzc+Hl8MatZXfmfVx55iedAoQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785488765; c=relaxed/simple;
	bh=Ev1y73HMQxcjOJewZg1xIAm73TkstDSbGtZIQryKITA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=W/QEI9Anjyked8VUVM6/6zALH3WuvwzsrZHkyTP8JCQ6qdIWrAlGb9yEKA8PQTMdNLANuyHn7k/oeVkfLwhpc+gvw/mm/1l4Melerow7P9Tdqo+zcOuWncaSNrJw348qJwZUGuvefP4ZNmoAeyG+PU7Q/bMJ7BZnwBxXb87DRhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=dDrBLYAD; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="dDrBLYAD"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FCnD8HhiyEh89ns5UhN33t7orzSOTTYZxYEgBomh0Hs=;
	b=dDrBLYADXJQAI9/9O973dj0Se9e/I4ZGZXSCxVTpQy6Wdl9VksZ19QYOuqoaYDwkVsb91t7Pt
	7x+1n5S/XRn99ae425km6N6s/H7pfaasz5jsT+CwzFGbp3MferQdd5hBjP4wZnzVT6DFJr75i5M
	uWeCGKSk5B3casPK/J2tnnM=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hBKgK3n7gzKmT0;
	Fri, 31 Jul 2026 16:56:29 +0800 (CST)
Received: from dggpemf500014.china.huawei.com (unknown [7.185.36.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 3B6A940578;
	Fri, 31 Jul 2026 17:06:00 +0800 (CST)
Received: from kwepemq500011.china.huawei.com (7.202.194.193) by
 dggpemf500014.china.huawei.com (7.185.36.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 31 Jul 2026 17:05:59 +0800
Received: from kwepemq500011.china.huawei.com ([7.202.194.193]) by
 kwepemq500011.china.huawei.com ([7.202.194.193]) with mapi id 15.02.1544.011;
 Fri, 31 Jul 2026 17:05:59 +0800
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
Thread-Index: Ad0gyUmfi0U9GU79ScORZ1StAXp+DA==
Date: Fri, 31 Jul 2026 09:05:59 +0000
Message-ID: <e14fd710216b4742be966d98df303cc1@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
Content-Type: multipart/mixed;
	boundary="_004_e14fd710216b4742be966d98df303cc1huaweicom_"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

--_004_e14fd710216b4742be966d98df303cc1huaweicom_
Content-Type: multipart/alternative;
	boundary="_000_e14fd710216b4742be966d98df303cc1huaweicom_"

--_000_e14fd710216b4742be966d98df303cc1huaweicom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

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

  *   Kernel: 6.6.0 (openEuler 24.03 LTS SP4 baseline)
  *   Hardware: Intel Xeon Gold 5220R / Mellanox ConnectX-5 (MT27800, FW: 2=
6.01-1.0.0)
  *   Storage: Huawei OceanStor Dorado (NVMe over RoCEv2)
  *   Configuration: nvme_core.multipath=3DN, dm-multipath enabled.
  *   Fabric Parameters: reconnect_delay =3D 10, ctrl_loss_tmo =3D 600 (or =
ctrl_loss_tmo =3D 10 for testing)

Problem Description & Observations
When we manually inject a link fault on one of the paths and restart multip=
athd, the multipathd process gets stuck in the D state (the path detection =
I/O does not return). Application I/O hangs for a very long time due to a r=
equeue ping-pong loop.

  1.  The Requeue Ping-Pong: After the link goes down, the NVMe controller =
transitions to the NVME_CTRL_CONNECTING state. During this time, nvme_fail_=
nonready_command() returns BLK_STS_RESOURCE. Upon receiving this, the block=
 layer (blk-mq) immediately requeues the request. This causes the I/O to en=
dlessly "ping-pong" between the block layer and nvme-core.
  2.  Abnormal Retry Interval: Based on ctrl_loss_tmo / reconnect_delay =3D=
 600 / 10, the subsystem is expected to retry 60 times. However, the actual=
 measured interval between two consecutive retries is stretched to 288s - 2=
90s, completely ignoring the configured reconnect_delay =3D 10. The total h=
ang time reaches 17,340 seconds (~4.8 hours).
  3.  Single Retry Test: To isolate the issue, we set ctrl_loss_tmo =3D 10 =
(which triggers only 1 retry before tearing down the controller). Even in t=
his case, the I/O still HANGS for exactly ~290 seconds. This indicates that=
 the problem is not cumulative retry multiplication, but rather that the ve=
ry first reconnect attempt or the single reconnect worker itself is being b=
locked/delayed internally for ~290 seconds by the underlying driver stack.

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

  1.  Block Layer: During the NVME_CTRL_CONNECTING state, if requests conti=
nuously receive BLK_STS_RESOURCE, should the block layer introduce an expon=
ential backoff mechanism or a maximum retry threshold? Blindly requeuing th=
ese requests seems to create an infinite loop that leaves the system vulner=
able to worker starvation or long hangs if the underlying driver blocks.
  2.  Multipath Subsystem: The multipath subsystem's path detection mechani=
sm for NVMe devices could be optimized. I believe that path-checking I/Os (=
such as those sent by multipathd to verify link sanity) should not be allow=
ed to retry indefinitely under these conditions, as it completely stalls th=
e failover process.

Any insights or architectural suggestions on how the block layer can better=
 handle or guard against such non-responsive driver behavior would be great=
ly appreciated.

Thanks.

--_000_e14fd710216b4742be966d98df303cc1huaweicom_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
	font-family:DengXian;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:DengXian;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:DengXian;}
/* Page Definitions */
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.WordSection1
	{page:WordSection1;}
/* List Definitions */
@list l0
	{mso-list-id:351490580;
	mso-list-template-ids:202003518;}
@list l1
	{mso-list-id:551113629;
	mso-list-template-ids:-786950274;}
@list l2
	{mso-list-id:655576772;
	mso-list-template-ids:-371145458;}
@list l2:level1
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:36.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Symbol;}
@list l2:level2
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:72.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:"Courier New";
	mso-bidi-font-family:"Times New Roman";}
@list l2:level3
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:108.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l2:level4
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:144.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l2:level5
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:180.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l2:level6
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:216.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l2:level7
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:252.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l2:level8
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:288.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l2:level9
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:324.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l3
	{mso-list-id:912667249;
	mso-list-template-ids:-1611339012;}
@list l3:level1
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:36.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Symbol;}
@list l3:level3
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:108.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l3:level4
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:144.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l3:level5
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:180.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l3:level6
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:216.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l3:level7
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:252.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l3:level8
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:288.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l3:level9
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:324.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l4
	{mso-list-id:1224219150;
	mso-list-type:hybrid;
	mso-list-template-ids:649337060 793951382 67698713 67698715 67698703 67698=
713 67698715 67698703 67698713 67698715;}
@list l4:level1
	{mso-level-text:%1\3001;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:66.0pt;
	text-indent:-36.0pt;
	mso-ascii-font-family:Arial;
	mso-fareast-font-family:SimSun;
	mso-hansi-font-family:Arial;
	mso-bidi-font-family:Arial;}
@list l4:level2
	{mso-level-number-format:alpha-lower;
	mso-level-text:"%2\)";
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-21.0pt;}
@list l4:level3
	{mso-level-number-format:roman-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:right;
	margin-left:93.0pt;
	text-indent:-21.0pt;}
@list l4:level4
	{mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:114.0pt;
	text-indent:-21.0pt;}
@list l4:level5
	{mso-level-number-format:alpha-lower;
	mso-level-text:"%5\)";
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:135.0pt;
	text-indent:-21.0pt;}
@list l4:level6
	{mso-level-number-format:roman-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:right;
	margin-left:156.0pt;
	text-indent:-21.0pt;}
@list l4:level7
	{mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:177.0pt;
	text-indent:-21.0pt;}
@list l4:level8
	{mso-level-number-format:alpha-lower;
	mso-level-text:"%8\)";
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:198.0pt;
	text-indent:-21.0pt;}
@list l4:level9
	{mso-level-number-format:roman-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:right;
	margin-left:219.0pt;
	text-indent:-21.0pt;}
@list l5
	{mso-list-id:1679847525;
	mso-list-template-ids:1352068588;}
@list l5:level1
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:36.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Symbol;}
@list l5:level2
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:72.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:"Courier New";
	mso-bidi-font-family:"Times New Roman";}
@list l5:level3
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:108.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l5:level4
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:144.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l5:level5
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:180.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l5:level6
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:216.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l5:level7
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:252.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l5:level8
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:288.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l5:level9
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:324.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l6
	{mso-list-id:1964190781;
	mso-list-template-ids:-818793726;}
ol
	{margin-bottom:0cm;}
ul
	{margin-bottom:0cm;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"ZH-CN" link=3D"#0563C1" vlink=3D"#954F72" style=3D"word-wrap:=
break-word;text-justify-trim:punctuation">
<div class=3D"WordSection1">
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-ser=
if">Hi all,<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-ser=
if">We encountered a severe I/O hang issue during NVMe-oF (RoCEv2) link fai=
lure when native multipath is disabled and dm-multipath
 is used instead.<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-ser=
if">Based on our test results, this issue is highly likely located within t=
he reconnect/backoff mechanism of the vendor's out-of-tree
 driver (NVIDIA DOCA-Host 3.3.0). The attachment contains the logs captured=
 when the fault occurs.<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-ser=
if">We look forward to the vendor analyzing this driver-side issue, but we =
would also like to seek advice from community experts
 regarding potential optimization suggestions for the block layer and NVMe-=
oF (NOF) collaboration mechanisms to guard against such behavior.<o:p></o:p=
></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-ser=
if"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><b><span la=
ng=3D"EN-US" style=3D"font-size:15.0pt;font-family:&quot;Arial&quot;,sans-s=
erif">Environment<o:p></o:p></span></b></p>
<ul style=3D"margin-top:0cm" type=3D"disc">
<li class=3D"MsoNormal" style=3D"text-align:left;mso-list:l5 level1 lfo5"><=
span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&quot;=
,sans-serif">Kernel: 6.6.0 (openEuler 24.03 LTS SP4 baseline)<o:p></o:p></s=
pan></li><li class=3D"MsoNormal" style=3D"text-align:left;mso-list:l5 level=
1 lfo5"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Ar=
ial&quot;,sans-serif">Hardware: Intel Xeon Gold 5220R / Mellanox ConnectX-5=
 (MT27800, FW: 26.01-1.0.0)<o:p></o:p></span></li><li class=3D"MsoNormal" s=
tyle=3D"text-align:left;mso-list:l5 level1 lfo5"><span lang=3D"EN-US" style=
=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif">Storage: Hua=
wei OceanStor Dorado (NVMe over RoCEv2)<o:p></o:p></span></li><li class=3D"=
MsoNormal" style=3D"text-align:left;mso-list:l5 level1 lfo5"><span lang=3D"=
EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif">=
Configuration:
</span><span lang=3D"EN-US" style=3D"font-family:&quot;Courier New&quot;">n=
vme_core.multipath=3DN</span><span lang=3D"EN-US" style=3D"font-size:12.0pt=
;font-family:&quot;Arial&quot;,sans-serif">,
</span><span lang=3D"EN-US" style=3D"font-family:&quot;Courier New&quot;">d=
m-multipath</span><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-famil=
y:&quot;Arial&quot;,sans-serif"> enabled.<o:p></o:p></span></li><li class=
=3D"MsoNormal" style=3D"text-align:left;mso-list:l5 level1 lfo5"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-ser=
if">Fabric Parameters:
</span><span lang=3D"EN-US" style=3D"font-family:&quot;Courier New&quot;">r=
econnect_delay =3D 10</span><span lang=3D"EN-US" style=3D"font-size:12.0pt;=
font-family:&quot;Arial&quot;,sans-serif">,
</span><span lang=3D"EN-US" style=3D"font-family:&quot;Courier New&quot;">c=
trl_loss_tmo =3D 600</span><span lang=3D"EN-US" style=3D"font-size:12.0pt;f=
ont-family:&quot;Arial&quot;,sans-serif"> (or
</span><span lang=3D"EN-US" style=3D"font-family:&quot;Courier New&quot;">c=
trl_loss_tmo =3D 10</span><span lang=3D"EN-US" style=3D"font-size:12.0pt;fo=
nt-family:&quot;Arial&quot;,sans-serif"> for testing)<o:p></o:p></span></li=
></ul>
<p class=3D"MsoNormal" align=3D"left" style=3D"margin-left:36.0pt;text-alig=
n:left"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Ar=
ial&quot;,sans-serif"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><b><span la=
ng=3D"EN-US" style=3D"font-size:15.0pt;font-family:&quot;Arial&quot;,sans-s=
erif">Problem Description &amp; Observations<o:p></o:p></span></b></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-ser=
if">When we manually inject a link fault on one of the paths and restart
</span><span lang=3D"EN-US" style=3D"font-family:&quot;Courier New&quot;">m=
ultipathd</span><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:=
&quot;Arial&quot;,sans-serif">, the
</span><span lang=3D"EN-US" style=3D"font-family:&quot;Courier New&quot;">m=
ultipathd</span><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:=
&quot;Arial&quot;,sans-serif"> process gets stuck in the D state (the path =
detection I/O does not return). Application I/O hangs for a
 very long time due to a requeue ping-pong loop.<o:p></o:p></span></p>
<ol style=3D"margin-top:0cm" start=3D"1" type=3D"1">
<li class=3D"MsoNormal" style=3D"text-align:left;mso-list:l0 level1 lfo6"><=
b><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&qu=
ot;,sans-serif">The Requeue Ping-Pong:</span></b><span lang=3D"EN-US" style=
=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif">
 After the link goes down, the NVMe controller transitions to the </span><s=
pan lang=3D"EN-US" style=3D"font-family:&quot;Courier New&quot;">NVME_CTRL_=
CONNECTING</span><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family=
:&quot;Arial&quot;,sans-serif"> state. During this time,
</span><span lang=3D"EN-US" style=3D"font-family:&quot;Courier New&quot;">n=
vme_fail_nonready_command()</span><span lang=3D"EN-US" style=3D"font-size:1=
2.0pt;font-family:&quot;Arial&quot;,sans-serif"> returns
</span><span lang=3D"EN-US" style=3D"font-family:&quot;Courier New&quot;">B=
LK_STS_RESOURCE</span><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-f=
amily:&quot;Arial&quot;,sans-serif">. Upon receiving this, the block layer =
(</span><span lang=3D"EN-US" style=3D"font-family:&quot;Courier New&quot;">=
blk-mq</span><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:&qu=
ot;Arial&quot;,sans-serif">)
 immediately requeues the request. This causes the I/O to endlessly &quot;p=
ing-pong&quot; between the block layer and nvme-core.<o:p></o:p></span></li=
><li class=3D"MsoNormal" style=3D"text-align:left;mso-list:l0 level1 lfo6">=
<b><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&q=
uot;,sans-serif">Abnormal Retry Interval:</span></b><span lang=3D"EN-US" st=
yle=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif">
 Based on </span><span lang=3D"EN-US" style=3D"font-family:&quot;Courier Ne=
w&quot;">ctrl_loss_tmo / reconnect_delay =3D 600 / 10</span><span lang=3D"E=
N-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif">,=
 the subsystem is expected to retry 60 times. However, the actual
 measured interval between two consecutive retries is stretched to <b>288s =
- 290s</b>, completely ignoring the configured
</span><span lang=3D"EN-US" style=3D"font-family:&quot;Courier New&quot;">r=
econnect_delay =3D 10</span><span lang=3D"EN-US" style=3D"font-size:12.0pt;=
font-family:&quot;Arial&quot;,sans-serif">. The total hang time reaches 17,=
340 seconds (~4.8 hours).<o:p></o:p></span></li><li class=3D"MsoNormal" sty=
le=3D"text-align:left;mso-list:l0 level1 lfo6"><b><span lang=3D"EN-US" styl=
e=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif">Single Retr=
y Test:</span></b><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-famil=
y:&quot;Arial&quot;,sans-serif"> To isolate
 the issue, we set </span><span lang=3D"EN-US" style=3D"font-family:&quot;C=
ourier New&quot;">ctrl_loss_tmo =3D 10</span><span lang=3D"EN-US" style=3D"=
font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif"> (which triggers=
 only 1 retry before tearing down the controller). Even in this
 case, the I/O still HANGS for exactly ~290 seconds. This indicates that th=
e problem is not cumulative retry multiplication, but rather that the
<b>very first reconnect attempt or the single reconnect worker itself is be=
ing blocked/delayed internally for ~290 seconds</b> by the underlying drive=
r stack.<o:p></o:p></span></li></ol>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><b><span la=
ng=3D"EN-US" style=3D"font-size:15.0pt;font-family:&quot;Arial&quot;,sans-s=
erif"><o:p>&nbsp;</o:p></span></b></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><b><span la=
ng=3D"EN-US" style=3D"font-size:15.0pt;font-family:&quot;Arial&quot;,sans-s=
erif">In-box Driver Contrast<o:p></o:p></span></b></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-ser=
if">If we switch back to the kernel
<b>in-box (mainline upstream) mlx5 driver</b>, this issue <b>DOES NOT</b> o=
ccur. The NVMe controller status updates rapidly upon link failure, and fai=
lover finishes within seconds. This further confirms that the 290-second bl=
ocking behavior is specific to the
 DOCA driver stack.<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-ser=
if"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><b><span la=
ng=3D"EN-US" style=3D"font-size:15.0pt;font-family:&quot;Arial&quot;,sans-s=
erif">Technical Consultation<o:p></o:p></span></b></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-ser=
if">The most appropriate solution is for the vendor to fix this issue withi=
n their driver. However, if the vendor driver cannot
 technically resolve it, are there any potential optimization mechanisms wi=
thin the block layer or the multipath subsystem to mitigate this?<o:p></o:p=
></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-ser=
if">For example:<o:p></o:p></span></p>
<ol style=3D"margin-top:0cm" start=3D"1" type=3D"1">
<li class=3D"MsoNormal" style=3D"text-align:left;mso-list:l6 level1 lfo7"><=
b><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&qu=
ot;,sans-serif">Block Layer:</span></b><span lang=3D"EN-US" style=3D"font-s=
ize:12.0pt;font-family:&quot;Arial&quot;,sans-serif"> During the
</span><span lang=3D"EN-US" style=3D"font-family:&quot;Courier New&quot;">N=
VME_CTRL_CONNECTING</span><span lang=3D"EN-US" style=3D"font-size:12.0pt;fo=
nt-family:&quot;Arial&quot;,sans-serif"> state, if requests continuously re=
ceive
</span><span lang=3D"EN-US" style=3D"font-family:&quot;Courier New&quot;">B=
LK_STS_RESOURCE</span><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-f=
amily:&quot;Arial&quot;,sans-serif">, should the block layer introduce an e=
xponential backoff mechanism or a maximum retry threshold? Blindly
 requeuing these requests seems to create an infinite loop that leaves the =
system vulnerable to worker starvation or long hangs if the underlying driv=
er blocks.<o:p></o:p></span></li><li class=3D"MsoNormal" style=3D"text-alig=
n:left;mso-list:l6 level1 lfo7"><b><span lang=3D"EN-US" style=3D"font-size:=
12.0pt;font-family:&quot;Arial&quot;,sans-serif">Multipath Subsystem:</span=
></b><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial=
&quot;,sans-serif"> The
 multipath subsystem's path detection mechanism for NVMe devices could be o=
ptimized. I believe that path-checking I/Os (such as those sent by
</span><span lang=3D"EN-US" style=3D"font-family:&quot;Courier New&quot;">m=
ultipathd</span><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:=
&quot;Arial&quot;,sans-serif"> to verify link sanity) should not be allowed=
 to retry indefinitely under these conditions, as it completely
 stalls the failover process.<o:p></o:p></span></li></ol>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-ser=
if"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:&quot;Arial&quot;,sans-ser=
if">Any insights or architectural suggestions on how the block layer can be=
tter handle or guard against such non-responsive driver
 behavior would be greatly appreciated.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:&quot;Arial&quot;,sans-serif"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:&quot;Arial&quot;,sans-serif">Thanks.<o:p></o:p></span></p>
</div>
</body>
</html>

--_000_e14fd710216b4742be966d98df303cc1huaweicom_--

--_004_e14fd710216b4742be966d98df303cc1huaweicom_
Content-Type: text/plain; name="log.txt"
Content-Description: log.txt
Content-Disposition: attachment; filename="log.txt"; size=6970;
	creation-date="Fri, 31 Jul 2026 08:16:00 GMT";
	modification-date="Fri, 31 Jul 2026 08:16:00 GMT"
Content-Transfer-Encoding: base64

U3VuIEp1biAgNyAxODo1NDozNSAyMDI2IG52bWUgbnZtZTI6IHVucmVhY2hhYmxlICg3KTogc3Rh
dHVzIC0xMTAgaWQgMDAwMDAwMDBmYzExMDI4Ng0KU3VuIEp1biAgNyAxODo1NDozNSAyMDI2IG52
bWUgbnZtZTI6IENNIGVycm9yIGV2ZW50IDcNClN1biBKdW4gIDcgMTg6NTQ6MzUgMjAyNiBudm1l
IG52bWUyOiByZG1hIGNvbm5lY3Rpb24gZXN0YWJsaXNobWVudCBmYWlsZWQgKC0xMDQpDQpTdW4g
SnVuICA3IDE4OjU0OjM1IDIwMjYgbnZtZSBudm1lMjogRmFpbGVkIHJlY29ubmVjdCBhdHRlbXB0
IDEvNjANClN1biBKdW4gIDcgMTg6NTQ6MzUgMjAyNiBudm1lIG52bWUyOiBSZWNvbm5lY3Rpbmcg
aW4gMTAgc2Vjb25kcy4uLg0KU3VuIEp1biAgNyAxODo1NDo0NSAyMDI2IG52bWUgbnZtZTI6IGFk
ZHJlc3MgcmVzb2x2ZWQgKDApOiBzdGF0dXMgMCBpZCAwMDAwMDAwMDZjNDE3OTJhDQpTdW4gSnVu
ICA3IDE4OjU0OjQ1IDIwMjYgbnZtZSBudm1lMjogcm91dGUgcmVzb2x2ZWQgKDIpOiBzdGF0dXMg
MCBpZCAwMDAwMDAwMDZjNDE3OTJhDQpTdW4gSnVuICA3IDE4OjU1OjIwIDIwMjYgaW5maW5pYmFu
ZCBtbHg1XzA6IHBvbGxfc29mdF93Yzo2MDA6KHBpZCAzOTMpOiBwb2xsZWQgc29mdHdhcmUgZ2Vu
ZXJhdGVkIGNvbXBsZXRpb24gb24gQ1EgMHg0MDENClN1biBKdW4gIDcgMTg6NTU6NTUgMjAyNiBp
bmZpbmliYW5kIG1seDVfMDogcG9sbF9zb2Z0X3djOjYwMDoocGlkIDM5Myk6IHBvbGxlZCBzb2Z0
d2FyZSBnZW5lcmF0ZWQgY29tcGxldGlvbiBvbiBDUSAweDQwMQ0KU3VuIEp1biAgNyAxODo1Njox
MiAyMDI2IGluZmluaWJhbmQgbWx4NV8wOiBwb2xsX3NvZnRfd2M6NjAwOihwaWQgMzkzKTogcG9s
bGVkIHNvZnR3YXJlIGdlbmVyYXRlZCBjb21wbGV0aW9uIG9uIENRIDB4NDAxDQpTdW4gSnVuICA3
IDE4OjU2OjMwIDIwMjYgaW5maW5pYmFuZCBtbHg1XzA6IHBvbGxfc29mdF93Yzo2MDA6KHBpZCAz
OTMpOiBwb2xsZWQgc29mdHdhcmUgZ2VuZXJhdGVkIGNvbXBsZXRpb24gb24gQ1EgMHg0MDENClN1
biBKdW4gIDcgMTg6NTY6NDcgMjAyNiBpbmZpbmliYW5kIG1seDVfMDogcG9sbF9zb2Z0X3djOjYw
MDoocGlkIDM5Myk6IHBvbGxlZCBzb2Z0d2FyZSBnZW5lcmF0ZWQgY29tcGxldGlvbiBvbiBDUSAw
eDQwMQ0KU3VuIEp1biAgNyAxODo1NzowNCAyMDI2IGluZmluaWJhbmQgbWx4NV8wOiBwb2xsX3Nv
ZnRfd2M6NjAwOihwaWQgMzkzKTogcG9sbGVkIHNvZnR3YXJlIGdlbmVyYXRlZCBjb21wbGV0aW9u
IG9uIENRIDB4NDAxDQpTdW4gSnVuICA3IDE4OjU3OjIyIDIwMjYgaW5maW5pYmFuZCBtbHg1XzA6
IHBvbGxfc29mdF93Yzo2MDA6KHBpZCAzOTMpOiBwb2xsZWQgc29mdHdhcmUgZ2VuZXJhdGVkIGNv
bXBsZXRpb24gb24gQ1EgMHg0MDENClN1biBKdW4gIDcgMTg6NTc6MzkgMjAyNiBpbmZpbmliYW5k
IG1seDVfMDogcG9sbF9zb2Z0X3djOjYwMDoocGlkIDM5Myk6IHBvbGxlZCBzb2Z0d2FyZSBnZW5l
cmF0ZWQgY29tcGxldGlvbiBvbiBDUSAweDQwMQ0KU3VuIEp1biAgNyAxODo1Nzo1NyAyMDI2IGlu
ZmluaWJhbmQgbWx4NV8wOiBwb2xsX3NvZnRfd2M6NjAwOihwaWQgMzkzKTogcG9sbGVkIHNvZnR3
YXJlIGdlbmVyYXRlZCBjb21wbGV0aW9uIG9uIENRIDB4NDAxDQpTdW4gSnVuICA3IDE4OjU4OjE0
IDIwMjYgaW5maW5pYmFuZCBtbHg1XzA6IHBvbGxfc29mdF93Yzo2MDA6KHBpZCAzOTMpOiBwb2xs
ZWQgc29mdHdhcmUgZ2VuZXJhdGVkIGNvbXBsZXRpb24gb24gQ1EgMHg0MDENClN1biBKdW4gIDcg
MTg6NTg6MzEgMjAyNiBpbmZpbmliYW5kIG1seDVfMDogcG9sbF9zb2Z0X3djOjYwMDoocGlkIDM5
Myk6IHBvbGxlZCBzb2Z0d2FyZSBnZW5lcmF0ZWQgY29tcGxldGlvbiBvbiBDUSAweDQwMQ0KU3Vu
IEp1biAgNyAxODo1ODo0OSAyMDI2IGluZmluaWJhbmQgbWx4NV8wOiBwb2xsX3NvZnRfd2M6NjAw
OihwaWQgMzkzKTogcG9sbGVkIHNvZnR3YXJlIGdlbmVyYXRlZCBjb21wbGV0aW9uIG9uIENRIDB4
NDAxDQpTdW4gSnVuICA3IDE4OjU5OjA2IDIwMjYgaW5maW5pYmFuZCBtbHg1XzA6IHBvbGxfc29m
dF93Yzo2MDA6KHBpZCAzOTMpOiBwb2xsZWQgc29mdHdhcmUgZ2VuZXJhdGVkIGNvbXBsZXRpb24g
b24gQ1EgMHg0MDENClN1biBKdW4gIDcgMTg6NTk6MTMgMjAyNiBmc25vdGlmeV9pbnNlcnRfZXZl
bnQ6IDI4OTcgY2FsbGJhY2tzIHN1cHByZXNzZWQNClN1biBKdW4gIDcgMTg6NTk6MTMgMjAyNiBw
aWQ9MjM3OTYwOSBjbWQ6cHl0aG9uMyBxX2xlbj0xNjM4NSBtYXhfZXZlbnRzPTE2Mzg0DQpTdW4g
SnVuICA3IDE4OjU5OjI0IDIwMjYgV2FybmluZzogYXQgZnNub3RpZnlfaW5zZXJ0X2V2ZW50LCBv
dmVyZmxvdyBldmVudCBvciBncm91cC0+bWF4X2V2ZW50cyByZWFjaGVkDQpTdW4gSnVuICA3IDE4
OjU5OjI0IDIwMjYgbnZtZSBudm1lMjogdW5yZWFjaGFibGUgKDcpOiBzdGF0dXMgLTExMCBpZCAw
MDAwMDAwMDZjNDE3OTJhDQpTdW4gSnVuICA3IDE4OjU5OjI0IDIwMjYgbnZtZSBudm1lMjogQ00g
ZXJyb3IgZXZlbnQgNw0KU3VuIEp1biAgNyAxODo1OToyNCAyMDI2IG52bWUgbnZtZTI6IHJkbWEg
Y29ubmVjdGlvbiBlc3RhYmxpc2htZW50IGZhaWxlZCAoLTEwNCkNClN1biBKdW4gIDcgMTg6NTk6
MjQgMjAyNiBudm1lIG52bWUyOiBGYWlsZWQgcmVjb25uZWN0IGF0dGVtcHQgMi82MA0KU3VuIEp1
biAgNyAxODo1OToyNCAyMDI2IG52bWUgbnZtZTI6IFJlY29ubmVjdGluZyBpbiAxMCBzZWNvbmRz
Li4uDQpTdW4gSnVuICA3IDE4OjU5OjM0IDIwMjYgbnZtZSBudm1lMjogYWRkcmVzcyByZXNvbHZl
ZCAoMCk6IHN0YXR1cyAwIGlkIDAwMDAwMDAwNzVmYWQ3YjENClN1biBKdW4gIDcgMTg6NTk6MzQg
MjAyNiBudm1lIG52bWUyOiByb3V0ZSByZXNvbHZlZCAoMik6IHN0YXR1cyAwIGlkIDAwMDAwMDAw
NzVmYWQ3YjENClN1biBKdW4gIDcgMTg6NTk6MzQgMjAyNiBpbmZpbmliYW5kIG1seDVfMDogY2Fs
YyBjcV9zaXplOjc0NzoocGlkIDgxODk0Myk6IHdxZSBzaXplIDI1Ng0KU3VuIEp1biAgNyAxODo1
OTozNCAyMDI2IGluZmluaWJhbmQgbWx4NV8wOiBjcmVhdGUgcXA6MzMyODoocGlkIDgxODk0Myk6
IFFQIHR5cGUgMiwgaWIgcXBuIDB4QzgsIG1seCBxcG4gMHhDOCwgcmNxbiAweDRjYywgc2NxbiAw
eDRjYywgZWNlIDB4MA0KU3VuIEp1biAgNyAxODo1OTo1MSAyMDI2IGluZmluaWJhbmQgbWx4NV8w
OiBwb2xsX3NvZnRfd2M6NjAwOihwaWQgMzkzKTogcG9sbGVkIHNvZnR3YXJlIGdlbmVyYXRlZCBj
b21wbGV0aW9uIG9uIENRIDB4NDAxDQpTdW4gSnVuICA3IDE4OjU5OjUxIDIwMjYgaW5maW5pYmFu
ZCBtbHg1XzA6IHBvbGxfc29mdF93Yzo2MDA6KHBpZCAzOTMpOiBwb2xsZWQgc29mdHdhcmUgZ2Vu
ZXJhdGVkIGNvbXBsZXRpb24gb24gQ1EgMHg0MDENClN1biBKdW4gIDcgMTk6MDA6MDggMjAyNiBp
bmZpbmliYW5kIG1seDVfMDogcG9sbF9zb2Z0X3djOjYwMDoocGlkIDM5Myk6IHBvbGxlZCBzb2Z0
d2FyZSBnZW5lcmF0ZWQgY29tcGxldGlvbiBvbiBDUSAweDQwMQ0KU3VuIEp1biAgNyAxOTowMDoy
NiAyMDI2IGluZmluaWJhbmQgbWx4NV8wOiBwb2xsX3NvZnRfd2M6NjAwOihwaWQgMzkzKTogcG9s
bGVkIHNvZnR3YXJlIGdlbmVyYXRlZCBjb21wbGV0aW9uIG9uIENRIDB4NDAxDQpTdW4gSnVuICA3
IDE5OjAwOjQ0IDIwMjYgaW5maW5pYmFuZCBtbHg1XzA6IHBvbGxfc29mdF93Yzo2MDA6KHBpZCAz
OTMpOiBwb2xsZWQgc29mdHdhcmUgZ2VuZXJhdGVkIGNvbXBsZXRpb24gb24gQ1EgMHg0MDENClN1
biBKdW4gIDcgMTk6MDE6MDEgMjAyNiBpbmZpbmliYW5kIG1seDVfMDogcG9sbF9zb2Z0X3djOjYw
MDoocGlkIDM5Myk6IHBvbGxlZCBzb2Z0d2FyZSBnZW5lcmF0ZWQgY29tcGxldGlvbiBvbiBDUSAw
eDQwMQ0KU3VuIEp1biAgNyAxOTowMTowMyAyMDI2IChrd29ya2VyLzE6MiwyMjM0MTcyLDEpOm8y
bmV0X3NjYW5fZGVsX3dvcms6NDc4MSBvMm5ldDogZGVsZXRlIHRoZSBzZXEgbnVtIHdoaWNoIGlz
IG92ZXIgMiBob3Vycw0KU3VuIEp1biAgNyAxOTowMToxOCAyMDI2IGluZmluaWJhbmQgbWx4NV8w
OiBwb2xsX3NvZnRfd2M6NjAwOihwaWQgMzkzKTogcG9sbGVkIHNvZnR3YXJlIGdlbmVyYXRlZCBj
b21wbGV0aW9uIG9uIENRIDB4NDAxDQpTdW4gSnVuICA3IDE5OjAxOjM2IDIwMjYgaW5maW5pYmFu
ZCBtbHg1XzA6IHBvbGxfc29mdF93Yzo2MDA6KHBpZCAzOTMpOiBwb2xsZWQgc29mdHdhcmUgZ2Vu
ZXJhdGVkIGNvbXBsZXRpb24gb24gQ1EgMHg0MDENClN1biBKdW4gIDcgMTk6MDE6NTMgMjAyNiBp
bmZpbmliYW5kIG1seDVfMDogcG9sbF9zb2Z0X3djOjYwMDoocGlkIDM5Myk6IHBvbGxlZCBzb2Z0
d2FyZSBnZW5lcmF0ZWQgY29tcGxldGlvbiBvbiBDUSAweDQwMQ0KU3VuIEp1biAgNyAxOTowMjox
MSAyMDI2IGluZmluaWJhbmQgbWx4NV8wOiBwb2xsX3NvZnRfd2M6NjAwOihwaWQgMzkzKTogcG9s
bGVkIHNvZnR3YXJlIGdlbmVyYXRlZCBjb21wbGV0aW9uIG9uIENRIDB4NDAxDQpTdW4gSnVuICA3
IDE5OjAyOjI4IDIwMjYgaW5maW5pYmFuZCBtbHg1XzA6IHBvbGxfc29mdF93Yzo2MDA6KHBpZCAz
OTMpOiBwb2xsZWQgc29mdHdhcmUgZ2VuZXJhdGVkIGNvbXBsZXRpb24gb24gQ1EgMHg0MDENClN1
biBKdW4gIDcgMTk6MDI6NDUgMjAyNiBpbmZpbmliYW5kIG1seDVfMDogcG9sbF9zb2Z0X3djOjYw
MDoocGlkIDM5Myk6IHBvbGxlZCBzb2Z0d2FyZSBnZW5lcmF0ZWQgY29tcGxldGlvbiBvbiBDUSAw
eDQwMQ0KU3VuIEp1biAgNyAxOTowMzowMyAyMDI2IGluZmluaWJhbmQgbWx4NV8wOiBwb2xsX3Nv
ZnRfd2M6NjAwOihwaWQgMzkzKTogcG9sbGVkIHNvZnR3YXJlIGdlbmVyYXRlZCBjb21wbGV0aW9u
IG9uIENRIDB4NDAxDQpTdW4gSnVuICA3IDE5OjAzOjIwIDIwMjYgaW5maW5pYmFuZCBtbHg1XzA6
IHBvbGxfc29mdF93Yzo2MDA6KHBpZCAzOTMpOiBwb2xsZWQgc29mdHdhcmUgZ2VuZXJhdGVkIGNv
bXBsZXRpb24gb24gQ1EgMHg0MDENClN1biBKdW4gIDcgMTk6MDM6MzggMjAyNiBpbmZpbmliYW5k
IG1seDVfMDogcG9sbF9zb2Z0X3djOjYwMDoocGlkIDM5Myk6IHBvbGxlZCBzb2Z0d2FyZSBnZW5l
cmF0ZWQgY29tcGxldGlvbiBvbiBDUSAweDQwMQ0KU3VuIEp1biAgNyAxOTowMzo1NSAyMDI2IGlu
ZmluaWJhbmQgbWx4NV8wOiBwb2xsX3NvZnRfd2M6NjAwOihwaWQgMzkzKTogcG9sbGVkIHNvZnR3
YXJlIGdlbmVyYXRlZCBjb21wbGV0aW9uIG9uIENRIDB4NDAxDQpTdW4gSnVuICA3IDE5OjA0OjEy
IDIwMjYgbnZtZSBudm1lMjogdW5yZWFjaGFibGUgKDcpOiBzdGF0dXMgLTExMCBpZCAwMDAwMDAw
MDc1ZmFkN2IxDQpTdW4gSnVuICA3IDE5OjA0OjEyIDIwMjYgbnZtZSBudm1lMjogQ00gZXJyb3Ig
ZXZlbnQgNw0KU3VuIEp1biAgNyAxOTowNDoxMiAyMDI2IG52bWUgbnZtZTI6IHJkbWEgY29ubmVj
dGlvbiBlc3RhYmxpc2htZW50IGZhaWxlZCAoLTEwNCkNClN1biBKdW4gIDcgMTk6MDQ6MTIgMjAy
NiBudm1lIG52bWUyOiBGYWlsZWQgcmVjb25uZWN0IGF0dGVtcHQgMy82MA0KU3VuIEp1biAgNyAx
OTowNDoxMiAyMDI2IG52bWUgbnZtZTI6IFJlY29ubmVjdGluZyBpbiAxMCBzZWNvbmRzLi4uDQpT
dW4gSnVuICA3IDE5OjA0OjEzIDIwMjYgZnNub3RpZnlfaW5zZXJ0X2V2ZW50OiAyODk3IGNhbGxi
YWNrcyBzdXBwcmVzc2VkDQpTdW4gSnVuICA3IDE5OjA0OjEzIDIwMjYgcGlkPTI0NjA4MjEgY21k
OnB5dGhvbjMgcV9sZW49MTYzODUgbWF4X2V2ZW50cz0xNjM4NA0KU3VuIEp1biAgNyAxOTowNDoy
MyAyMDI2IFdhcm5pbmc6IGF0IGZzbm90aWZ5X2luc2VydF9ldmVudCwgb3ZlcmZsb3cgZXZlbnQg
b3IgZ3JvdXAtPm1heF9ldmVudHMgcmVhY2hlZA0KU3VuIEp1biAgNyAxOTowNDoyMyAyMDI2IG52
bWUgbnZtZTI6IGFkZHJlc3MgcmVzb2x2ZWQgKDApOiBzdGF0dXMgMCBpZCAwMDAwMDAwMDc1ZmFk
N2IxDQpTdW4gSnVuICA3IDE5OjA0OjIzIDIwMjYgbnZtZSBudm1lMjogcm91dGUgcmVzb2x2ZWQg
KDIpOiBzdGF0dXMgMCBpZCAwMDAwMDAwMDc1ZmFkN2IxDQpTdW4gSnVuICA3IDE5OjA0OjIzIDIw
MjYgaW5maW5pYmFuZCBtbHg1XzA6IGNhbGMgY3Ffc2l6ZTo3NDc6KHBpZCA4MTg5NDMpOiB3cWUg
c2l6ZSAyNTYNClN1biBKdW4gIDcgMTk6MDQ6MjMgMjAyNiBpbmZpbmliYW5kIG1seDVfMDogY3Jl
YXRlIHFwOjMzMjg6KHBpZCA4MTg5NDMpOiBRUCB0eXBlIDIsIGliIHFwbiAweEM4LCBtbHggcXBu
IDB4QzgsIHJjcW4gMHg0Y2MsIHNjcW4gMHg0Y2MsIGVjZSAweDANClN1biBKdW4gIDcgMTk6MDQ6
NDAgMjAyNiBpbmZpbmliYW5kIG1seDVfMDogcG9sbF9zb2Z0X3djOjYwMDoocGlkIDM5Myk6IHBv
bGxlZCBzb2Z0d2FyZSBnZW5lcmF0ZWQgY29tcGxldGlvbiBvbiBDUSAweDQwMQ0KU3VuIEp1biAg
NyAxOTowNDo1NyAyMDI2IGluZmluaWJhbmQgbWx4NV8wOiBwb2xsX3NvZnRfd2M6NjAwOihwaWQg
MzkzKTogcG9sbGVkIHNvZnR3YXJlIGdlbmVyYXRlZCBjb21wbGV0aW9uIG9uIENRIDB4NDAxDQpT
dW4gSnVuICA3IDE5OjA1OjE1IDIwMjYgaW5maW5pYmFuZCBtbHg1XzA6IHBvbGxfc29mdF93Yzo2
MDA6KHBpZCAzOTMpOiBwb2xsZWQgc29mdHdhcmUgZ2VuZXJhdGVkIGNvbXBsZXRpb24gb24gQ1Eg
MHg0MDENClN1biBKdW4gIDcgMTk6MDU6MTUgMjAyNiBudm1lIG52bWUyOiBlc3RhYmxpc2hlZCAo
OSk6IHN0YXR1cyAwIGlkIDAwMDAwMDAwNzVmYWQ3YjENClN1biBKdW4gIDcgMTk6MDU6MTUgMjAy
NiBpbmZpbmliYW5kIG1seDVfMDogcG9sbF9zb2Z0X3djOjYwMDoocGlkIDM5Myk6IHBvbGxlZCBz
b2Z0d2FyZSBnZW5lcmF0ZWQgY29tcGxldGlvbiBvbiBDUSAweDQwMQ0KU3VuIEp1biAgNyAxOTow
NToxNSAyMDI2IG52bWUgbnZtZTI6IHF1ZXVlIHNpemUgMTI4IHggY3RybCBzcXNpemUgNjQsIGNs
YW1waW5nIGRvd24NClN1biBKdW4gIDcgMTk6MDU6MTUgMjAyNiBudm1lIG52bWUyOiBjcmVhdGlu
ZyA4IEkvTyBxdWV1ZXMNCg==

--_004_e14fd710216b4742be966d98df303cc1huaweicom_--
