From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V6 6/9] isert: Rename IO functions to more descriptive names
Date: Mon, 27 Jul 2015 16:45:15 -0500
Message-ID: <00c301d0c8b5$85ccc650$916652f0$@opengridcomputing.com>
References: <20150724161331.25617.8475.stgit@build2.ogc.int> <20150724161848.25617.26092.stgit@build2.ogc.int> <55B4B190.7070305@dev.mellanox.co.il> <55B5404F.5040404@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55B5404F.5040404-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
> Sent: Sunday, July 26, 2015 3:17 PM
> To: Sagi Grimberg; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
> Subject: Re: [PATCH V6 6/9] isert: Rename IO functions to more descriptive names
> 
> On 7/26/2015 5:08 AM, Sagi Grimberg wrote:
> > On 7/24/2015 7:18 PM, Steve Wise wrote:
> >> This is in preparation for adding new FRMR-only IO handlers
> >> for devices that support FRMR and not PI.
> >
> > Steve,
> >
> > I've given this some thought and I think we should avoid splitting
> > logic from PI and iWARP. The reason (other than code duplication) is
> > that currently the iser target support only up to 1MB IOs. I have some
> > code (not done yet) to support larger IOs by using multiple
> > registrations  per IO (with or without PI).
> > With a little tweaking I think we can get iwarp to fit in too...
> >
> > So, do you mind if I take a crack at it?
> 
> Sure, go ahead.  Let me know how I can help.  Certainly I can test it
> for you.  I'm very keen to get this in for 4.3 if possible...
> 
> 

Since Sagi is going to work on isert to support iwarp as part of his current isert large work, I'll drop the isert patches.  I also want to split up the max_sge_rd patches to their own submission.  So I will send out 2 new series for a final submission:

1) iser support for iwarp

2) use max_sge_rd and remove rdma_cap_read_multi_sge().

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
