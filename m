From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Thu, 1 Sep 2016 11:29:21 -0400
Message-ID: <20160901152920.GA23742@phlsvsds.ph.intel.com>
References: <20160822214352.GB11695@obsidianresearch.com> <20160823185441.GA1233@obsidianresearch.com> <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com> <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il> <20160828182715.GA12783@obsidianresearch.com> <004e01d20203$156edc30$404c9490$@opengridcomputing.com> <20160829161902.GB23557@obsidianresearch.com> <20160830060842.GJ594@leon.nu> <9C6B67F36DCAFC479B1CF6A967258A8C7DE04100@ORSMSX115.amr.corp.intel.com> <20160831200336.GA4134@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160831200336.GA4134-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 31, 2016 at 02:03:36PM -0600, Jason Gunthorpe wrote:
> On Wed, Aug 31, 2016 at 05:40:07PM +0000, Woodruff, Robert J wrote:
> 
> > If everything is bundled together, it makes providing incremental
> > updates very problematic.  For example, say vendor A needs to
> > distribute a simple bug fix in their code to a customer so they make
> > a copy of the bundled package, add their fix and give it to a
> > customer. Seems simple, right ?  But then vendor B has a similar
> > situation and distributes a package with only a fix to their
> > library, but when the customer Installs it, it overwrites the
> > package provided by vendor A and removes their bug fix.  This kind
> > of thing will end up as a huge disaster for customers and vendors
> > that are trying to support their customers.
> 
> Erm, but we already have a mess. AFAIK Mellanox and Intel both use
> OFED derivatives as their main means to deliver fixes to customers
> that both entirely replace the distro stack and completely conflict
> with each other.

OPA's "delta install" is _not_ based on OFED and installs only the bits which
are needed beyond what is in the distro.  Many of those changes already appear
in upstream repos which have not made it into the specific distro version.  As
things are accepted we drop those bits from our install.  This has been our
policy for some time and if you look at our IFS download you can see that the
packages which get installed for newer distros like 7.2 are smaller than
previous versions.

> 
> So, I'm sorry, I see your scenario as complete fiction today. We are
> certainly not making it worse for anyone.
> 
> One the contrary, as I pointed out to Mellanox and Chelsio, Intel has
> the same problem getting wide distribution of their provider. Is hfi1
> even in Fedora yet? Only thing I found was that it was blocked by
> review:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1315870
> 
> Let alone Debian..
> 
> So, again, your world view of 'rapid updates' seems like a complete
> fiction if you have been trying for half a year to enter the
> distribution channel. How can you possibly call that a success???

To some extent this supports Woody's position.  libhfi1verbs is being used by
many customers because we can supply it without breaking the standard
libibverbs install.  NOTE in Fedora, RHEL, SLES, and others we _do_ _not_
update libibverbs.  Thus keeping the standard distro support intact for other
vendors hardware.

> 
> At least ipathverbs seems uniformly distributed in Fedora and Debian,
> kudos on that. (though it hasn't changed since 2014, but your release
> process is not creating version tags in github, oops)
>
> 
> This would not be such a problem with rdma-plumbing as Fedora would
> seemlessly track upstream and all providers from all vendors would
> trivially enter the distribution when they regularly pick up the new
> upstream. Vendors would no longer have to individually have go to each
> distro and lobby for inclusion.

However, to use the example you have given...

We submitted libhfi1verbs to fedora over 5 months ago 3-8-2016.  Due to many
factors it still has not been accepted.

> 
> You, again, have missed the major point. Publishing some random code
> on a random github is not really distribution. It is not reaching end
> users, it is not working effectively. It doesn't matter how quickly
> you can update your own vendor private github if the distros simply
> ignore it.

I partly agree with your point.  Over all the RDMA vendors have been very
remiss in getting things "really upstream" after they have been accepted
"somewhere".  Generally this has been "It's in OFED...  done"...

I 100% agree this has to stop.  However, offering no "updates" directory for
incoming hardware or critical fixes is too draconian a policy.  Reading to the
end of this thread it seems that you and Woody have reached the compromise I
was going to propose.  That is...

Similar to the kernel why not have an "updates" directory where new and/or
updated vendor libraries can be installed.  While this does provide an out for
vendors to never get their fixes into the common library I for one will push
Intel to not stop there.  Intel is committed to fully supporting the community
and distro release mechanisms.

> 
> IMHO, there is no 'update' until a vendor's provider reach an end user
> through their preferred distribution.

While I share your sentiment personally the reality is we have many customers
who are actively using OPA hardware with software which is not in any distro
_yet_.

> 
> > 2.) Allow a vendor the ability to distribute their library package
> > separately from the bundled package.
> 
> There is nothing stoping this, it is trivial for the vendor to make a
> .spec file for rdma-plumbing that just produces a rpm with the single
> vendor provider (after doing the full build).
> 
> If you really want an example I will show you.

That could be an alternative.

> 
> > 3.) Allow the ability for a vendor to distribute an update package
> > that just contains their library code to replace the version of that
> > code that is in the bundled package. I think that OFI, for example,
> > has something like this to avoid this kind of mess.
> 
> Certainly, we can make this even easier as well. Mainly what is needed
> is some way for the vendor to drop in a override .driver file in
> /etc/ibverbs.d/
> 
> It would not be hard to make a patch that does that, if that is all it
> takes to alleviate your concern I can add it to the todo list.

Agreed.  FWIW I would just add such external updates to an "updates" directory
so that users can easily see that something extra was installed.  But this is a
minor point.

> 
> BTW, it is bit rich to laud Sean for bundling drivers with libfabric
> and condem us for doing the same with libibverbs :(

FWIW, I believe libfabric offers an external update mechanism.  But I have not
had time to verify that in the code.

Ira

> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
