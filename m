From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 0/2] Improved node descriptions
Date: Fri, 18 Feb 2011 08:09:53 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A207DDEAB@MNEXMB1.qlogic.org>
References: <20110217213017.25708.95042.stgit@homer>,<AANLkTim5MrHMVjaNFtHeWBy82dag4XNxdBcjBEW+d1yb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim5MrHMVjaNFtHeWBy82dag4XNxdBcjBEW+d1yb-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland,

Thanks for the positive feedback - I'll make the changes ASAP. Sorry about the subject lines, I thought I was doing the "right thing" by making them match.

The change is not in OFED yet, but QLogic has been using it in our own release for a while and works extremely well on large fabrics.
________________________________________
From: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org [roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org] On Behalf Of Roland Dreier [roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
Sent: Thursday, February 17, 2011 6:20 PM
To: Mike Heinz
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH 0/2] Improved node descriptions

On Thu, Feb 17, 2011 at 1:30 PM, Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:
> This patch addresses the problem by providing a function to build the node
> description. If the provided source string for the description contains an
> '@' character, the function will substitute the current utsname.
>
> This ensures that even after a fabric has been completely initialized, if
> a node's hostname changes, that change will be reflected in the next sweep
> of the SM, but also maintains compatibility with existing code since the
> behavior is unchanged if the description string does not contain an '@'
> character.

This looks like a reasonable approach to me, although of course the SM
has no way of knowing it should update a port's node description if a
hostname changes.

Aside from some minor quibbles
 - next time please use different subjects for each patch in the thread
 - the prototype of ib_build_node_desc() seems to force every call
   site to have a cast; maybe the function should take a pointer to
   struct ib_smp instead?
 - the internals of ib_build_node_desc() look a bit ugly, is there any
   way to make it a little cleaner?
I do like this.  Does anyone have any feelings about applying this
for 2.6.39?  Is this shipping in OFED?

 - R.


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
