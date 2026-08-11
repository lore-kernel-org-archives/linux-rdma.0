Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013012.outbound.protection.outlook.com [40.93.196.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D062F532F
	for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 16:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786467272; cv=fail; b=ajmtbPwk24XjTjNdx2FxhRGeDLT1mBAcl9Lh+YfaeJtIVDdfmOSzkLx8AARZYQyNhyH+EuNp9GFtGAuBdHMBj/YvXu4Q28i9bj8QokcrYbf2cctNn/f15nJrEfgq3+jDi6BdmkFyYX8qa/Zhj+hw71YPChVxlM+4vi911yP05O4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786467272; c=relaxed/simple;
	bh=QqxHmee89k2hiOiLZPgRYrkKegwuYYYlfQ7R6JaBr5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aDoegMbAiU+0ppr3rfg/Gf0Iqd9ydwuCINr8o44zxzZkkSNbisEU+MwclS4N99K44D2qhYtCg5ZdAls9NkBvv+Bg50howzojIof5QutH9vRnGcB5GzcCc3duvd8Zh6ztxFDoB5k+GSWzApp3tCvkU7P/AzWHWmbFM6/sId2Il7o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AKDRSKPw; arc=fail smtp.client-ip=40.93.196.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AKDRSKPw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U+RxYqaNQ7CXjFs8XaHe4eudBRnZwot00vkyG4EhexLWZ6F+9SDOZtve77a7PcusfF+6XNoCJQYkrKmNJ164eY9zxz5nE2ZRY+N/VKA7CusMUrYpW3750OP2CiTQzUi3KfiX5nUE5rN/S2JkkG/RffdDZAiUsCeWnd3cXQaTEqM0tYb0vSD7xWklZ5V6TQoxiOjybJpdTDApviGzrejjfNBs2RkuUDCz+PVF4O9JOeYKJXu1mLDuteaLL5Yk/YfHbBNtW9p5FPOJ7Rf652aBZ6Ym8j5KRGlDnzP70+98e6clQUhaf5HWy6CwUmKbTSf1nKfzRV0KZxUY6sTrQQJMRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lbGTeASfCmNy3IB3WyxgF/s9gLVQA23UWyrwdLOyNh4=;
 b=bEC8RzUe9rlctj05smPo/WVFhR5h0R4Co1L82tnzT/sst74lbSEbL+nmKGclARNvox4MMZzwBrALTiQr2dIJuk7KKNgWOg1FIPDONwVgJHYsCqMhAhAkkjW3edQ6MZYxH/mGvUDr/J+2xYuNYesXzgXoXaTwQA1RjGSAZVe92qC0FiZVXwp7hoP74kObnXYmgCkKa0GhFg2ziTWDk1F3dSZT4Kirps2aqGboiAhpnB1FvjU7WbOLbMHwtfrIadD+F8tgHSprsPUP4Rl/uBOhiNySFUJ5tkfFkIZZj3gUMkEeUAyUdeobFfifpiqE1fpyJp7dWQpxPAV377iSeff5zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbGTeASfCmNy3IB3WyxgF/s9gLVQA23UWyrwdLOyNh4=;
 b=AKDRSKPwMBttx8yc/m5CJ3I+iya24bkjvjePGhyG3Rf9A/iMVx7gDqN//Xau6ruBnFgLbpEF+HUfo7xnn+2jGtRJ3LKtnTfdBrjR2CCeAbxKtr6+iLIt7PAYWfp7BaZd7NXSZLCsIrcJ5vVutMIrNVfcH8yV2+UQVImSWtMvXUT7q8pQvF1OYiunDBRsLc6iwn7nZUG4E7BqG7oQkvJX4k27c2wTNnFeH87QkJbMPZCF4cUe2hy2hGgOOBu7ygjp01V8jPfPLgzLiKcrqmzGGoYMcUPyoiVKg5rSfFsDKTI66F/SicUNu7T5tzZ/QZ78qGx0TEf/6KQ9HGzhJY7RJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY8PR12MB7537.namprd12.prod.outlook.com (2603:10b6:930:94::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 16:54:27 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 16:54:27 +0000
Date: Tue, 11 Aug 2026 13:54:25 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Norbert Szetei <norbert@doyensec.com>
Cc: linux-rdma@vger.kernel.org, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-rc 1/2] RDMA/ucma: Lock the handler in
 ucma_write_cm_event()
