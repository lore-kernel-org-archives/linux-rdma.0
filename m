From: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb4: Unblock reads on comp_channel
Date: Fri, 21 Oct 2011 13:02:58 +0530
Message-ID: <20111021073254.GA23539@kumars-PC.asicdesigners.com>
References: <1318494090-9996-1-git-send-email-kumaras@chelsio.com>
 <CAL1RGDU9Ka7-sGVnCnobgQjoh7p2bsXbSLp-Fnn6aA1Q9of36w@mail.gmail.com>
 <4E970E02.2090207@opengridcomputing.com>
 <88B766C272F2C64B944B21AD078333151BEE2E947E@EXMAIL.ad.emulex.com>
 <CAL1RGDXw9kkxAM8_pJ=jRhFTgRRt52QygDpQ+89RfEN=7QU=HQ@mail.gmail.com>
 <4EA04A95.9010908@opengridcomputing.com>
 <88B766C272F2C64B944B21AD078333151BEE2E9521@EXMAIL.ad.emulex.com>
 <4EA05AA0.4030201@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4EA05AA0.4030201-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Parav.Pandit-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 20, 2011 at 12:30:08 -0500, Steve Wise wrote:
> On 10/20/2011 12:25 PM, Parav.Pandit-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org wrote:
> >You are right, cq_lock will result into dead lock.
> >Should there be a additional compl_handler spin_lock?
> >I was measuring performance impact for adding it, and, irq_save() and irq_restore() variant showed additional 200 cycles, which I believe should be o.k.?
> >
> >Parav
> >
> 
> Yea, I think adding a comp_handler spin lock would do the trick.  I'll let Kumar come up with this change.

I will cook up a patch and post soon.

Thanks,
Kumar.
> 
> 
> 
> >-----Original Message-----
> >From: Steve Wise [mailto:swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org]
> >Sent: Thursday, October 20, 2011 9:52 PM
> >To: Roland Dreier
> >Cc: Pandit, Parav; kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
> >Subject: Re: [PATCH] RDMA/cxgb4: Unblock reads on comp_channel
> >
> >On 10/20/2011 11:06 AM, Roland Dreier wrote:
> >>On Thu, Oct 20, 2011 at 2:11 AM,<Parav.Pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>   wrote:
> >>>http://lxr.linux.no/#linux+v3.0.4/Documentation/infiniband/core_locking.txt
> >>>
> >>>Line no 66 to 97 states that - at a given point of time, there should be only one callback per CQ should be active.
> >>>Is this ensured?
> >>>
> >>>compl_handler() is invoked from multiple places flush_qp() and post_qp_event() to my mind.
> >>Yes, does look like an issue with this patch :(
> >>
> >And I think this bug exists in the T3 driver too.
> >
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
