Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010058.outbound.protection.outlook.com [52.101.193.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B75C29D268
	for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 17:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786468972; cv=fail; b=Q8OPGZ+1BRRJB+KplIoM4Eq1cjNuDqEESgiCejp3Y74h6lC6BdPDbD8NTvyxfINKa/VkJQOkAYvZyJq0Xbte9onRjoVb/+UemBz/eY1LgF6JRd5sRmbfjc74rJvJn4ebmrgP/6mqUpexWCbBYrwNBvHsGAniKTJuv7gp6y9MWDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786468972; c=relaxed/simple;
	bh=4wnQCOzzj8UsGh33hyuAuf7H2UWslcGOFhzEckbPV8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aJilTmboabKr2nkWThC1qX71k0DwpK5w9CgUYFWe05wC5WNsi9gPnPOhKTqlRWByiBvqo0FpmbP30HVri91nNh22NBVW2eqd52Tw4VmzlszL/ZcflfqZgf6tRwxKtsQU1VtdTWTZinN6hL9KZO52gLiaZ2tDpjrCZdgook1fXw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UySdn1Bv; arc=fail smtp.client-ip=52.101.193.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UySdn1Bv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=op+mUW5khktYC9VP/3br+D2LQ13XZpnJRor1F7Uvze9vffYalDajOkEmqUrLUWQcxftnJsNSSXVUHFqHoKscBSrZk02k/ZH4pOHlXM12nlOBkRVNCYJmnVJqSgHDE+TjoHKapxjhq1DCuJAisGIl2OpYzl866CVeV3a5AEfVafiMCFFVarXkjA1Aw/8o+5ikLziyyzx2dGzeP1zsTLceCI/YzOZUL596ziV/3oZPlRz+3RnBPPWdNUHPzPyk9JXRBO2C142X3FpW1Dt3cvngTgbgRHNX6SnH4IqRgNnfmmQY/84gqHBoAxbJBZyMqkoPNHRjHv9Nat5lU+/iEhLxqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDQ1mLsv/OEDEULLlZpCl/MSrJETLdjnLrPQwB8Hwek=;
 b=mOYrBwJGSC2sjSfH+Jjw66qCwOG0acfz9aFTaKKHJk8hhAKkixuRgfcauO8G342/v3DbfJZBGceK9aPYSXvR9JrJ/udDb1DQlaQRz+t6Q3oV43OvkqyTruI/DrIbqjZh4u6nceOm+KjEo1AG+KGNJ/oqOTrqHg006dbgaUbXADKif7FG2cD23hn4/8lIK1HG83JcrqDuygVp8gr4viQGpIhyRsb6bpMKROcKPEv46CMVZ+IFMvClETtbU+iBnjDl6MF6zB1uF3ZFQSurSsWj7Wi43K16tbdBBonr3RveqeMcLys+FHzVQNiAeNUB5H4nTTi2RXzMi4IHAR6A7GuEKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDQ1mLsv/OEDEULLlZpCl/MSrJETLdjnLrPQwB8Hwek=;
 b=UySdn1BvejeplYP1xyEbIzdI7Exng5/0ZFx1pLmS3qMxs7YnNLBW2W9G8Fs3zCigRuia/n/yKVHJCfydokxoLFdGWxXMlVgBNjvUeHIJdS7IzPxBcxRD720J1XZ4d+NjpnrZzm5vMi4MTCFV2nTaD0sN5SNsx1RzBNfUGA72MasS4iJB0KZT1CcUEW/1HK/ZjARSWzUa1yhxLtTNReNaHz9JO/Aq5VUj8Bky6xqMeaWhWymr/+Fw5bdjRmJfpgnzRea7x5qx558NcebTz4Il3wnoB0JX+PHCEDhgRCv0upUvuabzbzIgNNZt7G+y8TGhP93fYClIDD/hPaYbSVEEdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH3PR12MB7716.namprd12.prod.outlook.com (2603:10b6:610:145::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Tue, 11 Aug
 2026 17:22:02 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 17:22:02 +0000
Date: Tue, 11 Aug 2026 14:22:01 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Norbert Szetei <norbert@doyensec.com>
Cc: linux-rdma@vger.kernel.org, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-rc 1/2] RDMA/ucma: Lock the handler in
 ucma_write_cm_event()
Message-ID: <20260811172201.GB59938@nvidia.com>
References: <60544A67-EFD6-4D5D-974C-D983445F1070@doyensec.com>
 <20260811165425.GA632972@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811165425.GA632972@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0492.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH3PR12MB7716:EE_
X-MS-Office365-Filtering-Correlation-Id: 873f2793-14d8-4023-e8c7-08def7cd0ef8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|4143699003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MpCc2gmUJX+Nn5qmv4KYn7WA65Dxq6IiQ/mvA+zdOe8T7gcix0mmgTp5W3/xOvDnSJS8BaKBFX3InVHxwVN4ikJAuLp1YHg14EszbAmhWnURdHADaDlrTBv3eyGmhpmUTfiY1Q4vXs/AGNubEaYIamp0M5y6/G7+VjOlZ1knHBAIqhG/ArTpyMj55QOiRp0b/CwxouCfrBAMxeDvZfglPJDCpuDH1hcHm45xBqRTwbrgghQlb0SGsnD/DA3tPciBcGGSK+mzoNQpWtuJGBoV/YJbTxtubCrjajUOzDQ/8yrYy/R7RZWXdgCfVC1SC4d1YDbCmnLrWgoEO03fRF/JLu9o8DDY4SHR88rSAVvkr+FkIsMMnRmV/R+jntNhecwTg6Q+LGVbhcKk87PfcQ1LfiY+clZjcifBiIVUOnk2nxTrKWaTvyV9DRaBmsOtGrTIHtxjafzHk1Y59RGjKzMFlKB2D2ek/f+AOC1Um7/weHxSphY5yZH587U9byzdeCnIv6A5f9eZC7ol7ZUBIl5OpM0Z0YU1LqNRYuL7wnVqKBUIWzICtpy7+iaTgMHAT/DlWp6N4TulcLzUwjCgG5i+TjF4xEUZcqV2cErMh0lykTzxLyK31/GCkfWEpv7FOCrqtrbiAy9oWkyNVyqcjlZwXjBscv7QSq0PlU2ndTD55Nk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(4143699003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fcR9PkrSnEA7Cw+o0UnzV4dKCFSJl0FcwvM/aqPeXxsE5/OZvaJGbZuROKK6?=
 =?us-ascii?Q?elEeQJgg1fJeDcIlK8bQArzZyxMHsNHDpfsdoQZ6Abbx/wZg3lqQhluxwDAX?=
 =?us-ascii?Q?tVlCCMB4gG72u937/RFNhr1L4YmOh6ZzVUAGts8aQmeKC/n7YAK/mWj2VsNA?=
 =?us-ascii?Q?Qr+rMnSfHuG/UaBjFDkAebvOW+CNkcSkXvWeagSVN5ZQ5ghPo710OTcDRwMF?=
 =?us-ascii?Q?4BSap6d/8joKtPFnTyjtQKzLPYpR0m04tSaAhWpMCyUHTTnboX/GlTaNV8+C?=
 =?us-ascii?Q?9FnuMCM6HtIQLx/fHdIrco8X6qftAD3DNiHuwD55aKp7s/PhjjcFmq2DuIkO?=
 =?us-ascii?Q?oO85SzxQMfO+xU2Mbc4TRJb5T2/og2lEY5uLj0uLXlC3Qx9xeML/qb9flXkY?=
 =?us-ascii?Q?5QKlesedfVWvgruLFx3ksFv4Qphyf131mi6lf59v7bXDO25H40SAR7byzJPC?=
 =?us-ascii?Q?+i1Pa4SHZFczxVPI95A7XUVzwmPMDZ57xiKKeAnxkFpT2+PEGWH+1atoWaKv?=
 =?us-ascii?Q?DzkBdGhWkUtK9rplYoEjR8hMMxHhbTPbSOFd8flM0kXO0PmpF01saa8zQTeu?=
 =?us-ascii?Q?QAJ33OweJ4o5ywqqFh+nlG8epRcd0fVUIVfbBlNIQu6wkLH914khVr3QnbQM?=
 =?us-ascii?Q?TyqfQBRvrkH9rEbSdfPtloNKpcP1PLn17m7qtM1zT7LkrpcqEHitUTut3xKI?=
 =?us-ascii?Q?9j8kq2KxqUaTaQHYNJKQrynnFn3bXkZ+gZv1a02X+b+YcoNiIeR1LmrJtAfm?=
 =?us-ascii?Q?b2m28rh89/TYAzJJzWBWPZaBuF44Izi7FLJ5yULQq+4m9OfohA50WSpHAIQT?=
 =?us-ascii?Q?s/poLUy3Ow8CN7+elaNB34jv14cjJNGDfD1a0bZ/7c/ojyK3SUt4qc1lUfgw?=
 =?us-ascii?Q?ZmICkWmoaYheGmQ7g/M0fO0tB5Spvxl8fP9PEQFR/qjtaN3bTA9ajKjbt6ck?=
 =?us-ascii?Q?zpVn3P8iPF3y1mEdTOuJgJ1s/rqDxcOl22cUs0zk++4os/lbdbixWgCq0dso?=
 =?us-ascii?Q?5PlOu3RfrVrkGk81a0Z9fg4fAtbCSJHRla9ccBCJz/SgMVu+qus9rVdLVTfY?=
 =?us-ascii?Q?OwS/OAHnqssKOnhCEXa593IadeRP8eAZAURA+aVF3G/TrDVzlfVkvRXz7OWx?=
 =?us-ascii?Q?Cid0gFXRteW1BkvLM1bvjjAdjeGFoP4SAfWRB856aYsQQM7TytnIUEv98ZFO?=
 =?us-ascii?Q?u5ZOzcn+rcbunHdEiERSoAR/eO6G6B2HPyieM6APgWY3gY3+tRt/kGnosgYF?=
 =?us-ascii?Q?3LAjoi97zg/YNFi0PyQ/7N25+Q2bVmf4VIpzz9TdaZQEyZ7/5tDGIDmnnebl?=
 =?us-ascii?Q?jnHTlPqvVfVr08hsODk02cRQ1JpnPKVw5rg/jefiHwNRCWgWxesNBHZb/xhn?=
 =?us-ascii?Q?o5pQw6Cv0dHrbfsNj3WMN0bFZn0paGn3Q3sNabrnubEv2ANrueD14VasyNz3?=
 =?us-ascii?Q?7R+ggyM97NNGdUN64j51NRd+VFnYTH2kqECmbfc5FBrBWeERPH0rCfF3qyH5?=
 =?us-ascii?Q?DqGqKgD5FhOX5vIWvLu55q+4EAnaQL/OthJb0FRagEmvC3Cwru5A2G1sQPn1?=
 =?us-ascii?Q?nyunSKGmV+N3HrkirvDE4lQnyKsQTbNZan2lq+koDHOTbiJhmOL0BNoMVgat?=
 =?us-ascii?Q?bX0cWqLd9ktUKo+86i3+1d5NiMREX5J6WkVMMSFC5GuXH+o1WbtKLX7Cl3Vs?=
 =?us-ascii?Q?2aq1eaQo4R/JI6APEDJO1ZtUomSPLiRs/RJPV7cjBLJDGs+Cl+M92OfeT/yc?=
 =?us-ascii?Q?pOxQDCwMgA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 873f2793-14d8-4023-e8c7-08def7cd0ef8
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 17:22:02.6871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f7AcdPbAhtksjga0Gz7L9Yboinw+/n7jb2UhMnyQVhUe9jugmhCoCWBPxiN/G1Wz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7716

On Tue, Aug 11, 2026 at 01:54:25PM -0300, Jason Gunthorpe wrote:
> On Mon, Jul 27, 2026 at 10:06:12AM +0200, Norbert Szetei wrote:
> > The window is the mutex_lock() itself: the writer sleeps in it while the
> > migration reassigns ctx->file.  The list_add_tail() then runs on file B's
> > event_list holding only file A's mutex:
> > 
> >   list_add corruption. prev->next should be next (ffff888101320f30),
> >     but was ffff88814a08c418. (prev=ffff88814a075c18).
> >   kernel BUG at lib/list_debug.c:32!
> >   Call Trace:
> >    ucma_write_cm_event+0x36e/0x5e0
> > 
> > and file A's mut is left held forever, wedging its next writer in D state.
> > The uevent is also stranded on a list ucma_cleanup_ctx_events() will not
> > walk, so it outlives its context.  /dev/infiniband/rdma_cm is 0666 and no
> > RDMA device is involved, so an unprivileged user reaches all of this.
> > 
> > Take the handler lock, as ucma_cleanup_mc_events() does; ctx->cm_id is
> > pinned by the ucma_get_ctx() reference.
> > 
> > Fixes: a3c9d0fcd371 ("RDMA/ucma: Support write an event into a CM")
> > Cc: stable@vger.kernel.org
> > Assisted-by: Claude:claude-opus-5
> > Signed-off-by: Norbert Szetei <norbert@doyensec.com>
> > ---
> >  drivers/infiniband/core/ucma.c | 2 ++
> >  1 file changed, 2 insertions(+)
> 
> There was another one of this mistake too, I'll send a patch
> 
> applied to for-next

Actually this is not quite right either, ctx->uid is also protected by
the handler lock and pedantically should be checked for zero like the
normal event delivery path.

I will squish this in:

@@ -1779,6 +1779,13 @@ static ssize_t ucma_write_cm_event(struct ucma_file *file,
                goto out;
        }
 
+       rdma_lock_handler(ctx->cm_id);
+       if (!ctx->uid) {
+               kfree(uevent);
+               ret = -EINVAL;
+               goto err_unlock;
+       }
+
        uevent->ctx = ctx;
        uevent->resp.uid = ctx->uid;
        uevent->resp.id = ctx->id;
@@ -1787,13 +1794,13 @@ static ssize_t ucma_write_cm_event(struct ucma_file *file,
        memcpy(uevent->resp.param.arg32, &event.param.arg,
               sizeof(event.param.arg));
 
-       rdma_lock_handler(ctx->cm_id);
        mutex_lock(&ctx->file->mut);
        list_add_tail(&uevent->list, &ctx->file->event_list);
        mutex_unlock(&ctx->file->mut);
        wake_up_interruptible(&ctx->file->poll_wait);
-       rdma_unlock_handler(ctx->cm_id);
 
+err_unlock:
+       rdma_unlock_handler(ctx->cm_id);
 out:
        ucma_put_ctx(ctx);
        return ret;

Jason
