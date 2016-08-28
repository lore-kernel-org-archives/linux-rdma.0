From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Sun, 28 Aug 2016 12:36:27 -0600
Message-ID: <20160828183627.GC12783@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
 <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <20160825173916.GC20612@obsidianresearch.com>
 <20160825195246.GI1916@redhat.com>
 <20160825201306.GA5421@obsidianresearch.com>
 <8ef70f6c-e26d-191d-9a9a-2e0bf47fb227@redhat.com>
 <20160828132804.GN594@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160828132804.GN594-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 28, 2016 at 04:28:04PM +0300, Leon Romanovsky wrote:
> On Fri, Aug 26, 2016 at 11:17:52PM -0400, Doug Ledford wrote:
> > On 8/25/2016 4:13 PM, Jason Gunthorpe wrote:
> > > We've never been able to run the rdma stack from the build trees,
> >
> > It's possible...you just have to do every step in the right order ;-)  I
> > had a spreadsheet that I tracked packages, versions, build states,
> > install states, and dependencies.  Made things a lot easier.
> >
> > But I get your point.
> >
> 
> Sorry, but I missed your point. On my development machine, I'm
> running all relevant RDMA stack directly from their git trees
> without any excel file. It worked flawlessly without any
> obstacles, did I do anything wrong?

Maybe, because it is fairly hard to do correctly.

How do you make sure that eg librdmacm or a provider is built against
the git checkout of verbs, headers, shlib and all?

How do you rebuild the right trees if a change is made to verbs?

How do you have verbs load the provider driver from the git directory build?

When I said 'from the build trees' I mean without a 'make install',
just run 'build/bin/ibvdev_info' for instance and it guarenteed uses
the build products exclusively, including all the libraries and
providers.

Or set LD_LIBRARY_PATH=`pwd`/build/lib and have everything
use the new build.

This is the goal, and the consolidated repo can do everything except
the providers right now.

Doug is also adressing a larger issue with packaging and getting
everything to build correctly as the distro - he talked about it here:

https://www.spinics.net/lists/linux-rdma/msg37855.html

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
