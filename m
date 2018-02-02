From: "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: How to tell RoCE v1 vs v2?
Date: Fri, 2 Feb 2018 22:20:00 +0000
Message-ID: <DE927C68B458BE418D582EC97927A9287FE204BF@ORSMSX113.amr.corp.intel.com>
References: <DE927C68B458BE418D582EC97927A9287FE1FCF7@ORSMSX113.amr.corp.intel.com>
 <VI1PR0502MB3008131CCEE4D9523F346611D1F90@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008131CCEE4D9523F346611D1F90-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Sen, Sujoy" <sujoy.sen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Steps:
> mkdir /sys/kernel/config/rdma_cm/mlx5_0
> cat /sys/kernel/config/rdma_cm/mlx5_0/ports/1/default_roce_mode
> #Above command tells whether default is RoCEv1 or v2.
> 
> echo "RoCE v2" >
> /sys/kernel/config/rdma_cm/mlx5_0/ports/1/default_roce_mode
> 
> Above command will force to pick RoCEv2 GIDs by default when using
> RDMACM based applications (if HCA supports it).

Thanks, this worked, the step I was missing was that I have to do the mkdir command first.  Looks like we're defaulting to v1.

root@purley02:/home/rsa# mkdir /sys/kernel/config/rdma_cm/mlx5_0
root@purley02:/home/rsa# cat /sys/kernel/config/rdma_cm/mlx5_0/ports/1/default_roce_mode
IB/RoCE v1

> RoCEv2 was made default in below patch.
> 
> commit 3c7f67d1880db4bda8eed12ca603c92b5434390e
> Author: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date:   Fri Jul 28 13:47:24 2017 -0400

This is good to know!  The patch looks to be from July 28 and we're running a kernel from August 6th so I guess we just missed picking up that change.  I'll try loading a newer kernel and see if the default changes, and if not we can try the recommended steps to force it.

root@purley02:/home/rsa# uname -a
Linux purley02 4.12.5-041205-generic #201708061334 SMP Sun Aug 6 17:35:26 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

Thanks very much for the help.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
