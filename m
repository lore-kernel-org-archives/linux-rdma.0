From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] staging: rdma: Fix braces around if/else
Date: Sun, 4 Oct 2015 08:20:09 +0100
Message-ID: <20151004072009.GA8336@kroah.com>
References: <1b3a2e933e163bf11a2163c76bedd074551c1b9a.1443901389.git.mkletzan@redhat.com>
 <5610CB98.1090907@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5610CB98.1090907-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Martin Kletzander <mkletzan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 04, 2015 at 09:47:52AM +0300, Or Gerlitz wrote:
> On 10/3/2015 11:55 PM, Martin Kletzander wrote:
> >Get rid of all ELSE_AFTER_BRACE type errors reported by checkpatch.pl.
> 
> Hi Greg,
> 
> Is there a way to signal people/tools that a certain driver parks in staging
> on their way **out** of the kernel
> and not the other way around? I guess you (nor Doug) don't want to spend
> time on fixing such drivers, right?

I'm not spending the time :)

But no, there isn't a way to really show that that I know of, and it's
fine, we end up getting a number of "cleanup" patches for a kernel
release or two before the drivers get deleted.  It gets people involved
in kernel development which is the key thing here, it's not like they
are actually using these drivers...

So it's fine, I take the patches, the people writing the patches are
happy, and the code gets a bit nicer and feels better about itself
before we kick it out the door.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
