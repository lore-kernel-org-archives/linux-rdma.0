From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Thu, 25 Aug 2016 11:39:16 -0600
Message-ID: <20160825173916.GC20612@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
 <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 25, 2016 at 10:20:15AM -0400, Doug Ledford wrote:
> On 8/23/2016 2:54 PM, Jason Gunthorpe wrote:
> > On Mon, Aug 22, 2016 at 03:43:52PM -0600, Jason Gunthorpe wrote:
> > 
> >> The full install to / is still a small TODO, it is part and parcel
> >> with doing the packaging, in my mind.
> > 
> > I just pushed a basic starting point rpm spec file, it still needs to
> > be split into multiple subpackages, but it is installable with all the
> > usual paths.
> 
> You can do that, but I routinely tell upstream maintainers that we don't
> touch their spec files.  Every distro modifies the spec file so heavily
> for their own custom installation that it just doesn't make much sense
> to worry about it at the upstream level.  Build one that can be used
> when running rpmbuild -ta and that's all you need.

I'm not sure I understand your comment.

Are you saying we don't need a specfile in upstream? How does upstream
test the build infrastructure?

Are you saying the simple one .rpm is all we need? Is that really
useful to developers if it clashes with the distro packaging? How do
we test the build system parts that help the package splitting?

Isn't it easier for downstream to have recommended packaging to
reference?

Eg I think it was a dis-service to other distros not to update the
reference verbs spec file with the libnl dependency. I wonder how many
downstreams noticed this change and are still building verbs properly?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
