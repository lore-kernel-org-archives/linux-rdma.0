From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Mon, 22 Aug 2016 15:43:52 -0600
Message-ID: <20160822214352.GB11695@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 22, 2016 at 03:06:13PM -0500, Steve Wise wrote:

> Hey Jason, following your RHEL6 instructions from README.md, I was able to build
> everything fine.  I'm amazed at how fast it builds...

Yes, it really is a better developer experience, and you probably
didn't notice that ninja automatically does stuff like 'make -O' (and
it actually fully works) and tracks changes to the build commands
(like kbuild).. For those reading my system can go from a clean git
checkout to a full build of all 15 libraries in 3.5s.

The install is done in the usual way:

(make or ninja) install

DESTDIR environment var works as usual for packagers.

That does exactly the same as 'make install' did for auto*, which is,
IMHO, somewhat useless since it goes into /usr/local.

The full install to / is still a small TODO, it is part and parcel
with doing the packaging, in my mind.

But the basic starting point is:

cmake .. -DCMAKE_SKIP_RPATH=ON  -DCMAKE_INSTALL_PREFIX=/usr

But a bit more work is needed to make SYSCONFDIR work right..

I also want to make a patch to 'run in place' (eg with
LD_LIBRARY_PATH), which makes sense now that the providers build
along-side libverbs.

It isn't too hard but lets get agreement on this direction at all
first...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
