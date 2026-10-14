Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D28D1A9F90;
	Wed, 14 Oct 2026 10:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974855; cv=fail; b=dOYlkg4pBxHuqRlwBVFFscf3l4MfzomiZOgg6mFpI1etTueMJtFYaWxUttbMn44kMem+aBmx9/eMw/6zqt0sVjCuv/n6Mva+i9AL4XMUniWSFUiDO4UogaTSgpb5RyNEXUoPRRUaACLjU/6UzmXSqAUpzuEdCCtoMW/KtE+xWYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974855; c=relaxed/simple;
	bh=5yE5CZgQnfCo6kNpPl307zxIqQOjXTbPuqIFVIDzdBU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E4JHrUkgQeA00SM/Cl6Hs2aj48UtDt5xvn7/yiIEcu7mJajYrAIPhLy2LscYcyQV9BcyCf7DDvotKprdVHOvcVY/jCtu//Jz9OGus9HYenK8lDcrlGSHeWvmunsTwt0LDRKiPO2Co8utMa9jkWTfBZOggdPFfxqAXAsZVAoIMGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RssLrv15; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RssLrv15"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791974854; x=1823510854;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5yE5CZgQnfCo6kNpPl307zxIqQOjXTbPuqIFVIDzdBU=;
  b=RssLrv15z6pnVBUm1pog1WEG8GG5NheefivBojBY6/LIqy8+7ZpY4DQe
   knN32yWKaHoH3guZqvSevA6hXTQti3mj7MrcJVlpCKIvNkD1LAIxgSkL/
   GxDlB3R0iW8IGoCjhrqHPQNpYh75qvW1vNbx36rpzLVVT9bhm02Ms5lfc
   aBtC2/qesm8FPYxJjRXN43U9ypR6y4RtmGLb7qXKR6mDDWVd2sMFGZ9qC
   uYjff/BvjWkOeNC3Vq0Ws/q43Xupa+aAk6ghSl6987bMdMTvXc9qxnrdd
   WjhZ0dXa0r64cJQ6WK51jaOHuFbWaH4gs2PC6RtS9gGb4BCDlb9u9kZg2
   A==;
