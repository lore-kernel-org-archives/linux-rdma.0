From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] An argument for allowing applications to manually send
 RMPP packets if desired
Date: Fri, 16 Sep 2011 21:42:51 -0600
Message-ID: <20110917034251.GA6056@obsidianresearch.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB4A5387E899@MNEXMB1.qlogic.org>
 <CAL1RGDUXM9-Ey1aF8xQo3X_L1PLrVyyLPYvqmy6Qeu5M2JnJPA@mail.gmail.com>
 <20110912172334.GC18574@obsidianresearch.com>
 <CAL1RGDVPZzMKmMg7mokhG0btX+3NH_+tL-9P5guV10h6X6i0iw@mail.gmail.com>
 <20110912190623.GD18574@obsidianresearch.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB4A5387ECDF@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB4A5387ECDF-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 16, 2011 at 01:28:16PM -0500, Mike Heinz wrote:

> The patch at hand avoids all that complexity by simply allowing the SM
> application handle RMPP itself in whatever manner is considered best. If
> the SM wants to use the current RMPP implementation it can, turning this
> ability on is completely optional.

I agree, this is a good idea. Allowing the SM to control the RMPP
entirely, and amortize the content generation across the entire query
is a very good way to manage many of the issues with a RMPP heavy work
load.

Ultimately I think the scalable/compatible answer is to move these
RMPP work loads to a verbs QP and we need to have a user space RMPP
implementation for that anyhow.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
