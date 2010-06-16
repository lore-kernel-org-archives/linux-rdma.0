From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [ewg] [PATCH v4] IB Core: RAW ETH support
Date: Wed, 16 Jun 2010 12:12:06 -0500
Message-ID: <4C1905E6.2000304@opengridcomputing.com>
References: <E113D394D7C5DB4F8FF691FA7EE9DB4439A76E8632@MTLMAIL.mtl.com> <1276513450.30132.51.camel@alst60.voltaire.com> <aday6eguhfn.fsf@roland-alpha.cisco.com> <4C18DB37.6050501@opengridcomputing.com> <20100616170234.GA2932@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100616170234.GA2932-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Alekseys Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> On Wed, Jun 16, 2010 at 09:09:59AM -0500, Steve Wise wrote:
>
>   
>> Granted our dev process may not be documented, but I always assumed the 
>> general idea was to get changes accepted upstream, then pull into ofed. 
>> OFED is just a mechanism to make top-of-tree linux work on distro 
>> kernels. There are some exceptions, but this stuff shouldn't be an 
>> exception.
>>     
>
> That is what many people wish for, me included, but it is not at all
> what generally happens :(
>
> In my observation the typical flow is:
>  - A patch is written, it may or may not be sent to the list
>  - 'business drivers' get it slammed into OFED right away
>  - A patch is finally sent for proper review
>  - It is not merged, there are comments..
>  - Interest in doing anything is lost because it is already in
>    OFED and that is all that matters, right?
>  - People complain.
>
> For instance, the iWarp thingy we were just discussing fits this
> process rather well.
>
>   

You're wrong.  I started that iWARP change in 2007 on LKLM.  I proposed 
a few ideas and show the pros/cons of each.  And it was NAKed 100% by 
mister miller.    It was then included in OFED as a last resort only 
because I couldn't get any help with trying to add this upstream in any 
form.  I even spent a few weeks developing a way to administor "iwarp 
only" ipaddresses, but Roland didn't like that scheme for various 
reasons.  So please don't mention that particular patch as a "bad 
process" unless you want to argue with me some more about it.

Also, the chelsio iWARP driver has 100% been upstream first, then 
ofed.   Some of us are indeed trying to do the right thing.

<steps off soap box>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
