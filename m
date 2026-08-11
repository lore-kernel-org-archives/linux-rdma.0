Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013028.outbound.protection.outlook.com [40.107.201.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC3D37AA91;
	Tue, 11 Aug 2026 20:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786478551; cv=fail; b=Jnn6ml0HdEbSb0rmzP5NXqKyW8dwj0lYGVpwIWSmqfj9CD6cXP62wJTZVfbs1APEQfPZunBBj1sH1WmUn8baOhZQGo483Fl4F/KiRA1GWqdA5mlF8LBuioOmnvT8iFnLTty0DyI+SP3tOmKKbUg1Bfyz8RJ5MquhEG2f2xk2Ezo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786478551; c=relaxed/simple;
	bh=81TB5KubBgkQNJRHQVpTQ1ntUxqhBTwJFZlhRbIl2zY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=J/Q2FC87bVtNn2tXdiFCp4dohhNPuQCKy4XpFikaqKB/lVxItoq4URyu4a811COx/qO7bOQ2XDd7KSIjsgf5JqCC8f9ewDoK5b3RduwYeEdB7bn9yLGzapNxG+KGQFDf//GRStJ9KVs8FqyjfpgNOh+GKM38j0j/mCmK6ted+EI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=L+Ez53OL; arc=fail smtp.client-ip=40.107.201.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="L+Ez53OL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iPcxmf6AXhbTSAvOk7aYN9Ehzz6eAdj2M2WBRZijBmnfxxEvHXQq96uX9hwKF3FZZn/lya00p2zsOMr68v6LH+nRtas/+Uq/6E85d/rMNTWLHXt+h5/DDPES8r/opJrNwmNQyhXZ3aUM/Vu09MFyTSDE6JpwVWZGKoz82hNEkNISUKEhlfydemSA1M6MiYPCpnPP8tU9QAARTZNaple0RS+LtCY4Ex1W1DyKOzRI9hftNcr8Gge8PewO21fFiOJB5GcnYnaFzoOOA0De+eT54fL4C/O2wLf9zPONmldywhQ+bTHAev7eeEuHIfRufPXAFuQeSiZdt9n+Jd/nxdu1zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r26hSQl19WV6QzqXK2dAIl7V4wfjZs4fEeJ4EKGDPC0=;
 b=cqfMvjm4fpIo9NimbRuiNrtJpFduX7S12//PnhtZKZM8Kz91ukWuagBNzLHDos41Iu73g8c0krAivgLthwOlGGLvfR69iuwCN5ORTTyAfGTKW67IOHrQ53erpMbBwU0MREagIZiJbfxPrpYQ1aT8mmjGGYGUI1pwdcU4qU6llGGfYGlWGtWGgCoxnieeHP2f2cFbbs3YDoqS4DNUSZEjrICv6+UJQVW5YFLW9nKQ5mXewrFdswzPVy5S5SEUtnDcVuco27C3hBy2rDrKXt3gY8ATY/SlsPVZmiPqaPi/HrPedw2jDXPue95GdtK/+0zL+5QCm0z4QVMyt1AFYZK3LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r26hSQl19WV6QzqXK2dAIl7V4wfjZs4fEeJ4EKGDPC0=;
 b=L+Ez53OLzKz8PJ8vwXYTlyix2PjuG8m71mrDA+cGhUcX8fgOsW66EinTuQdDNxYQCldQjz1+b7EreGcC1ezqcBwc0CZjzYsd1MOPTLTXxAs+QPNQYJk7+eBpgO5xIapAb4AvXnLvdTpElKOHedTSxIFu8Z2q2notYJyLqA1qtPUBRFvTR6mv5rZWPF1UyP0kCz+l/lG/9DIhsN7+tYDXpi4cu0O6vp3m66qS2/9TXLUGdgNLtj8D6XhYk/9CcdOldr7G5SEfF2EzL+DwNxsvYxEVdIykO7VK5ZD2EWrGXn8j49rh8OSvC5DEmlnwlHcgQGmAv2AOiBjFH2yIHR8TMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MW4PR12MB7165.namprd12.prod.outlook.com (2603:10b6:303:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.24; Tue, 11 Aug
 2026 20:02:19 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 20:02:19 +0000
Date: Tue, 11 Aug 2026 17:02:17 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Fan Wu <fanwu01@zju.edu.cn>
Cc: linux-rdma@vger.kernel.org, bharat@chelsio.com,
	larrystevenwise@gmail.com, leon@kernel.org, dledford@redhat.com,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] RDMA/cxgb4: Cancel reg_work before freeing device on
 remove
Message-ID: <20260811200217.GA664971@nvidia.com>
References: <20260806130128.465460-1-fanwu01@zju.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806130128.465460-1-fanwu01@zju.edu.cn>
X-ClientProxiedBy: BLAPR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:208:329::18) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MW4PR12MB7165:EE_
X-MS-Office365-Filtering-Correlation-Id: bbd51f8e-ca77-4a77-9bbe-08def7e372b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YCPmtZwKLQlx2sr0nRlXrWyd87boES/n0QLswwVMFHabBagrhr6mUKNwbYkwWVg38wO0szZ635K5kFHj6RZJAvpKclL3FbdAgCgiXLPD2NpQkm3lLwAgpmOEr8rWscX8XVvzoLnHYcWl0DtAnMRP4OKbnnLlv4mPPi7zi30qpCofLRqFQZlN24dcnFQ9ijirN4jvATpRY/OyzA6KoVA6VU3zka8wOyub9c1CGDXam4uQfTRNpIoftyPjjgCteOpP4BEPtwfa1f9IYqrwPoWnOJDiw/yK16NjS1Fm/4Jz+nf4vey3N4C1I85AyrGnHN/OF1dpekJp9/j+8BTdNnHE0aMW03mSDEsWVp7Cld1xmleTQ6U9P79jo8W8KoQCZ63bGYgZb0vKv7sgAXn2tNAxPM5DDq8hIV0ly2NTOxeNqumeF+Mard86EaCcUGJdBi+enHExcsRHC8RPmLYjBsPEsWNmPie4CkjEoigscOF+p2cOj+4/aXvUNMg7r1vN3B0Z57jsWzuVJwBhtvF9UwLG3IBJGX1jabMfQOVCqrYtR+ahmpTMM8S3DOANZAGZUuMY7rG0EV4ZcWsXYtYA6sM3YbxrGgflJeJhSi7Tlm61WKnlbOh+T/vUSoFmdJgvq2qTHNzKaEyLgRpNU+nRIVVGg0VdybXcrFwR6xwmnd5MmKY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M3YkfjV2jtSxykEd56D7fklY79XPX866wH3ROqEpQq45JLdNpxIV3w/neF7g?=
 =?us-ascii?Q?qz4Sp6SsICZIab/wkD9MuyIHFm+NcCcIHU2GTQyfDGsvve+9kA5N581OfGAj?=
 =?us-ascii?Q?uPOs15xkeazqITW71zPYO0OebTGjKnNF0104IW5VEqCPgDk1WW9t6W6cIUwO?=
 =?us-ascii?Q?xH3XKA1DIC/hSyiRfafBU9YOwifOSRxRSN5DLGCA58gU/fvw3k5PSrnvvH7D?=
 =?us-ascii?Q?eCM4Pa/T6Ltb7Z9vtT9uBfohU9GoDAwEIz6amhwvrVwIx6M7n7wziBCcHF17?=
 =?us-ascii?Q?U9tJ7AvW8Jjhy/cRJw51RWoaCE0hAxfLmlT+6JETNRY7ymmgPweKfqll6AZ6?=
 =?us-ascii?Q?DydjWfsILWVkbarEPEeEhCn2ie8qkxOt2HH5xwt2kRmaQS97Oqp5xVP0hS3f?=
 =?us-ascii?Q?/3rQAlBjdejQaQiS2dgImiQFgoliPSGMxvkuWuhhBwdR55bjQ93W/pyXax/j?=
 =?us-ascii?Q?G8DLF9wqGK2pdIhv4V4K3h7wK6uJ4zA119idgHCYgnpItHortXjjxMtzjdk/?=
 =?us-ascii?Q?x/V7e/uBVfct1RoExsWpQVDxS7LGo9YRdqq7k9Jsp2BJkrcopgATf/U+JCJt?=
 =?us-ascii?Q?pDZFhwrpQbu/Y8/znYa7qcP5tAHCH3fpmkV/rzLTLWCPwkg9pDOvxDNJz+kP?=
 =?us-ascii?Q?VptwP6JBHGHWjLBnixCxQhR2JIXJONmPbWA05tgjmMdqnQ+/5K4/BaNw1TW/?=
 =?us-ascii?Q?MCaH4tgHfx7HEzAePyb307yFjIhPQnDvoSMD1KcWmolQitVOZBIFkTvYBNmT?=
 =?us-ascii?Q?PkiaR4AgPIn62yzXECZnLfGNuiqwMtY6M2pwMGvXTW4LK/gdR5vDUMhUn6p0?=
 =?us-ascii?Q?zqKp+g4fQcfmZklgi9ZXkNJ+Dq8wsX8YVDDfDyO6Rag07wGXjjSnYhwoXuoB?=
 =?us-ascii?Q?lmwqLz2wjKV5iwmJjDTdr5qsTFXLijOGhW3vV84YSxMhpWn5hU7u7Kd4631x?=
 =?us-ascii?Q?yDssWcnTAMhfFoC3hz77biWcJxo34EpUB28qykjZXb1b3bgsms42FmD4AdOB?=
 =?us-ascii?Q?kRiUUyhPBK17bSZcHisUUyhDzt8+2t+FVceowDpHZtpX5m+7m6/PcoU6fy4N?=
 =?us-ascii?Q?649rWeyACUmygcp1OVp7/oik2CTNuk5cI8Z2xZ2pDKldBDMrJre5EozTbZAC?=
 =?us-ascii?Q?sj5y0/cVadS1yg4AyFOd8yUm98pt8i8+qd7oE3HouvPRVZXtXCr57s737XQd?=
 =?us-ascii?Q?gjDhc1RA8YEl2AXRkV8Fv369iIHNRwihBvWXBS2QBcg94B92VAe9W/rxqTR9?=
 =?us-ascii?Q?BvJlMLOVnrb7oZX7RsbpehKzadOBhgu0YR7uqrfizgLpZXARyzYcR5GD5Pto?=
 =?us-ascii?Q?6PF4tJOMPHaUCDUn7+wIAGxsf81gKNTnXhCw1S3AJ571hBeJpVv3KO11YNlg?=
 =?us-ascii?Q?m8hdFohyXjpLbsThTUppBXRt6FD04WV84Y3cSmy3bK3rYsE3RcRXZ64bFQfS?=
 =?us-ascii?Q?xJFBoP5pC7K/TOdFdSLB5MGcWrbZR+R4kqWZdDwUvz2zJiyKojZfReXQ/UNa?=
 =?us-ascii?Q?0QS1OdAkjAZT1ywnRTXAYMk/5uJHJ7xVEPczmBp3YglhW01MLvVdqAa16mkH?=
 =?us-ascii?Q?1aJh0nsLuKbtF3/izhpxAJ9HAKkoACrU71RvtXoVkvVVRZA6V2V+FLqX6qAn?=
 =?us-ascii?Q?7eM+i6jG8mOMhQpFQUN1S127GfCKTefcHaSQBJWwhbvP2BlglyngYojpinZx?=
 =?us-ascii?Q?M9y3pD+ZmFUFo/CckR+PR2xcKXaEpAxzBnIAcoVdisHCDxe/lPhPr4FnFQhl?=
 =?us-ascii?Q?VwupWOlNzQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbd51f8e-ca77-4a77-9bbe-08def7e372b7
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 20:02:18.9571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UziD1Vyb3mAcqI9B3oszc0wDy3HPGbkxwbzSJoiA/34fPBy85eaK1YuMV9WaEIgR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7165

On Thu, Aug 06, 2026 at 01:01:27PM +0000, Fan Wu wrote:
> c4iw_uld_state_change() queues reg_work to register the RDMA device.
> c4iw_remove() can free ctx->dev while this work is pending or running,
> leaving c4iw_register_device() accessing the freed device.
> 
> Cancel reg_work before removing the device.  The registration work can
> tear down ctx->dev when registration fails, so do not unregister or
> deallocate it again in that case.
> 
> This issue was found by an in-house static analysis tool.
> 
> Fixes: 1c8f1da5d851 ("iw_cxgb4: Fix possible circular dependency locking warning")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5.6
> Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
> ---
>  drivers/infiniband/hw/cxgb4/device.c | 6 ++++++
>  1 file changed, 6 insertions(+)

applied thanks, the sashiko review also noted a number of pre-existing
issues that seem easy to fix

Jason
