From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH for-4.1 0/2] Adds support for user mode bar2 mapping and bar2 qid density
Date: Thu, 11 Jun 2015 09:08:12 -0500
Message-ID: <005201d0a450$0dd27660$29776320$@opengridcomputing.com>
References: <1433854392-6531-1-git-send-email-hariprasad@chelsio.com> <1433998881.71666.147.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433998881.71666.147.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Doug Ledford
> Sent: Thursday, June 11, 2015 12:01 AM
> To: Hariprasad Shenai
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org; leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
> Subject: Re: [PATCH for-4.1 0/2] Adds support for user mode bar2 mapping and bar2 qid density
> 
> On Tue, 2015-06-09 at 18:23 +0530, Hariprasad Shenai wrote:
> > Hi,
> >
> > This patch series adds support for user mode bar2 mappings for T4 adapter
> > and also adds  support for bar2 qid densities exceeding page size.
> >
> > This patch series has been created against Doug's github tree 'for-4.1'
> > branch and includes patches on cxgb4 and iw_cxgb4 driver.
> >
> > We have included all the maintainers of respective drivers. Kindly review
> > the change and let us know in case of any review comments.
> 
> I didn't catch this in my original responses to this thread.  But, your
> subject calls this out for 4.1.  You do realize that 4.1 is already at
> 4.1-rc7.  Did you really mean for a patchset this large to go in at this
> late stage of the rc cycles?  And if so, what's the justification?
> 
> Otherwise, I fixed up the cast issue I brought up and have this ready to
> apply to 4.2.  But if you *really* mean 4.1, speak up with the problem
> this solves and why it's so bad it can't wait.
>

4.2 is fine with me.  The changes are too great for 4.1-rc7.

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
