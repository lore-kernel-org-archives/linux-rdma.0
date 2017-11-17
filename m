From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH] rdma: Add Jason as a co-maintainer
Date: Fri, 17 Nov 2017 11:14:10 -0700
Message-ID: <20171117181410.GL4276@ziepe.ca>
References: <20171116204400.GA28216@mellanox.com>
 <1510941272.2846.46.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510941272.2846.46.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 17, 2017 at 05:54:34PM +0000, Bart Van Assche wrote:
> Thanks Doug for having added a co-maintainer. Jason, thank you for willing
> to be a co-maintainer.

Thank you Bart!

> Jason, if you are going to send pull requests to Linus you should be aware
> of the following:

I think we will work up to that, obviously I will be working with Doug
and his expertise and experience will guide what happens.

A new git tree has been setup for RDMA:

  https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/

This will replace Doug's personal k.o tree effective immediately as
the cannonical source for the RDMA work in progress.

Both Doug and I have write privileges to this tree.

> * Linus trusts pull requests from a kernel.org repository more than pull
>   requests from a repository outside kernel.org (e.g. github). Any requests
>   to pull from e.g. github must be PGP-signed.

Done

> * If you send an e-mail to Wu Fengguang then he will add a branch from your
>   repository to his zero-day testing. This is a great way to catch build
>   failures before linux-next catches these.

Thanks

> * Any patches that will be sent to Linus must have been in the for-next
>   repository for at least a few days. Requests to add a branch to linux-next
>   should be sent to Stephen Rothwell with linux-next in Cc.

Doug will send Stephen Rothwell a note to move his for-next pull for
RDMA from Doug's personal directory to:

git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git

Branch k.o/for-next

> * Maintainers are expected to keep an eye on merge conflicts and other reports
>   sent out to the linux-next mailing list
>   (http://vger.kernel.org/vger-lists.html#linux-next).

Good advice..

> * Rebasing a tree that will be sent to Linus is completely inacceptable. A
>   quote from Linus: "And in general, you simply should never rebase commits
>   that have already been publicized." Source: Linus Torvalds, Re: linux-next:
>   Signed-off-by missing for commit in the drivers-x86 tree, linux-next mailing
>   list, 2 August 2017 (https://www.spinics.net/lists/kernel/msg2571584.html).

Yes, of course

> * Backmerging (merging a later rc into a maintainer tree) to pull in rc fixes
>   from other maintainers is considered inacceptable too. If patches from other
>   maintainers are really needed I think it is acceptable to merge a maintainer
>   tree into Linus' tree and to apply late rc patches on top of that merged
>   tree.

Yes, this gets tricky if two trees have to coordinate..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
