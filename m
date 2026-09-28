Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012025.outbound.protection.outlook.com [52.101.48.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39F72AE78
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 14:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790605559; cv=fail; b=AR7n39/2aOsMy0DtzxpQrsJMqm2EFLn1+8t8W9hdUgj+x/anrXPoO7g9WVmtqaBx3eq/SH9a4VJkDzwhj32VaYk5IQKl60Gfr6TCIuNz+mvyn5Rl9zZ/5/PR2MVTkjTNOWkm4neXrZCF9SnuxS8YZcuMcXj3jkV/OuHgj9IZsv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790605559; c=relaxed/simple;
	bh=4/AIBwvkJKuU7WSp5HayNW6q8ThdUHE1vwZBVtjNUn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KttPOp/vqFYfGsT73aPAxtSlrTBb7yydVmXDEvhdtLl7/fdF0xVm5UAQ1dTnTeNycGIWJ4n3nmFpg3aXRPBetqIrJQQ1Qk98+IoIQtoiKLWYJ+Xw7i5C4Q+MHmywAFSI98CNMoDf2LjhP53tOLgCSommZ6CMuTjycxb4JgsOnds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DVer2t4n; arc=fail smtp.client-ip=52.101.48.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DVer2t4n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GLhMpeqbv5OpmM/E8tpq4ywwJVxnfsbNd8nDisCVad4gNbg4Ha1lvmcD0G9r2OP9xMYGlMXwrudr+gcPujdxI7o1yhyzzJm7iLerSDD9NxdGaZ9tFcXR/BI/C/sySka9jBH7WoIExAcVCiiHUXaC+6b9e5qL0HY1DYh+cLmNuEO1k6HMUgZicysGR0N+Ww0PHku45eM1fI2p8exnafWD5ywvdMttAQ1AW1ANRURAoclStonf7r7hxVSk3yADbfxhXifxLkqBXf7wOIvrVQVmHxlZfN7MwI8rHCoRdZrJyUJ+ubzqNsOYRUe/WAwN4Zu9dukNVPWHCnjrwmN1SzFFcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/AIBwvkJKuU7WSp5HayNW6q8ThdUHE1vwZBVtjNUn4=;
 b=i9qSlyNwSVnv81GqdEqlUA8ZLFXaOXY6yDgTu9ll9hH644VdnCL12NprjeLJ+aIQWfFUpr+jrtRqqBMr3hSgiCeUItPTijUoXj9tdMY4TKXfZ7uL0FOlwUqUJtea0ImPYBzNtIddHsZ3gur/JZXJFReEy7oIqaDeL9GlfwBMmRbb7OXW3MGragwGWkJ8XuciRdSNk4TABAzQY1zDwHhEuUxjW0YtBOkcn1JrdbbKyCOIUJJJNY0OVpZcFZ+w492Ak9l6p2B/cVuMxso+0Li28ixAR4vOdse0txqg+8Mh87rBz/ofgFhwC71jp1/hLWfQFdfkvRxqSli4t/JVLyawUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/AIBwvkJKuU7WSp5HayNW6q8ThdUHE1vwZBVtjNUn4=;
 b=DVer2t4n+/VvzTFib5vL2jey1RcEUnC1lKUzq+CBkmiC3B4AXB/qlru45S3fXuDkEK0jV1XpkPvB31tnWE4oIHGoeBl0HtIK1D0e2kzEAOZkzYPrStkfdwztq0gqCVHmxWLlvR9HbjwDgsTHWGQab59x2u7wEBdSnIvDH841dA5dc4UBWX0KpzsAWGGCdfD6pM/L6VBp09ZrzkP+RKJUZDw3kVUTI6Zyzb61fXsYaMxRTfZDGqpAjMO6yRPAFBO0IJccBySlMGw6ZbzAnm607oOZ9EPa3guxaHvZBb/oDqQwMUDpxW8P1CI6FoFm4jpehrXymSQ87eRZ6WLvaTA/Gw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB9499.namprd12.prod.outlook.com
 (2603:10b6:208:595::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Mon, 28 Sep
 2026 14:25:52 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 14:25:52 +0000
Date: Mon, 28 Sep 2026 11:25:50 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Nguyen Van Tien <nguyenvantiennani@gmail.com>,
	linux-rdma@vger.kernel.org, leonro@nvidia.com
Subject: Re: [PATCH] RDMA/rdmavt: Fix potential use-after-free in rvt_mmap()
Message-ID: <20260928142550.GA1668261@nvidia.com>
References: <20260825042058.561-1-nguyenvantiennani@gmail.com>
 <bf986ada-b869-498b-8aca-2497198a019f@cornelisnetworks.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf986ada-b869-498b-8aca-2497198a019f@cornelisnetworks.com>
X-ClientProxiedBy: SJ0PR13CA0036.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::11) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA1PR12MB9499:EE_
X-MS-Office365-Filtering-Correlation-Id: fd83be8a-994e-4e80-365e-08df1d6c6663
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|10067099003|4143699003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	oQG4xFhNLf9OfaWEihRgBwePP5/71hJmwomLhljBMVo9FxF2JZCwBtECz8Ed0hKfFrP1Zqe7Tbb+3PsjP1BBsaVXUoOJrlMZKzSy54s0UbK69cnlpK+aWh88kFPhnBC3ADxC+/A3LJBDi/VnOxa23OVJm0yzjliadKLuW5Z6Y1CqoOfGyj0DinZnjnH8aUchUps7gHKHsQhDglvGRrohpWEhig88PrTmpGqYrjhEzS0sG/rDOHJEceRxmNULbv4KYuCEV4SBn3Jq3Ltkt6B+Fy/bgqfHQaateXa1LNk9Wu4R1wTrxOjoebMWMRszOESvK/Ndsp50/IRoTGwCMb4xAerelMcLr1QafxmDqDhACG1C4N1woMpC3EdnXJtTUkRGchp9B+P+KMkU1OnuV4YcBQBUisDMn1e0lSV4aN+UbaK0vTUkd0k68Kas/MMsTY22mJ8NXe6R+hyzbZLXzNteV5t6zdVpGdMlZNdHyPApV1glK8Eko1HfjlySC1ZWeGluBkqzYWpKb2c0EPNFsFPQAkx1GVbOQekZGWSMxZ5vdPrD+8FUYCGbQ2omKyIrQMOWNbCfj94MBUJzZ6DIdBtyKv9dhKUiWw9ADIPI9FDPsNJUj1t/bT4izispqtcHsy9KO/WyKgJFOBouKObtzPX0nOwN7QCO+6mHVVYrffZM0Eg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(10067099003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xqsGzWgg6Xg7qgtjJkhG8Fcob5i9pElbijJIw+8wbZ56KkHhZKJeI2Q4aGIt?=
 =?us-ascii?Q?clyiWUpWcBs1/0MjlYNGf6qb6VIpxpozIhbzIVcbarSIbK+Wp8Pt6T4HWn9b?=
 =?us-ascii?Q?6heVRAV4h6lN+Nwpgj3YZs1HlCMK6xtYe9A3mdJZJA6d50w8DXlaYhONtB5h?=
 =?us-ascii?Q?3Mp6nlAGLSxu9t/jj05NYPOGIGI1qlvbd8jYLK0QaUsywcOjI/ESEBM1SYJs?=
 =?us-ascii?Q?anlRmJdi/udRaon6gQ/T0JbqAiMwFKNezzyPzLSYO/Y0ew/3+2EiQmzBdgwq?=
 =?us-ascii?Q?mNJTW4GR7xYooewS83qMrqdgB+W0W2Glby1tIDcZ/7Ka2rh8PxjlTA2gNKZD?=
 =?us-ascii?Q?sd/rGJoFhvuIa4q/8ggB0KZxJ2wFFQXgsPVuBkjY8sMQDxQGX8i5Wi694wYj?=
 =?us-ascii?Q?CyV0YH2xp6OMXCxB0EBn0mw+8kaet+dvDHzXAkHfET9sZ5rox28XfBbXS2Rt?=
 =?us-ascii?Q?50zQQ4Ku+8UHrJiBQqcfuMyFWlYEESgeU1vsbfM1jXgEeQ9w1jnpVVQyn9q0?=
 =?us-ascii?Q?NKQJpr+wRyLTaRwOIzvxnZNylvH1f3fw25CUZcI8DhjqSAnrgZs+nL9NCHGn?=
 =?us-ascii?Q?ecZbXGILD5YpYU6T1HAwgqPw9fXVQEdkP0xY/48amxU3Z18Zfzy/9Qlynp1Z?=
 =?us-ascii?Q?pPZkBEpcaMArzEswW0G7a9I0TRqgUEvbry41i2cEQVCVHO+nWWTttqahkANx?=
 =?us-ascii?Q?Gk+AfF/abJoBzjLmPAsWwx/OAv6vPHpYClBJFWnE3VyHH56kLtSHfJ8P/yaF?=
 =?us-ascii?Q?fDonMK4AcWOm12BEgHIeSr2KxNrujjYhmYg3Y2dVY/TMEghWNrqviI5q8nzS?=
 =?us-ascii?Q?Z3iXVY29rWFew1rKrBo2sRbeMZ/TiEy8eoaZGkYzkBvKyT5LBD06Cbbiye90?=
 =?us-ascii?Q?vxKeDBGsbs1GqLturgSPImZo8tm4cDcNmTV5xGnRp+uuRP8eGx28nSYxF62e?=
 =?us-ascii?Q?ltMT+WQyr69Lv54MZ7b693qUsviG611ilGBW3alZSzl9OmM7D8uqfvl+u8yH?=
 =?us-ascii?Q?ut/xjvELxI8VQF6r6TXZi11+4xd2GqPglwVXigoHO+whhwlBOLHEA+vA03o+?=
 =?us-ascii?Q?Q+wXiARWcJCPm6omUqiuy/T9y2NidX4O37sAK3F8U/VZMQO2hC2AUljMcsqj?=
 =?us-ascii?Q?QAwAw9lYkslgzQ425XPwbI0AGJSzRSnPKfL4CzThFO+VkZM6v5h4DafgPSBC?=
 =?us-ascii?Q?FEgxWpW1AwkpJBA+BgdoHr8mj2DffuD15T7KDR22JFcl383qvx1pBcsUIXSY?=
 =?us-ascii?Q?cvYxtq0KltdCYSw7wr55PWdl/7mp87kl+bNN4gmecf5EbHvKPqNDDbJQLlHs?=
 =?us-ascii?Q?hSsYnn6cZu88qoDdPr3VSd6MD34Vi7+xBnndjbjCsfy8ztJbA4nN0U8TZ4eL?=
 =?us-ascii?Q?keWfmoonrFJqyMtLXOE4tIlL2GR8XeL4/Q5ED5SLrru882GRAFV5cKY/jQMW?=
 =?us-ascii?Q?b2xMLxM3j/kkkiII9BDIQN8pIBgPv7KnUF6+5I1s7mERkx6mr4iTfUFbOQdU?=
 =?us-ascii?Q?srPKt3MxYJ0jwb3wd1YrwbiWKy2l+WVoV6wAbAbWxvpr1kKSQHWc3JI1xD4P?=
 =?us-ascii?Q?qbzT2MG2QYE3p3pTQjbWzm61O/jNStpq+ccMYtYXOzLh1KLPivD9jR0RtY1P?=
 =?us-ascii?Q?JlwYJAtQG/kxbF6heRRtMWVyWmPbYa2BsfGO1ZcztsdZNdhP6NMptL49T6i8?=
 =?us-ascii?Q?Yoe+4DfPExxLPlwRnAR/NrZCivOUWkM5Z2DE0s8segorrdPq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd83be8a-994e-4e80-365e-08df1d6c6663
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 14:25:52.2203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4IxN/NelYZjsMDpBGmDzcizVuUP+quQSrOSr4oTDUVsJRTd3wHQ+xK0/80S/ERZu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9499

On Tue, Aug 25, 2026 at 09:28:11AM -0400, Dennis Dalessandro wrote:

> My AI cranked out basically the same patch. Only it will be tested and
> reviewed. I'd say drop this and pick up my validated version. If you go with
> this one the commit message should be updated to explain why we aren't
> calling rvt_vma_open() anymore.

It's been a month are you sending yours?

Jason
