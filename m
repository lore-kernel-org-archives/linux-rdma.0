From: Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: NFS over RDMA crashing
Date: Thu, 7 Feb 2013 15:54:13 +0000
Message-ID: <0EE9A1CDC8D6434DB00095CD7DB873461151874C@MTLDAG01.mtl.com>
References: <51127B3F.2090200@mellanox.com>
 <51127DB1.6070804@opengridcomputing.com> <51128DAC.9000206@nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51128DAC.9000206-NSQ8wuThN14@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Becker <jeffrey.c.becker-NSQ8wuThN14@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Jeff Becker [mailto:jeffrey.c.becker-NSQ8wuThN14@public.gmane.org]
> Sent: Wednesday, February 06, 2013 19:07
> To: Steve Wise
> Cc: Yan Burman; bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Or Gerlitz; Tom Tucker
> Subject: Re: NFS over RDMA crashing
> 
> Hi. In case you're interested, I did the NFS/RDMA backports for OFED. I
> tested that NFS/RDMA in OFED 3.5 works on kernel 3.5, and also the RHEL
> 6.3 kernel. However, I did not test it with SRIOV. If you test it
> (OFED-3.5-rc6 was released last week), I'd like to know how it goes. Thanks.
> 
> Jeff Becker
> 
> On 02/06/2013 07:58 AM, Steve Wise wrote:
> > On 2/6/2013 9:48 AM, Yan Burman wrote:
> >> When I moved to commit 79f77bf9a4e3dd5ead006b8f17e7c4ff07d8374e I
> was
> >> no longer getting the server crashes, so the reset of my tests were
> >> done using that point (it is somewhere in the middle of 3.7.0-rc2)
> >>
> > +tom tucker
> >
> > I'd try going back a few kernels, like to 3.5.x and see if things are
> > more stable.  If you find a point that works, then git bisect might
> > help identify the regression.
> > --

Vanilla 3.5.7 seem to work OK out of the box.
I will try 3.6 next week + performance comparisons.

Yan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
