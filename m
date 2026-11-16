Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794862656;
	b=5To2/LPnVTt5D5jBnsO3ucdov/xYBjse8nw3L8zIKYt92BCinYYVaYozXqPPPlTdGJ7y
	 iyRBtJfghP6ZxV9roQJvmrswYhb2Hz+xjLtcX/iBU+X0s4iyVMR8PU1vs87HiIu9lSiJX
	 GS8kPbSUl5iW98VJHHR312cFMcBONPPNlib9EbRWW6jNRQvWF39ADndEum9IuaxKaeIX4
	 1G/aK5JW+M13PCEVZLeqQIGk8yfTzH2Mhn2T0hH+Pl0Par6ozIKgjfMZy5Y1vIMojAGkY
	 waKhYMFpRjRoMlz1bU/QelRbPx++X53GPLerr6zpHe6RaRzszgKbUaDUMvMNBcreCTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794862656;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=dG88cZRLJLTaY4FMSKozm6dz3m8ZUOV5eTjcR6QnV5M=;
	b=jVnaB//vWT8Xo91KILYYT4erihaJVNASV6VzBktg7Ci+sEOyf2qmKTSqgKu2XV65364Y
	 YOdA7PX86/nBVoTxoUhBeJ9WhFNU8vafMgt/dNMfsGIh1FMYtLJw0lotR31iAjjPO34MD
	 h+P5FmSLHYvJiS3rDOgHj7nT+9m1jG8gZnpU3W0SIdOHiaV3K4efLJdcl9Fxk02CTrtSp
	 wKulBszXrMxw2ooFuHH6702nhwY9Y8MLSX+OlNkbQjWcanMKFOTbuJ0fb8lEApC9Lj/FH
	 FzMwhmn95pC+rAUHBRmvi/5VCP+8/KYHfO1x+aXAhbaLi53e6TBYi0KbyrzXBQhtiXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gs80n0b0;
	arc=none smtp.remote-ip=198.175.65.19
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A05606A31C
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 20:57:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64A05606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gs80n0b0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794862655; x=1826398655;
  h=date:from:to:cc:subject:message-id;
  bh=fXq1ZBsWhaA6wNiweHqUbHtPHSiwX4OFEHfVWj642zM=;
  b=gs80n0b0nL8D3lT85R7EgY8ia7oKrJ6sbpcnYPt6YM6Zr73nypu2AxFM
   EaQr71+aPvt/+hgNILhHXtGVykpFZNDofLiybo7bdr0YQsdSq0XAVH7tZ
   17LxvKXMax18n3CLPD4ZbbEavmftVE9QGAmjyyGF01VK2o8fMQbWYZjh9
   K7uolik1JdBYsjucFx47bGPDUQCqNjmnaYydId7zH5+YsMwqV++6mIYUJ
   x5aO2zu3ObnyuRhG1xqZmrad/BlYkA05b9M97HfR0bqpqOfRk0vLLk8rQ
   1pdK4/NOiAjH433ETzcnZVJRRkt0ErdUS1TbW+kMbY0nPNAZ+XHOe5dFN
   g==;
X-CSE-ConnectionGUID: RuvByTuZRbuSAcqGGu4vNw==
X-CSE-MsgGUID: 1QXoOoG0Sp+erENt0ShqGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11968"; a="3652325"
X-IronPort-AV: E=Sophos;i="6.27,217,1787036400"; 
   d="scan'208";a="3652325"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 12:57:35 -0800
X-CSE-ConnectionGUID: jWOsmnCWSyyclo7+wILxZA==
X-CSE-MsgGUID: 1oYEn6EGQw+2KsLk44L9mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,217,1787036400"; 
   d="scan'208";a="9893375"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa008.fm.intel.com with ESMTP; 16 Nov 2026 12:57:31 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xT3lY-000000002oM-1UPR;
	Mon, 16 Nov 2026 20:57:28 +0000
Date: Mon, 16 Nov 2026 21:56:30 +0100
From: kernel test robot <lkp@intel.com>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org,
 Leon Romanovsky <leon@kernel.org>
