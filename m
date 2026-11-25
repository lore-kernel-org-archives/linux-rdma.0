Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1795622336;
	b=0BoUwcObxJ7RLYfiofhLu6lKm4woVuttHcnCmoM7CeOj9Ibe7PZ7yZc1sHcNQQp8TN39
	 zGULeoc6CmwHWyjXo4pkMPErqz64pxc/KcFcFGKcwTggN4UqkH8DZSuz5jHwx5K4dLpxO
	 D64biGG58zPreuas4XvX6X0Wilm97aO+12mOdHpf9F+z00IMUUYWXAXBCH5bjxdGuTJCE
	 siV0g5cyYI38kvvA++ZZ4yXwT8vpkuXoCc5kbWGIxJZdP0PfNn2evp8DPrcxLIyPXwGgm
	 wLvM4fyIjPyMRhmmI8E5+POl4ZzojkAk3p/dluheKF+zJQcTV+4a8h65GgnL5/oOTDA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622336;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Date:From:To:CC:Subject:
	 Message-ID:References:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=22jzem2ZFLEp+FV2Af5l4tryurkZKznzx86Yb9g/TtA=;
	b=xUn1XeMFDqSMTxvBGeVvF6bHn0oE/HYkSkNwg/Ackz+utyRMdb+OlqMhArX8uvotBMQh
	 iZBpd6inzYFLTsechUq+olVeKXjcSNDFNkyz8RzkB4jFmeRJSflB2PaAZvXfZAcw3Twru
	 h31TXxYn9+B7AWDPzOuQw5zXEyNdTSTBP40XpExo6kMen/AYmzVcY0E5wrgDTXGLdD94I
	 iRfayeGo/Ny9uPZmyLwUx5unNutKIlKNAyOZIZ6lekso18r6YckOz/sT9GAg9VSMqVkHg
	 MSmjFKzWpJw/N4ZxKsyqd7x6vM2RdxOYIv9MnAvEnWeDnbL3/UnIfkLekxvI2q5SKog==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=SL4jKB01;
	dkim=fail reason="signature verification failed" header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=kgV+Gc1q;
	arc=fail smtp.remote-ip=192.198.163.7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A84C606A32E;
	Wed, 25 Nov 2026 15:58:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A84C606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=SL4jKB01;
	dkim=fail reason="signature verification failed" (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=kgV+Gc1q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795622336; x=1827158336;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Z8Rl4qJ/wG+1VaqciQ5pQCXo5IXzh1qcpowHXXL5JT8=;
  b=SL4jKB01caKXRCxEqlaltjKy1IC6ClNDfJawiD+6/SH/RzQaXz25tCDq
   RchQVeiEyKWh2xYje5UX06hhss8zLNJPi/kL9CpOrem8iEN7eStmC7FCO
   d1b8DkMCuZPM0bEnT6QKJm3GWWKN25Add1aeHxtcuEK+9j9NxX9STFthe
   fcc6OhYU29M8KIb9TCDWRhGeayoj4OL2JmQa0pP2bXJ2bUfJrjtd/jtpL
   KMOA9wZV/5aGrTZ5hIwG7Yw9bfCjWMnh6MWZRrXd0t8QSKC5e+Uhs34am
   rEfBz/Wioe6PhvPc/7F+8Czd0y3cqKufFRfWJPsod0RaPlhK+AYakcVjL
   g==;
X-CSE-ConnectionGUID: U56jnSAbSsqUkuCI6RY4nQ==
X-CSE-MsgGUID: DZBjb4l0Tq6IOct8aejC/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11977"; a="4364376"
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="4364376"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 07:37:24 -0800
X-CSE-ConnectionGUID: IOOm1t/QRMmpcfAxe8zeTw==
X-CSE-MsgGUID: +9zH+A23SJuXGBeEXyZtwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="11778445"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 07:28:19 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Wed, 25 Nov 2026 07:28:18 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57 via Frontend Transport; Wed, 25 Nov 2026 07:28:18 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.50) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Wed, 25 Nov 2026 07:28:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RdbFdOe3mKHpGXfeubEwdf8DfcKEc1nZH6iqreuYNdYR4U9j37Z9k+GHlslzVNC3DesNr3cPZ1l7RI9+0vbPAFC6rFP5QAzZ3CQccKu3XvoZ0veEFtswosmAgtxv5maD+Q2XM3v4SwlLlerh6akbZCcy8M1HKhEGsODjda6m77z96FdztDRYxC8uPHGcpYCYJ01N7k1/NHZWwMWWblC+DRXgyh3SmzMENUdcgJnGQCeAPsAcPIR0cPjWAWtl3OPFp9WvFiD7YKGsvYUKqCT0cwy+6aM68/cfJqfuqQMmDLcjaPYuRaeGBZpKqWXhN5hkYyteW4Jprr52LKQ3yLWO0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Y01RI4dLpy0VZdx6J6Hqnc84/tqxy/bEC1Kl8WeXXE=;
 b=b+R3LN2wmoxY0/q0AjCywQjB6C0Q5vx97BmVB8BFzUYHEDxhiPeUsxMI4lh1lsGl3+U8GL4/xIMTBIC3S4670mDa49n9icky7Uvmnuvbuv/V7JyEK7gNI0HcLQ/OYOQDVOBpVnuG5ghfoIhsh8LtoMZkemC+u0LE/09IkD60StPN8CkJg7P6iN71zMfQqcq73xg3m/MnayOodei75wuLxYuMxs+CcMJL5QzFlmdPPrrrOC5cenuSFLkcAIyC1rw8xdCB9D9rDQeMqPM7o4i1W/T29VATxXHkBVja06Seal/LTf3uOerEuEpCorNyAAKoEy4W4dU4QHXz31038zeLyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Y01RI4dLpy0VZdx6J6Hqnc84/tqxy/bEC1Kl8WeXXE=;
 b=kgV+Gc1q0vueBCxiPfuVWY99hJ/Apxx8rMIhA0+d0N6gvvXWofu8HX0RTb5RBsYITk9c2n7oepDOwW2L1rSRSflVP2i14Ya3UWrzIEI1qYgnyeqalGLM+Gsxo7cvidrOk/ax3PGQUz9MispiI1oe4XF1JvgqINMuCJgf6ef/EhE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV2PR11MB868673.namprd11.prod.outlook.com
 (2603:10b6:408:422::13) by SJ0PR11MB5168.namprd11.prod.outlook.com
 (2603:10b6:a03:2dc::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Wed, 25 Nov
 2026 15:28:14 +0000
Received: from LV2PR11MB868673.namprd11.prod.outlook.com
 ([fe80::5bfd:6afe:a9db:b7de]) by LV2PR11MB868673.namprd11.prod.outlook.com
 ([fe80::5bfd:6afe:a9db:b7de%4]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 15:28:14 +0000
Date: Wed, 25 Nov 2026 16:28:02 +0100
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>
CC: Magnus Karlsson <magnus.karlsson@intel.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
	<daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, "John
 Fastabend" <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi
	<memxor@gmail.com>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	"Alexander Duyck" <alexanderduyck@fb.com>, Saeed Mahameed
	<saeedm@nvidia.com>, "Tariq Toukan" <tariqt@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Michael Chan
	<michael.chan@broadcom.com>, Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	<bpf@vger.kernel.org>, <netdev@vger.kernel.org>, "Stuart Clark"
	<stuclar@meta.com>, Stanislav Fomichev <sdf@fomichev.me>, Simon Horman
	<horms@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Mina Almasry
	<almasrymina@google.com>, Song Liu <song@kernel.org>, Yonghong Song
	<yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis
	<emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, Randy Dunlap
	<rdunlap@infradead.org>, <kernel-team@meta.com>, Dimitri Daskalakis
	<dimitri.daskalakis1@gmail.com>, Bobby Eshleman <bobbyeshleman@meta.com>,
	Mohsin Bashir <mohsin.bashr@gmail.com>, Kees Cook <kees@kernel.org>, "Breno
 Leitao" <leitao@debian.org>, Maxime Chevallier
	<maxime.chevallier@bootlin.com>, Tao Cui <cuitao@kylinos.cn>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>, "Mike Marciniszyn (Meta)"
	<mike.marciniszyn@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>, "Jiayuan
 Chen" <jiayuan.chen@linux.dev>, Martin Karsten <mkarsten@uwaterloo.ca>,
	Nikolay Aleksandrov <razor@blackwall.org>, David Wei <dw@davidwei.uk>, "Pavel
 Begunkov" <asml.silence@gmail.com>, <linux-rdma@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 05/15] xdp: Run programs on buffers that must
 not hold kernel structures
Message-ID: <awb+gg7b1JlsmqDh@boxer>
References: <20261124112707.118678-1-bjorn@kernel.org>
 <20261124125654.183091-5-bjorn@kernel.org>
 <awb9GzkXa9Z9LxuP@boxer>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <awb9GzkXa9Z9LxuP@boxer>
X-ClientProxiedBy: DUZP191CA0002.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:4f9::12) To LV2PR11MB868673.namprd11.prod.outlook.com
 (2603:10b6:408:422::13)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR11MB868673:EE_|SJ0PR11MB5168:EE_
X-MS-Office365-Filtering-Correlation-Id: da75ce1f-2f0c-49f1-1ce9-08df4b08b90b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|261026121527099003|11063799006|10067099003|4143699003|56012099006|5023799004|261102123227099003|261021123027099003|261009223027099003|261021121427099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: RyXmQ+9IN1ozeSFe0T54k6nEw/c8hKa9aD3JoFueI3Iw02WlM8dMfbgFwJ8spzXsvSDghAgIJKHKXROJUCtcSZy+4X3Qj1D+Hnldkr5I8uPYUBsofdBJ4rHgxDuREmheOuD2lEByn3ghVIoITglsqn1qrsNoNNbVtrXk9RGZQmP3axAqLpnd9usgzAXCCnYR4UARReYNAgNFuS4Oq1ra7C4cwEleh0h/BZ9dSpXHi5yP0ppzoJ7MSxqPy3dlm/URm+ZTW5SRE3Aad+XeyKKjUWiZfTo+dGZrJBbZCz6l/TZDE/x5ae6hyn1/jWWA6eOp1z2VWLLxVos5ozc0nwBLyXGdowbHVSzHZi5ptvZqjRAmObDR9/SAgI15GvsLHhbz1j9xew/9P+sqzkqRSq8zyihz9lWA2Va4FNYF/3iGgNc/2IIU4LfDDxn6w7uaSNrXXNMLFg52DvHznKcmMqK6wQ7BTOnE02J2RSMRLRMQWlanTMds7JNKi6unZDx5DCzeWR5wKl9UG7AjiTyvEaX+OIswThyXRUM4EONxhmOGTcmC3vQAl02KWPwBEWh1GMdfco94O3uJqAvej2KNEZ9f4NUAwbGX+L+U6uPjVmFN2p/v3pNhW0MTeTwZbbwdLj/3A/QnvLvkjZmPj7IPWPJ5ltwzHMd6wunMMzdvgxeYv7Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB868673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(261026121527099003)(11063799006)(10067099003)(4143699003)(56012099006)(5023799004)(261102123227099003)(261021123027099003)(261009223027099003)(261021121427099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?+NmNS3cK/9/grGlK+zjxDFgfFtzKaarpdaDocANdAXhAa9t61cJNz+oY3N?=
 =?iso-8859-1?Q?ITG+8erhob5ECMd0dF9ABI+wmJzpIGiO6FkMdJl3tha3EspJeMwklj1buR?=
 =?iso-8859-1?Q?KIzF5tWWwtpWYOp0ZtuOgy14awnfptOIbQROaIPOBfBUQSwxFDrh4WQ4uE?=
 =?iso-8859-1?Q?du9mjNT+ZzmiwBlvHTP3DW7e1CKEnA3ea8Pv4lylurfT+wEsriHWvGTmDN?=
 =?iso-8859-1?Q?stJclTUBjapyooxJEvGJ6boqWAeJNpTgzb7S+U5mclUDn9egHel1D4+gU7?=
 =?iso-8859-1?Q?yUm3MJn5j5lU0fGcBVBV9eanIv3aOoh0ylIoWEbNF1ibCRBIQDCjCyTr0Y?=
 =?iso-8859-1?Q?sqUN2ovnFoDIt1J09WixSSK/xPGzM7quuaTykUJIdulGI3BDEgws0C3DSS?=
 =?iso-8859-1?Q?bhcziT/LBt+wxwiO8kd9TMGPqnp9Va1qT4iTsBUjOeSbzQhXVKpZ0M11dc?=
 =?iso-8859-1?Q?DPkKIBEK3vQCdU8GhU3dd0F3+J0v2MZwekkhfPoS+61S4LUxZeMxh9RrT8?=
 =?iso-8859-1?Q?o3vh62Fbn+9RBv/4HFeWZep9zToSRP+Y6vKwG66WsR/SQRL+NvgzB8BG2I?=
 =?iso-8859-1?Q?ld0qaEkd3eI1HUjyV4a+LAAKh/tInwF7SgrRnSYfkjjnG5tITaMSV6iZp5?=
 =?iso-8859-1?Q?DHw4HpvSSyh5D9C2jR7HCGxAa3qBQDO51zP+LVs1FIUDhE6uaG85ca3I5a?=
 =?iso-8859-1?Q?G7+nsg+9nYSnaLtdp+7bD/zSGz7+Ye+egtW9Adt9J/+z+TmXRpug0XStOm?=
 =?iso-8859-1?Q?69jf7uJsjVWTaFYEE80/MKd11OvP7okkpXyajYspcm0vkVF/oBay5s/8om?=
 =?iso-8859-1?Q?Fou7oDmsCp731OyD1V3/CXis7RQshBFkC6zzVsSKD6MT7CjbpH9zfkJfNK?=
 =?iso-8859-1?Q?UxcWnTzJLxOmZ0BoAAYtAzv6q6DIAeGIlmNI6NAsNI+nyChubW84mhkeeh?=
 =?iso-8859-1?Q?uYjHOrbHbpXl3us9jaBMJGK3VWJw+E36SgH3JUhlM7ZXq/ZdMlVxiXE0TU?=
 =?iso-8859-1?Q?7rUe5+UpWNWUIs0DPrLmqRbuTkCI9ZQS7iRY3gnRZcyapCRTQjXlTSJL1H?=
 =?iso-8859-1?Q?Y7w+ztuBa6V7tVG49gUnMrzQLd1rNxg4Wr0oTf50pPbBrnXjLVZoXtO8ry?=
 =?iso-8859-1?Q?T109NWUi7hMWD9gmLYeVrRGGLMMmdZFOhQHzfKQq8ciiEkPoLSofxxUEcV?=
 =?iso-8859-1?Q?Q3pY/5yOcQCXxfFMYFSDh8qO/1rGh+CoNoewA1Q8bIfKe15/y6Tz5OmEuQ?=
 =?iso-8859-1?Q?1XQAArsIcceZFG3NK0W/b2VxViCZXM1CJ6uQ2xE+Cjl5Qy2BdR8GI3zbb0?=
 =?iso-8859-1?Q?dfjHMQRWmX1TK4lv/vSlUnsYv3E4GT9hrT/zCklhyBCTA5+jayO3XkffW6?=
 =?iso-8859-1?Q?VnHBrJqs+oGTVfQYy8lZMKXzS+qt3sfufGlntfmQO7EjJuY8Pxls8vprHB?=
 =?iso-8859-1?Q?V+P5kp1hdL0tUl/SApsWWmmnLG9UOLKk9uEFp7aJT3uUOGEpZSqJgiaa05?=
 =?iso-8859-1?Q?sPBz/BWUxDRXYU3VtRGjRNSbJOH1jfY8MXX+2SW7AffwCqX0MC6zmP6Xo/?=
 =?iso-8859-1?Q?lUAl+BSXKcHbiMPd/IMa8+Uieh533UvEaqU+ijOIvtpAzIrlbbi2joRYwr?=
 =?iso-8859-1?Q?EMv/xb4cHC7hzD5bxlf71LoXIDGySMkI8MOO2QS+D8fT6cxkJV8a8tpSW8?=
 =?iso-8859-1?Q?6Fp71MUPYT/QLXH5w0KBy+79txoF1t7yWuskvYeeImDnfkqOeNPTcumJzl?=
 =?iso-8859-1?Q?U8c1jx5U68Am+eOulTxfzyHPPUy2TDxXw5WaT1ppdbAvQIYUy1OuYGIsoP?=
 =?iso-8859-1?Q?rI+P8mqm37molVyRC49ye/OKdwPbaRE=3D?=
X-Exchange-RoutingPolicyChecked: kRerBZReCD5Y2G45gBbfilcoKe1NUCTWFmRbR2Vqk0D3kHQi1phYD3QUrWi+pbKhztne5l9ksPmX99jutmDj7OdE/S79hqGIg5eLXgQv++wAvf2K7+wn6L8SgCGJRi0nxsWB82crkzQOY+nEpYS5JgmXV/H6PTCgtuUaV9sskWJvt45cGNxF22MNAHGLJLOvVBVPRO/o5DCyNjLpHyUZO3/GXkqtUzjHIDMIfCVyTTzJOR5X51j36kF+nXCpueHxSmxFQlGiXkxxuobUeyj/9pdeFfv2A0USGSdazD0QgyvRpi6djnbPEI5bObUT5NETachxeGvEMI+wDQm8M7N+Yg==
X-MS-Exchange-CrossTenant-Network-Message-Id: da75ce1f-2f0c-49f1-1ce9-08df4b08b90b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB868673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 15:28:14.7012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TZPN7h1dI74joVs6vGGuvw3kzKecalKBk7lHsrNyE+lEjSg5OhSJHS5o5GnlnM2AA2Y4hl8rWtLYx/KSfIHyGjraYW5IYF7FZdck/TZRkts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5168
X-OriginatorOrg: intel.com

On Wed, Nov 25, 2026 at 04:22:03PM +0100, Maciej Fijalkowski wrote:
> On Tue, Nov 24, 2026 at 01:56:40PM +0100, Björn Töpel wrote:
> > Currently, the core refuses native XDP programs next to a memory
> > provider. An AF_XDP sink needs XDP to steer its packets and to use the
> > RX metadata kfuncs. Its buffers are UMEM chunks that XDP may read
> > through the kernel mapping, but that userspace may write at any time,
> > also while the kernel reads them. If drivers build XDP buffers on them
> > as on pages, the core puts kernel structures into them, such as the
> > shared info of a multi-buffer packet, the xdp_frame of XDP_TX and
> > redirects, and the skb of XDP_PASS.
> > 
> > Let programs run on sink buffers as on pages, and keep every kernel
> > structure out of them.
> > 
> > A sink offers an XDP view of its UMEM, so drivers build the buffer as
> > for a page, while netmem_address() and skb_frag_address() still give
> > NULL for sink net_iovs. Programs and helpers read and write the packet
> > in place, fragments included. xdp_prepare_buff() tells a sink head by
> > its address, with one range check under a static key, and marks the
> > buffer before the driver adds fragments. Other buffers pay nothing
> > while no sink is bound.
> > 
> > A marked buffer keeps its shared info in the queue, with
> > XDP_FLAGS_SINFO_EXT, set up when the driver registers a sink page pool
> > as its memory model.
> > 
> > A sink buffer may only go to the AF_XDP socket of its queue. The core
> > turns XDP_TX and XDP_PASS into XDP_DROP, so drivers need no checks of
> > their own. XDP_ABORTED and invalid verdicts reach the driver, which
> > traces them and drops the packet. Frame conversion and skb
> > construction refuse sink buffers too, so devmap and cpumap drop them,
> > and sink net_iovs never become skb frags, so every net_iov frag stays
> > unreadable.
> > 
> > As userspace may change the bytes meanwhile, the kernel takes bounds
> > only from its own fields, and only the program and its helpers read
> > the bytes. A helper that reads bytes twice must check a copy.
> > 
> > Signed-off-by: Björn Töpel <bjorn@kernel.org>
> > ---
> >  include/net/netmem.h          |  5 ++-
> >  include/net/page_pool/types.h |  7 ++--
> >  include/net/xdp.h             | 60 +++++++++++++++++++++++++++++++++--
> >  net/core/xdp.c                | 46 +++++++++++++++++++++++++--
> >  4 files changed, 108 insertions(+), 10 deletions(-)
> 
> >  	xdp_frame->data = xdp->data;
> > @@ -763,6 +812,11 @@ static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
> >  	 */
> >  	u32 act = __bpf_prog_run(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
> >  
> > +	/* Sink buffers go to the AF_XDP socket of their queue, or nowhere */
> > +	if (static_branch_unlikely(&xdp_sink_key) && xdp_buff_is_sink(xdp) &&
> > +	    (act == XDP_PASS || act == XDP_TX))
> > +		act = XDP_DROP;
> 
> I think it would be better to follow SEC(xdp.frags) approach and from
> verifier POV disallow progs doing anything different than XDP_REDIRECT...?

Or that wouldn't work if XDP progs are still global per interface.

> 
> Here you affect whole system.
> 
> Also, I don't follow currently why xdp pass is not allowed, management
> traffic gonna be dead on this queue.
> 
> > +
> >  	if (static_branch_unlikely(&bpf_master_redirect_enabled_key)) {
> >  		if (act == XDP_TX && netif_is_bond_slave(xdp->rxq->dev))
> >  			act = xdp_master_redirect(xdp);
