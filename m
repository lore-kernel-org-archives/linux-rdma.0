From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Sun, 4 Sep 2016 20:34:09 -0600
Message-ID: <20160905023409.GC21542@obsidianresearch.com>
References: <004e01d20203$156edc30$404c9490$@opengridcomputing.com>
 <20160829161902.GB23557@obsidianresearch.com>
 <20160830060842.GJ594@leon.nu>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DE04100@ORSMSX115.amr.corp.intel.com>
 <20160831200336.GA4134@obsidianresearch.com>
 <20160901152920.GA23742@phlsvsds.ph.intel.com>
 <20160901170955.GA19982@obsidianresearch.com>
 <a27267c8-3d5c-cdfe-ed2a-d57cb106a3bf@redhat.com>
 <20160901201727.GG20472@obsidianresearch.com>
 <9efe8c8f-40e2-b016-9a1e-4770298b9068@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9efe8c8f-40e2-b016-9a1e-4770298b9068-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, yarong@mellanox.c
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 04, 2016 at 05:38:45PM -0400, Doug Ledford wrote:
> >> 1)  The override directory needs to be a fixed place.
> > 
> > /etc/libibverbs.d/*.driver is the standard drop in place we used, and is
> > already used by every provider driver.
> 
> I meant the .so's override directory.  I'm assuming the actual .so name
> for an override driver will have the same name as the default .so, so
> you need a second directory.  I would make that directory a fixed,
> standard location.

.so override? Where did that come? I'm not proposing that..

I would not give them the same name either, we don't need to because
the .driver file lets us override, that is the whole point.

> >> 2)  The driver files need to only allow names.  The absolute path patch
> >> sounds like an immediate security issue.
> > 
> > The patch for this has been in for years now.
> 
> It might be worth removing it, or at least analyzing it in more detail...

Well, lets have some detail, I don't see anything that would warrant a
security concern.

> It won't break biarch.  You can't load a 32bit .so with a 64bit
> libibverbs and vice versa, so you can put the .so library path into your
> binary based upon arch.  I would do this in preference to libdl searches.

I generally dislike to hardcode paths like that, but sure, we could
do something like that.

> It's not just the permissions to modify, it's the file's default
> context.  Many files in SELinux parlance inherit their default context
> based upon their location.  If you want to have a specific
> rdma_driver_t

Why would I need a rdma_drver_t label? Loading the driver .so or the
.driver file is not a security sensitive operation.

I don't know if I've ever heard of using selinux to forbid running
unprivileged binaries?? Is that really a thing? Doesn't just running
them from your home dir trivially defeat that?

> context, you would need a directory specifically for them so you can
> have an SELinux inheritance rule that sets the driver's context.

The .driver doesn't really change anything. If selinux has arranged
things so libibverbs will only load labeled plugins, then the
driver.so still has to carry that label, nothing has really changed by
adding the indirection through the .driver file.

If an attacker can manipulate selinux labels then all is lost and the
.driver file is not a concern.

> rpm, then the new file is saved as <filename>.rpmnew.  My comment above
> is that in order to support modifying those driver files and not having
> those modifications get wiped out on upgrade, the config files must be
> marked as %config(noreplace) and that means we will preserve
> changes.

AFAIK, %config leaves the user's file alone *unless* the file in the
copy in the .rpm has been updated (other wise config files are
useless). Since we never change the .driver file %config and
%config(noreplace) are essentially identical for our purposes.  A user
modified .driver file will not be replaced if the .rpm is upgraded or
re-installed, which is the desired behavior.

> >> anywhere.  And then you have something like opensm being run as root and
> >> loading up this nefarious driver from wherever.  It's a big security issue.
> > 
> > This makes no sense. As above, access to the .driver files must
> > require the same privledge to write as write to the .so libraries.
> 
> A text config file is easier to manage a hack on that a .so.  If
> your

Eh? Any change to the .driver file must be matched with creating a
nefarious .so. I don't see how this makes it any easier.

> library simply doesn't read any text config files and instead has
> SELinux secured .so's in a well protected place, that is more
> secure.

Don't see it. Your definition of 'secure' is really strange.

> Yes, you would need root in order to modify the driver config text files
> if you are using vi, but the point is that the text config files are a
> weak link in the security chain, at least weaker than the rest of it.

I've never seen security evaluated this way.

> But, even if they do have root and use that to modify the text files,
> that's still worse than just modifying the .so because an rpm upgrade
> would not undo the damage so it's possible their subterfuge could
> exist

See above about %config..

> beyond measures that would otherwise render it null and void.  If the
> admin found out that someone had hacked root and was attempting to
> re-lock down the machine, that could be problematic (yes, I know they
> should really be reinstalling from scratch, but admins do what admins do
> when the shit hits the fan).

Again, never seen security evaluated this way.

A compromized machine must be wipe-installed.

You could apply all your arguments to many files in /etc. For instance
why do you think the .driver bad but /etc/ld.so.conf.d/ is OK?

> And in the intervening years, I doubt the configurability of these text
> files has been used by more people than I can count on one hand.

Uh, look in libibverbs/debian, it is used by the Debian
packaging. Every single Debian user relies on this feature.

> For all those reasons, I simply don't see the utility of those config
> files being worth the added attack vector that they create.

Well, I agree with getting rid of the default .driver files, just for
different reasons..

I'd keep them for vendor overrides, which really is their designed
function anyhow.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
