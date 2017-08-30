From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [Pv-drivers] [PATCH v1 for-rc] RDMA/vmw_pvrdma: Report CQ
 missed events
Date: Wed, 30 Aug 2017 11:31:06 -0400
Message-ID: <20170830112816.4e2214c8@vypre.local.home>
References: <1502391902-5674-1-git-send-email-aditr@vmware.com>
 <20170810200256.GA4913@yuvallap>
 <306A2D1C-3070-4BFA-B532-D5020F5D185A@vmware.com>
 <20170810210103.GA9201@yuvallap>
 <B2047B7A-49AA-4899-86F9-E80039033662@vmware.com>
 <20170810213326.GA2343@yuvallap>
 <1502895592.33760.8.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1502895592.33760.8.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 16 Aug 2017 10:59:52 -0400
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> (because I know that's exactly what Linus will ask when he sees it).

  https://lwn.net/Articles/13183/

Never ever use BUG_ON(), unless you are ready to really defend it. And
be prepared to be yelled at by Linus. Just use WARN_ON() and exit the
routine nicely.

-- Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
