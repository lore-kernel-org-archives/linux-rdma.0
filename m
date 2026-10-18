Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09B33DD532;
	Sun, 18 Oct 2026 18:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792348410; cv=fail; b=FjuflRCLLHe5eLSqPBl+GsSaXD0YlmPWH8RMGWglFyKtxG5KS5s01evQtzj14bR3q+zRsst23pv/b2GztO6ltAdbMAPUmKgwAyvTW/xZtrShcQXN7tsbfqDK4ujLDQwpZJUxEycpHQvVMlTBkNlrMaXDYhcUCCZUhGH/Ay20VB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792348410; c=relaxed/simple;
	bh=0sR2EpPBhvGecea0Q2K+qmHZn2orKVi2W0w5EFIx6Lo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XwUJer5/jh1bIXMEHMywC0ww8euX5YZGncZHf8l48FNuGXCQcv3WIQ98k4mXSljStustHkm+uMTVEM/zhhU9isLHLfE5cG/oMCMIMzqdaDmSJxce+9YfkvlTZMeO/H7afcu8eXW0PfaZBNBiw6h7Q2POq6QmJQKu7t9Ne37PURU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d40EXES7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=k83IRpsT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d40EXES7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="k83IRpsT"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69IHGUAE4157905;
	Sun, 18 Oct 2026 18:33:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+c9bmOyvwaSMSbVGGSqpAVMejCaJ8p8MfBE2Pox9XYQ=; b=
	d40EXES7g5jWEri2NMnhWUvT9I+8HmuUvmG5PEJpDqgurhflatuPTi9jR/YcW+pb
	8cHM3db4QKNlP7tPS0NpLHilh7iiZi9KxN2Symspg901wCigRpjjW/16UECgbuOH
	q/KHuTzJaTFeSfw+oWZPO3OM6Hn2ESuv+HpFSKeQtVn3P+WG2DfQ1U2IOrnPfKlJ
	zNjwVnjJFeJD34+RfN2ESnY4vTsFJ/OVeChHp1Qf2r2iKlYGRCd3wlI89eOxCVkd
	N7iMpfFDY/2DiUeYRvShTLJEmJRv4/MWiZpU2amtGgsgQjesBc9xKtO3GjiI+Y8i
	8rLkuToGl2rGqMhN+akrkg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4hc0mrs0x3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sun, 18 Oct 2026 18:33:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 69IISmtw607393;
	Sun, 18 Oct 2026 18:33:10 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011044.outbound.protection.outlook.com [52.101.57.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4hcydjvae4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Sun, 18 Oct 2026 18:33:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lRLW2/cPxHnJxCxSQomx8snNXicTW+VXlvUwVzhyn87gQYPLhuN6Q7tluBWlBRfHAY/rt+NKTgAh15eiHJyOF9QT0EqLkHPEUct6aFsFH7mYkESpKbYEPzJKEPD4NKVnNLTDvg0A29QUicu0Aa40/J43MVJ6Xg257jddzjOV/XVanBo6GgVRPo1tzWaWo8hl0+s2iAxhQVaKujZoE1TIaS4E1XSZChLxGr37ziqV7fdQLG02N06kNYq7w2dMkL2thWeGhoZKP9wrlAOulh9nbiGWICXP2uS4ovqOiKJSawSAQsRco2OLNweN5meHQN2UR4pJzQ1g/tdUJP89wCx/zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+c9bmOyvwaSMSbVGGSqpAVMejCaJ8p8MfBE2Pox9XYQ=;
 b=KsStSnzpjgH6NVcpSlWdDETGkLKQ9pu329JF9NzlQXcRzZtUKyJsp5KJuu27pGP9huEe3D73Py8v163dIytModlLP+x37axfeZTo/5bpReXFMWOMFQmcOm7Fg4AZFpoSSF1b33qyCbLZJ1n3sG5xKRkwOkYy+JLnbqiti9EWRPkYjGZkfv8qpfiC0Ng9bNgBo13Lrh4+ZSvAYl8NH3/wTDVbPVa62Xd0MZYH0rF/fuGE0hqcFDmkimuKq7c1vE1Aj/ZoXWZ80R09wFajEJPZ3Pipgz/3gvrEHDMJjtgU2HXE3m4U/R6V02V2NXq/dmj50f0ktWtFoHC79mh7V69jFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+c9bmOyvwaSMSbVGGSqpAVMejCaJ8p8MfBE2Pox9XYQ=;
 b=k83IRpsTnUwA4/X5nPC9TLB/dPyrqnXmGijR+63MwzuqyOETo1IvPFxpAd86/A9nLeBc/LozrPkyZQzLhuI+8/OuXbn22tsSFXm73ACg7wKG+Uqz7A3Wu14ykwbUXn/R69QWuaMOsEVHkNlIq1hNB8P9PAkFJKI3hEQ5ssuagzg=
Received: from IA1PR10MB6050.namprd10.prod.outlook.com (2603:10b6:208:38a::16)
 by IA0PR10MB7370.namprd10.prod.outlook.com (2603:10b6:208:3dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Sun, 18 Oct
 2026 18:32:35 +0000
Received: from IA1PR10MB6050.namprd10.prod.outlook.com
 ([fe80::645a:f184:3a35:ef9f]) by IA1PR10MB6050.namprd10.prod.outlook.com
 ([fe80::645a:f184:3a35:ef9f%4]) with mapi id 15.21.0522.011; Sun, 18 Oct 2026
 18:32:35 +0000
From: Gerd Rausch <gerd.rausch@oracle.com>
To: Allison Henderson <achender@kernel.org>
CC: sungbyeongchan <tjdqudcks0424@naver.com>,
        "David S . Miller"
	<davem@davemloft.net>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>,
        Andy Grover <andy.grover@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [rds-devel] [External] : Re: [PATCH net] RDS/IB: validate receive
 completion payload length
Thread-Topic: [rds-devel] [External] : Re: [PATCH net] RDS/IB: validate
 receive completion payload length
Thread-Index: AQHdVfkYeaU81NT5tUOQtAB1MDRwlLcAqzQAgAIukICAANhfAA==
Date: Sun, 18 Oct 2026 18:32:35 +0000
Message-ID: <30C797F2-FB1B-494D-8E36-B50C58BB8A03@oracle.com>
References: <20261006205204.1322102-1-tjdqudcks0424@naver.com>
 <c1efb25a93739dfe2c16828bbcdc9bd7535850c1.camel@kernel.org>
 <7e69b862-7cad-443f-912b-ce2db7854d60@oracle.com>
 <f1504e3ae8da8789bcd6cd474ce51fec7dd15555.camel@kernel.org>
In-Reply-To: <f1504e3ae8da8789bcd6cd474ce51fec7dd15555.camel@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.700.51.1.3)
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR10MB6050:EE_|IA0PR10MB7370:EE_
x-ms-office365-filtering-correlation-id: 66c14a23-ccd3-4273-f906-08df2d462df7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|7416014|4143699003|56012099006|38070700021|18002099003|22082099003|10067099003|3023799007;
x-microsoft-antispam-message-info:
 8+9CtOjpjteK3nwKjOqZarih4eULlH6mHFkH8nHmFeS1X7ey+OGiZYCMK893KQQePgh89tGwCdgdzUYQfj2W8ynj7F2wwY0zl5ce+DLQUHpS6UoI+nqXX4uLI3YYN+uFUbBa6hPsyD2yNb7oZ9d+H6i2U5j6tw7+tKmIu+KCvD2pITjhXDPpvdmjd+MNYudLwSVz7r0asDayp7rKLUMCRefhPyolAMPKrJGdEopuKQpDR5woDh369aQXy7gzAEoI5Nq5d6wrX76DbGSB0yMqJ91l+s8mXuzPhNiRNlusinjTpkZXBdD/DbkXLRUrMHxA8H3wz9nZwv1kdmWrDeiBebwXCTNVIuevl9Y0AEkhnLlxUGEaFDtRh2enR95snT9djpakDHdHgixmwK7WwoDcdb7iBYTm0h9XeNhz4Q0stNfk9roP0BCvCrf2qYcMQ/xnZ0k0cLen5BjD3kHSOnwWMcy/r6ewattckLSKhwF54TpmZlzMi2lp+W7A/h4XnvZ21AfoeVYeyM5oINd1USJprLxPumUfy3UGhHtlU43ioASmkuhAKoctX3gjpKXJphLU2gvtOVDh/DBq0z5pCCGr3lbdf6RpIrx2jWX5Oth/VDz/snTnvhFxZyzqV0Aael1oMoladdJOpXk5anqxh1x9ZouTOZtrlr9g20ZmdnAquXVwQ7yDusy2i4OklVenhWyHLNA051nlPH6M8r7knPv5KEbWBbXBzl0PaYr9cTBs0H4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB6050.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(7416014)(4143699003)(56012099006)(38070700021)(18002099003)(22082099003)(10067099003)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?KFtmnRTiSTP+Y/TLwdrXJRk9SOfm5v8XHaNuH0CcWZRhDP/PudgvLCRd6hju?=
 =?us-ascii?Q?C3QnCyqdKz6ZZlr5FDDxm1aoOY8g30Tv7YPO4OudyJTYS1PzNTCSF6AqFiV1?=
 =?us-ascii?Q?t+FpypWD+cZt3tTsLMtWARWZGEgLXF/GUaHNQZ0lDtUVkD5jSAYGMfqXKJrf?=
 =?us-ascii?Q?RSWulJHyt/BCN5yoXRb3nFGPaRRn/ld+PnDA4ktCmDtcFIvI4IzswzHnhLpR?=
 =?us-ascii?Q?ru26GSGLa8u5gazi61aWIrHG7L6cCZ0Ki0RYWY5cVKRGdieUUbECKmVWmVZM?=
 =?us-ascii?Q?4aiOCIAvnkJDr8H7VYbvy6uyCT7B1/B9Ilum2hvjP+tjLuOWs4ymr2d20YH1?=
 =?us-ascii?Q?ejlL+S1LBwHwQJk1HJJRm8OhEFf7kbFnHNQirvoKKTL56pe/OJWWPrug59NG?=
 =?us-ascii?Q?XtGYgBrHkkKL+wh3fp/UT3av6oeMEu8bwSYmwUXZ3FyrYwskNyZOi9uXJOXk?=
 =?us-ascii?Q?g76gXxG/cWCnNYtmzQeW2nj834HQcHgxmMXtJxhNA1z8Cp3dB5N8EZ7VNnDr?=
 =?us-ascii?Q?VShi/3GosWb8EpiVej74b5r5e/9u04IZ48aATjLKhFCcQY7NU+imzzosykfI?=
 =?us-ascii?Q?oWESlIMz9+tdCDq1SfEs7tzFmTQG2p5cWWtqNz0G6jBFtro1gGu4IIpjVw1a?=
 =?us-ascii?Q?jqMQshzoWO5TOVte4xJx5G1hxYUXphHFXiLn8juTKRGflr6iwQkFNtgPhF9t?=
 =?us-ascii?Q?ntYBhxRQAGyh2hsECGxuBUj32SFEm79Ug3x5/3x6zF55PeGcXczdxGIzg4qk?=
 =?us-ascii?Q?PeA0M0ohIucCpNsMM5tc6Z+ZW7Mk4lYo7SfIFIcmXs/uJ0/npmYmZHbCODRO?=
 =?us-ascii?Q?TH1XtI7w8lhpGDByH4FXm02GbbJeTVMblHpbVLrIzaXNUGz+D48bmHt2xofg?=
 =?us-ascii?Q?LPcZgK3bANYpDyYZWqK0xMRyPhNbRH4SJo/Sq7TWqwiEcoWdmnZd4BYsUzOn?=
 =?us-ascii?Q?S746AE3Jeag1wsdXZReGM9yc3BM6PwTWphidXozQUDR+eyoyteNVs1AQyUBq?=
 =?us-ascii?Q?7RAMpr5Xv78KAJK1aNOV+03ykvG9U9nKeGVpIjN8XqRwVSVBAdtEaIR9Rj0t?=
 =?us-ascii?Q?/W6NsrV64rJrrsGA9UFgs8DMNQN9aTPzvx+KCPAqo4c1/b/KtcNJ8eiDMhRZ?=
 =?us-ascii?Q?X5E+ZBcv8/arAkry4iqzEUXPWD6Rsxq5BIuEa3YLgGkQk95smAWI0XScJLIB?=
 =?us-ascii?Q?LKfy/krmaCzwI5GItM7coQ5aMe4Ws7FKUezMq1/GTWNtRZEVIZ719e62Gvk3?=
 =?us-ascii?Q?DX1LxibuHgOJsUuXzf0PKCXKIMXAH0DWhgcSnmN19Wz+FNO20v8S17+ahoIc?=
 =?us-ascii?Q?YM6WluifkXpLxixb8c4edxCy0XPVKDk8GxvlwQryumM+xmcIh3LOcnn8lSC8?=
 =?us-ascii?Q?XEc3tZklUkF33KOmj+h1M4axOGmQuILCWFVcNIYwUOqUfAaut1R8GwKBkmBe?=
 =?us-ascii?Q?1pSur8oxZn49S7x+2RBa2j3JELD3pOcJNEuwygVcG/XJwowggG/lOaBj2T6u?=
 =?us-ascii?Q?FftSM4aNBq5H8v5t98qNua/8riKkNu/wQo7Bse/srrZMXM+lkqhl7FFoYy99?=
 =?us-ascii?Q?ogH/pB8Wp2ElVzdK0xsBlquz6lXALOhWaWgd0IkRKntGJQJRC6FSGYcL1/mz?=
 =?us-ascii?Q?cpPe21v2K5+fuaQRcxKQ0DmSkOoJaODucr8muvPNPROcmpBtaRMgSzFIjlF1?=
 =?us-ascii?Q?mI/7xVeaAqx8iwwP7GcahSB0l6Uh4BmbKkjNVUuxZI6EBy5j0p+TovCTg+Yu?=
 =?us-ascii?Q?7ygcGhPcvzZhGDwCj/wUO/XbmqpdrU8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <553C33B84D75FB4B87704D311A895DF3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	2Bjh6TXpgkFATNiYG6YwDHJDipPeNw9X2t2q84ZAhprOA9izyBwngppXRaBL5cHdJ4O13+PiIPn8w1eLSyrm2/P7oEisNirBkOZlERt1EbuXXtWrC0KL4tulWzScyQUHyG7alSDwJw+CYd66c5X/fkPZMIyyO810VhPhuPjgGmYleAXrKVSS3gEM6hd/09VlqAftqtYeHv80G8Vbq38+SJ/mqwr9fHH2RxwTvWr4J2Ip5faTU9iZnHmlAgpNDxPoxHb3LaFy0ZARdFVi4GQ5aA3zMKH4IEb9NTvW+Z1AREhUAV7r7JTKi6QWLFfkZg85vgx21JmVAzkYcQhtN3L4Ww==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lsUQrDoWUtMESVlIvGTjdgbtfoWfdxzWldA7MXizMHs6E03qREd92We75O8gQ6DJiviWDgGLKCRgE5yiFVpvK/7CNXleX6D1KM4qi77+wMQNyDHQOFIn2Cj4b+YyvE6h2zMc2QhVkpIlyvmonrB4CCrf/TtF5RUWK3B3FeENx2lktvcDmGlxwMPJmBedQoL02eZax359G9yOLCshB37GGI8rKLw35EmK9nR81AVC3wiLHRtvMse1oL4WfXncpUxz8MQJ/pfkSAJpn+MUVxMWaSgMwcjBi6p/6jKixdVeOLIoCfZ/nfgPdMfE/ugIy2fkV1CjIMKerAztfl/TzeiDGFhREZb3D5WWRySMepVJ5mAKFb4kkVio7lKwmdP9yO2NB2rhjPtdBhVpr5W7iFGSO+ixprEGdEejZixqtsrM6LoAtQpEOymwFIiSvilV4YDpRpcC/GgSJIfkGzbGE621bxXF3wfEr2/nrgN5KE79SiRXeoUgZ7GwEP+9119lezjZ2MSfMwrc9mCNGeKPZRi8CkS3giV4nwMsC1KrxMPjNnVOstgWjB1LDCBRIKj+g/SfpxPSmprBTD3CnwkRg6PlbK9JY9uuQJAt5iCjO+M96qg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB6050.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c14a23-ccd3-4273-f906-08df2d462df7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2026 18:32:35.2069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HGLif1D+NPjZtDNdewQF7vNBzXwGEubUv9j5OVXhIJM+JzpM6BN4IHKOTcxJxvGtzwTe1EqhQk4jKN7TRqfhTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7370
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-18_04,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610180073
X-Proofpoint-GUID: kmUUvhDu_4zUV-5naMG9Ldv5tKvo3iQQ
X-Proofpoint-ORIG-GUID: kmUUvhDu_4zUV-5naMG9Ldv5tKvo3iQQ
X-Authority-Analysis: v=2.4 cv=IoSL47/g c=1 sm=1 tr=0 ts=6ad510e6 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22
 a=VwQbUJbxAAAA:8 a=iPS_XkCnHNCcha14EesA:9 a=CjuIK1q_8ugA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE4MDA3MyBTYWx0ZWRfXxLhECvbTlMUM
 YxJrk4Jc+flcnaU32r4eXGzKba1gMv1VcjbToXJTE2MQJwXLWv8aaWaEcTTyrzVXNFOdUYknr5V
 t7rs7GriSjlsojCPdzOclKKWXzUbYm67H7SuCBm1PW9ON0m+kU182mGPC6Ro25aoSobHDt5HHDV
 7rWE3gPRJJ0teopFviDlxOPhaqgoOou3V7OWDBSq8HyTIUoZwcAT32OYXCKLj2CYzs7IgPvYgfd
 cfmAfPCBulBaUHp76DjFAh7XuFmOHIlWHB45p8llR5BOASOiw+B86GwM50oUrKSlbW9Wi/ZJa1J
 Y54XYMBnNe4GpJhMQCmH1gGmYE6MZS61C1/OMVy5TPbRcdqB5KJbwD4X6P+agSJpoZISXRKoR42
 Tz5iQXcRTBZLq7zSAvbArcGCB0Al+pexjFrsfxP+fLi2gqxJYeciZxDThXUFV0Pcm2LFPtLeaha
 4Ci0QULqXcobvUsjGEg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE4MDA3MyBTYWx0ZWRfX0CUHMTgd9N4W
 dAwNEkIK6QU82fSUNU786VMXoPTuZFUGGrQ7IELplY4QL3z1+fgMgHWnOwfUHliQJtQkzDaAimo
 C4VllEwvXKTJMXnsC4HMT+PbihoRL7dCkyJvWPZq+n3FnbmWOkpx

Hi Allison,

> On Oct 17, 2026, at 22:38, Allison Henderson <achender@kernel.org> wrote:
> On Fri, 2026-10-16 at 13:18 -0700, Gerd Rausch wrote:
>>=20
>> On 2026-10-06 18:13, Allison Henderson via rds-devel wrote:
>>>> --- a/net/rds/ib_recv.c
>>>> +++ b/net/rds/ib_recv.c
>>>> @@ -949,6 +949,15 @@ static void rds_ib_process_recv(struct rds_connec=
tion *conn,
>>>> }
>>>> }
>>>>=20
>>>> + if (data_len !=3D min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE)) {
>>>> + rds_ib_conn_error(conn,
>>>> +  "incoming fragment payload length %u, expected %u; "
>>>> +  "disconnecting and reconnecting\n",
>>>> +  data_len,
>>>> +  min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE));
>>>> + goto done;
>>>> + }
>>>> +
>>>> list_add_tail(&recv->r_frag->f_item, &ibinc->ii_frags);
>>>> recv->r_frag =3D NULL;
>>>>=20
>> How does forcing a reconnect help this situation?
>>=20

