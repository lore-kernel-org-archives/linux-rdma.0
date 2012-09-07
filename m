From: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: SoftiWARP: new patchset
Date: Fri, 7 Sep 2012 20:28:03 +0200
Message-ID: <OF10496475.0AF0DFFE-ONC1257A70.0054C570-C1257A72.006574E4@ch.ibm.com>
References: <OFC1BE1396.C1ACB810-ONC12578D5.00644648-C12578D5.00670E1B@ch.ibm.com> <50472368.2060804@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50472368.2060804-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Stefan,

thanks for asking. I kind of went astray from further pushing
siw for mainline integration. That time I did all the suggested
changes, and some more work went into it. I updated
gitorious.org/softiwarp accordingly, but did not send again
to the list. It might be a good idea to start another attempt.

I also saw SoftRoCE aiming for mainline integration. Don't know
exactly their status, I guess it's about the same.

We are happily using siw, I have it at
gitorious.org/softiwarp, where I maintain it - loosely.
I agree that a software based RDMA stack can be very useful.
That's why I did that work.

Many Thanks,
Bernard.


linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org wrote on 09/05/2012 12:03:20 PM:

> From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
> Date: 09/05/2012 12:07 PM
> Subject: Re: SoftiWARP: new patchset
> Sent by: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>
> Hi Bernard,
>
> > many thanks for commenting on the software iWARP RDMA
> > driver code is sent about 5 weeks ago. I hope I now
> > incorporated all recent suggestions and fixes.
> >
> > These are the main changes:
> >
> > o changing siw device attachment to be dynamic based on
> >   netlink events
> > o enabling inline data for kernel clients
> >   (now inline data are stored within wqe structure)
> > o bitmask access to packet headers removing the
> >   '#if defined(__LITTLE_ENDIAN_BITFIELD)' style
> > o moving debug stuff to debugfs
> > o shrinking the stack size of the core tx
> >   function
> > o updates to documentation
> >
> >
> > Due to the number of lines of code changed, it might be
> > appropriate if I send a complete new patchset. I'll
> > keep patch packaging as before.
> >
> > I made the current siw code available at
> > www.gitorious.org/softiwarp
> > and will keep it up-to-date. This code is now free
> > of kernel version dependencies. It has been tested
> > on different kernel versions from version 2.6.36.2
> > up to 3.0.0-rc1+. I tested on both big an little
> > endian machines.
> >
> > I would be very happy to get further input. I work on
> > this project only part of my time - all your input speeds
> > up code maturing. I would be happy if the code reaches an
> > acceptable status soon. Thank you.
>
> I'm wondering what the status of this patchset is?
>
> Do you get any feedback?
>
> It would be very good if the softiwarp module could be
> included in the mainline kernel.
>
> Hopefully Samba will get support for SMB-Direct (SMB2 over RDMA) support
> in future. And having RDMA support without hardware support would be very
> good for testing and also for usage on the client side against a server
> which has hardware RDMA support.
>
> For me at least rping tests work fine using siw.ko on a 3.2.x kernel on
> Ubuntu 12.04.
>
> metze
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
