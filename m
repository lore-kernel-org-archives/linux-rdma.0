From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 00/16] IB/hfi1, qib, rdmavt: patches for next
 08/21/2017
Date: Mon, 28 Aug 2017 19:16:22 -0400
Message-ID: <1503962182.52034.7.camel@redhat.com>
References: <20170822011657.32701.22207.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170822011657.32701.22207.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Grzegorz Morys <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-08-21 at 18:26 -0700, Dennis Dalessandro wrote:
> Hi Doug,
> 
> Another week another set of patches. I meant to send on Friday but
> was waiting
> for 0-day builds to complete. I still haven't gotten any
> notification, the
> service may be down but I wanted to get these on the list anyway for
> review.
> If I get any bad result I will reply but there is nothing
> particularly scary
> in here.
> 
> Content wise this is more clean ups including a patch for rdmavt to
> use
> the put_swqe/clear_mr_ref helpers that support was added for in
> qib/hfi1
> previously. 
> 
> We have some minor bug fixes as well. A large portion of the patch
> set is
> a clean up/refactoring exercise by Harish that I took because it
> makes the code
> cleaner and easier to read.
> 
> Note, one of the fixes from Mike is marked stable. I don't know if
> it's something
> that you want to take into this late of an RC so it may be best to
> just go to
> next and flow through the stable process.
> 
> Patches can can also be found in my GitHub repo at:
> https://github.com/ddalessa/kernel/tree/for-4.14
> 

Hi Denny, 

I went ahead and took these, but please make sure you follow up with
the review requests from Leon.  Preferably by the time I'm back from
PTO the incremental patches will be waiting for me ;-)

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
