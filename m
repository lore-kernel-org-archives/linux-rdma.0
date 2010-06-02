From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: libibverbs and versions
Date: Wed, 02 Jun 2010 12:40:04 -0500
Message-ID: <4C069774.4050402@opengridcomputing.com>
References: <4C067DE0.8020508@opengridcomputing.com> <20100602173245.GG15969@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100602173245.GG15969-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Jason Gunthorpe wrote:
> On Wed, Jun 02, 2010 at 10:50:56AM -0500, Steve Wise wrote:
>
>   
>> I have this library I'm writing that uses libibverbs.  Somehow it seems  
>> to be using the 1.0 version instead of the newer version (I'm guessing).  
>> When I call ibv_create_cq()  I get a seg fault and the stack looks like 
>> this:
>>     
>
> Make sure you link your library to libibverbs and do not rely on
> linking the app to libibverbs to resolve the symbols. Check with 
> ldd foo.so
>
> Jason
>   

This was the issue.  My library wasn't explicitly linking via 
-libverbs.  When I added that, it worked.

But how did it manage to link to the old version I wonder?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
