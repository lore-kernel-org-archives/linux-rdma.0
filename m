Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793883056;
	b=gp5FkSGoO1hHvuSdhwBtVjvmWZKh4v0z6kNMR2K2kcH/k/gkzQojUguUGrE8TmDO0z3W
	 z9L2kj1iL7yijezhyG7pYSEKIQIpdkxOz+TJzAhdma+gt3lBJOIHVOeoA3u/GoNmMUTsy
	 ADWLK7Uo2SXsj8P9atoSVLnyeO6BsqW3r6/H7X8x2+6YhF7L8UYGgc2iO2Yii0F6S7E8x
	 d4SCoPbgIs6DOw1vZVvD//rbjheJJd7RTXAUlz2kxzzPAl0uSrMrbEtDtXdY5wizxkf2/
	 IxS6ERlvyQjZS6/Rii5Qa0a02ykefjGZS0QY//8JucHh0bzbOhBUCfUeXssH7iE/qwQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883056;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ld-processed:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=tTm0aw1KwdQjIz2crEpeXc6IEwMkxQFjxql+mZgR+GU=;
	b=31vYKGIbUjroWq0s6VzCelLTmvdgqON+xsg32shJXmyJTlETlAJ6JXVYmwToWTlB12K/
	 ci0cfNFeGuFOO4I4Wh+turK97DxkUiDDHuTtysDK6Jn3jpf1pEQA4hs0jM1XRT7JENl8a
	 T1puzk5Yy53UtcEcefuwDMfLSCBXQbEe9MyEs57JKN/9iV60x5EfXrIfBU5hGjYZH1/hp
	 6WvKXc10xsPtOKppV+/9Pe0Gk1Mg+ivXfP7yX55/47syOTpv1IVcuRR4A1Sn/Heoq1/uq
	 TZibAxB97d2KOOKETKr9vjdci5s9zA6zlMfw3eMX0c9GbVAsyPmodbU0vbbLRc/XPaA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="XTI/fOFQ";
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.14
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8B2606A326;
	Thu,  5 Nov 2026 12:50:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E8B2606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=XTI/fOFQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793883055; x=1825419055;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DVTEEKSZ6c8vusuvDYtwJ4nfHqai3fo7nPuajMtLxfA=;
  b=XTI/fOFQR5WBYnG5hKr5eUrDYVTq9p8RaVaiou5w4+ogesoYS/vbzT4Y
   1uwjsi19J8CQ2s32nHjx9MYFAU9m1DQ/1fp3oTsmz/cgo7ac+kPMcwL3e
   Vv8jNJLQ7hnhGG6pPNXhIUCySCyqKB6JpmQ2MHXFsyILEKIU6K+QHR45T
   2Z/JiLa9dYHE+GDGb/8mwNx63VRhqT3Ihe2yeQQGsJFgArX79y3GwJiQP
   TcsRODuWDljMo3TGrhZu9QcXtGJYMqy5iylyYJ0bIXfGXbzhowLy+cOVe
   /CmDZp/UyWeK8lEkOs+qzBk3H6q6g756yRM+u+hVhCm0uQVOhzT7/8/ef
   g==;
