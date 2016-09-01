From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Thu, 1 Sep 2016 14:17:27 -0600
Message-ID: <20160901201727.GG20472@obsidianresearch.com>
References: <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il>
 <20160828182715.GA12783@obsidianresearch.com>
 <004e01d20203$156edc30$404c9490$@opengridcomputing.com>
 <20160829161902.GB23557@obsidianresearch.com>
 <20160830060842.GJ594@leon.nu>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DE04100@ORSMSX115.amr.corp.intel.com>
 <20160831200336.GA4134@obsidianresearch.com>
 <20160901152920.GA23742@phlsvsds.ph.intel.com>
 <20160901170955.GA19982@obsidianresearch.com>
 <a27267c8-3d5c-cdfe-ed2a-d57cb106a3bf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a27267c8-3d5c-cdfe-ed2a-d57cb106a3bf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, yarong@mellanox.c
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 01, 2016 at 03:38:13PM -0400, Doug Ledford wrote:
> On 9/1/2016 1:09 PM, Jason Gunthorpe wrote:
> 
> > I'll write a patch to enable 'run from build' in a way which should
> > make this even more straight forward.
> > 
> > However, things are already fine today, you just drop your driver in
> > /opt/intel-opa/lib/libhfi1.so and customize
> > /etc/libverbs/hfi1verbs.driver with an absolute path to the .so (I
> > wrote the absolute path patch for this years ago for exactly this
> > reason)
> 
> We do have to be a little bit careful here.

Nothing I describe requires any support beyond what we have today..

So if there is an actual security issue you need to make it clear and
we need to deal with it right away.

However, I don't see your logic.

> 1)  The override directory needs to be a fixed place.

/etc/libibverbs.d/*.driver is the standard drop in place we used, and is
already used by every provider driver.

> 2)  The driver files need to only allow names.  The absolute path patch
> sounds like an immediate security issue.

The patch for this has been in for years now.

> 3)  libibverbs needs to be modified to search the overrides directory
> for <name>.so first, then the normal directory.  No other searches
> should be performed.

libibverbs does not search paths. It dlopens "libfoo-rdmav2.so" and
libdl searches the system search path for that name. AFAIK the user
can override this search with LD_LIBRARY_PATH like any other dynamic
link. (of course automatically prevented by libdl for setuid)

If *.driver specifies an absolute filename then libdl opens only that
file.

We do not want libibverbs to search paths directly because that breaks
biarch and other configurations. It is best to let libdl handle this.

> 4)  The overrides directory and the normal directory need to be system
> paths so that both file system permissions and SELinux context (if
> enabled) prevent random files from being dropped there.

Of course. selinux/etc should apply the same protections to modifying
the .driver files and the containing directory as it applies to
modifying the system .so's. (ie only root can do it)

This is super critical.

> Basically, with the idea you outline above, you would have to change the
> file type of the /etc/libibverbs.d/hfi1verbs.driver file (and all the
> other driver files) to be a changeable config file, which prevents rpm
> (and other) security scanners from being able to detect that it's
> been

Really? You are shipping things in /etc/ and they are not marked config
files? That doesn't violate your distro policies?

The entire point of these files, the only reason we have them at all,
and the reason they are in /etc/, is *specifically* so users can
configure the search path and customize the driver choice.

Otherwise we'd just dlopen("<kern-name>-rdmav2.so") and eliminate this
configurability entirely. We certainly do not need the data stored in
the .driver files to operate libibverbs. And indeed that
auto-configurability is the basic approach I am thinking of to enable
run-from-build.

So I view the lack of config marking as a packaging bug, sorry.

> anywhere.  And then you have something like opensm being run as root and
> loading up this nefarious driver from wherever.  It's a big security issue.

This makes no sense. As above, access to the .driver files must
require the same privledge to write as write to the .so libraries.

If an attacker can access the .driver files then they can access the
.so, then the attacker can just replace libc.so, and game over.

I think any possible attack avenue would have to involve setuid. Eg
trick a setuid program using libibverbs to dlopen a user controlled .so.

I don't have an avenue in mind though, that would require replacing
/etc/ with something else, and AFAIK, the ability to do that would
make  other setuid programs like su and sudo insecure??

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
