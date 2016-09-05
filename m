From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs 1/3] Add new call ibv_cmd_create_ah_ex which
 supports extra parameters
Date: Mon, 05 Sep 2016 06:56:54 +0200
Message-ID: <1473051414.26625.40.camel@oracle.com>
References: <1472713193-22397-1-git-send-email-knut.omang@oracle.com>
         <1472713193-22397-2-git-send-email-knut.omang@oracle.com>
         <20160901164939.GD6479@obsidianresearch.com>
         <1472750558.9410.230.camel@oracle.com>
         <20160901180512.GB20098@obsidianresearch.com>
         <1472754220.9410.236.camel@oracle.com>
         <20160902020642.GA30057@obsidianresearch.com>
         <1472802582.3975.16.camel@oracle.com>
         <1472887840.9410.364.camel@oracle.com>
         <20160905023817.GD21542@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160905023817.GD21542-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2016-09-04 at 20:38 -0600, Jason Gunthorpe wrote:
> On Sat, Sep 03, 2016 at 09:30:40AM +0200, Knut Omang wrote:
> 
> > Looking more closely at this whole problem, I think for my patch, 
> > the right solution is just to avoid adding a new function name and 
> > instead provide a redefinition of the original symbol with a new version 
> > using the __asm__(".symver ...) construct already nicely used for v.1.0 
> > bw compatibility - just following the pattern already established.
> 
> That is possible, but to date we have never done that and have
> continued to preserve source compatability for providers.
> 
> I agree the providers should be updated, but I don't see this being
> practical until after rdma-plumbing is in place..
> 
> So I suggest you proceed as you have with the fixed symbol version.

Ok, fine - I have implemented and tested both solutions with current libmlx4 + 
Connect-X3 and libsif + SIF using the libibverbs and kernel patch sets in the same box, 
with a small amendment to the size checking in the uverbs ibv_reg_mr path and feel 
I am ready for a v2 then.

Thanks,
Knut

> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
