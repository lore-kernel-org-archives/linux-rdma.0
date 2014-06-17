From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] infiniband: Fixes memory leak in send_flowc
Date: Tue, 17 Jun 2014 08:53:01 -0500
Message-ID: <002201cf8a33$740fc730$5c2f5590$@opengridcomputing.com>
References: <1402940957-6381-1-git-send-email-xerofoify@gmail.com> <539F34E8.3000501@opengridcomputing.com> <alpine.DEB.2.02.1406161638360.21018@chino.kir.corp.google.com> <CAPDOMVg8hT95Wcmy4VHdfsumEvc=w3dz8V8xP1QScsLK3buSxw@mail.gmail.com> <alpine.DEB.2.02.1406161707230.21018@chino.kir.corp.google.com> <CAPDOMVjjwywH36guWC2q-Y26m-DEoHHJtk5Vasvk2kfsDpCuiA@mail.gmail.com> <alpine.DEB.2.02.1406161735490.21018@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1406161735490.21018-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'David Rientjes' <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, 'Nick Krause' <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On
> Behalf Of David Rientjes
> Sent: Monday, June 16, 2014 7:37 PM
> To: Nick Krause
> Cc: Steve Wise; swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org;
> hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] infiniband: Fixes memory leak in send_flowc
> 
> On Mon, 16 Jun 2014, Nick Krause wrote:
> 
> > That's true David,
> > I will resend this parch without the use of the pr_warn.
> 
> There's no patch to resend if you don't use pr_warn().  kfree_skb(skb) is
> unnecessary if !skb, look at the first thing it checks:
> 
> void kfree_skb(struct sk_buff *skb)
> {
>         if (unlikely(!skb))
>                 return;
> 	...
> }
> 
> Thus, I don't see the memory leak you're referring to.

send_flowc() still needs to handle a NULL return from get_skb().  That is what the bug
report is addressing...

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
