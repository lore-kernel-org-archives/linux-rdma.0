From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] An argument for allowing applications to manually send
 RMPP packets if desired
Date: Mon, 12 Sep 2011 11:29:20 -0700
Message-ID: <CAL1RGDVPZzMKmMg7mokhG0btX+3NH_+tL-9P5guV10h6X6i0iw@mail.gmail.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB4A5387E899@MNEXMB1.qlogic.org>
 <CAL1RGDUXM9-Ey1aF8xQo3X_L1PLrVyyLPYvqmy6Qeu5M2JnJPA@mail.gmail.com> <20110912172334.GC18574@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110912172334.GC18574-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 12, 2011 at 10:23 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> It seems at least the SM side could be handled using writev() to
>> splice together the data it wants to send.

> How does that help avoid the kernel memory allocations?

It doesn't, I was only responding to the idea that the SM has to
rebuild the table for every query.  That issue seems independent
of where we do RMPP.

 > I think having the option for RMPP in user space is a good idea, it
 > allows much more efficiency on the SM side..

Maybe... but I'd like to explore if there's some way to avoid
the copying without having to do the full protocol in userspace.

Couldn't the kernel just copy data as needed, and say that
userspace needs to keep the buffer stable until the send
completes?  (With an opt-in from userspace maybe?)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