X-CSE-ConnectionGUID: 9x+iFeQ3TAG/4slIdz+f2A==
X-CSE-MsgGUID: qyIzo8H0TzOjUX4VqHooAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2557783"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2557783"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 04:50:54 -0800
X-CSE-ConnectionGUID: u88PAwlGQvuzY+xkiA39xg==
X-CSE-MsgGUID: sF1r355RR/2yisGZDf0RJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7015368"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 04:50:55 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 04:50:54 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 5 Nov 2026 04:50:54 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.25) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 04:50:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EAV/JO/o0xjuRP8v/tSlfc5DPULQGRLdKRH2PeX/BiIBXmAoWSFERoX2bOL25dW6ARnvjI9YESTUTimY/GspOTMheEK0fXtCUcmXaOmqysxthnFMSZMXvruIGoptMOVZLtqc6jk4UNHkukvff9PgWpWGZve0dqZ/ogOo6zoj7PzmN16+Sd4+pAPQSwuRcazHmX5CLrWEZtDfIhauxf0W1zgaf5Avlmj6XsB4t3AVHWFQNfOfztYbRzHIkyBCsHnFUMLx70naXPprBmWFoYl8OFZxrPqaGrqnqdj7xKBwhWcvNNdSwbnZC73ZeCQ4rrAR7J5EWGZ6c+C/XqOnlPQJNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tTm0aw1KwdQjIz2crEpeXc6IEwMkxQFjxql+mZgR+GU=;
 b=affuBNXpyGE54OJKBIZhKhge18OXciT3Eeixvee93F1oa2aTaXSINGv+gAIlrTjVSRhSyJZcACbUR2OSj45LgESIx3iuS7IqGKxbBURNAOlRzDbAx5MKmgpEAJ/n3vRSxKmQo7Bu9oraKV/FH++GN3FQLcdMCW8+/SEhOe1kdo45y/8vGoDq4WydOG5wxLE9ci2DDpQnVZ0ehULVLWun5QB41PsQArxsnuvF4VQSUowJkUPENH5H1LuoXS3Cj6HUvFYn9aQ/vvigq5hnGKD0/0kkFwisAPMqHwF103QKM5xt0l2Ub5JqF9Cpk3hJeQVtu6Csm35DWk7f5aOq1f44vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB566895.namprd11.prod.outlook.com
 (2603:10b6:610:34d::22) by CH4PR11MB222363.namprd11.prod.outlook.com
 (2603:10b6:610:508::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 12:50:46 +0000
Received: from CH3PR11MB566895.namprd11.prod.outlook.com
 ([fe80::87f5:c8cf:d52:e584]) by CH3PR11MB566895.namprd11.prod.outlook.com
 ([fe80::87f5:c8cf:d52:e584%7]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 12:50:46 +0000
From: "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
To: David Hu <dhu@x6u.co>, Mustafa Ismail <mustafa.ismail@intel.com>, "Shiraz
 Saleem" <shiraz.saleem@intel.com>, Leon Romanovsky <leon@kernel.org>, "Jason
 Gunthorpe" <jgg@ziepe.ca>
CC: Jacob Moroni <jmoroni@google.com>, "intel-wired-lan@lists.osuosl.org"
	<intel-wired-lan@lists.osuosl.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "David, Hu" <xuehaohu@google.com>
Subject: RE: [PATCH rdma-next v4 1/6] RDMA/irdma: Plumb uverbs_attr_bundle for
 QP, SRQ
Thread-Topic: [PATCH rdma-next v4 1/6] RDMA/irdma: Plumb uverbs_attr_bundle
 for QP, SRQ
Thread-Index: AQHdaxojO7oKbe9RvUq/94D6I1H5g7cfckMw
Date: Thu, 5 Nov 2026 12:50:45 +0000
Message-ID: <CH3PR11MB56689519BD2B2A4CD964487E0DE5772@CH3PR11MB566895.namprd11.prod.outlook.com>
References: <20261030181512.2056056-1-dhu@x6u.co>
 <20261030181512.2056056-2-dhu@x6u.co>
In-Reply-To: <20261030181512.2056056-2-dhu@x6u.co>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB566895:EE_|CH4PR11MB222363:EE_
x-ms-office365-filtering-correlation-id: f1d14584-c464-4bd5-57a7-08df3b3b6903
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|261021121427099003|261022105027099003|11063799006|10067099003|4143699003|261022113327099003|261021135927099003|56012099006|261021123027099003|261009223027099003|261026121527099003|261028144727099003|261022075727099003|261022115727099003|261021130227099003|261102123227099003|261026130827099003|261026140227099003|22082099003|18002099003|6133799003;
x-microsoft-antispam-message-info: lB+O9XPdkNOTiKrtMIn8ddEpL6zksUIDekzehefFqYvEDfW+c/yU3BBzu3zFX5Pc4uptauXxYHZUw2o5NpjhBBwk8SHARsySLKwqhsBKp0d3S4jP70Z5Xd8nZixqaDBBurTjRfkngRWLoCDyIg5qA1AUaGOX0srie+D4eojGM0wUHM+GfdFNAlvRi+W4ExhGTMytLcsuTHyV9iwYEB2uipwQc564xAKhlFQT8llPqW2oYF5UgNF5Y6zsWUAiBgZWxve6MS+cHa4pdB3swjcE7CkNDcfVrV7CiGDfH8CBciqkP1vfYRztLe69EHyZJu7JhTosRjUXoZTWVnRgfSwBRshZY/uJewsuac515KhWRNG1ydedYofN8ALsIIGQW9DAUHjqAA0bMcp4U676EtvvO1ugtkzUucWI3gZKHVE3l62nI+dZ4PKP++pPJyTaruzFAPvUNMNHhWjyYQRqYvZFqy5g9ZSSm8rzlZYmA/uIeBmxAxi4ywB8PtUu39JWzF63cF6Vkp14dO/6tzjMoq6jef/iKbqMmcTz9cH3SS4qOkhPPvtFLK0IxTs+dY5NdHoivYwOYh5MX57iDvpEFaz1A/n43Olpg0iHVCtOU+tD7OR0kgW/hpyDX9lwutMqqYy71mvE8IcoZYHW5+IpX3MDdHJx0iCU35++8zv0mkY6bQ1lXKpSpj1hH1avTBwX03mNbhCgScJpGNEXs9/MnKD3wwVf0xHxxnvDOVVAPeavW9A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB566895.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(261021121427099003)(261022105027099003)(11063799006)(10067099003)(4143699003)(261022113327099003)(261021135927099003)(56012099006)(261021123027099003)(261009223027099003)(261026121527099003)(261028144727099003)(261022075727099003)(261022115727099003)(261021130227099003)(261102123227099003)(261026130827099003)(261026140227099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3OBURU3ehhdcyLzlPSgUWS/TjJcZyzty/ie4D6uYLOBQzz6sfHL5dvzpvSQg?=
 =?us-ascii?Q?XQGCNuGGq1nkwqZCHuywU2k4dvIGdNAeMk0jnwDB8EdRd7GlbBL93+qJL7so?=
 =?us-ascii?Q?MJAFXD8fER7gHTG763x+lLSiyp/P3MRKI1yTYYAaKTch0elq4FOFpbI09Ubl?=
 =?us-ascii?Q?gh0aqbtoFVukfZs90x3hPVB8BdsRzGPg9BS82EEPd5KaDH3Zn4UXsqxGqwP/?=
 =?us-ascii?Q?WCIzo+pZ6OB3m3jCjYdny5mjAeNPKXWdOv3JrlQIR1SNp9yHvUESp3AKFtmW?=
 =?us-ascii?Q?rZqVyRNeE/iC/2Oii9Mj0Df/iTD4QTyt7jB9Qsvx4qicvsz1YR7fcZtej5H9?=
 =?us-ascii?Q?xiXkJjCMg/H0grhc/+HSZP6Wo8BPFxuFqP4IsxUfRS6qnLOp+RSzzxvg/f3I?=
 =?us-ascii?Q?ytdMjMg+I3hFh7pY/5dUclAnIqbZNRdkwacPX0osMXNeGCIwzReKxob9iXV/?=
 =?us-ascii?Q?TnZHQeYrLE69WKbAcYLh2QtejubA5dx3FLEclm+NU2++HiNOJCObI4Ort8T0?=
 =?us-ascii?Q?3a2swxrd43/6w20ORQWG6DNx6duPRzEYNhunHRYlmNPF4H8TYT77jnv2JsQQ?=
 =?us-ascii?Q?+kV4lLVcoGaT++Kx3mbmsR+LTqgZKEfMgCjsZ6UH8rC+PHfKjQ6SyaSxeweA?=
 =?us-ascii?Q?6xucV/w9IC6lHt6n8gEq5oxkrQAFLlNy6UYNDZxrRT4C6B2MqhcVe/KZG5tP?=
 =?us-ascii?Q?qeZS84zFLSm7QXP6BcKURTxMgTusdlXQB4s8CurNSPSMGe8lURSgfbrI2qe+?=
 =?us-ascii?Q?ZTv0nGcPhFC8DyrTc4Fayew5XkfHzSUiiw05P+QleYFrIyaj2aLJK+rT1q/x?=
 =?us-ascii?Q?iPMahv0pxaPX64T+uuTK8vpGgi3zjU/RBW3Q6PsDMTQWhN4E6oT6zg947R9O?=
 =?us-ascii?Q?FauP4BDE6CQdAwzbF3IbSdtW1gri5y3etZ59ByeO6mE0jJljHUv4nlQ19fFk?=
 =?us-ascii?Q?FKxwS2gG9RA2z2KwEQPuhm1PiTQLJl7+KLDR0CJgSu+7v4RB0+O1z/TtiBes?=
 =?us-ascii?Q?SDnDq8ggRQ7jSe8NH7NtwlZNGm8GAbMnhsbem/nUfPqJ4c5W0Nw8nPTnWg36?=
 =?us-ascii?Q?x46P4BJAqlrknANeX4M/I+6pOpDNcVhJlJjNPHUoSjZheNNLJLGaX1NkKO1c?=
 =?us-ascii?Q?esCsV75dNA9VHU82zNLWd0IBP9l2FrxRWEHv7k+PzBlSaJCv8cs26+0cXABx?=
 =?us-ascii?Q?7O6zVnaA3kXXey0fPPeoWrt/Hw+QvmCwqLFGaAg/Fk2IHgEk6ssFrwOErvhv?=
 =?us-ascii?Q?6H9GZ2Bt0NDSg4IcFGZVw63dRsIXmsMOi7um9mRiEGu5bW3TvE1Haps+nOHQ?=
 =?us-ascii?Q?W+sV3lXVKChPlaxn97wWtXc9CJu9Llgc6zBVVTygf3zux9OV8HwU/58LJZeV?=
 =?us-ascii?Q?L9MZyIKh2vnk/c0vbbzEAfpzC6LVMKR1XKdl+jztxVwVtUZ1mzFseOxmYV83?=
 =?us-ascii?Q?s5grlfzSJ1Yq9U8qFXXmBFZVjkGUGhTrEdxq670duzg23Zh3wLGTHQQERgxI?=
 =?us-ascii?Q?XYo2CX9rtGf8AsjWy2IbxFkA8TNH2kwBCnMJOhJu7A5zk6L742UXbTkNwU86?=
 =?us-ascii?Q?1twmVTkVjYyNP2MvDLfL2OaHxpKCIXBpV+T5NlzrcoJ9f0B5o/cFjF7pHCCQ?=
 =?us-ascii?Q?0awqy+1pSwUym9PxJseSHkYmCKmm2aWMzNfRas8uc3BYOpctkngDrOHrqQMM?=
 =?us-ascii?Q?TLOUPYo4v3VN2EvHrEPYyyM5jyQd5J1ig0kJhOjVudTIhw1butg60+HLppnm?=
 =?us-ascii?Q?TfEhbr1udrt8AWwSufUyv6tZ3UY31UM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: LwkuJVgHtlFIh5Yjw9SRLcfj/MZsqOV2cEtpYIEAqbidmpefBQzuC71VmxGLooVOtydtVnsrvgCLeW3Ia1U0n7oTFyHb4ZUJcqmhPOieEIjfcRHG9cIirfTyP5uMbTP+gN6OJ1A3TfSRzuZM0y+QluwXvmZXWnsFEGeDA1E23c/3FYAONjacydJvsNuv4V+t+VUfRMuuoobxnsVdHiTcRtjNF46vpJFk4F4d/dU/vj4V5N+C5QWetY0H+bSkgs/An0Wd4TZgr7uXLyXZztXkrmxNAeMOYVBRno4vGEPHplhyT1xXqM2BC+z/5sf5RkT/csqjBDSvjP3UALWBnPMxfw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB566895.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1d14584-c464-4bd5-57a7-08df3b3b6903
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2026 12:50:45.9761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 98/3Sl4Xd0Q5LVdxD5OtfgcUa7tjcjZG/+sY+j7sY4LmF4VcBoIbqGkwGJDgOPO72GNnZ1cJFNoWegEJpNs3oQjpGw9/FNbTSBm04PY2jZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR11MB222363
X-OriginatorOrg: intel.com



> -----Original Message-----
> From: David Hu <dhu@x6u.co>
> Sent: Friday, October 30, 2026 7:15 PM
> To: Mustafa Ismail <mustafa.ismail@intel.com>; Shiraz Saleem
> <shiraz.saleem@intel.com>; Leon Romanovsky <leon@kernel.org>; Jason
> Gunthorpe <jgg@ziepe.ca>
> Cc: Jacob Moroni <jmoroni@google.com>; intel-wired-lan@lists.osuosl.org;
> linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org; David, Hu
> <xuehaohu@google.com>
> Subject: [PATCH rdma-next v4 1/6] RDMA/irdma: Plumb uverbs_attr_bundle
> for QP, SRQ
>=20
> From: David Hu <xuehaohu@google.com>
>=20
> In preparation to support modern UVERBS ioctl attributes (such as
> UVERBS_ATTR_UMEM for CoCo DMA bounce buffers), we pass down
> `uverbs_attr_bundle` for inner QP, SRQ routines. Since standard uAPIs
> provide `ib_udata`, we derive it via the helper macro,
> `rdma_udata_to_uverbs_attr_bundle`. `irdma_create_cq()` supports
> `uverbs_attr_bundle` already, therefore, this patch fills the gap for QP
> and SRQ.
>=20
> QP, SRQ uAPI will now have `ib_udata`, and CQ uAPI has
> `uverbs_attr_bundle` as a top level input. However, we think it is a
> future project to unify them.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>
> ---
>  drivers/infiniband/hw/irdma/verbs.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/irdma/verbs.c
> b/drivers/infiniband/hw/irdma/verbs.c
> index c91c55917de9..811b1d532599 100644
> --- a/drivers/infiniband/hw/irdma/verbs.c
> +++ b/drivers/infiniband/hw/irdma/verbs.c
> @@ -637,13 +637,15 @@ static void irdma_setup_virt_qp(struct
> irdma_device *iwdev,
>   * @iwqp: qp ptr (user or kernel)
>   * @info: initialize info to return
>   * @init_attr: Initial QP create attributes
> + * @attrs: uverbs attribute bundle
>   */
>  static int irdma_setup_umode_qp(struct irdma_ucontext *ucontext,
>  				struct irdma_create_qp_req *req,
>  				struct irdma_device *iwdev,
>  				struct irdma_qp *iwqp,
>  				struct irdma_qp_init_info *info,
> -				struct ib_qp_init_attr *init_attr)
> +				struct ib_qp_init_attr *init_attr,
> +				struct uverbs_attr_bundle *attrs)
>  {
>  	struct irdma_qp_uk_init_info *ukinfo =3D &info->qp_uk_init_info;
>  	unsigned long flags;
> @@ -981,10 +983,14 @@ static int irdma_create_qp(struct ib_qp *ibqp,
>  	struct irdma_qp_init_info init_info =3D {};
>  	struct irdma_qp_host_ctx_info *ctx_info;
>  	struct irdma_create_qp_req ureq =3D {};
> +	struct uverbs_attr_bundle *attrs =3D NULL;
>  	struct irdma_srq *iwsrq;
>  	bool srq_valid =3D false;
>  	u32 srq_id =3D 0;
>=20
> +	if (udata)
> +		attrs =3D rdma_udata_to_uverbs_attr_bundle(udata);
> +
>  	if (init_attr->srq) {
>  		iwsrq =3D to_iwsrq(init_attr->srq);
>  		srq_valid =3D true;
> @@ -1071,7 +1077,7 @@ static int irdma_create_qp(struct ib_qp *ibqp,
>=20
>  		init_info.qp_uk_init_info.abi_ver =3D iwpd->sc_pd.abi_ver;
>  		err_code =3D irdma_setup_umode_qp(ucontext, &ureq, iwdev,
> iwqp,
> -						&init_info, init_attr);
> +						&init_info, init_attr,
> attrs);
>  	} else {
>  		INIT_DELAYED_WORK(&iwqp->dwork_flush, irdma_flush_worker);
>  		init_info.qp_uk_init_info.abi_ver =3D IRDMA_ABI_VER; @@ -
> 2337,7 +2343,8 @@ static int irdma_modify_srq(struct ib_srq *ibsrq,
> struct ib_srq_attr *attr,  static int irdma_setup_umode_srq(struct
> irdma_device *iwdev,
>  				 struct irdma_srq *iwsrq,
>  				 struct irdma_srq_init_info *info,
> -				 struct ib_udata *udata)
> +				 struct ib_udata *udata,
> +				 struct uverbs_attr_bundle *attrs)
>  {
>  	struct irdma_create_srq_req req =3D {};
>  	struct irdma_ucontext *ucontext;
> @@ -2420,6 +2427,7 @@ static int irdma_create_srq(struct ib_srq *ibsrq,
>  	struct ib_srq_attr *attr =3D &initattrs->attr;
>  	struct irdma_pd *iwpd =3D to_iwpd(ibsrq->pd);
>  	struct irdma_srq *iwsrq =3D to_iwsrq(ibsrq);
> +	struct uverbs_attr_bundle *attrs =3D NULL;
>  	struct irdma_srq_uk_init_info *ukinfo;
>  	struct irdma_cqp_request *cqp_request;
>  	struct irdma_srq_init_info info =3D {};
> @@ -2430,6 +2438,9 @@ static int irdma_create_srq(struct ib_srq *ibsrq,
>  	u32 depth;
>  	u8 shift;
>=20
> +	if (udata)
> +		attrs =3D rdma_udata_to_uverbs_attr_bundle(udata);
> +
>  	uk_attrs =3D &rf->sc_dev.hw_attrs.uk_attrs;
>  	ukinfo =3D &info.srq_uk_init_info;
>=20
> @@ -2470,7 +2481,7 @@ static int irdma_create_srq(struct ib_srq *ibsrq,
>  	attr->max_wr =3D iwsrq->max_wr;
>=20
>  	if (udata)
> -		err_code =3D irdma_setup_umode_srq(iwdev, iwsrq, &info,
> udata);
> +		err_code =3D irdma_setup_umode_srq(iwdev, iwsrq, &info,
> udata, attrs);
>  	else
>  		err_code =3D irdma_setup_kmode_srq(iwdev, iwsrq, &info,
> depth,
>  						 shift);
> --
> 2.56.0.317.g454f8302e1-goog

Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

