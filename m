From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Fri, 21 Jul 2017 08:25:47 -0400
Message-ID: <1500639947.23761.26.camel@redhat.com>
References: <1500639364.23761.22.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500639364.23761.22.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-07-21 at 08:16 -0400, Doug Ledford wrote:
> Hi Linus,
> 
> As per my previous pull request, there were two drivers that each had
> a
> rather large number of legitimate fixes still to be sent.  As it
> turned
> out, I also missed a reasonably large set of fixes from one person
> across the stack that are all important fixes.  All in all, the
> bnxt_re, i40iw, and Dan Carpenter are 3/4 to 2/3rds of this pull
> request.  There were some other random fixes that I didn't send in
> the
> last pull request that I added to this one.  This catches the rdma
> stack up to the fixes from up to about the beginning of this
> week.  Any
> more fixes I'll wait and batch up later in the -rc cycle.  This will
> give us a good base to start with for basing a for-next branch on
> -rc2.
>  Thanks.

I didn't specifically mention it, because it goes without saying, but
this has passed 0day.  I don't send you anything that hasn't
specifically passed 0day unless 0day has failed to run the tests and
sent me an email saying I won't get any more emails.  This has not, as
you probably imagine, been through linux-next.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
