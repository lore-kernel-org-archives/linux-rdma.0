From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IPoIB: fix faulty list maintenance in path and neigh list
Date: Thu, 17 Feb 2011 15:23:45 -0800
Message-ID: <AANLkTinyUjhZE_-n8zPJyGLVobaoFVnQ=iC1QMusQH+y@mail.gmail.com>
References: <20110201161247.12671.10028.stgit@kop-dev-sles11-04.qlogic.org>
 <AANLkTin1pudSXZCGY31p2GnY6noWi2DS3y2+Gprj0+ug@mail.gmail.com>
 <4D5C70F6.3050604@linux.vnet.ibm.com> <AANLkTim-BnQ9tM68eGsCoOVYDRonmEOO6JN+EFT2zdff@mail.gmail.com>
 <4D5D7C95.5010408@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D5D7C95.5010408-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gary.leshner-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, tom.elken-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Yes, that is the crux of the issue. I had missed that ipoib_mcast_free() is
> only called on remove_list.

So do we have any idea of what this patch is fixing?  Any thoughts from
the qlogic people involved in this patch?

> While we are discussing IPoIB issues, how about the two other issues that
> I illustrated previously. One was Ralph Campbell's patch for fixes to
> ipoib_cm_start_rx_drain() and my questions wrt ipoib_neigh_cleanup()?

I do need to take a good look at Ralph's patches to try and understand them
and I hope apply them.  Not sure I still have any link to your questions though.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
