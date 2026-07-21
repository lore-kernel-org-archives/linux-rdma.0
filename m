Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11022141.outbound.protection.outlook.com [40.107.200.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF7546EF61
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 20:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665670; cv=fail; b=P3OWTIhMyzw92doUMs+swdD4xFgzcLpEj5RfO5SVmmO2EKa0rw6jQAOLGPo5lwr4aMJusBxGUIDTDG2qwMUrGxD3LgunHjdPyqPwUjrSSCROD0hGrod7h9EHUaps4pw4CwVGPNaDL+gqq/RSA6EhU7WK/D4fhNnPOHHQvMfMdzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665670; c=relaxed/simple;
	bh=7IV2qNo4U71KuKKJFIC0TUg5CONcd1Ysut50Ic5Jois=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KoM0f6TGeYLhcu0ueOHlE0lGvxjT+9ECY/0M0YItBPapYMjidKEMYfeZG1Nvl699ElYgdfZBnQ/rGMAtzf17+hkW0dqOfJkv5HI4q5YNDFFOVWJ1Qz2PTF0EIKfZYtODTdGyMz04ay9EG+yOmWwK15YYXiGLfr9QLAg1SmoYAzc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=UOjdHmfx; arc=fail smtp.client-ip=40.107.200.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="UOjdHmfx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fXb8NQoG4li50qn8LxwRu28IplJUALqtVwGVercjuruYfBotdI6Nc+b/RBpxLpdYVLoBG+ZoiEsS7TYsqkLTknjc4FubS7uJroTfeiJ8NWbezzBX8skqxP2fv2VgPTXVsg1ce1kRqWj9Df9kGK9NWSzAGWSpFlh1DI9AOH4Nw8j01clMbnYl/uboCvzJnjbgd/dAu/5AETnYdpPiajbhRjRzcwy1CCbMowcBU8FXlGerfwwS4ywGZHjpx70otcwVwf5yjzYyTWVIrvnc63Kqm7JSSLAez/UFX6Oux8t9b3FdWBqxL1Z/+5fEBVqIu2FaMoSrY2cK8nZm9hId3G46AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7IV2qNo4U71KuKKJFIC0TUg5CONcd1Ysut50Ic5Jois=;
 b=Wm5Hu+XJ2kKZyy3j1jHIs4qRtX2zJFLlfb78nxJ2opWCe/ieOq7iz4W7by94ZGMqHpI2qbCu/aYB0ZFNye97dvi742nVJMCzNN/xa/E9D4oszZbr1Va4hfr1pYcxRlyLsSnJzDl7BvYkf8vOYttdYQslNSpB1NaKF3ULzLaIE1ef27Zw3+vY0mwzsND3LWOeJoK7UxALL2a4hBDyPYrvNFsrtaCTq9STlA527FMj/SBBC+Qj+bMk+lV2cZA9gUqu98CgnwciC5CCqYsRJCeddWrBOpXttQaeHrJ7f9avZ9CeiHgBKcuV3Zy0XJlss34T7st9mjHytgFCoPR6Ei3Oeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7IV2qNo4U71KuKKJFIC0TUg5CONcd1Ysut50Ic5Jois=;
 b=UOjdHmfxj8ewQoZ5EO4OkZvvWdqVikcWx64+GN1SIQu++V9KPLkJaD74yDTkxOwYrgShx1T96vFpsT0buPGAyx2+6MnhP5UNBvkVgPC8u+N0ki2xKxav+MrcKjmTxemLfW15+dF8+IEZFk/LdDLyyr143sTfTNHA1SJ76wOKs0ucJ+KoEcC+0Ic+4rMDQBrKVELeKqRQZuDDxv7vn9G2LvVHFheq1Ls1aquikXlFSxtdH6HwxPJFcgU+TOqhnyT/TXN6pm9d0MqRjNFKTpOGXvxcy2eKMvG9QuAWwlUOV8l/ZGyKMaPmCuq0WXxfxj4u0GVBuzk8BbrpDBdC90o3uQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 BY5PR04MB6488.namprd04.prod.outlook.com (2603:10b6:a03:1d1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Tue, 21 Jul
 2026 20:27:42 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0223.017; Tue, 21 Jul 2026
 20:27:42 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Timothy Day <timday@thelustrecollective.com>,
	Michael Margolin <mrgolin@amazon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	linux-rdma@vger.kernel.org,
	Gal Pressman <gal.pressman@linux.dev>,
	Yossi Leybovich <sleybo@amazon.com>,
	Marco Elver <elver@google.com>
Subject: Re: [PATCH v1 0/5] Support Clang context analysis for RDMA/efa
Date: Tue, 21 Jul 2026 16:27:33 -0400
Message-ID: <20260721202734.29592-1-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260721111030.GH110966@unreal>
References: <20260717031658.477397-1-timday@thelustrecollective.com> <20260721111030.GH110966@unreal>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0001.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::6) To DM6PR04MB4682.namprd04.prod.outlook.com
 (2603:10b6:5:24::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|BY5PR04MB6488:EE_
X-MS-Office365-Filtering-Correlation-Id: 3689f9c1-8861-451a-520c-08dee7668408
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|6133799003|56012099006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	bDG8AlKhBS5oHPmI6IDLwUaT1txBnZYpF0QlXPbgWSj8V99I29Ar+S8/1OGfipB+wcj+kcRvLfJsBbeCDsQaqUZSM3EqD+FlanaRNoaawwoKOJf1klrG2oHTFLigAI98WqahtwFUAP/RzzWkNu+n5Pp+b1FKHWmWZsxPT1L/6Qzvf0E3f1+jcGqtLrViHnTPGPE+GV/lOWc9CbSUrL/HsFbT5Gi1J8pJxNIMsXhD4+j/ZblpyrxhboQxq1ydVgv5gmN1kdjYfeY0R+z779ZWAbBm8CPZ5EA5IqdES9eP3Gkc9SyJPq+qRJ8XFHz1tNkVXYmABl3IRRzAitnL4jcRj4BnVSxbDumaQDUKvmWKe/6oB7gGfTPPGuUQUWk71R7zsGlfLIkzoDcH1ZcXaEVcZDgIT4ye/eIxadkjLPS8jqxLkk1QEt1wdj9meFAGgSURmD/5JkwrB4k6J7z44uauN8dYOvVq7JqHaliH3iDeauxlnlowOffM6u29BmQFdYFTSPE0uBLLw1rNnvzo1QZETbENEJ+oVspxtYl596hbXpYZCZmg/6iNiVgK+ADt7SGnli9214n+LgDTJ+cgdD0d2k2EGzNK6TFbDseDO3snbETWk2dNl+atJLbKMzA5046x4B5j3ggOzZxhNGivF0JEquI3RZFSjMaidEg2Vpri64A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(6133799003)(56012099006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OOOoqLtFSsAJtFxWNRT9hEXly8j10XXaIpZg1ruDiizuRH1lrClZMEpo4OCj?=
 =?us-ascii?Q?oDBVVF4akrGecyobmXYyfIljE+2SorgqghTmkyZ0aYCBSxoJtLU2ild9x5WI?=
 =?us-ascii?Q?q0QibuKtPqZxwzgAvOFkWZl4DSikl8QSZ26XlpIbkdSMht5uPWtpNedQGuPu?=
 =?us-ascii?Q?Siq37+usAdY/nMKt0YeoZOOj6Dj4KmSupNnHpkrfKjKlIwYZGY9x8OneCfje?=
 =?us-ascii?Q?dkc2szSwISDXMt9dV1kjZTM5FVGgFU1YxM6I8puHjVYYAATQY6s1QtRPI4tA?=
 =?us-ascii?Q?z0xweUhITPcmNYdqmKLWqu3zrGN9Mk1Gfoxl+mmpaC43Wv2wW2P1Nq0MmlTA?=
 =?us-ascii?Q?yiwnq3fzS6RH8z0dz6SuqnaVj+UzXP0OLgmsUT1bgdAg31n2UhxclX/ghdbS?=
 =?us-ascii?Q?X0/mGyGcrJs1sySRLzhV6FOOKnFjFBS2xhqiUGytRUXo6MFC1hi57PVZ2NS/?=
 =?us-ascii?Q?V29Md6DtZTVt8ssaO9h2cWgHzkNf3F2WCbHJQVx4AsYB0sMiBa2kWSehl4Rz?=
 =?us-ascii?Q?c9R6ztz0WtE/KYJ069MKgpLg/I0HgXGui6maqunQQvhBd9aWe5tJjJ9VaJx0?=
 =?us-ascii?Q?ccZZIyQirzdlu2fI2t8xRDc20UDLP0uDO1oblnwnpPpFUgzr6LgN9V73hglT?=
 =?us-ascii?Q?6z7nJBbQ6ysMiPFjDHzGSJkkHngIyOeOzJw9+tSUp+NztzU4f6spNsbMZmjp?=
 =?us-ascii?Q?EadQ32Z5uxRn5qge+2q6CrY73IuUsTJvOex8Qt5MXWrXzswBXrwV9+G4k4pF?=
 =?us-ascii?Q?7iO3RBg9oRT/8vy5NjY5+++HAYZG5bA7dShgh0mpfkKgjq6fKB3JIWTTnA+9?=
 =?us-ascii?Q?joIsBhhL2ymFggQ2cniRr/MN3eeWs7fwEA3eX8d/hYReAu/z8hmk0TTPey92?=
 =?us-ascii?Q?7TT7U/glAtnVTuXPmZoLXvx6kIp4B7Lh/rPqENnJBoG29c63N39sKIo38f/t?=
 =?us-ascii?Q?5Ip7Q/fpyKtpi0NRxo/RC16u2P6v2pzCv8f0Bc/YsAqt/UbLZnOpw0bY/83H?=
 =?us-ascii?Q?cKypKhHldjfkiehWyjeMv7LCNdUvFytmbmt2VzjiACb+eUNCuNeIjIS9tjLM?=
 =?us-ascii?Q?EDIirftfqhXPUE5JzTsvJIea9MBWIJQWXmLieQ5pD0EffZZVw24+Ogo/I50N?=
 =?us-ascii?Q?Gk/w/If0cwXl7CpTdWAJHffwu8V3Ef/F4HOnvp6+q28uixEITfdwnewSbb8e?=
 =?us-ascii?Q?ujF2cJ6WqxEca443wD9niB60ki0U5vMww3+UdlGi0Aayb5f0SH+QhPHVos0u?=
 =?us-ascii?Q?9uPdYDgdj2mfml++sTnHJbAvPOpoDTcFHDXSZPEC0ndcwix/n2OyfwzLOWaJ?=
 =?us-ascii?Q?rrjtaCBZYLLKwgPyp1hhwRPe2N5iCkQYvtWbypmxtNJObtuAz0LrZwPHU5jQ?=
 =?us-ascii?Q?gBvutMJtsfvny/wneYVscyiyrpKhrprfOWpj2sx3LZu2LhZvUQ4HdfjgDgJT?=
 =?us-ascii?Q?HUDVtFXqfCynPpsFiaATVgct6iElgxk0ai+AN4R8oqCOHHFsbPqNwukldRTf?=
 =?us-ascii?Q?/sFe8mQ5Nw5EB5EhqRqIR6qGqhfmVhOitkSbJR2tsc8rgHX8iTi7Xv+h/j7R?=
 =?us-ascii?Q?W5IDXn+c9eRIiJEJxM7VB3Nf1S7wsivBObtCzwnzt6CZ4dqN+un2wvWyozHA?=
 =?us-ascii?Q?fDbt0myHviAzBSQTt1boJGphOGklWNsw3GEmo1m6TNuybPhYHMMiKd1czf/V?=
 =?us-ascii?Q?zG25dL1WKqFUobFjkvEnbGy4mYGnBFBYn06fDU8r9IFwFW9aW1vzK0DIxVmo?=
 =?us-ascii?Q?fKpEZbJq7OjYItzB7CmyezuQp+HU0eY=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3689f9c1-8861-451a-520c-08dee7668408
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 20:27:42.3646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZvygoLnFxR38SljeCB9VRztHoHjEb66tkfNUA+HVnXs/iZhGOL/ko//hQljkQ45phIhicpIYGUPRTJm/rFScI0PQdRFd8KCFBSkrY6pMSjg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6488

On Tue, 21 Jul 2026 14:10:30 +0300, Leon Romanovsky wrote:
> On Thu, Jul 16, 2026 at 11:16:53PM -0400, Timothy Day wrote:
> > Hi,
> >
> > This series adds annotations for Clang's context analysis to the
> > RDMA/efa driver.
> >
> > Clang context analysis was recently added in a series by Marco
> > Elver [1]. This allows the compiler to validate different
> > locking patterns at compile time. This series enables context
> > analysis and adds new annotations.
> >
> > The series was built with Clang 23 (since the minimum Clang
> > version for this feature was recently bumped to 23 in 7.2+ [2])
> > with CONFIG_WARN_CONTEXT_ANALYSIS enabled. I based this series
> > on rdma/for-next.
> >
> > I'd appreciate reviews and suggestions. I'm especially interested
> > in suggestions on how we can make this easier to enable in other
> > parts of the rdma subsystem.
>
> Yes, this is precisely why I'm not rushing to apply it. It would
> be far more compelling to first apply this context analysis to
> drivers/infiniband/core, so we can evaluate both its benefits and
> drawbacks.

That's fair - the context analysis work is still pretty new. There
are some examples in other subsystems. I submitted a series to
convert ext2 [1]. And there's some on-going work in the block layer
to enable this for nvme and other drivers [2].

> On the other hand, converting drivers incrementally is the safer
> approach.

The annotations should be a no-op without CONFIG_WARN_CONTEXT_ANALYSIS
enabled.

Generally, I'm looking for false positives/negatives in the
analysis and opportunities to create helper functions/macros
to reduce the amount of manual annotation required. I started
with smaller drivers to hopefully reduce the amount of churn
required for larger components. Also, core code tends to have
more complex locking patterns.

But I can prepare a series for core/, if there's interest
in reviewing it. We can also hold off a bit if you want to
wait for more adoption in other subsystems.

Tim Day

[1] https://lore.kernel.org/linux-fsdevel/20260712165610.366474-1-timday@thelustrecollective.com/
[2] https://lore.kernel.org/all/20260706141452.3008233-1-nilay@linux.ibm.com/
