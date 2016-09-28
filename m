From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH for-next 0/8] Bug Fixes and Code Improvement in HNS
 driver
Date: Wed, 28 Sep 2016 16:06:33 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F91A734800@lhreml503-mbx>
References: <20160910040930.25988-1-salil.mehta@huawei.com>
 <57EBDA43.3010708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57EBDA43.3010708-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Huwei (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Zhuangyuzeng (Yisen)" <yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Wednesday, September 28, 2016 3:57 PM
> To: Salil Mehta
> Cc: Huwei (Xavier); oulijun; Zhuangyuzeng (Yisen);
> mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Linuxarm
> Subject: Re: [PATCH for-next 0/8] Bug Fixes and Code Improvement in HNS
> driver
> 
> On 9/10/16 12:09 AM, Salil Mehta wrote:
> > This patch-set introduces fix to some Bugs, potential problems
> > and code improvements identified during internal review and
> > testing of Hisilicon Network Subsystem driver.
> >
> > Hi Doug,
> > These are few HNS patches which are not related to HNS RoCE driver
> but
> > are being sent through your repository hns-roce (as requested) to
> mitigate
> > any conflicts with HNS RoCE driver for the 4.9 merge window. In
> future
> > i.e. after 4.9 we will go by more formal git-pull request method once
> > HNS RoCE base driver becomes part of 4.9.
> 
> Hi Salil,
> 
> I've chatted with Dave Miller about this series.  Here's where we
> stand.
> 
> First, the review feedback from Dave:
> 
> ---
> 
> In patch #7, their comments are mis-formatted and these
> hns guys do this a lot.
> 
> 	/*fix hardware broadcast/multicast packets queue loopback */
> 
> They seem to have a hard time putting an initial space in the comment,
> and properly capitalizing and punctuating their sentences.
> 
> Also in that new function, they need to order local variables from
> longest to shortest line (reverse christmas tree format).
> 
> Patch #6 has the local variable ordering issue as well as does patch
> #3.
> 
> ---
> 
> Please address those issues and resubmit.
Hi Doug,
Thanks for the feedback. Point noted. I will address the mentioned issues,
discuss internally as well and revert with fixed patches.

Best regards
Salil
> 
> As for the method of resubmission, please send the set to netdev@ and
> also linux-rdma@, make note that, as a one off thing, these will need
> to
> go through my tree to avoid conflicts with patches already in my tree,
> and that future submissions will follow the Mellanox model of
> submitting
> shared code to both mine and David's tree that is needed to avoid
> conflicts for that merge window's submissions.  After the netdev people
> have reviewed it, and Dave acks it, either he can pick it up and sort
> the conflicts out, or I can pick it up.
Sure, got it. Will resubmit to netdev & linux-rdma this time and as
discussed would go by the Mellanox model of submission (git-pull) for
future such submit.

Thanks
Salil
> 
> >
> > Daode Huang (6):
> >   net: hns: bug fix about setting coalsecs-usecs to 0
> >   net: hns: add fini_process for v2 napi process
> >   net: hns: delete repeat read fbd num after while
> >   net: hns: fix the bug of forwarding table
> >   net: hns: bug fix about broadcast/multicast packets
> >   net: hns: delete redundant broadcast packet filter process
> >
> > Kejian Yan (1):
> >   net: hns: fix port not available after testing loopback
> >
> > lipeng (1):
> >   net: hns: fix port unavailable after hnae_reserve_buffer_map fail
> >
> >  drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c  |  11 ++-
> >  drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |  13 ++-
> >  drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h  |   2 +
> >  drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c |  10 --
> >  drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.h |   1 -
> >  drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c  |  16 ++++
> >  drivers/net/ethernet/hisilicon/hns/hns_dsaf_reg.h  |   4 +
> >  drivers/net/ethernet/hisilicon/hns/hns_enet.c      | 106
> ++++++++++++++-------
> >  drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |   7 ++
> >  9 files changed, 117 insertions(+), 53 deletions(-)
> >
> 
> 
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>    GPG Key ID: 0E572FDD
>   Red Hat, Inc.
>   100 E. Davie St
>   Raleigh, NC 27601 USA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
