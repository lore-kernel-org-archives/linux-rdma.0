From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: rdma-core, cmake/ninja question
Date: Thu, 22 Sep 2016 11:21:53 -0500
Message-ID: <014501d214ed$6e4472f0$4acd58d0$@opengridcomputing.com>
References: <00cc01d214e6$e4cb2d80$ae618880$@opengridcomputing.com> <20160922154814.GB15212@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160922154814.GB15212-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> I recommend *against* running 'make install' to /usr. This is a big
> package now, it is hard to unwind it once it installs over your
> system. I really should finish the run in place patch :|
> 
> If you do this:
> 
> $ echo /usr/local/lib64/ > /etc/ld.so.conf.d/usrlocal.conf && ldconfig
> 
> Then you can install to /usr/local/ and things will work as you
> expect. Note, this depends on a verbs patch that is still only in my
> preview tree.

So I have a dev system setup with everything installed from the distro in /usr.
I have my rdma-core git tree.  I change libcxgb4 to fix a bug.  I want to test
it.  I install it to /usr/local and add /etc/ld.so.conf.d/usrlocal.conf.  But
that still doesn't work because ldconfig still finds libcxgb4 in /usr/lib64
first...

How can I force ldconfig to look in /usr/local/lib64 first?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
