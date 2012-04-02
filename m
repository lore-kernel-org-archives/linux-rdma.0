From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [RFC] Proposal to change Node Description naming scheme for
 HCA's
Date: Mon, 2 Apr 2012 13:58:08 -0700
Message-ID: <20120402135808.df12d36b.weiny2@llnl.gov>
References: <20120330173908.0abdd264.weiny2@llnl.gov>
	<F93D748CDCC46C42B498F40A38D90369641004@FMSMSX107.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F93D748CDCC46C42B498F40A38D90369641004-AtyAts71sc9zLByeVOV5+bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Heinz, Michael William" <michael.william.heinz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bob Ciotti <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>, James Silva <jsilva-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2 Apr 2012 15:27:35 +0000
"Heinz, Michael William" <michael.william.heinz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> I like this idea - but it reminds me of a related issue I raised a while back: nodes can often set the HCA description before they received a hostname from DHCP - in which case you end up with saqueries full of "localhost HCA-1".
> 
> At the time, QLogic's proposal was to modify the kernel stack so that it extracted the hostname at the time of the query instead of at boot time - but the linux_rdma list did not like that solution.
> 

The reason this is not acceptable is it hard codes hostname at a low level.  We should allow the user to override the Node Descriptor if they so desire.  In the case of the SM being faster than the boot scripts (rdma, openibd, udev, dhcp, or whatever).  It is better that the SM see the Node Description change trap and update the ND there.  As a final "fix" OpenSM has an "update_desc" option in the console to force a resweep if your names from the SA are wrong.

> Any ideas on how we could solve the hostname problem while we're changing the description?
> 
> As for what installs the openibd script, I'm pretty sure that's part of ofa_kernel.

Thanks, I will look for that.

Ira

> 
> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Ira Weiny
> Sent: Friday, March 30, 2012 8:39 PM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Doug Ledford; Bob Ciotti; James Silva
> Subject: [RFC] Proposal to change Node Description naming scheme for HCA's
> 
> First, a question: what package installs the openibd script in OFED?  For the life of me I can't find this script in 1.5.4.1 or 3.2 ...  :-/  [*]
> 
> Right now the "standard" for node description is, AFAIK, "<hostname> HCA-<num>", where num is simply a counter for the HCA's as they are found in /sys/class/infiniband.
> 
> The problem is resolving this "random" HCA number to an actual HCA on the host.  I thought about including the node description in ibstat but that seems a bit short sighted.  I think the better solution would be to append the hca name (ie mlx4_X, qibX, etc) to the hostname for the Node Description.
> 
> Hacking the RHEL start up script is really easy to do this and results in nice names on the fabric which are easily resolved by the infiniband-diags, ibverbs, and perftest utilities.
> 
> bash-4.1# ibhosts
> Ca      : 0x0002c90300325280 ports 1 "ending mlx4_2"
> Ca      : 0x001175000079da38 ports 1 "happy qib0"
> Ca      : 0x0002c90300108f2e ports 1 "ending mlx4_1"
> Ca      : 0x001175000077d90e ports 2 "ending qib0"
> Ca      : 0x0002c903004bebda ports 2 "happy mlx4_0"
> bash-4.1# hostname
> happy
> bash-4.1# ibstat mlx4_0
> CA 'mlx4_0'
>         CA type: MT26428
>         Number of ports: 2
>         Firmware version: 2.8.600
> ...
> bash-4.1# ibv_rc_pingpong -d mlx4_0
>   local address:  LID 0x0008, QPN 0x16004a, PSN 0x2e8316 ...
> bash-4.1# rdma_bw -d mlx4_0
> 6089: | port=18515 | ib_port=1 | size=65536 | tx_depth=100 | sl=0 | iters=1000 | duplex=0 | cma=0 | ...
> 
> I realize this is really a distro thing but it would be nice if we could agree to change the current "standard".
> 
> I can send a patch for RHEL and OFED (if I someone can point me to the openibd script or srpm).
> 
> Thoughts?
> Ira
> 
> 
> [*] Last I knew openibd does the same as RHEL's rdma start up script in this regard.
> 
> --
> Ira Weiny
> Member of Technical Staff
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
