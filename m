From: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/ipoib: add get_settings in ethtool (fwd)
Date: Thu, 20 Apr 2017 19:44:04 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1704201943070.11573@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The complete context is not included, but if speed is unsigned then it is
not useful to check for < 0.

julia

---------- Forwarded message ----------
Date: Thu, 20 Apr 2017 18:27:25 +0800
From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
To: kbuild-JC7UmRfGjtg@public.gmane.org
Cc: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/ipoib: add get_settings in ethtool

Hi Zhu,

[auto build test WARNING on rdma/master]
[also build test WARNING on v4.11-rc7 next-20170420]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Zhu-Yanjun/IB-ipoib-add-get_settings-in-ethtool/20170420-163907
base:   https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git master
:::::: branch date: 2 hours ago
:::::: commit date: 2 hours ago

>> drivers/infiniband/ulp/ipoib/ipoib_ethtool.c:199:5-10: WARNING: Unsigned expression compared with zero: speed < 0

git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout e83ee68b3051f0002f2185aed6771925cb15f4c5
vim +199 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c

e83ee68b Zhu Yanjun 2017-04-20  183  	case IB_SPEED_FDR10:
e83ee68b Zhu Yanjun 2017-04-20  184  		speed = 10000;
e83ee68b Zhu Yanjun 2017-04-20  185  		break;
e83ee68b Zhu Yanjun 2017-04-20  186  	case IB_SPEED_FDR:
e83ee68b Zhu Yanjun 2017-04-20  187  		speed = 14000;
e83ee68b Zhu Yanjun 2017-04-20  188  		break;
e83ee68b Zhu Yanjun 2017-04-20  189  	case IB_SPEED_EDR:
e83ee68b Zhu Yanjun 2017-04-20  190  		speed = 25000;
e83ee68b Zhu Yanjun 2017-04-20  191  		break;
e83ee68b Zhu Yanjun 2017-04-20  192  	case IB_SPEED_SDR:
e83ee68b Zhu Yanjun 2017-04-20  193  	default:
e83ee68b Zhu Yanjun 2017-04-20  194  		speed = 2500;
e83ee68b Zhu Yanjun 2017-04-20  195  		break;
e83ee68b Zhu Yanjun 2017-04-20  196  	}
e83ee68b Zhu Yanjun 2017-04-20  197
e83ee68b Zhu Yanjun 2017-04-20  198  	speed *= ib_width_enum_to_int(attr.active_width);
e83ee68b Zhu Yanjun 2017-04-20 @199  	if (speed < 0)
e83ee68b Zhu Yanjun 2017-04-20  200  		return -EINVAL;
e83ee68b Zhu Yanjun 2017-04-20  201
e83ee68b Zhu Yanjun 2017-04-20  202  	ethtool_cmd_speed_set(ecmd, speed);
e83ee68b Zhu Yanjun 2017-04-20  203  	ecmd->duplex = DUPLEX_FULL;
e83ee68b Zhu Yanjun 2017-04-20  204
e83ee68b Zhu Yanjun 2017-04-20  205  	return 0;
e83ee68b Zhu Yanjun 2017-04-20  206  }
e83ee68b Zhu Yanjun 2017-04-20  207

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
