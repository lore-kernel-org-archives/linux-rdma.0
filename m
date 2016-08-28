From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Sun, 28 Aug 2016 12:27:15 -0600
Message-ID: <20160828182715.GA12783@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
 <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c84de2a5-6526-c0a6-6535-519add3fbabb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 28, 2016 at 07:14:31PM +0300, Yishai Hadas wrote:

> Today each vendor manages its code and is not exposed to bugs/issues in
> other vendors. Moving to a consolidate rpm might cause that any bug fix in
> one component will force a new release of all other stuff without any real
> reason. Introducing such a dependency might even delay/block a release
> without any justification.

We already went over this with Steve, and the consensus was this isn't
a practical problem.

Please read the thread from here:

https://www.spinics.net/lists/linux-rdma/msg37813.html

There is some excellent information on how the distribution processes
work and general support from the community on this integration.

The basic summary is that this consolidation allows the
already-existing per-distro coordiation of all the libraries and the
providers to happen in the open and be shared by all the downstream
consumers.

Things would be more like the kernel flow where the distros will
monitor one place for bug fixes to back port (rdma-plumbing) and
vendors will still work with the distro to get their specific patches
backported.

Remember, by the time we get to the provider level there are already
often dependencies in the kernel and libibverbs that need to be met by
the distro, so it has rarely been the case of 'just grab my libprovider and
you are good'

The few case like that are also trivially cherry-pickable patches.

This makes things easier for all the downstream users by providing a
single source reference, and makes it easier for developers beacuse we
can update all providers in one pass with one pull request.

The other thing to bear in mind is that most of the code is
dead. Other than a few providers there simply is no churn. All the
work is keeping everything up to date and still compiling on modern
distros/arches/etc.

I'm expecting that the whole thing will remain continuously releasable
exactly because it is largely all dead code. If a vendor pushes a bug
into their provider then they are going to get burned, not other vendors.

However, we face the ioctl UAPI conversion in our future, and tackling
that across 15 different dead git trees with MIA maintainers is simply
too hard. I view this work as a necessary precondition for the UAPI
fixup.

> I believe that we agree that each maintainer should be independent to
> review/accept relevant code to his component and make sure that his code is
> fully tested and ready for a release in any given time.

The model is exactly the same as the kernel, which is proven to work,
and does expect that all patches are release ready.

Sean has proven this model works with libfabric and has shown
benefits of building community infrastructure.

> Put all code in one big umbrella letting only one person to accept code is
> not a good idea which might slow the process of accepting new code and
> features.

This is already basically the case, you need to wait for Doug to take
any libibverbs changes before you can push any provider feature
change.

If this really concerns you then propose a maintainer team scheme -
eg hosting this on github would allow for that.

> In addition, need to consider that there are few distros which have releases
> in different times, the flexibility to take a specific component based on
> its readiness and importance is a vital
> point that must be saved as done today.

Again, it doesn't matter. The distros will take from upstream whenever
they are ready and upstream is 'continuously releasable'. This way the
distros can get everything and not have to hunt down 15 different git
trees randomly sprinkled across the internet

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
