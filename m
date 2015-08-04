From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V6 6/9] isert: Rename IO functions to more descriptive names
Date: Tue, 4 Aug 2015 12:44:40 -0500
Message-ID: <008a01d0cedd$3d382b90$b7a882b0$@opengridcomputing.com>
References: <20150724161331.25617.8475.stgit@build2.ogc.int> <20150724161848.25617.26092.stgit@build2.ogc.int> <55B4B190.7070305@dev.mellanox.co.il> <55B5404F.5040404@opengridcomputing.com> <000001d0ce23$27048810$750d9830$@opengridcomputing.com> <55C0F5B7.4040100@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55C0F5B7.4040100-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Sagi Grimberg [mailto:sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> Sent: Tuesday, August 04, 2015 12:26 PM
> To: Steve Wise; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
> Subject: Re: [PATCH V6 6/9] isert: Rename IO functions to more descriptive names
> 
> > Hey Sagi, how is this coming along?  How can I help?
> >
> 
> Hi Steve,
> 
> This is taking longer than I expected, the changes needed seem
> pretty extensive throughout the IO path. I don't think it will be ready
> for 4.3
>

Perhaps then we should go with my version that adds iwarp-only FRMR IO handlers for 4.3.  Then they can be phased out as the rework matures.  Thoughts?
 
> I'll try to send you soon a preliminary version to play with.
> Acceptable?

I can test the iwarp parts once you think the code is ready to try.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
