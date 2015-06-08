From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 0/5] Indirect memory registration feature
Date: Mon, 8 Jun 2015 06:51:51 -0700
Message-ID: <20150608135151.GA14021@infradead.org>
References: <1433769339-949-1-git-send-email-sagig@mellanox.com>
 <20150608132254.GA14773@infradead.org>
 <55759B0B.8050805@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55759B0B.8050805-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 08, 2015 at 04:39:23PM +0300, Sagi Grimberg wrote:
> I have learned about QUEUE_FLAG_SG_GAPS from your recent comments on
> the list. Won't setting this flag interfere with bio merges?

It would if any in-kernel consumer would actually generate such SG
lists.  But none does - the only source is vectored SG_IO support.

> Ideally
> I wouldn't want to restrict merges if my device supports this feature.
> 
> >Right now drivers tat set these would always fail SG_IO ioctls using
> >iovecs, but that can be fixed much more easily by doing high level
> >bounce buffering compared to these horrible workarounds deep down in the
> >stack.
> >
> 
> My tests have shown significant cpu savings with this against SW bounce
> buffering, especially for large transfers. I've seen applications that
> a significant part of their IO workload consists of this type of memory
> layout.
> 
> I must say that I've always considered SW bounce buffering as a
> work-around for an RDMA driver.

bounce buffering is always a workaround, and offloading it to silicone
just makes it a worse hack.  So please fix it in the proper layers
first, and if you really care about the vectored SG_IO case use
your indirect registrations just for that.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
