From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Versioning scheme for rdma-plumbing
Date: Tue, 13 Sep 2016 22:47:45 -0600
Message-ID: <20160914044745.GB7975@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi all,

Here are my thoughts on how to version this thing. I've completed the
proposed Debian packaging to the point of being lintian clean and now
have a reasonable idea what their sensitivies are.

I've written a small file discussing the issue here:

https://github.com/jgunthorpe/rdma-plumbing/blob/master/Documentation/versioning.md

The gist is, I recommend using a single increasing integer for the
overall tree. I think udev popularized this scheme for stable plumbing.

The shlibs files will become sensibly labeled using a semantic style
soname.abi.release scheme. Eg the next release of libibverbs (assuming
no ABI change) would be 'libibverbs.so.1.2.11', (with the usual link
from 'libibverbs.so.1').

This conveys actual information now, '1.2' indicates that @IBVERBS_1.2
and better symbols are present, and '11' indicates it is release 11 of
the overall tree.

These file names serve no functional purpose (we have used
libibverbs.so.1.0.0 forever), so this is all bikeshedding - but
distros that package the libraries seperately (eg debian) should have
sensible versions for them, and this is a forumula to get there.

We will start applying symbol versions and ABI versioning sanely, so
if new ABI symbols are added they will be correctly tagged eg
@IBVERBS_1.3 and the libibverbs version will change to '1.3.11' and so
on. This will make RPM work properly.

umad has released 1.3.10.1, so I'm suggesting sarting at '11'. There
is no particularly strong reason for that. (since libibumad3's package
version will change to 3.1.XX anyhow)

As debian uses a split package it will then use the above scheme for
shared libary package versions:

 libibverbs1 1.2.11-1
 libibumad3 3.1.11-1
 librdmacm1 1.1.11-1

And use the overall release number for other things:

 ibverbs-utils 11-1

This is all largely automated.

The providers are versioned with the top level, there is no longer an
place to put a provider specific version, nor do I think it is desired
for the same reason we don't like it in the kernel..

I thought about using the kernel version, but we are not so strongly
linked to the kernel to make that really useful, and it makes the
names longer..

Thoughts?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
