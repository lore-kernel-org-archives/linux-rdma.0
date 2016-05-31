From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V4 libibverbs 2/7] Add member functions to poll an
 extended CQ
Date: Tue, 31 May 2016 12:06:08 -0600
Message-ID: <20160531180608.GA21834@obsidianresearch.com>
References: <1464533475-18949-1-git-send-email-yishaih@mellanox.com>
 <1464533475-18949-3-git-send-email-yishaih@mellanox.com>
 <574B6F71.9060808@redhat.com>
 <20160529233009.GA12420@obsidianresearch.com>
 <8F7BC9E2-75EC-413B-BEBE-11450225AF06@redhat.com>
 <20160530013507.GA19230@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05CA6D@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB05CA6D-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 31, 2016 at 05:46:38PM +0000, Hefty, Sean wrote:

> These are more thoughts than questions: If an app wants to support
> iWarp/RoCE/OPA, is it just going to have a branch around the calls
> anyway?

This doesn't really change one way or the other, apps have to
understand what attributes are available on the CQ and do whatever
branching is needed to access them.

It is a good question if we should have different accessors, like
get_src_addr(buf,sizeof(buf)) or something that can handle the other
protocols with less hassle.

But at the end of the day, the user will still have to cast the buf to
the right type...

> What data is actually needed by the apps?

The apps decide when they create the CQ what things the CQ is needed
to return. So apps are in control. Are you musing if some of these are
needed or not?

Oh, that reminds me: Yishai, please purge pkey_index from the new
API. It was a mistake in the old API, the standard says it is only
valid for QP1, and we don't support QP1 in user space. Any app that
uses pkey_index is broken. It was a mistake to ever expose this to
userspace.

> Is there any relationship between the various calls?  For example,
> if an app calls read_slid, is it more likely than not to also call
> read_pkey_index and read_dlid_path_bits, etc.?
> Is the app expected to retrieve addressing data piecemeal like this
> for every possible architecture?  Are 5 function calls better than
> one call that fills out a structure, when all fields are needed?

There are certainly logical groups, eg the various path parameters are
almost always going to be needed together.

I was asking this same question.. I think the response was that
memcpying into a stack struct was more expensive than the branches..

I'm skeptical of that, but maybe if the C ABI doesn't use return value
optimization like C++ does it could get a bit costly....

Even so, it seems like an easier API for the end user...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
