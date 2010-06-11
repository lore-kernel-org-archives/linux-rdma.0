From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Fri, 11 Jun 2010 18:40:33 -0500
Message-ID: <4C12C971.4000909@opengridcomputing.com>
References: <20100611124746.GA2292@CTUNG-MOBL1> <adapqzxy2sb.fsf@roland-alpha.cisco.com> <2EFBCAEF10980645BBCFB605689E08E904924CCE42@azsmsx506.amr.corp.intel.com> <4C12A6E8.5040400@opengridcomputing.com> <adamxv1w7cb.fsf@roland-alpha.cisco.com> <20100611224126.GA4630@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100611224126.GA4630-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> On Fri, Jun 11, 2010 at 03:08:20PM -0700, Roland Dreier wrote:
>
>   
>> If Dave Miller says this is an unacceptable thing to merge, then I'm not
>> going to merge it over his explicit and unequivocal NAK.  Trying sneak
>> this in by hiding this patch on linux-rdma without cc-ing netdev is the
>> wrong approach... the right approach is to get the hordes of users being
>> hurt by this issue (if there are such hordes), make a big stink, and
>> force a solution that everyone agrees on.
>>     
>
> Right..
>
> What exactly is the end-user harm anyhow? Everything works 100%
> correctly without this patch, and your arguments all revolved around
> diagnostic capability..
>
>   

No, everything does not work without this patch.  Go read the thread 
from 2007 (I posted the URL to it on this thread).   I describe exactly 
how an application like MPI will get incorrect behavior due to port 
space collisions on iWARP HW.


> It is a known weakness that the RDMA stack has crappy visibility. That
> has been talked about before. If you want better visibility then fix
> that by adding netlink stuff to dump out all the QP states, PDs, etc,
> similar to what TCP does.
>   

What does this have to do with port space allocation?  I agree the rdma 
stacks should have tools to dump all that good stuff out for 
admins/debugging.  But its really not part of this issue IMO.

Steve.


> Jason
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
