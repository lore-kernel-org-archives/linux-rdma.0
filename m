From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: InfiniBand-ocrdma: Delete unnecessary variable initialisations
 in 11 functions
Date: Fri, 15 Jan 2016 17:59:38 +0200
Message-ID: <20160115155938.GB32346@leon.nu>
References: <566ABCD9.1060404@users.sourceforge.net>
 <567EDED5.4040201@users.sourceforge.net>
 <5697D865.5010507@users.sourceforge.net>
 <5697DE31.9040309@users.sourceforge.net>
 <20160115132014.GC30615@leon.nu>
 <56990733.7000506@users.sourceforge.net>
 <20160115150935.GA32346@leon.nu>
 <56990FAC.6000506@users.sourceforge.net>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56990FAC.6000506-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 15, 2016 at 04:26:36PM +0100, SF Markus Elfring wrote:
> >> Would you like to clarify any measurable effects around the implementation
> >> detail when various variables will only be initialised immediately
> >> before they will be read again?
> > 
> > Compiler will drop this variable initialization by itself because
> > there are no reads between this variable initialization and write.
> 
> Which compiler variants would you to take into account for such an use case?

GCC supported it before 1999 when I saw it first time. My assumption
that in 2016 all compilers are doing such optimization now.
I would be glad to hear an example of modern compiler which doesn't
support this simple optimization.

> 
> 
> > I recommend you to take a look on the assembly code and ensure it
> > by yourself.
> 
> Will any configuration parameters and command arguments become relevant
> to improve also a corresponding software comparison?

Please suggest us, you are proposing this change, and not me.

> 
> 
> > The proposed change won't affect performance at all.
> 
> Will unneeded variable assignments be really optimised away by default?

Yes

> 
> 
> By the way:
> Will a small source code reduction matter also a bit here?

If you are interested in saving space of one latter, you need to take into
account git database increase, do you?

> 
> Regards,
> Markus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