Subject: [rdma:wip/leon-for-next 33/37]
 drivers/infiniband/hw/mlx5/dm.c:217:11: error: no member named 'base' in
 'struct mlx5_ib_dm'
Message-ID: <202611162132.pYyZA0UN-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git wip/leon-for-next
head:   586be88310461aaded66e16c5579e384dde494b5
commit: ea97d0a83f4ed62c6f5716e27a260e21febbc79f [33/37] RDMA/mlx5: Check the DM type before mapping a MEMIC operation
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20261116/202611162132.pYyZA0UN-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261116/202611162132.pYyZA0UN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611162132.pYyZA0UN-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/infiniband/hw/mlx5/dm.c:217:11: error: no member named 'base' in 'struct mlx5_ib_dm'
     217 |         if (mdm->base.type != MLX5_IB_UAPI_DM_TYPE_MEMIC)
         |             ~~~  ^
   1 error generated.


vim +217 drivers/infiniband/hw/mlx5/dm.c

   203	
   204	static int UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_ADDR)(
   205		struct uverbs_attr_bundle *attrs)
   206	{
   207		struct ib_uobject *uobj = uverbs_attr_get_uobject(
   208			attrs, MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_HANDLE);
   209		struct mlx5_ib_dev *dev = to_mdev(uobj->context->device);
   210		struct ib_dm *ibdm = uobj->object;
   211		struct mlx5_ib_dm *mdm = to_mdm(ibdm);
   212		struct mlx5_ib_dm_memic *dm = to_memic(ibdm);
   213		struct mlx5_ib_dm_op_entry *op_entry;
   214		int err;
   215		u8 op;
   216	
 > 217		if (mdm->base.type != MLX5_IB_UAPI_DM_TYPE_MEMIC)
   218			return -EOPNOTSUPP;
   219	
   220		err = uverbs_copy_from(&op, attrs, MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_OP);
   221		if (err)
   222			return err;
   223	
   224		if (op >= BITS_PER_TYPE(u32))
   225			return -EOPNOTSUPP;
   226	
   227		if (!(MLX5_CAP_DEV_MEM(dev->mdev, memic_operations) & BIT(op)))
   228			return -EOPNOTSUPP;
   229	
   230		mutex_lock(&dm->ops_xa_lock);
   231		err = map_existing_op(dm, op, attrs);
   232		if (!err || err != -ENOENT)
   233			goto err_unlock;
   234	
   235		op_entry = kzalloc_obj(*op_entry);
   236		if (!op_entry) {
   237			err = -ENOMEM;
   238			goto err_unlock;
   239		}
   240	
   241		err = mlx5_cmd_alloc_memic_op(&dev->dm, dm->base.dev_addr, op,
   242					      &op_entry->op_addr);
   243		if (err) {
   244			kfree(op_entry);
   245			goto err_unlock;
   246		}
   247		op_entry->op = op;
   248		op_entry->dm = dm;
   249	
   250		err = add_dm_mmap_entry(uobj->context, &op_entry->mentry,
   251					MLX5_IB_MMAP_TYPE_MEMIC_OP, dm->base.size,
   252					op_entry->op_addr & PAGE_MASK);
   253		if (err) {
   254			mlx5_cmd_dealloc_memic_op(&dev->dm, dm->base.dev_addr, op);
   255			kfree(op_entry);
   256			goto err_unlock;
   257		}
   258		/* From this point, entry will be freed by mmap_free */
   259		kref_get(&dm->ref);
   260	
   261		err = copy_op_to_user(op_entry, attrs);
   262		if (err)
   263			goto err_remove;
   264	
   265		err = xa_insert(&dm->ops, op, op_entry, GFP_KERNEL);
   266		if (err)
   267			goto err_remove;
   268		mutex_unlock(&dm->ops_xa_lock);
   269	
   270		return 0;
   271	
   272	err_remove:
   273		rdma_user_mmap_entry_remove(&op_entry->mentry.rdma_entry);
   274	err_unlock:
   275		mutex_unlock(&dm->ops_xa_lock);
   276	
   277		return err;
   278	}
   279	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
