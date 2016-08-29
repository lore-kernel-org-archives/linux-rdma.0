From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Mon, 29 Aug 2016 10:34:53 -0600
Message-ID: <20160829163453.GC23557@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
 <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il>
 <20160828182715.GA12783@obsidianresearch.com>
 <765b7e2d-51e0-98aa-60d1-26be35eb7a3d@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <765b7e2d-51e0-98aa-60d1-26be35eb7a3d-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 29, 2016 at 03:07:48PM +0300, Yishai Hadas wrote:

> >We already went over this with Steve, and the consensus was this isn't
> >a practical problem.
> >
> >Please read the thread from here:
> >
> >https://www.spinics.net/lists/linux-rdma/msg37813.html
> 
> Already read it, still issue is open, any major bug fix in one vendor code
> might require a new package, comparing current situation that components are
> self-contained.

They are not self-contained. They have all sorts of inter-dependencies
between each other and the kernel. Going forward do not expect the
distros to just blindly take whatever tar ball you publish into their
stable releases. That was special situation for the 'Technology
Preview' stage in RHEL6.

Providing well described backportable patches and maybe even a
'stable' branch is far more in line with what the distros want from a
mature and stable upstream.

> >Remember, by the time we get to the provider level there are already
> >often dependencies in the kernel and libibverbs that need to be met by
> >the distro, so it has rarely been the case of 'just grab my libprovider and
> >you are good'
> 
> Each commit today to libibverbs must maintain compatibility with other
> vendors and can't break one of, I don't believe that this is going to be
> changed by that model.

It is hard to say. I fully expect we will break all the providers when
we do the uAPI transition, anything else will likely be too hard. Hard
to know at this point.

> The kernel is managed by pull requests to Linus from few maintainers, it has
> a clear cycle of time frames for releases, etc.

But it also *doesn't matter*. The distros do not necessarily wait for
4.x to start looking at backportables fixes. They monitor patches
coming in and take them as they see fit independent of the release
cadence.

> Are you talking about same model that each maintainer will maintain his GIT
> and upon known time-frames will ask the main maintainer (who ever that will
> be) to take from their gits ? today the cycles in user space for such a flow
> are not defined, moving to that model in user space without a well defined
> process might be a very bad idea that will slow the process of having things
> formally upstream.

Right now I am just building the tree and making sure the technical
bits work. I think all the people on this CC list should work out a
process.

Remember, most of the code is dead, the maintainer is MIA or hasn't
accepted a patch in months or years.

mlx4/mlx5 is an notable exeption. You and Doug should work out a
reasonable appraoch. Maybe he takes your pulls directly, maybe you
have co-commit access on Github (the team approach), something else?

> >This is already basically the case, you need to wait for Doug to take
> >any libibverbs changes before you can push any provider feature
> >change.
> 
> This is incorrect, when Doug is taking into libibverbs, vendor code that is
> ready can be taken immediately, the new approach might cause some extra
> delays and slowness.

I haven't seen you do that.

If you are pushing code into your provider that doesn't work with
upstream libibverbs then you will be blacklisted by the distros. Do
not do that.

> >If this really concerns you then propose a maintainer team scheme -
> >eg hosting this on github would allow for that.
> 
> The maintaining issues as described above are not solved by some extra
> github.

Of course they are, you should familiarize yourself with how the team
features work on github.

> We must save the development/acceptance process flexible and fast and not
> put some extra barriers that may slow it in the way.

No, the main issue here is to clean up our releationship with the
distros and behave as a sensible and mature upstream.

I believe we can do that without a significant impact on the patch
flow.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
