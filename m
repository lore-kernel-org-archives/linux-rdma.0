From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 00/50] Add OPA gen1 driver
Date: Fri, 31 Jul 2015 00:34:20 -0700
Message-ID: <20150731073420.GB2485@infradead.org>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <CAJ3xEMha-BKEkTRq5qUE8tt5MOpohRvrjY7_wW2u-ApayZZFpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMha-BKEkTRq5qUE8tt5MOpohRvrjY7_wW2u-ApayZZFpQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 31, 2015 at 02:05:06AM +0300, Or Gerlitz wrote:
> So... enough is enough, please put it in a kernel module residing in
> the IB core and use it in this driver, to begin with. The fact that
> ipath is going to go, makes the cope duplication "only" 2X vs the 3X,
> but it's still 2X

Agreed.  Any if anyone tries to submit software RoCE again it'll be
another duplication.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
