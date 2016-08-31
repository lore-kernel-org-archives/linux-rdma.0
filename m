From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Wed, 31 Aug 2016 14:03:36 -0600
Message-ID: <20160831200336.GA4134@obsidianresearch.com>
References: <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
 <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il>
 <20160828182715.GA12783@obsidianresearch.com>
 <004e01d20203$156edc30$404c9490$@opengridcomputing.com>
 <20160829161902.GB23557@obsidianresearch.com>
 <20160830060842.GJ594@leon.nu>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DE04100@ORSMSX115.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9C6B67F36DCAFC479B1CF6A967258A8C7DE04100-8oqHQFITsIFqS6EAlXoojrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.wein>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 31, 2016 at 05:40:07PM +0000, Woodruff, Robert J wrote:

> If everything is bundled together, it makes providing incremental
> updates very problematic.  For example, say vendor A needs to
> distribute a simple bug fix in their code to a customer so they make
> a copy of the bundled package, add their fix and give it to a
> customer. Seems simple, right ?  But then vendor B has a similar
> situation and distributes a package with only a fix to their
> library, but when the customer Installs it, it overwrites the
> package provided by vendor A and removes their bug fix.  This kind
> of thing will end up as a huge disaster for customers and vendors
> that are trying to support their customers.

Erm, but we already have a mess. AFAIK Mellanox and Intel both use
OFED derivatives as their main means to deliver fixes to customers
that both entirely replace the distro stack and completely conflict
with each other.

So, I'm sorry, I see your scenario as complete fiction today. We are
certainly not making it worse for anyone.

One the contrary, as I pointed out to Mellanox and Chelsio, Intel has
the same problem getting wide distribution of their provider. Is hfi1
even in Fedora yet? Only thing I found was that it was blocked by
review:

https://bugzilla.redhat.com/show_bug.cgi?id=1315870

Let alone Debian..

So, again, your world view of 'rapid updates' seems like a complete
fiction if you have been trying for half a year to enter the
distribution channel. How can you possibly call that a success???

At least ipathverbs seems uniformly distributed in Fedora and Debian,
kudos on that. (though it hasn't changed since 2014, but your release
process is not creating version tags in github, oops)

This would not be such a problem with rdma-plumbing as Fedora would
seemlessly track upstream and all providers from all vendors would
trivially enter the distribution when they regularly pick up the new
upstream. Vendors would no longer have to individually have go to each
distro and lobby for inclusion.

You, again, have missed the major point. Publishing some random code
on a random github is not really distribution. It is not reaching end
users, it is not working effectively. It doesn't matter how quickly
you can update your own vendor private github if the distros simply
ignore it.

IMHO, there is no 'update' until a vendor's provider reach an end user
through their preferred distribution.

> 2.) Allow a vendor the ability to distribute their library package
> separately from the bundled package.

There is nothing stoping this, it is trivial for the vendor to make a
.spec file for rdma-plumbing that just produces a rpm with the single
vendor provider (after doing the full build).

If you really want an example I will show you.

> 3.) Allow the ability for a vendor to distribute an update package
> that just contains their library code to replace the version of that
> code that is in the bundled package. I think that OFI, for example,
> has something like this to avoid this kind of mess.

Certainly, we can make this even easier as well. Mainly what is needed
is some way for the vendor to drop in a override .driver file in
/etc/ibverbs.d/

It would not be hard to make a patch that does that, if that is all it
takes to alleviate your concern I can add it to the todo list.

BTW, it is bit rich to laud Sean for bundling drivers with libfabric
and condem us for doing the same with libibverbs :(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
