From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 00/50] Add OPA gen1 driver
Date: Mon, 3 Aug 2015 08:29:58 -0700
Message-ID: <20150803152958.GB4171@infradead.org>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <CAJ3xEMha-BKEkTRq5qUE8tt5MOpohRvrjY7_wW2u-ApayZZFpQ@mail.gmail.com>
 <20150731073420.GB2485@infradead.org>
 <55BD2D57.8030107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55BD2D57.8030107-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Aug 01, 2015 at 04:34:31PM -0400, Doug Ledford wrote:
> Or, I haven't looked at the soft-roce driver (ever).  Is it going to
> need this library as well?

ROCE implements the IB protocol, so a software ROCE driver will need
a IB protocol implementation sitting ontop of ethernet frames (v1)
or the internet protocol stack (v2).

> If it is, then as you have rung the bell for
> getting this library written, I will expect Mellanox to work with Intel
> to make sure that this library is suitable for not just their hardware
> drivers but also the soft-roce driver you guys are working on.  I might
> even suggest that it's time to work up the soft-roce submission sooner
> rather than later in light of what I've done with the hfi1 driver.

I think burdering this on Intel is a bit unfair.  If they can come
up with a library that jsut fits their use case without being bad in
other ways the burden to adopt it to ROCE should fall on whoever wants
to submit that code.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
