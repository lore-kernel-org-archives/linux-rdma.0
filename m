From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] Improved node descriptions
Date: Tue, 22 Feb 2011 15:13:47 -0800
Message-ID: <AANLkTi=1rmRckZz1iAXLpakf5bMuBp4koGOyO-FUDz_M@mail.gmail.com>
References: <20110217213017.25708.95042.stgit@homer> <AANLkTim5MrHMVjaNFtHeWBy82dag4XNxdBcjBEW+d1yb@mail.gmail.com>
 <20110219192458.GB4506@obsidianresearch.com> <4C2744E8AD2982428C5BFE523DF8CDCB4A20B28B17@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB4A20B28B17-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 21, 2011 at 11:26 AM, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:
> The biggest problem with that is that patching existing boot scripts
> is always going to vary from distro to distro and is always going to
> have problems when dealing with files that were already edited for
> site-specific reasons.

This is the wrong way to look at it.  Really it would make sense in
the long term to add required support to native distros -- piling hack
on hack in OFED is clearly a long-term disaster.  So I don't think
saying "it's hard to make a single RPM" is a very good argument.

With that said I think we should look at where it makes sense to
implement this sort of thing.  Just because we can do something with
scripts in userspace doesn't necessarily mean we have to do it there
-- if it's much simpler or more robust in the kernel, then we can
implement it there.

In this case I do think it makes sense to add this support to the
kernel, since the kernel handling is so simple.  In fact based on
Jack's question it might make sense to go further and have more
flexible expansion... what if we do something like adding primitive
format expansion, ie

    %h --> expands to current hostname
    %d --> expands to ib_device->name

Then one could have a trivial script that just does 'for every IB
device, prepend "%h/%d: " to the node description.'  And I guess we
could even talk about making that the default kernel policy.

Not sure what Jason or others thinks about this opinion...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
