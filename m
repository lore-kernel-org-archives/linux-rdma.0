From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Thu, 25 Aug 2016 15:32:54 -0500
Message-ID: <023101d1ff0f$db692b30$923b8190$@opengridcomputing.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com> <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com> <20160822214352.GB11695@obsidianresearch.com> <20160823185441.GA1233@obsidianresearch.com> <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com> <20160825173916.GC20612@obsidianresearch.com> <20160825195246.GI1916@redhat.com> <20160825201306.GA5421@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160825201306.GA5421-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Jarod Wilson' <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Thu, Aug 25, 2016 at 03:52:46PM -0400, Jarod Wilson wrote:
> > On Thu, Aug 25, 2016 at 11:39:16AM -0600, Jason Gunthorpe wrote:
> > > On Thu, Aug 25, 2016 at 10:20:15AM -0400, Doug Ledford wrote:
> > > > On 8/23/2016 2:54 PM, Jason Gunthorpe wrote:
> > > > > On Mon, Aug 22, 2016 at 03:43:52PM -0600, Jason Gunthorpe wrote:
> > > > >
> > > > >> The full install to / is still a small TODO, it is part and parcel
> > > > >> with doing the packaging, in my mind.
> > > > >
> > > > > I just pushed a basic starting point rpm spec file, it still needs to
> > > > > be split into multiple subpackages, but it is installable with all the
> > > > > usual paths.
> > > >
> > > > You can do that, but I routinely tell upstream maintainers that we don't
> > > > touch their spec files.  Every distro modifies the spec file so heavily
> > > > for their own custom installation that it just doesn't make much sense
> > > > to worry about it at the upstream level.  Build one that can be used
> > > > when running rpmbuild -ta and that's all you need.
> > >
> > > I'm not sure I understand your comment.
> > >
> > > Are you saying we don't need a specfile in upstream?
> >
> > Distros certainly don't require it.
> 
> I know that, my question is poised to the larger developer community
> who need to build test and deploy this stuff as not-a-distro.
>

I always ./autogen.sh, then ./configure, then make && make install.

> > > How does upstream
> > > test the build infrastructure?
> >
> > ./configure, make, make install (or cmake/ninja/whatever)
> 
> rpmbuild does stuff that needs to be checked out and validated by
> upstream at least occasionally, or packaging becomes too hard for the
> downstream because of broken build infra.
> 
> > I either build locally in the git tree(s) and run from there, or I take
> > the upstream tarball and modify my distro spec file to use it.
> 
> We've never been able to run the rdma stack from the build trees, the
> dlopen stuff and the split packaging made it too hard. We can almost
> do it with the unified tree, but that is still a few patches away.. So
> that isn't a good answer for developers.
> 
> > Generally, no, because various upstreams often do things that violate the
> > packaging rules for a given distro. Upstream specs are occasionally used
> > for reference bringing up a new package, but at least for Red Hat
> > and
> 
> Well, that is exactly where we are right now, bringing up a new
> (complex) package.
> 
> Would you help making a spec file that is close to what you
> could use in the distro? I don't really care if it is stored in the
> package or stored inside RH, but we need to get one made.
> 
> > > Eg I think it was a dis-service to other distros not to update the
> > > reference verbs spec file with the libnl dependency. I wonder how many
> > > downstreams noticed this change and are still building verbs properly?
> >
> > Add the dependency to the build infra, and problem solved for rpm, deb,
> > whatever other packaging system. Updating the spec only helps rpm-based
> > distros, maybe, if they use the spec (which RH/Fedora doesn't).
> 
> The build infra has an optional requirement for libnl3, and other
> things.
> 
> I don't know why we did that, maybe it should have been mandatory, but
> the point remains, it is a subtle change that is easy to miss
> downstream. Presumably downstream folks review changes to the tarball
> including the reference spec file before packaging a new version?
> 
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
