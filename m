From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [ewg] [PATCH v4] IB Core: RAW ETH support
Date: Wed, 16 Jun 2010 09:09:59 -0500
Message-ID: <4C18DB37.6050501@opengridcomputing.com>
References: <E113D394D7C5DB4F8FF691FA7EE9DB4439A76E8632@MTLMAIL.mtl.com>	<1276513450.30132.51.camel@alst60.voltaire.com> <aday6eguhfn.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <aday6eguhfn.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Alekseys Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > I tested it before on the Roland tree ( iboe branch ) and it fails,
>  > because it writen in the way suitable for OFED. If adapt the patch to
>  > the Roland tree, then appling Mellanox OFED patches will fail, because
>  > it changes the same functions in the code.
>  > Here is one example:
>  > Look at __mlx4_ib_modify_qp at the Roland tree - there is no RAW_ETY
>  > support. But in the OFED version of the same function this support is
>  > present.
>  > RAW_ETH patch modify this function and looking for RAW_ETY word and
>  > without this RAW_ETH Mellanox patch will fail.
>
> Don't take this too personally -- I picked a semi-random email in this
> thread to reply to; this is pretty broadly targeted.
>
> <rant>
>
> What the hell is the thinking behind introducing IB_QPT_RAW_ETH?  You're
> inserting an enum value before IB_QPT_RAW_ETY, so any old userspace
> passing in IB_QPT_RAW_ETY will silently get different behavior depending
> on the kernel version.  And you're creating two constands that differ in
> a single letter (IB_QPT_RAW_ETY vs. IB_QPT_RAW_ETH).  How are you going
> to explain that to users?  How is anyone ever going to get it right?
> For that matter, what exactly does IB_QPT_RAW_ETH mean?
>
> This all seems to be a symptom of how broken our development process
> is.  Yes, unfortunately I can't spend as much time reviewing and
> applying patches as I might like, and I apologize for that.  But if we
> have all the RDMA developers piling up shit in their little area and
> then sending it on to be merged as soon as it kind of works, without
> thinking about design or maintainability and without ever doing any
> review, then I'm always going to have an expanding review backlog.
>
> And then we have OFED compounding problems -- "Oh that's a nice pile of
> shit you've built there.  We better ship it to users while it's still
> steaming."  How about if OFED developers take a little time to think
> things through?
>
> </rant>
>
> In other words, can someone explain the plan for this raw QP stuff to me?
>
>  - R.
>   


It doesn't even look like this patch and the mlx4 patch were ever posted 
to linux-rdma. Only to the EWG list.

Granted our dev process may not be documented, but I always assumed the 
general idea was to get changes accepted upstream, then pull into ofed. 
OFED is just a mechanism to make top-of-tree linux work on distro 
kernels. There are some exceptions, but this stuff shouldn't be an 
exception.

We should all follow this "upstream first" process IMO.

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
