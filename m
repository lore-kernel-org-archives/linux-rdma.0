Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011065.outbound.protection.outlook.com [40.107.208.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8624B522F13;
	Fri, 18 Sep 2026 20:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789761655; cv=fail; b=J3EvfW4+rgFMQBzJrnMJJDnOw8FS/8ZJoM0jF1m+paNWpydvfQneBGbNnDkNQED223klws72zGfsXrk4SYwU59LB49gTgI58TqnD1S/WhbHsOXYHDB7H01sotgQxbgr6KoUKgCRYYX7Il4JDb7eeCTIv4HP9CjppT6YU3l/50sc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789761655; c=relaxed/simple;
	bh=cqZUv7w7QEVKNHSoyyhSka7dhh21ridSiz05WuAmKqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XUlpSsSiUrizr84xGzZw5ntnaaAdkL8r0cPTGqIXRN4/Dj52pQu/queVzR8IHnnVVQ7j9WpfQ9PrCt+tJqjjr004KxmZ3+4lXOpbpJ/qaPAii7sEKWqRBBXrENUgYdmIxpa0H7roQiZEkmhRJzm/Hk2JTR774aR8NkqUuSRef8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Pff3QL8c; arc=fail smtp.client-ip=40.107.208.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Pff3QL8c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eKmadvgebOjoLr/v84aLd5W7xFBY8yt2SQrokl8XrqxBOuhXmw34UoGbJATapIFdqrqgoB0na6ymwU6PCH1/XKsmDuEeAsZexyNhZkpC+TQ6pN+1pnp8iMfkhvXl70nPGi5VZyLjZ5/ouI4ajdQ+xTeQBGzeh+V4FUKYLn9CAUfkEWdb4cJfwTCtV5OfjKoaIN8g6b6MQ4JOs+0wHpcqWaE1ftOypHAJepE8X+ZCtYgzKvBSP4NsnucWtj872Pj6X3MivZ2146tZqAQhjttTGOMj8yLyn9d8G9CAYO8fr4eUp49mLJ9pubPYP1sLgkswV9FKe7ZK4k910tTMqeoaSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kCGj/CSdy0Fm/77MJ6OHqusU5Okd/rqaf0iPXDb4eMs=;
 b=wUkkFkpWAtJ2rCNFkd6ACKIwsZbC+X/oIA1bhxn/fDiYINmvTSKe99IiVlci8//JcHXGR7ieEGbDSlj7Ny6kH4IOI3lXFhtNLzu6ZAj+aAI6hUp9etJ69z+Z7L0NSinHXIgtKoQ1aRrI+Leqcw5fDTf7xlatVWeUc4U8+I6QrGMvcL8ITct8Lenpn3qAor27ObcboJJsIEXSfzgz1Q6SpYMh0a4NN8xaAd395LY4NqKCagFXKYicOoSlsMR47a6ukjNM0JoFAguFnV6l13Mm7/60WEVTM/rVV0YMJXggABsbjGFwnrQXPSsP3hGMcuJrfy1O0lTmMywHU0hzhHeu7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kCGj/CSdy0Fm/77MJ6OHqusU5Okd/rqaf0iPXDb4eMs=;
 b=Pff3QL8cSmtB12EDR+FtQ0+J8D6cXsIRHCRbtIQsZufFtqB5FE1Ybw7IYaA/fmgxkU097LSQwDj/3a8jm9J1YXxSaK5G4J4Av2yRs854icd6/cQwZLBFnXTy6NR8zHMQ3sbPb3FfDOFPtDICNAuZiW4ydQTbQWAYtyXt9GWAq3sF5AZVyLxD2Pwn+PiG2dxeCBHnR0Vp5Q3gAg76XLVkEft8b1KSc0kN/5giUY7Zyh8fEy/rm0JmbYegbOxpVwnm0ORNbUshfh2S/sF67EaHIkI8xkdrTknE8Nlg69YqgFF1Q0IOpjmaZRWyaj+KXD+83noXFEr6x8CazhBDgPb6Zg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS3PR12MB999241.namprd12.prod.outlook.com
 (2603:10b6:8:38e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.14; Fri, 18 Sep
 2026 20:00:02 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Fri, 18 Sep 2026
 20:00:02 +0000
Date: Fri, 18 Sep 2026 17:00:00 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Matlack <dmatlack@google.com>
Cc: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v6 06/10] vfio: selftests: Allow drivers to specify
 required region size
Message-ID: <20260918200000.GB11142@nvidia.com>
References: <6-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
 <20260917235245.CAAE41F00898@smtp.kernel.org>
 <20260918115217.GA11142@nvidia.com>
 <CALzav=f4NTb4Csn2BoK5kk=MckFRvbVnOdO9yiCz8MLXdRMPOg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=f4NTb4Csn2BoK5kk=MckFRvbVnOdO9yiCz8MLXdRMPOg@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0183.namprd13.prod.outlook.com
 (2603:10b6:208:2be::8) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS3PR12MB999241:EE_
X-MS-Office365-Filtering-Correlation-Id: b1235046-9151-40a5-d60b-08df15bf6ce2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|10067099003|11063799006|6133799003|18002099003|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	VzwMWJCW816XkWLdNglNWL1keTyz4iV4GlG7qHoL1uq6vBdwI3GoWio9BBllebWuCh2ak+SR5i35NosAsVRlTEk9jA2qv9Vtoa5jLxj4HDuRPyEZYnFy8mb5+VcV1edxF/rLx9cTnJsSxTFIfIjjX7gMmSD0db4Zvi063oFuNSCLF0g8VFy5vbeThwz9M2mnj5GhuB11Ht0NERpeqPZ8t36O4ruQ7zpLeLiSSNPyICq7O/beAR+/5XaxcYrXg/pMhtGa/XPReuvnqKg5GknOybjsDZyBtxPWMza3LvLVgiVEt1NUpstdeQNDzTiMHnO6wCGa4RkbqjjupfcRwJynnkVsT9IFQG5YkV/HS034vpsv8pBPNd9729oiVUu0aoCynb7hf3hrDczBE/kjz6DPEotHMA6xQASC+qUkQ/N2sYphi++ULAoWE6K0tM3bKP4KLjT8BTTWf6lhkt3qm89dU9JaENxr7FwiNBkdoUEWJ+n8eS4qd+8e6Z0u1EVZBDuMHs+b9f69WJV7W6S5fDHXWPV0gtosH0JC1xae5yuMKhrv/H5PrKAbbqVoMExa0y0NAVmy4HsTpVqxah9STkSNZ07MTIF2JpHdW7rjzgFWr4V3AjWhVecT1I4JUuot7xP5svo2Q4sDHv6lrHKSEoEHeZbVROlOUdSbTS2QEfK1KnY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(10067099003)(11063799006)(6133799003)(18002099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NCEQJwqMhilPfGjIhwz8BjYgM83UhNyPDipsKGKmz2RkH+vxQDG6SwS0BgcM?=
 =?us-ascii?Q?Y2aSNwCH6OthMSTqvP4zssAMiojzQbQIloUjX49zA4q/PxXmVxO9XvzGtv4K?=
 =?us-ascii?Q?oLqQFo5xbSTknb+eRqgGyzyx1nBOHqSFkxZs2qJ27WSSu3fFUZuTv+C9z7HF?=
 =?us-ascii?Q?wBDbP/8LqAue2wRCGlvVZvtR/eeqYDOihveikxOva4IRAZgZla47XjyXVJj+?=
 =?us-ascii?Q?UH5Di4i8rKRFIeeaj4OxbPjMa1g1l9pdhsKZ1T7i/jazXonsv3PdAuhc94CT?=
 =?us-ascii?Q?rXlXttBH2U7yV8HpK/3wqi23Raeoy4I+7CzSibclO0gdxJmTWwUL0CVeWEv0?=
 =?us-ascii?Q?Zhn9h1FC46YOLCM4NWbUEyeiKTprVHwzzY21GTR/CPAmpY5jxhakTrqhzoMR?=
 =?us-ascii?Q?tCkPfLhM9oO3DQQ3vocu28aVbJ0JpR6efL5F7MY3ywDwI3aRUrExSQRB28kH?=
 =?us-ascii?Q?VF+ubJ95WhGT9heV/Z6qI7gfUkBqhf3gGt8W6DCY0vxNaidbiH6oIm1rROXh?=
 =?us-ascii?Q?jhMRDMC+aplaow0nqJCUvfl+Nl7asNtCRs7SoE+ksK47bSARMsC+P0d/jXV9?=
 =?us-ascii?Q?CiWZnHTHzbIaa23zf0YyGPk9mchqQcHzp9QEuvYkPc/Ez55BH+wip3n/YYta?=
 =?us-ascii?Q?S5qF9XCiTQJWZPjO/Rvc8juR0OjJvBKHvRtX6DPFgZ2RNdoT0NsVISlTIHGv?=
 =?us-ascii?Q?v1UHwb1gdosLymOJURG1R2hg6bEbB9LmAu/dZF6r+bVW9JglsJp3wc7U1XT8?=
 =?us-ascii?Q?8B4i4ArgYE/diW/zQDohGuJAH0+0MWbQNR6aQvlkIYoq9vOf8ERJBZXOuRWY?=
 =?us-ascii?Q?2w2bjtURj43iT3nF5PEUGUQjmnti7SKmy/2G8DMg/zDc+sN4McTuC4fP1wmZ?=
 =?us-ascii?Q?lRrGqA2qD1SGbfZtiY3t+d9cidJngY+2At/sUkvoskcSvLlkuU9qDtdVRunE?=
 =?us-ascii?Q?ewoURKTfeXsRBHg4grGojkE/4LEhJ4i3047Hwch+jWyDuhNrbtfWhGQL4P+L?=
 =?us-ascii?Q?/+3ENczRGZK/l01cjgSx2M9ivEpMluAf+g53jTht/xfQz1UXBBLktHGCJYWr?=
 =?us-ascii?Q?PUA2U91VbzfZs6p6L2ZhSt7hxhL6N92zY4/L9XpJ18VCkZdG4RxR8AT0On/A?=
 =?us-ascii?Q?S5nnE51h58U9qX/hkf4dzmcbW1C606oCt8XDFY/tck0TR4wfsjtBJ4rQu8NV?=
 =?us-ascii?Q?zRVFTkNd1kAHM1BdEzjTP72vHJe86jJ4SdoJGmh2tWRHrgAYxyNkbOzWI98w?=
 =?us-ascii?Q?qu5Kt5C8V223uE9Uvy81NC0K8tyYMzt9MXMBBT/3XT6VdZeyUA/wofILZ+I0?=
 =?us-ascii?Q?FyksZZmuOlDvNz1aX72PopEoUR3gr3OT6tgcZL8BtLcHSenmjxTM+3FsRren?=
 =?us-ascii?Q?jutG4ScPxUIEBDLXavIsxxyOUCXgoI+FS3e3K19arw+HHnuYWzTqjMCLcSag?=
 =?us-ascii?Q?eZOtJU+Fjqo15e/ZuMDR/0adfX9w7Lyu410FsW4iWpV1pKnG9QGj3O0dPA2l?=
 =?us-ascii?Q?o+dffZNPOfYVwkIx/8FEG+7jeCl0kMdfe28m3LugJ4vg3ToCoNHTiEl9D0IK?=
 =?us-ascii?Q?sUIV9At13I0xDeSUPvCnkLeKZBoRPoNYZ7pkNaQFoGoIB+Hx2dZJ40GRkw72?=
 =?us-ascii?Q?44+CYV8uFfnzH+YEeQtsM85KZZo4NpUdWGal56pOxWViD+ItKLviUoGP17mj?=
 =?us-ascii?Q?RmpUNnZASWFzp41KV/XPmF2b91823Oht1/BuZzWMBnr5i1zh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1235046-9151-40a5-d60b-08df15bf6ce2
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 20:00:02.0454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kTxI/4MGW3Z/GWPiyjO/ec/UIgX51lOhYxFC6a1Xq/L3W6AHDzRtXvI/z7w4i6Ef
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB999241

On Fri, Sep 18, 2026 at 07:58:58AM -0700, David Matlack wrote:
> > >
> > > [Severity: Medium]
> > > Since this changes the vfio test to use the dynamic driver->region.size
> > > instead of SZ_2M, should tools/testing/selftests/kvm/irq_test.c be updated
> > > as well?
> > >
> > > It looks like vfio_setup_msi() in kvm/irq_test.c still forcefully overwrites
> > > the dynamically probed size back to 2MB:
> > >
> > > tools/testing/selftests/kvm/irq_test.c:vfio_setup_msi() {
> > >       ...
> > >       region = &device->driver.region;
> > >       region->size = SZ_2M;
> > >       region->iova = iova_allocator_alloc(allocator, region->size);
> > >       ...
> > > }
> > >
> > > Will this cause the KVM irq_test to fail with a VFIO_ASSERT_GE during driver
> > > initialization via vfio_pci_driver_init() when tested with a driver that
> > > requires a larger region, such as the mlx5 driver mentioned in the commit
> > > message?
> >
> > I have no idea, Dave? Did kvm start using this stuff?
> 
> Yes, KVM started linking in the VFIO selftests library in 7.3 and
> irq_test.c is the first test using it.

Okay, so I think this is all that is needed:

@@ -101,7 +100,6 @@ static int vfio_setup_msi(struct vfio_pci_device *device)
        allocator = iova_allocator_init(device->iommu);
 
        region = &device->driver.region;
-       region->size = SZ_2M;
        region->iova = iova_allocator_alloc(allocator, region->size);
        region->vaddr = kvm_mmap(region->size, prot, flags, -1);
        TEST_ASSERT(region->vaddr != MAP_FAILED, "mmap() failed\n");

> Looks like that is also causing the dma_rmb/wmb() redefinition
> compiler warning from the kernel-test-robot.

Yeah, for some reason kvm defined them in its private headers instead
of putting them in the right place :(

I think I can just delete the kvm definitions.

I don't have an arm system or userspace cross compiler to test it with
though..

Are we good on everything else, can Alex pick it up after I fix this?

Jason
