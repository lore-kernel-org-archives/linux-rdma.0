From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: RDMA/CM and multiple QPs
Date: Thu, 10 Sep 2015 06:29:27 -0700
Message-ID: <20150910132927.GA6440@infradead.org>
References: <20150906064550.GA30683@infradead.org>
 <55EED54B.7090608@dev.mellanox.co.il>
 <20150908131407.GB5316@infradead.org>
 <55F15269.2060200@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55F15269.2060200-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 10, 2015 at 12:50:33PM +0300, Sagi Grimberg wrote:
> >What I'm more interested in is a way to tell the CM that I only
> >want routes that are using this ib_device that I got from the first
> >lookup as all others are useless for me.
> >
> 
> I'm not sure I understand what you are aiming for? if you connect to
> a single address multiple times you will get the same device because
> it is the same route right?

In testing I do get the same all the time, but I don't see anything that
gurantees that in code or documentation.

Think about the case where the routing changes between the calls, or
we're using multipath TCP for example.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