X-CSE-ConnectionGUID: 5xZ4If9IROSrzGjrkIC3kg==
X-CSE-MsgGUID: 03TM6PkbTIayZenqlbWISw==
X-IronPort-AV: E=McAfee;i="6800,10657,11934"; a="728020"
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="728020"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 03:47:32 -0700
X-CSE-ConnectionGUID: d7IDPnlASJyrshF0RitshQ==
X-CSE-MsgGUID: 4V7pmA4KSKeAxz8wtJCAFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="1345679"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 03:47:32 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 03:47:31 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 14 Oct 2026 03:47:31 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.71) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 03:47:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jbap2dQlZQJ95KQCPMve0fj3kXh0w5DSJyeMeVSVgOerY6BllQPupfq9AesjKJDX248mzsHxWx9kXikXw4OJXRHApkdpAOWvVhMmTJvO2uVwsGD36vmXSMjVoII0WVulaD3fccEzE4QJtWB47jWlLhvvax0s8xj+EJYsLiTBb8amPSb/DCNkWFXoePeXdCtybUMay+CHF6UvKh/ihv+Wbr23Cw7fryaJ/ILGL2IJDYHYdBSq68IF2JSegPOmAoeboaNKG0KZm7iJjffgQZEFEmox8vydM6arBMfLS79QkAOoHrHcUCNclnwRIxWFzSuEHFU460AknjqI8rWrnisWJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5yE5CZgQnfCo6kNpPl307zxIqQOjXTbPuqIFVIDzdBU=;
 b=BADxcrTYTK1WP7Mv8r+nbfuSffTdn17f/1qXiK1qHDW5Q0a7V02TRLUiFn+/GErEmwJAVOlK9Q9A2ibvgbtmjO+2/ytESSk2afSaLWcOqnWE+tAJ/NJPBM0lqJqiLOM892/cnVZluGAUFa35Q7QDs3yZLqf3jJpfPrNr+t/ZIvDjkk0Qc5VWG3gtRQ1ZZChzPv1gpYptq73GX0WL+OETkCPdALwIpdGl2nwe6Jqt5vDC8gP6ZjUF4fXtm5qhVpRPNjPS431KCRTXlGywg31Afm9qe9CJwQd0udpVEZ0GPI1uoMZ9Of+nACiSnsjt2lVCaSbVo3Q3oA5lcc6tLrJtfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS4PPF7551E6552.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::31) by SA3PR11MB403611.namprd11.prod.outlook.com
 (2603:10b6:806:58c::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 10:47:29 +0000
Received: from DS4PPF7551E6552.namprd11.prod.outlook.com
 ([fe80::ac6c:1d96:c766:799f]) by DS4PPF7551E6552.namprd11.prod.outlook.com
 ([fe80::ac6c:1d96:c766:799f%5]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 10:47:29 +0000
From: "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
To: Mina Almasry <almasrymina@google.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC: Ayush Sawal <ayush.sawal@chelsio.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Tariq Toukan <tariqt@nvidia.com>, Simon Horman
	<horms@kernel.org>, Steffen Klassert <steffen.klassert@secunet.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>, John Fastabend
	<john.fastabend@gmail.com>, Sabrina Dubroca <sd@queasysnail.net>, "Eric
 Biggers" <ebiggers@kernel.org>, Kees Cook <kees@kernel.org>,
	=?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWcgKFRoZSBDYXBhYmxlIEh1Yik=?=
	<u.kleine-koenig@baylibre.com>, Jijie Shao <shaojijie@huawei.com>, "Michael
 Grzeschik" <mgr@kernel.org>, Jakub Raczynski <j.raczynski@samsung.com>
Subject: RE: [PATCH net-next v2 6/6] net: kunit: test netmem, page_pool, and
 skb frag refcounting
Thread-Topic: [PATCH net-next v2 6/6] net: kunit: test netmem, page_pool, and
 skb frag refcounting
Thread-Index: AQHdWiLNgjxpfn8VG0qz7dcXeOLF8rb83m8g
Date: Wed, 14 Oct 2026 10:47:29 +0000
Message-ID: <DS4PPF7551E655224D3DE0925E960B22F15E59D2@DS4PPF7551E6552.namprd11.prod.outlook.com>
References: <20261012082148.1698596-1-almasrymina@google.com>
 <20261012082148.1698596-7-almasrymina@google.com>
In-Reply-To: <20261012082148.1698596-7-almasrymina@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS4PPF7551E6552:EE_|SA3PR11MB403611:EE_
x-ms-office365-filtering-correlation-id: 965fd5df-a851-4952-1fae-08df29e08b1f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|7416014|1800799024|376014|366016|22082099003|18002099003|10067099003|38070700021|11063799006|4143699003|261009223027099003|5023799004|56012099006;
x-microsoft-antispam-message-info: vS4qJaNbID0ng3Qu1GT11cI5kkKpXhc5o3BWHmDbo+uPtexOOeVL7xHn6oHrGCk/fQln0JE0yHAiAsDaAfLWnmiyJqtfeErspqhXjx4/H3BNH9JjtIN+e+6hoqqYHZc6JGe5qzlqsHEO2kyNxpYJqCafAvBSQzH+9tzRF9MJ7lXbgMXaNZXGbYVjM+YfWD5tLrGCFfo4uLhA66I7y+Y3qB6hDTYBTQ7MbI86HyBlngUywK5TyOrON56IM+lzfWSWDQx38ADnffqpl1MoD2zwblXxDT+B6ZuDPjA3oXsC0w4kNq2yjKZp8eGQpoNngE9F1sYWv2WCkLQ0uRniSnJWHw4iBSIN7zenmIDuZezMATouhYkMcJJWRy/WdShXiQ1vB2+EQ4+L+k1mIAj0lub+osE11SjSEZsaryqGfYSnpZotxZe8JDB68vTCOn97IwAbvC8dRqYkIksFm/xtbUwxCNY6jse9mq7MY10SHhM0j37BtBROhn+lwaTNDqaiBVYaGAYn2rQBqi+zt0XUsFhb96e95JLbE396mNG+jiN1ZC7FyzBODv1TH8JqGLRYtOy7cmaa5+8J5DNEgReOZM5qHG8ZQklOlJq2A5zG6bdDNlfxkQN/15c4azT2pg7N57LUOpQ8Ezh9UMEgzUGmrkdaRaTXNLDi45djvk+uTW1rn9E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF7551E6552.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(376014)(366016)(22082099003)(18002099003)(10067099003)(38070700021)(11063799006)(4143699003)(261009223027099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZkZkZXZ1eCtOUXRJOTN4RmFJb1dsTDZrOG0rUzlmZExGMmtqbzFhcy9zdUFV?=
 =?utf-8?B?SllhbnVZOVZsWDRZRm92OWhFRHlaMllpa3dsaC9qci9Gd0ltMWhBcytLV0NL?=
 =?utf-8?B?UFpHUEFrNi9TOGlaYVdWY1I3TjZ2TE8xUndXZGQvNVRwcGZPVzhwb3FDbEdW?=
 =?utf-8?B?YWQ4emlnZ1BNd2UyblgrellaeXhhRGh6ZXVacTBlUzlqL29TTHA5N0tTN3ZK?=
 =?utf-8?B?YVpabmx6Y2lRNXg5UWVoQ2xOSGhocjZZQ0ZlQmVTR3hsRXF5M3U3T0pIZGlS?=
 =?utf-8?B?dHVBMzRZOWdHK3JaYVNhYW9TS0gvU3F2RHFISW5LQm5UZ0wwMmY2dDlsYTFq?=
 =?utf-8?B?Ui9LWmViemN6Vms3OGtveU1wRDg0U0JibEhrRTRSTU16U0YrQTNKMUx2c1Vr?=
 =?utf-8?B?OHBVanV2SUI2VEo1clVtTzFWR043ODRxNWg0ZTFhUGdFRitsTGZMcTdHeXV0?=
 =?utf-8?B?S0VFR3NySkFlVVc3RlF6UEhUNUZYK2RkWHA3SFdLUTQzVnRpc1pLTnlnRzZH?=
 =?utf-8?B?NlgyeWlxY1A3d2oxdjVRcjVZZGRCbWJNdlQ5T0gyMGIrb3MxUnBtVEdETWVn?=
 =?utf-8?B?cXk5ZXZ4RjUwN1pmeHNtY1BPb3gzZytCLzBsRUgya2ZnaDZYV080VEJ4dndt?=
 =?utf-8?B?RUdURW1oZU5pV25hVlZyaVUvaGtqQm9lOUxtdk1RRnluUVN1RFBlRThwUGZy?=
 =?utf-8?B?bkZJQ0JCVFJBaHFkNGpIbXk3R1pGMFpIUDZNajFFWXVWamlKc0R6NXg2QStQ?=
 =?utf-8?B?cDJUcklWYkRpMThHUERXb2tKOEg4WXl3bkxrRldjd3M2SUlLK0FyVUNCUTZj?=
 =?utf-8?B?UWtlaG5QZkhMVHhuOCtLZWdkWkpmbnZIRWNka3ViYnE1alBsYzNEZ2M2c2kx?=
 =?utf-8?B?SDlRclhuSHVrMnBqQSs1YjgyRUt0VHE3OUVtMk5RYmpHbkFRTmZQV2srR3ht?=
 =?utf-8?B?YktJYW5teVA0UzlnR1FubVBWYzYrbENyK2FhczIyQmpGenFqUys1eVZaUENv?=
 =?utf-8?B?R1F3aVp5SVM5NU00TjVuUWNpSFd4OFd3RHROeFh2clduV1hoUVRBMjZuNExW?=
 =?utf-8?B?SjR2NHBiWWxDOFY0R3RDV3I0cjJKV1pMNHlHcjFZakR6ZkdpaWdFV1lBa3Bk?=
 =?utf-8?B?d2IrclZvN1BETC82V21kTWNHbmphL1pCbDNURmRYYWI2ZktlM3c1YkVMcXNQ?=
 =?utf-8?B?RGxQNjRYM04xRFE3MFhhSldnc2VSekkzaHlXQ21CUTJDQXdyb3FJeHBySXhs?=
 =?utf-8?B?ekhsenQ1cGtNNk1renZ3a0pJU1JKcmllMEhwNVAyTE5IMjZraEdrV25nUzBN?=
 =?utf-8?B?RkZzSkxLTUZqeXdtbTJhQ2poSFY1VTVUWFFVdVlzYVVMdi9sWGtHeWg2TTB3?=
 =?utf-8?B?d21TUml4bXpXSjNMeWhHNlJaZDdUTjJXbFplTXlFOVc0OUhqUmQxandOMlQ3?=
 =?utf-8?B?b1dIa2tacjNwT3B4ck10Z0V1bTcwRURtb2VXVXc3RkZQV0czbW5rMFluOGJX?=
 =?utf-8?B?V09jU3Rob3pVNFMwMW0xV0g3cWtwVjNKeUtjMzVRSDArNWFmajJQVWliTzlw?=
 =?utf-8?B?OVM0MDdMaGhYL1RrcTUwUTJJbkNydDBNVWkrV3pRZFZZMHd0SWh6VE42enBW?=
 =?utf-8?B?LzJRWlVQM1NwOUJPZDMzeFRDdFlvcVZsbENRWFhQK2tHdkV6VDl1ZWpoS2FE?=
 =?utf-8?B?d1pzTk9pdmJWWENkZHA1bnVXWUhmY0dsb2V6MGh1b01QNFBRYTZFUkwzN1pU?=
 =?utf-8?B?aFNyZkhOdHJZMEU0VHFPdE01ZHNaN2lyWU5INTRKT3ladWdwblNNcTVUbnhV?=
 =?utf-8?B?QmhoN1cxUU5qTnRxR05ISWhNVjR6V1lYaVRBV3pHcDd0NXlSeHl4TEVrUDlv?=
 =?utf-8?B?Q2JoNkZLYWJFQjd5TFVSb1FLVXhhWmxFbHVBUTdveE9kT2Q4UXBUZnJVbnpF?=
 =?utf-8?B?NXVTdHkzSU56UzcxajRMb1VhMUFxY0MzVEZwQkhmdWI0K1BNVXlmZHU2b2ow?=
 =?utf-8?B?QUdEc1RCMTd0US8xVjR1RnZpd04wSCtRbG5DVjZqSnNrdGJobkdGbUJ3clpQ?=
 =?utf-8?B?TnFzRzNNWFY1ZVg1aFpBYi94SlFTMkI1Y2VjTEdDQWJNcXh0aTdudmFtMlB6?=
 =?utf-8?B?VjJzejREcEc2OW8yOG13ZkhNc3ZESnNWeWVIazB5bFA5NjBheE9GcDFabEFJ?=
 =?utf-8?B?Mm8yRHRseVhtNE85NWJMYlBQR25tTXMzR1ZVeFFYOEVRLzMvdW5IaWlYcW5U?=
 =?utf-8?B?WVRGOEYyWlpybGkwdHpXa0oveGsrbTZrZVFsMDhLREtGU3F3T3Q3TzJ5R1N1?=
 =?utf-8?B?S1Nid0dwUXVlT0x3aGNNUjhIVjRldnN1c2pUbUZOR2tSa3o3SHV6eVd5Zk1S?=
 =?utf-8?Q?yXXssvJnFylQnwrc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Gixb8q7hLZSwoAK8915Pxi63UaR5ZCqjPytx/WwA4pyvc+T4zeeg5Q/5zJSMPh+p0SOQLWYy0VZOE54LlWet5f+61cjttV7W/uclQA+R/QXm4bG0gd4k8HtRRb1KCK1mKosc7CkGiYAHmd9wctoQTrbVhKGbtLODB8QFbwksMC/rCRKqFcXpVuixvCNds2sRGqscXdiuEqb8+C9ADfBlT1NHmA5zaNHG4WGfvfUnLyQk9x2TyDuWMQrqKhN8ASWSpXrm1Jb4/hiUMd1j50ye1NX6gmBaCEmiOPtoScatAVC7BP23tbyyPZpMAeIRp0LhWZZBEfFSi1bjBcxwmFGjcg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF7551E6552.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 965fd5df-a851-4952-1fae-08df29e08b1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2026 10:47:29.2086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4M1xNz6m8LNmG05GssmCg///seEcrj56VxY5K4dGlboUpKdA9yQohfydmOp1NB5p9wgF7TE+zSIFQkptY/KZsQGqPRNMr6LPxl887XnOBsQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB403611
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWluYSBBbG1hc3J5IDxh
bG1hc3J5bWluYUBnb29nbGUuY29tPg0KPiBTZW50OiBNb25kYXksIE9jdG9iZXIgMTIsIDIwMjYg
MTA6MjIgQU0NCj4gVG86IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiByZG1hQHZnZXIua2VybmVsLm9yZzsgYnBmQHZnZXIua2Vy
bmVsLm9yZw0KPiBDYzogTWluYSBBbG1hc3J5IDxhbG1hc3J5bWluYUBnb29nbGUuY29tPjsgQXl1
c2ggU2F3YWwNCj4gPGF5dXNoLnNhd2FsQGNoZWxzaW8uY29tPjsgQW5kcmV3IEx1bm4gPGFuZHJl
dytuZXRkZXZAbHVubi5jaD47IERhdmlkIFMuDQo+IE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dD47IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAa2VybmVsLm9yZz47IEpha3ViDQo+IEtpY2luc2tp
IDxrdWJhQGtlcm5lbC5vcmc+OyBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+OyBUYXJp
cQ0KPiBUb3VrYW4gPHRhcmlxdEBudmlkaWEuY29tPjsgU2ltb24gSG9ybWFuIDxob3Jtc0BrZXJu
ZWwub3JnPjsgU3RlZmZlbg0KPiBLbGFzc2VydCA8c3RlZmZlbi5rbGFzc2VydEBzZWN1bmV0LmNv
bT47IEhlcmJlcnQgWHUNCj4gPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47IE5lYWwgQ2Fy
ZHdlbGwgPG5jYXJkd2VsbEBnb29nbGUuY29tPjsNCj4gS3VuaXl1a2kgSXdhc2hpbWEgPGt1bml5
dUBnb29nbGUuY29tPjsgSm9obiBGYXN0YWJlbmQNCj4gPGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNv
bT47IFNhYnJpbmEgRHVicm9jYSA8c2RAcXVlYXN5c25haWwubmV0PjsgRXJpYw0KPiBCaWdnZXJz
IDxlYmlnZ2Vyc0BrZXJuZWwub3JnPjsgS2VlcyBDb29rIDxrZWVzQGtlcm5lbC5vcmc+OyBMb2t0
aW9ub3YsDQo+IEFsZWtzYW5kciA8YWxla3NhbmRyLmxva3Rpb25vdkBpbnRlbC5jb20+OyBVd2Ug
S2xlaW5lLUvDtm5pZyAoVGhlIENhcGFibGUNCj4gSHViKSA8dS5rbGVpbmUta29lbmlnQGJheWxp
YnJlLmNvbT47IEppamllIFNoYW8gPHNoYW9qaWppZUBodWF3ZWkuY29tPjsNCj4gTWljaGFlbCBH
cnplc2NoaWsgPG1nckBrZXJuZWwub3JnPjsgSmFrdWIgUmFjenluc2tpDQo+IDxqLnJhY3p5bnNr
aUBzYW1zdW5nLmNvbT4NCj4gU3ViamVjdDogW1BBVENIIG5ldC1uZXh0IHYyIDYvNl0gbmV0OiBr
dW5pdDogdGVzdCBuZXRtZW0sIHBhZ2VfcG9vbCwgYW5kDQo+IHNrYiBmcmFnIHJlZmNvdW50aW5n
DQo+IA0KPiBWZXJpZnkgdGhhdCBub24tcHAgKHBhZ2UuX3JlZmNvdW50IC8gYmluZGluZy0+cmVm
KSBhbmQgcGFnZV9wb29sDQo+IChwcF9yZWZfY291bnQpIHJlZmVyZW5jZXMgc3RheSBiYWxhbmNl
ZCB3aXRob3V0IGNyb3NzLWNvdW50ZXIgbGVha3Mgb3INCj4gdW5kZXJmbG93cyBhY3Jvc3MgcmVn
dWxhciBwYWdlcywgcGFnZV9wb29sIHBhZ2VzLCBub24tcHAgbmV0X2lvdnMsIGFuZA0KPiBwYWdl
X3Bvb2wgbmV0X2lvdnMgd2l0aCBib3RoIHBwX3JlY3ljbGU9MCBhbmQgcHBfcmVjeWNsZT0xLg0K
PiANCj4gQ292ZXIgZ2V0L3B1dF9uZXRfaW92KCksIGdldC9wdXRfbmV0bWVtKCksIG5hcGlfcHBf
Z2V0L3B1dF9wYWdlKCksDQo+IHNrYl9uZXRtZW1fcmVmL3VucmVmKCksIHNrYl9mcmFnX3JlZi91
bnJlZigpLCBwc2tiX2NvcHkoKSwNCj4gc2tiX3plcm9jb3B5KCksIHNrYl9zaGlmdCgpLCBza2Jf
c3BsaXQoKSwgc2tiX3RyeV9jb2FsZXNjZSgpLA0KPiBza2JfcmVsZWFzZV9kYXRhKCkgKGNsb25l
cywgdW5jbG9uZSBvcmRlcmluZywgcHNrYl9leHRyYWN0KCksIGFuZA0KPiBza2JfbW9ycGgoKSks
IHNrYl9zZWdtZW50KCksIGFuZCBkZXZtZW0gdGNwX3JlY3Ztc2dfZG1hYnVmKCkgLw0KPiBTT19E
RVZNRU1fRE9OVE5FRUQuDQo+IA0KPiBFeHBvcnQgc2tiX3NoaWZ0KCkgdmlhIEVYUE9SVF9TWU1C
T0xfSUZfS1VOSVQoKSBzbyB0aGUgdGVzdCBsaW5rcyB3aGVuDQo+IGJ1aWx0IGFzIGEgbW9kdWxl
IChDT05GSUdfTkVUX1RFU1Q9bSkuDQo+IA0KPiBBc3Npc3RlZC1ieTogTExNDQo+IFNpZ25lZC1v
ZmYtYnk6IE1pbmEgQWxtYXNyeSA8YWxtYXNyeW1pbmFAZ29vZ2xlLmNvbT4NCj4gLS0tDQo+IHYy
Og0KPiAtIEV4cG9ydCBza2Jfc2hpZnQoKSB2aWEgRVhQT1JUX1NZTUJPTF9JRl9LVU5JVCgpIHRv
IGZpeCB0aGUNCj4gICBDT05GSUdfTkVUX1RFU1Q9bSBtb2Rwb3N0IGVycm9yIHJlcG9ydGVkIGJ5
IE5JUEEuDQo+IC0gUmVzZXQgbWFjX2hlYWRlciBiZWZvcmUgc2tiX3NlZ21lbnQoKSBhbmQgY2hl
Y2sgc2tiX2Nsb25lKCkgcmVzdWx0cw0KPiAgIGJlZm9yZSByZXVzZSAoU2FzaGlrbykuDQo+IC0g
Q292ZXIgY29tcG91bmQgdGFpbCBwYWdlcywgc2tiX3RyeV9jb2FsZXNjZSgpLCBUQ1AgZGV2bWVt
IHJlY3Ztc2cgYW5kDQo+ICAgU09fREVWTUVNX0RPTlRORUVELCBza2JfemVyb2NvcHkoKSByb2xs
YmFja3MsIHNrYl9zcGxpdCgpL3NrYl9zaGlmdCgpDQo+ICAgZWRnZSBjYXNlcywgYW5kIG1peGVk
IHBwX3JlY3ljbGUgZnJhZ19saXN0IEdTTy4NCj4gLSBMaW5rIHRvIHYxOiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9uZXRkZXYvMjAyNjEwMTAwODM5MzUuMzI3NDE3OC03LQ0KPiBhbG1hc3J5bWlu
YUBnb29nbGUuY29tLw0KPiAtLS0NCj4gIG5ldC9jb3JlL25ldF90ZXN0LmMgfCAxMjA0ICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gIG5ldC9jb3JlL3NrYnVm
Zi5jICAgfCAgICAyICsNCj4gIDIgZmlsZXMgY2hhbmdlZCwgMTIwNiBpbnNlcnRpb25zKCspDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvbmV0X3Rlc3QuYyBiL25ldC9jb3JlL25ldF90ZXN0
LmMgaW5kZXgNCj4gOWMzYTU5MDg2NWQyNi4uNmYyMWU2YmFmN2ZiMyAxMDA2NDQNCj4gLS0tIGEv
bmV0L2NvcmUvbmV0X3Rlc3QuYw0KPiArKysgYi9uZXQvY29yZS9uZXRfdGVzdC5jDQo+IEBAIC0z
NzAsMTAgKzM3MCwxMjEzIEBAIHN0YXRpYyB2b2lkIGlwX3R1bm5lbF9mbGFnc190ZXN0X3J1bihz
dHJ1Y3QNCj4ga3VuaXQgKnRlc3QpDQo+ICAJS1VOSVRfQVNTRVJUX1RSVUUodGVzdCwgX19pcHRf
ZmxhZ19vcChiaXRtYXBfZXF1YWwsIGV4cCwgb3V0KSk7DQo+IH0NCj4gDQoNCi4uLg0KDQo+IA0K
PiAgLyoqDQo+ICAgKiBza2JfcHJlcGFyZV9zZXFfcmVhZCAtIFByZXBhcmUgYSBzZXF1ZW50aWFs
IHJlYWQgb2Ygc2tiIGRhdGENCj4gLS0NCj4gMi41Ni4wLjM4NS5nZDNhY2I5MGVmOC1nb29nDQoN
ClJldmlld2VkLWJ5OiBBbGVrc2FuZHIgTG9rdGlvbm92IDxhbGVrc2FuZHIubG9rdGlvbm92QGlu
dGVsLmNvbT4NCg==