[...]

>=20
> On the retransmit loop: cp_retrans only matters if the sender is our
> own RDS stack, and our stack can't produce the fragment this check
> rejects.

Correct. But this check was presumably added for a reason.

1) An incorrect implementation of RDS (other than the one we're looking at)
2) A bad actor, intentionally crafting such messages.

>> Therefore, apart from security concerns, the previous behavior of garbag=
e-in / garbage-out
>> is IMO better than this behavior of just endlessly forcing a reconnect.
>=20
> The trouble is that the garbage going out wasn't the sender's.  The
> receiver delivered h_len bytes of a page that only had data_len bytes
> written into it, so the tail was whatever the page held before: an
> earlier message to another socket (the report demonstrated this across
> UIDs), or unzeroed memory on a fresh page.  That's the bug. And
> refusing to deliver it is the whole fix.

Wait. This patch was created for a hypothetical case, no?
Based on analysis of "Assisted-by: LLM".

This patch does *not* refuse to deliver the bogus message.
That would have been a fine choice.

This patch just drops the underlying connection, in the hopes
that when this message gets sent again, it'll somehow be different.

What would make it different?
Some unknown and non-deterministic sender?

>=20
> Dropping the connection is also what rds_ib_process_recv() has always
> done for the neighbouring case, a fragment whose header doesn't match
> the message in progress.  That check has been there since 1e23b3ee0e94
> and has the same "a misbehaving peer can keep us reconnecting"
> property.  This patch doesn't add a new failure mode, it just closes
> the one way a malformed fragment could still get through.

