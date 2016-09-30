From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/9] Remove HAVE_VALGRIND_MEMCHECK_H/INCLUDE_VALGRIND
Date: Thu, 29 Sep 2016 18:15:07 -0600
Message-ID: <20160930001507.GB7570@obsidianresearch.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1475182076-5411-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <aef5ce41-14bf-9869-88c8-ab5796634a8c@acm.org>
 <20160929223415.GD27229@obsidianresearch.com>
 <610a3086-07bd-baa7-11e2-88642c0e2297@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <610a3086-07bd-baa7-11e2-88642c0e2297-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 29, 2016 at 04:48:25PM -0700, Bart Van Assche wrote:

> That would allow to annotate rdma-core code correctly for Valgrind without
> introducing a dependency on the valgrind-devel package.

Sure, but we are recommending distros build their official packages
with valgrind, the sample packaging I built includes valgrind as a
dependency, the README.md instructs to install valgrind, and cmake
warns if valgrind is not present.

I would never encourage a distro to build official packages using a
built-in valgrind header, that is a great way to accidently break a
new or obscure architecture.

> As you know most Linux distro's by default do not install the
> valgrind-devel package.

Are you worried about users? Like I said, we could make valgrind hard
required. It is not hard to install valgrind, and everyone already
needs to install other non-default things like libnl3-devel and cmake.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
