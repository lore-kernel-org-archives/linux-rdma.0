From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 0/2] Improved node descriptions
Date: Sat, 19 Feb 2011 09:23:12 +0200
Message-ID: <201102190923.12641.jackm@dev.mellanox.co.il>
References: <20110217213017.25708.95042.stgit@homer> <AANLkTim5MrHMVjaNFtHeWBy82dag4XNxdBcjBEW+d1yb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim5MrHMVjaNFtHeWBy82dag4XNxdBcjBEW+d1yb-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Friday 18 February 2011 01:20, Roland Dreier wrote:
> This looks like a reasonable approach to me, although of course the SM
> has no way of knowing it should update a port's node description if a
> hostname changes.
> 
What about the problem of multiple HCA's of the same type on a single host?
Won't all of them get the identical node description?
Mike, can you add something to handle this case?

(See my original feedback:
http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg04413.html
and see Mike's response:
http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg04414.html

Mike, I agree that doing something for the upstream is better than doing
nothing, but I would still like to see the multiple-HCA case handled. I think
this can be done by adding a query to the low-level driver to distinguish between
HCAs).

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
