From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [RFC] =?windows-1252?Q?=96_Proposal_for_new_process_?=
 =?windows-1252?Q?for_OFED_releases?=
Date: Tue, 06 Dec 2011 09:16:13 -0600
Message-ID: <4EDE31BD.7090103@opengridcomputing.com>
References: <CD250C48050CFB4D95E78C95F2FDDD6E237661EA@MTLDAG01.mtl.com> <1828884A29C6694DAF28B7E6B8A8237323FC20F5@ORSMSX102.amr.corp.intel.com> <4EDC6D4A.7060407@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EDC6D4A.7060407-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/05/2011 01:05 AM, Or Gerlitz wrote:
>
> To be concrete/constructive here, a per IB stack module individual has to be assigned for that backporting, which 
> doesn't mean "make IB code from kernel X to build under kernel Y" - lets
> see if we have people to actually do that.
>
> For example, on the iser space, and for the stack provided by Mellanox to customers - I took the approach of 
> iser_backport(X,Y) = ~Y  --- which means that if I have to backport the iser code from kernel X into kernel Y, I 
> simply use the iser code that comes with Y
>
> I do that since Y has well/tight integrated iscsi stack for which the maintainers worked very hard to produce, and I 
> can't re-invent backporting that stack.
>
> The tilde in ~Y stands for slight verb changes that could arise from the backporting the rest of the IB stack has gone 
> through, from X to Y, so if the verb to create CQ has another param in X vs what it had in Y- I add it under the ~ 
> umbrella, is that clear?
>

What if you had some feature in kernel X's iser that you wanted in the kernel Y backport?  By your definition, this 
wouldn't be possible it seems.  If we're only using the functionality of kernel Y, then what's the point?   Maybe I'm 
confused.

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
