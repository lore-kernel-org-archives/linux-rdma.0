From: Chet Murthy <chet-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
Subject: Re: OFED 1.5.4.1 on Ubuntu 10.04 with Mellanox cards?
Date: Fri, 22 Jun 2012 12:02:46 -0700
Message-ID: <5754967.2RWSFZticM@twitter>
References: <1565389.HptLAFPzES@twitter> <4FE4304E.3090002@profitbricks.com>
Reply-To: Chet Murthy <chet-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FE4304E.3090002-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Sebastian,

Thank you for taking the time to explain these things!  It's a little
confusing ....

> Here a simple list of matching code:
> OFED-1.5.4  ---> kernel 3.2.x
> OFED-1.5.4.1 ---> kernel 3.3.x

(1) Is there a more-exhaustive list of the right kernel to use with
each OFED release?  I was going by the OFED docs (e.g. release notes),
which seemed to indicate that for 1.5.4.1, the "right" range of
kernels was (kernel.org: 2.6.30 - 3.1), and specific kernel versions
for various distros.

(2) I'm pretty familiar with adminstering Debian systems and building
debian packages, hacking their insides, alienizing, hacking that
process, etc.

(I -think- ;-) The only real question for me is, which versions, with
which patches, of the various bits, will work together with this RoCEE
card.

(3) I'm -not at all- familiar with the workflow/process that Debian
Developers use.  For instance, I don't really understand what you men
below:

> But you'll have to ensure that the kernel code matches the OFED user
> space. The kernel stuff included in OFED doesn't support latest kernels
> and is based on an older code base (e.g. OFED 1.5.4 kernel stuff is
> based on 2.6.30).

Do you mean that the kernel-ib RPM in 1.5.4 is the code form the
2.6.30 kernel?  But then the list below doesn't seem to make sense.

> Here a simple list of matching code:
> OFED-1.5.4  ---> kernel 3.2.x
> OFED-1.5.4.1 ---> kernel 3.3.x

(4) I think what you're saying here

> the trick is to check out the latest pkg-ofed source from debian SVN
> (svn://svn.debian.org/svn/pkg-ofed/) and to update the upstream source
> by merging the stuff by extracting the source RPMs or even better by
> importing the source directly from the git repos of the OFED user space.
> In the "debian" directory there are some patches e.g. which change some
> stuff in shell scripts for the dash. These need to be adopted.

is:

  (a) check out the stuff from svn.debian.org

  (b) pull source from the OFED repos user-space

  (c) -copy- that (latest) OFED source into the tree I checked-out
  from debian

  (d) make sure that the patches in the debian directories apply
  properly to the various shellscripts

  (e) build debian packages per usual

And per your instructions above, I believe you're saying I should be
using a 3.3.x kernel?

Thanks,
--chet--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