Message-ID: <20260811165425.GA632972@nvidia.com>
References: <60544A67-EFD6-4D5D-974C-D983445F1070@doyensec.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60544A67-EFD6-4D5D-974C-D983445F1070@doyensec.com>
X-ClientProxiedBy: YT3PR01CA0028.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::34) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY8PR12MB7537:EE_
X-MS-Office365-Filtering-Correlation-Id: bb4d2d4b-8079-40a4-f162-08def7c93423
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|22082099003|18002099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	EPH/FNLu7aLNJ3PAqSeE9XmBKX9ylpekkN89QrCagrPadd/+UCwa380DrnOB3pvcN/36qKB/YK0sKmaQCU2qwocvF5nRdnyW3iEnUo4GBGyPu1xCBgGHGP4EPNxkGOEG3OuNZOVdALGq0cimnVAWTKR965xb57ZmLbsXSr4DfLJytWL2k7PfFbx3AtNGAHX6tbq1I59P6vTDLmqtdRqlQuCDWCjeh4kFyzk3T3b+7p3uiBSHCoyop+ShnaBlkc3AqKmlvWCsVTaD8Tt2yNiP5xdCz5jhEI256FkEyWqFl2IwIlQAFwdPxB2/L0x1kFRJPYfGyNy282BMLxZgi/o8ICpN0U1Ht1QuL6d3TWaZzmagmIH9zF5eoGy8E07GmPjo9vMibt2hRKzCfaKB3ojGP4eReK9Lf+pkPXH0h2ioSxTRKqZo/h2gLYOlHihs7p3Zx55pbSSrai8swanhgxTe5/KzJCYFFgRVSXcvNYbCm5rhnjFl94cjM+ZizQDwijtmyeOUvKxuo8noTAElP2uKMNcxEJqS6CSLFgH3XqID071uokdOhBN625Er8AeTTdafrUxlYuiMC/Jn52KgcxhbtV14pPPFp/zElnw6P+cRPbixXgrtJrFWMIhtQUqi1Qdl/0QZz3iZmi9AzJcQlXIDqBkGLCGNLuhrWpfiOPbbpKk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Vf9hYlKVn4D7dmWoybV8MKdcuaOcA9wlFY4IsqMETY909nvZx11cR2Bryhak?=
 =?us-ascii?Q?tnTSylszNNlWloR8rr9N4ep+ZAv+1DSH/EFCLQ+rghTlfHKKJZirfuCHt5CO?=
 =?us-ascii?Q?yQvwvtr38TrECdvZtC9w2ivxS4KNzKQgeqf8ZIFGKh6I67FOWjLi9OkARPtn?=
 =?us-ascii?Q?qTQUsqMcuRG0lFW2aIt8u82HnPCmjGDfiRogxxzRGlikvnMoBmCzPVwNl05v?=
 =?us-ascii?Q?j5PritoolSRoYsfQPUrEcBOPUw6T60f2nzSWm13VPdB14iuJ/4Hoh2md+gqC?=
 =?us-ascii?Q?MOv53mLmNiYGw9wuUKTZZxuDf77PawnnEsAn8P36F73jZS0DxAB49McX2ixC?=
 =?us-ascii?Q?6ftGDc4XVVWCZ29SXiKAcYarR22cf88NVJLrceyBdEeRwddTk8OZeNLGCeuR?=
 =?us-ascii?Q?C5OCU9oHlYz1/i5DJmpT1xVezSY11K8wPhmixjUTbaqmGzHhP9PaOoiZ4QMT?=
 =?us-ascii?Q?TD1YO7HH9re/e/+EcDNOkKJCavCoJF/c8EugT7YTP61yV1yvXMyFRY/XS4Gx?=
 =?us-ascii?Q?5zpcFK1NmksKweYm6uuctUNSaU4DzjdnBm6XkSwSzLnXQiRGpWNvm0zyFIV/?=
 =?us-ascii?Q?xayD2OeuM71xhFOC4DfStsjvRyKZNrD2RbEliX0IoTlQqybZ61KHbQ+U5W85?=
 =?us-ascii?Q?zSi7rKDgkxX8eL3eR5YlHUNCSlmd0iFP4BdO1nlnDxZyRPa/jzodZl+pFpdH?=
 =?us-ascii?Q?aEkemNmWt3Y7LPpZzifCpYf3oj4oGFrVghnDEuNqQj2uHydWO6B9tpc3KiR/?=
 =?us-ascii?Q?AybdV259OwNeuNnDsuwivVnFGSl7UaaUAy7IFbfINDMb/rAErFaHsmHWmRty?=
 =?us-ascii?Q?MURTYHqAQh+u7PoKKK8j2k2nWa1W3SjrMkyqB97mppmYGRX8FcTQgx6CLiSQ?=
 =?us-ascii?Q?q4sEfP1+6slOd8Q/+E55aUY/CheTc6sqNF4D16MK4EdtWLOiPaV+jeCiWGGX?=
 =?us-ascii?Q?AJOrBhM42xfaiflb6jiRTkdejy5lPtcN/9AQxxiMlzB0PAF5KnT+0UVHOZbL?=
 =?us-ascii?Q?hyBACKfxAOrgxx7FUltpoAwioV33UDEWyNYuojJenJB9kCkq45odjpFoQBZ9?=
 =?us-ascii?Q?CWnAuMTcWqQncAyJDwuO75N7h5czxABn8sbkOMQFl40oP01o2YVqylASoZ4V?=
 =?us-ascii?Q?Po00N72GfJQfdl1Y244sI57iiBBN1yneiokGjR6sEDDigBmc8O9TKx74tqU9?=
 =?us-ascii?Q?C0Gc7hvDs3KuwL5tqSu3Fh2EDYnLFajKcTBKAPPjx4ixL5tHuw2/uJKt2315?=
 =?us-ascii?Q?jCHeF8p7Ck+VuUIdKS5H0YFrQVXFBiQ6xDGuDJ0lPPvLbn4mDV/ExssSEZ/3?=
 =?us-ascii?Q?eUnlVjA68Vyx7uxE8ytZZhlZXDyydhbAXHsJNJ2gNnIl9wk/b5Ki2WpzUVku?=
 =?us-ascii?Q?V9hWwWR0izxNHCdYDG+dymNy6GzuMi7r7Zc3PTGNV4afv/T/zS0cTsSJAy7+?=
 =?us-ascii?Q?8fJ3h6QfI7dCCKotu9ieUqlHcUqNJPUoWBz9DUSbBrFDhGuzlSVur7KQogpD?=
 =?us-ascii?Q?ZbaIjtuzRVNRmEiOurlZc+sKqXgk7lJlcQ5xByAnjikBSds/g70y4QRyQS8a?=
 =?us-ascii?Q?dwBQEojGWF8xXOsLyBSc1ZFO1/y8kKIYM3aenhdgt65yGvmAgMVYVKl8T/Y8?=
 =?us-ascii?Q?iM8kIAqc8b6FLy1GsuqzGBoVTcp7fC96r2CGguXd0lr52nVhmhsG8/LMXRX6?=
 =?us-ascii?Q?KOJg1bEWUbrZ5tDOHg1mGuJlbdFIdD46zCsxZgRl/cxiDatIRRnnD7fd2Jgz?=
 =?us-ascii?Q?uc91ITGzYA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb4d2d4b-8079-40a4-f162-08def7c93423
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 16:54:27.0515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z7rYtgJDh+puJSompaK+bE0rl0aGQgkQnNHlLcUHIZqkIIhQSnZ0vFPLqkGKFhEN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7537

