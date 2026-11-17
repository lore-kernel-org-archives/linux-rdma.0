Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794879622;
	b=d2Be1wEY93cwSYEOXfLfOTGHRPz8TDDIqw0rJ68xFsLFP9/GDCH8LqruJ1FpLcoVg8rT
	 T48e5VPCKcQqAFFdHHKZ2mlQUgw83fvoA9Z9DGhsSN9WRUgYoRaScHN7TC4KBZYFPuRJ2
	 e9/9PhE76MPbLXJhzfNbXHi4d5aHlLo89BukPNOGvf33pnueIbpLkB+IIG66cE75ONEKj
	 ddwwLbfhwYUxOd01dSOPrsgJXhrNSzFg/QMADdnkqRvWNGD+8ZRRZlDOKxIRWssCmVBNT
	 IJS/WVElWrpQ6Rr8EYioSe9tIwV+yd37m3fiwqW+VmtuGq/u80piuu3rBDTRtnGKPWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794879622;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=OFl6UDFI76eLpaveKeAUCdPmHxT1stKaGqJ/+zkltfM=;
	b=k2orERculm1VmMHxpgAqclU6TXFhFF1YmIGf9PrAQowZozJxSWKzsYKM/ABc+vkjULFE
	 H2JJG58+LoG2jONGvvTdIhgg1AxEi7BqEX/8FSzSdk9c21+VMJXmjY5Z0FbJ7yseTMgST
	 D9nhIA4l24l2YTAQaUn4Ml1ry4VqKhLcW+jglIttdJF8R6YowEQIzkMf1JWqrP9tNSxJ2
	 eiWWk7h7CgpJvS7g/7nhu6z/kg4zAWv/XZgVtD9l+0NCqL3DJ2QFsFURcMYmd/yncYI5N
	 YWla0eJwneepWGgt76UtLeD02ZkOUiv/R2RZcKzl7g2mhG0z5HiNY257zpwZz2bSRcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=HJVL0gTM;
	arc=none smtp.remote-ip=198.175.65.9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F121C606A331
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 01:40:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F121C606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=HJVL0gTM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794879621; x=1826415621;
  h=date:from:to:cc:subject:message-id;
  bh=K0shpxN2IOlpd2Zd68utRZSuPHrcNeNdIeDrpWfM6ZQ=;
  b=HJVL0gTMBMGx8Y/mwXqfO8GwExGgCqT2VrlKvaMmwlOMVsP5sapeuGaw
   T/ryo/27QXgWEZnQZWX2WHIWhvsVxx9EHLLkTy5v17TUNBPx7pIyXZEsb
   bhTPpbst5zHWIw4fj9BbE5isHqjfZQRg/Mxu1R2lvYATwRciGkzEaWVLn
   VJO/zFJ5j9KX+DiCTc6ioYWqrrgPaGpnEYrhXQyVD0LjYAeAW4kmHikkh
   iyiLyX8vdz8AnhcOxippLqWEehVF0xwKESsKNWpZfCUGDSpLmL57R0huI
   9V8iBowSNHg1d+UwKxe9Se4GuObYFDmQN9c51dgGE9Vtcn3cnt4bUp6Ot
   A==;
X-CSE-ConnectionGUID: QHzCwOLCTputB0grfPBA+w==
X-CSE-MsgGUID: KFGbngX2SGC1BLVhz486yA==
X-IronPort-AV: E=McAfee;i="6800,10657,11968"; a="3486139"
X-IronPort-AV: E=Sophos;i="6.27,217,1787036400"; 
   d="scan'208";a="3486139"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 17:40:20 -0800
X-CSE-ConnectionGUID: jCHT0acrQdKLjN3s88SGWA==
X-CSE-MsgGUID: 0MUluONsRv2GI0QcXI9eOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,217,1787036400"; 
   d="scan'208";a="9684044"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by orviesa006.jf.intel.com with ESMTP; 16 Nov 2026 17:40:19 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xT8BE-000000002uw-1Qj8;
	Tue, 17 Nov 2026 01:40:16 +0000
Date: Tue, 17 Nov 2026 02:39:40 +0100
From: kernel test robot <lkp@intel.com>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg+lists@ziepe.ca>, linux-rdma@vger.kernel.org,
 Leon Romanovsky <leon@kernel.org>
Subject: [rdma:wip/leon-for-next 33/37]
 drivers/infiniband/hw/mlx5/dm.c:217:16: error: 'struct mlx5_ib_dm' has no
 member named 'base'
Message-ID: <202611170202.VKw86FKB-lkp@intel.com>
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
config: mips-allmodconfig (https://download.01.org/0day-ci/archive/20261117/202611170202.VKw86FKB-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261117/202611170202.VKw86FKB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611170202.VKw86FKB-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/infiniband/hw/mlx5/dm.c: In function 'mlx5_ib_handler_MLX5_IB_METHOD_DM_MAP_OP_ADDR':
>> drivers/infiniband/hw/mlx5/dm.c:217:16: error: 'struct mlx5_ib_dm' has no member named 'base'
     217 |         if (mdm->base.type != MLX5_IB_UAPI_DM_TYPE_MEMIC)
         |                ^~


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
