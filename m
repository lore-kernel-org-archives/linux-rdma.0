From: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Subject: Re: [PATCH V3] IB/uverbs: Fix race between uverbs_close and
 remove_on
Date: Sat, 12 Mar 2016 10:28:13 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1603121025410.2055@localhost6.localdomain6>
References: <201603120023.slIBt5nA%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201603120023.slIBt5nA%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It looks like braces are missing on lines 964 and 968.

julia


> Hi Devesh,
> 
> [auto build test WARNING on rdma/master]
> [also build test WARNING on v4.5-rc7 next-20160311]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Devesh-Sharma/IB-uverbs-Fix-race-between-uverbs_close-and-remove_one/20160311-232536
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma master
> :::::: branch date: 71 minutes ago
> :::::: commit date: 71 minutes ago
> 
> >> drivers/infiniband/core/uverbs_main.c:965:2-54: code aligned with following code on line 966
> 
> git remote add linux-review https://github.com/0day-ci/linux
> git remote update linux-review
> git checkout 850ad4029f22757665c94675f929a6cfa2ba4f60
> vim +965 drivers/infiniband/core/uverbs_main.c
> 
> 850ad4029 Devesh Sharma 2016-03-11  959  	int srcu_key;
> 850ad4029 Devesh Sharma 2016-03-11  960  
> 850ad4029 Devesh Sharma 2016-03-11  961  	srcu_key = srcu_read_lock(&dev->disassociate_srcu);
> 850ad4029 Devesh Sharma 2016-03-11  962  	ib_dev = srcu_dereference(dev->ib_dev,
> 850ad4029 Devesh Sharma 2016-03-11  963  				  &dev->disassociate_srcu);
> 850ad4029 Devesh Sharma 2016-03-11  964  	if (!ib_dev)
> 850ad4029 Devesh Sharma 2016-03-11 @965  		srcu_read_unlock(&dev->disassociate_srcu, srcu_key);
> 850ad4029 Devesh Sharma 2016-03-11 @966  		wait_for_completion(&file->fcomp);
> 850ad4029 Devesh Sharma 2016-03-11  967  		goto out;
> bc38a6abd Roland Dreier 2005-07-07  968  
> 036b10635 Yishai Hadas  2015-08-13  969  	mutex_lock(&file->device->lists_mutex);
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