On Mon, Jul 27, 2026 at 10:06:12AM +0200, Norbert Szetei wrote:
> The window is the mutex_lock() itself: the writer sleeps in it while the
> migration reassigns ctx->file.  The list_add_tail() then runs on file B's
> event_list holding only file A's mutex:
> 
>   list_add corruption. prev->next should be next (ffff888101320f30),
>     but was ffff88814a08c418. (prev=ffff88814a075c18).
>   kernel BUG at lib/list_debug.c:32!
>   Call Trace:
>    ucma_write_cm_event+0x36e/0x5e0
> 
> and file A's mut is left held forever, wedging its next writer in D state.
> The uevent is also stranded on a list ucma_cleanup_ctx_events() will not
> walk, so it outlives its context.  /dev/infiniband/rdma_cm is 0666 and no
> RDMA device is involved, so an unprivileged user reaches all of this.
> 
> Take the handler lock, as ucma_cleanup_mc_events() does; ctx->cm_id is
> pinned by the ucma_get_ctx() reference.
> 
> Fixes: a3c9d0fcd371 ("RDMA/ucma: Support write an event into a CM")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Norbert Szetei <norbert@doyensec.com>
> ---
>  drivers/infiniband/core/ucma.c | 2 ++
>  1 file changed, 2 insertions(+)

There was another one of this mistake too, I'll send a patch

applied to for-next

Thanks,
Jason