How much benefit a 16bit IPv4 checksum calculation adds on top of
the underlying InifiniBand CRC-32 protection is debatable.

But let's just say somehow (I don't know how) the CRC-32 check missed
a header corruption that ip_fast_csum() catches:
You're correct, the connection would be dropped.
So the assumption here is that this is a transport error,
that fixes itself with a retransmit, and not that it's a bogus
or malicious sender.

Does this patch also assume we're looking at a transport
error, that the CRC-32 didn't catch, and consider that more likely
than a bad or malicious sender?

I suggest that just dropping this message, not tearing down the connection,
would have been a much better choice here.

>>=20
>=20
>> If there's a strong desire to address this issue, the sender should be
>> told to discard the message. A reconnect doesn't address this issue.
>>=20
> I don't think there's a way to say that today.  The RDS header flags are
> congestion-bitmap, ack-required, retransmitted and the extension-header
> bit.  The only error a receiver can signal to its peer is to drop the
> connection.
>=20

Not exactly true.
There's already code for the RDMA_CM_EVENT_REJECTED case to downgrade
protocol version.

The RDS code can be changed. The RDS protocol can be extended.
A receiver could be made to tell a sender to drop a message,
if we'd consider that beneficial.

But in this case, since the message itself violates the "unwritten rules"
of the RDS protocol, I'd say just dropping the message would be been
a fine choice.

Dropping the connection however, doesn't do anything.
It just asks the sender to send the same bogus message again.

> A per-message reject would be a protocol extension that both ends have to
> implement.  But that would be net-next material, and it couldn't help
> against the only peers that actually send these.  I'd be happy to review =
it
> if someone wants to take it on, but I don't think it should hold up a sta=
ble
> fix for a data disclosure.
>=20

Again, we don't need to do that.
Dropping the message would have been a fine choice here.

Thanks,

  Gerd

