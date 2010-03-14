From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Software iWARP stack
Date: Sun, 14 Mar 2010 11:34:30 -0700
Message-ID: <adaiq8yah1l.fsf@roland-alpha.cisco.com>
References: <OF64DD5621.D563EA15-ONC12576E6.00510BE1-C12576E6.005B5E57@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF64DD5621.D563EA15-ONC12576E6.00510BE1-C12576E6.005B5E57-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>
	(Bernard Metzler's message of "Sun, 14 Mar 2010 17:37:59 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > We at IBM Zurich Laboratory are developing a full-software
 > iWARP stack to run within the OpenFabrics verbs framework.
 > Today we open sourced that work to be available at
 > http://gitorious.org/softiwarp. It consists of a kernel
 > module (siw) and a user level library (libsiw).

Great, congratulations on finally releasing this.

I will take a look at this, and I hope we can move this towards the
mainline kernel.  With the current backlog of things to review/merge,
unfortunately I don't think 2.6.35 is realistic; so let's set a goal of
getting this into 2.6.36.

One thing you could do that would make this a little easier to test and
review would be to have the kernel driver tree be based on the main
kernel -- ie a git tree based on Linus's kernel tree with exactly the
patches required to add softiwarp support committed.  It may seem crazy
to carry the full kernel tree with your relatively small amount of code,
but git makes this really cheap (I can clone your tree with "--reference
<my-main-kernel-tree>" and only get one copy of all the objects in
common), and it makes it much easier to build and test.

Also I would suggest posting your announcement to netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
too, to get review comments from the networking guys.  If you can split
your code up into a digestible series of patches for review by email,
that would help too (post to both netdev@ and linux-rmda@).  Having the
git tree is useful for following development, testing, building etc, and
having the patches by email is useful for reading and reviewing the
code -- it makes sending comments back much easier.

 - Roland
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
