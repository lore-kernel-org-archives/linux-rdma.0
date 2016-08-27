From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Fri, 26 Aug 2016 23:21:38 -0600
Message-ID: <20160827052138.GB23049@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
 <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <20160825173916.GC20612@obsidianresearch.com>
 <20160825195246.GI1916@redhat.com>
 <20160825201306.GA5421@obsidianresearch.com>
 <8ef70f6c-e26d-191d-9a9a-2e0bf47fb227@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8ef70f6c-e26d-191d-9a9a-2e0bf47fb227-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 26, 2016 at 11:17:52PM -0400, Doug Ledford wrote:
> > rpmbuild does stuff that needs to be checked out and validated by
> > upstream at least occasionally, or packaging becomes too hard for the
> > downstream because of broken build infra.
> 
> Given that rpmbuild is basically nothing more than a scripted build
> session, as long as the make/cmake system works well, so will
> rpmbuild.

Well, the thing that cases pain is the %configure and %cmake macros
that rpmbuild provides, and sorting out all the various distro-specific
install paths.

eg I ran into this bug with %cmake while testing 
(see https://bugzilla.redhat.com/show_bug.cgi?id=1301720)
and had to deal with it in both the spec file and the build scripts.

> The main things that cause problems for distros when upstream does it
> are things like using rpath to search alternate library locations.
> It

rpath is sorted automatically. %cmake takes care of it.

Be aware that rpath will still be set in the build output, just
stripped during 'make install'.

> > We've never been able to run the rdma stack from the build trees,
> 
> It's possible...you just have to do every step in the right order ;-)  I
> had a spreadsheet that I tracked packages, versions, build states,
> install states, and dependencies.  Made things a lot easier.

Yes, I've done that too, but the hardwired load path for the .driver
files is still a difficult problem.

I have an approach in mind to fix this too.

> shouldn't be mandatory.  However, in order to make it very explicit
> since I suspect most people want RoCE support and might not realize they
> are missing a build requirement for it to work, the tests in the
> configure script could be changed to add a new feature "RoCE Support
> (default: yes)" and make the libnl3/libnl test be part of the RoCE
> support, and if it isn't present, fail.  Then people have to turn off
> RoCE to build it without libnl3/libnl.  That would be more effective of
> a configure setup I think.

Yes, I agree. This is straightforward to do as well, I'll look at it.

Also, do you know why we have the libnl1 fallback support? I couldn't
figure out what distro needed that.

BTW, I've basically de-supported any distro that doesn't have O_CLOEXEC
and related, which probably includes anything that needed libnl1. We
can probably remove libnl1 someday too.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
