From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: CQ and RDMA READ/WRITE APIs
Date: Tue, 17 May 2016 07:38:52 +0200
Message-ID: <20160517053852.GA25133@lst.de>
References: <743399f9-10b7-6e62-2bf4-6a8656df8a55@redhat.com> <20160516114926.GA681@lst.de> <f6fdfc59-8193-18ed-0449-a16bba4601e0@redhat.com> <CA+55aFzq+4DJL46B8PXQQG-DpNpzZNzk=O6j+8U_NC6H6BwTdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFzq+4DJL46B8PXQQG-DpNpzZNzk=O6j+8U_NC6H6BwTdQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

we're not talking about a driver here - we're talking about a new API
lifted from a driver to generic code because it's commonly useful.

It's also in entirely new files and not a modification of existing code,
and it's always been clear how it is.  Some of the code has been in
since Linux 4.5 with a properly clear copyright.

I really don't understand Doug's objection, and as said if they have
a weird problem with it we can simply move it to a separate module.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
