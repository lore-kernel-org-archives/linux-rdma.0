From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/amso1100: deprecate the amso1100 provider
Date: Tue, 4 Aug 2015 16:33:06 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2577970C@fmsmsx120.amr.corp.intel.com>
References: <20150729144646.C1FF1E0B55@smtp.ogc.us>
 <55B8ED2B.1020206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55B8ED2B.1020206-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: Re: [PATCH] RDMA/amso1100: deprecate the amso1100 provider
> 
> On 07/29/2015 10:44 AM, Steve Wise wrote:
> > The HW hasn't been sold since 2005, and the SW has definite bit rot.
> > Its time to remove it.  So move it to staging for a few releases and
> > then remove it after that.
> >
> > Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> 
> Thanks, applied.
> 

This might run into the same issue as in https://lists.01.org/pipermail/kbuild-all/2015-August/011216.html.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
