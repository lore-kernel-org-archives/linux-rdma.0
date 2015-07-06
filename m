From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V6 3/5] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Mon, 6 Jul 2015 11:18:03 -0600
Message-ID: <20150706171803.GA20680@obsidianresearch.com>
References: <1435659967-27173-1-git-send-email-yishaih@mellanox.com>
 <1435659967-27173-4-git-send-email-yishaih@mellanox.com>
 <20150630184035.GC2819@obsidianresearch.com>
 <559A8BC8.60507@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <559A8BC8.60507-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, achiang-VXdhtT5mjnY@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 06, 2015 at 05:08:08PM +0300, Yishai Hadas wrote:

> The patch that introduces this bug was added 5 years ago by Alex Chiang and
> Signed-off-by: Roland Dreier.
> 
> Look at commit ID:2a72f212263701b927559f6850446421d5906c41, it can be seen
> also at:
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=2a72f212263701b

Perhaps, this one also looks involved as well:

commit 055422ddbb0a7610c5f57a056743d7336a39e90f
Author: Alexander Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Date:   Tue Feb 2 19:07:49 2010 +0000

    IB/uverbs: Convert *cdev to cdev in struct ib_uverbs_device
    
    Instead of storing a pointer to a cdev, embed the entire struct cdev.

Embedding the cdev without using a parent kobject looks like the root
mistake.

> AFAIK V6 addressed all opened comments raised by Jason, including the last
> one that asked to use 2 separate krefs for both complete and free, it didn't
> introduced the problem above.

It does make it worse though, previously the module locking would make
it unlikely to ever hit any problem here, but now we have a naked
fully exposed race where release races with kfree resulting in
use-after-free. I'd think hitting it is quite likely if the new
feature is being used, and subtle memory corruption is not something
we want to see in the kernel.

So, I'd say, yes it is an old bug, but it is unlikely to hit it. This
patch series is making it much likely, so it needs to be fixed.

In any event, I'm not sure what you are complaining about - this
series absolutely reworks the lifetime model of ib_uverbs_device, why
on earth do you think it is OK to have a buggy new implementation just
because the previous version was buggy? *Especially* when someone
takes the time to point out the mistake and tells you exactly how to
fix it, and it is *trival* to do?

Even worse: I went through and audited the lifetime of V6's new model,
and I think that is *absolutely* something you should have done before
sending V1 :(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
