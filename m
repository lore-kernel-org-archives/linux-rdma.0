From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Fri, 11 Jun 2010 20:18:43 -0500
Message-ID: <4C12E073.2040008@opengridcomputing.com>
References: <20100611124746.GA2292@CTUNG-MOBL1> <adapqzxy2sb.fsf@roland-alpha.cisco.com> <2EFBCAEF10980645BBCFB605689E08E904924CCE42@azsmsx506.amr.corp.intel.com> <4C12A6E8.5040400@opengridcomputing.com> <adamxv1w7cb.fsf@roland-alpha.cisco.com> <20100611224126.GA4630@obsidianresearch.com> <4C12C971.4000909@opengridcomputing.com> <20100612000431.GC4630@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100612000431.GC4630-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> On Fri, Jun 11, 2010 at 06:40:33PM -0500, Steve Wise wrote:
>
>   
>> No, everything does not work without this patch.  Go read the thread  
>> from 2007 (I posted the URL to it on this thread).   I describe exactly  
>> how an application like MPI will get incorrect behavior due to port  
>> space collisions on iWARP HW.
>>     
>
> I guess I missed the fact that OFED included this patch, rather than
> relying on the other administratively configured schemes you
> originally outlined. I was opining that nobody was complaining about
> the administrative stuff.. but of course nobody complains, they don't
> have to do it :(
>
> A seperate IP for iWarp always seemed to me to be the way forward on
> this. And I do mean seperate, as in TCP packets for this IP are never
> sent into the net stack seperate :|
>
>   
 From a user perspective, separate IP addresses for iWARP is terrible.  
Further, its not even needed for IB, just iWARP.  That's an unnecessary 
admin pain IMO.  iWARP should and can easily co-exist with the host TCP 
by sharing the port space.  But, as Roland stated already, maybe the 
only way forward it to get end-user pressure applied at the appropriate 
places! :)

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
