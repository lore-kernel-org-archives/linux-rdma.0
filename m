From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 FIX for-3.19] IB/ipoib: Fix sendonly traffic and
 multicast traffic
Date: Thu, 29 Jan 2015 13:29:47 -0700
Message-ID: <20150129202947.GA20641@obsidianresearch.com>
References: <1422277227-1086-1-git-send-email-erezsh@mellanox.com>
 <CAJ3xEMjERaEP5d_ZT8RN5+w8Z_Hig4T7dhuq3o+1NOUuQgfJLw@mail.gmail.com>
 <1422301106.2854.41.camel@redhat.com>
 <CAJ3xEMg3vYGbGuT+Z-XQMv5YuPws33XHQP_Wcz8gvpBbCg3TSw@mail.gmail.com>
 <1422309605.2854.62.camel@redhat.com>
 <54C74D49.3080201@dev.mellanox.co.il>
 <1422378130.2854.119.camel@redhat.com>
 <54CA2CE0.30107@mellanox.com>
 <1422545677.2854.260.camel@redhat.com>
 <CAL1RGDV30SRUv0oxZCQW0e+tziO0g+iDha8DSWeM56PiWtnRwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDV30SRUv0oxZCQW0e+tziO0g+iDha8DSWeM56PiWtnRwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 29, 2015 at 11:23:22AM -0800, Roland Dreier wrote:
> On Thu, Jan 29, 2015 at 7:34 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > > So lets close the 3.19 saga, again, either revert your eight patches
> >
> > I would support that option.
> 
> I think at this point we have to do the revert, and get it right for
> 3.20.  There's just too much noise floating around and I can't tell
> whether all the regressions are dealt with or not, and we're running
> out of time.
> 
> I will ask Linus to pull in the reverts, and then let's try to agree
> on a patch set for 3.20 ASAP.

This discussion with Yann is around this patch, perhaps it should be
reverted till 3.20 as well?

5a77abf9a97a7ecc8fb0f6bf4ad411fb12b02f31 

IB/core: Add support for extended query device caps

Add extensible query device capabilities verb to allow adding new
features.  ib_uverbs_ex_query_device is added and
copy_query_dev_fields is used to copy capability fields to be used by
both ib_uverbs_query_device and ib_uverbs_ex_query_device.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
