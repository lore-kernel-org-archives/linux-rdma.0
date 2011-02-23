From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 0/2] Improved node descriptions
Date: Wed, 23 Feb 2011 15:02:31 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A20B28D7C@MNEXMB1.qlogic.org>
References: <20110217213017.25708.95042.stgit@homer>
 <AANLkTim5MrHMVjaNFtHeWBy82dag4XNxdBcjBEW+d1yb@mail.gmail.com>
 <20110219192458.GB4506@obsidianresearch.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB4A20B28B17@MNEXMB1.qlogic.org>
 <AANLkTi=1rmRckZz1iAXLpakf5bMuBp4koGOyO-FUDz_M@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=1rmRckZz1iAXLpakf5bMuBp4koGOyO-FUDz_M-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I had actually submitted a patch back in June of last year that did set the default policy to be the hostname & device but looking back through my records I can't find the reason it was never explicitly rejected - it got limited feedback and just wasn't ever added to Linux-rdma. (I'm not sure how to learn the final disposition of proposed patches.) Maybe it was a coding style or formatting issue?

Right now the HCAs default to a description of the HCA model. I can certainly create a patch that sets the default descriptions to "%h: %d (device description)" if that's what you want.  We certainly need something that's widely applicable, not distribution specific and lets large clusters manage their nodes effectively.

-----Original Message-----
From: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org [mailto:roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org] On Behalf Of Roland Dreier
Sent: Tuesday, February 22, 2011 6:14 PM
To: Mike Heinz
Cc: Jason Gunthorpe; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH 0/2] Improved node descriptions

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


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
