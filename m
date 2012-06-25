From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: OFED 1.5.4.1 on Ubuntu 10.04 with Mellanox cards?
Date: Mon, 25 Jun 2012 11:35:36 +0200
Message-ID: <4FE830E8.5040808@profitbricks.com>
References: <1565389.HptLAFPzES@twitter> <4FE4304E.3090002@profitbricks.com> <5754967.2RWSFZticM@twitter>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5754967.2RWSFZticM@twitter>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chet Murthy <chet-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Chet,

On 22/06/12 21:02, Chet Murthy wrote:
> 
> Sebastian,
> 
> Thank you for taking the time to explain these things!  It's a little
> confusing ....
> 
>> Here a simple list of matching code:
>> OFED-1.5.4  ---> kernel 3.2.x
>> OFED-1.5.4.1 ---> kernel 3.3.x
> 
> (1) Is there a more-exhaustive list of the right kernel to use with
> each OFED release?  I was going by the OFED docs (e.g. release notes),
> which seemed to indicate that for 1.5.4.1, the "right" range of
> kernels was (kernel.org: 2.6.30 - 3.1), and specific kernel versions
> for various distros.

Unfortunately, there is no more-exhaustive list for matching the kernel
code with the OFED user space. It's a matter of comparing dates - kernel
release and OFED release.
O.K., here is how they put the OFA kernel code into OFED:
- kernel developers develop for the latest kernel release cycle (here 3.3)
- OFED packagers use an older kernel as basis (2.6.30) and forward port
the OFA kernel stuff to the current kernel release (here 3.3) by patches
for kernels (2.6.30..3.1) - this leaves space for failures (e.g. that
they don't port the open-iscsi kernel code correctly)
- this is why they say that they don't support the mainline kernels
completely

We at ProfitBricks need latest kernels anyway. This is why we match it
from upstream (OFA kernel stuff from kernel.org). And we don't have to
build the OFA kernel modules from out-of-tree which simplifies our
kernel build chain. We have OFED-1.5.4 with OFA kernel code from kernel
3.2 at the moment.

But there is also a new OFED release approach:
Perhaps you've seen the OFED-3.2 already?! This is the OFED especially
for kernel 3.2. This makes it easier to match OFED user space and kernel
code. Here they just backport the OFA kernel stuff e.g. from 3.4 to 3.2.
Looks promising, but I have no experience with that, yet.

> (2) I'm pretty familiar with adminstering Debian systems and building
> debian packages, hacking their insides, alienizing, hacking that
> process, etc.
> 
> (I -think- ;-) The only real question for me is, which versions, with
> which patches, of the various bits, will work together with this RoCEE
> card.

Your issue can be something with the shell scripts, kernel code to user
space matching or plain that you don't have the opensm running. Without
a running instance of a subnet manager your card will get no LID
assigned, no partition key, etc. IPoIB, MPI, iSER, SRP, etc. won't work.
Check with "ibdiagnet -r" if your master subnet manager is running. IB
is self-managed by the subnet manager. Make sure that your opensm
configuration is correct.

We have big deployments and don't want to have "rpm" installed on Debian
systems. This is why we've taken OFED-1.5.2 stuff from debian
experimental from "pkg-ofed". We've converted the SVN stuff into git
repos for OFED, imported the OFED-1.5.4 upstream code and adopted the
modifications by Debian (e.g. shell code changes). Now, we can build
OFED with "git-buildpackage" and upload the deb packages to our debian
repository.

> (3) I'm -not at all- familiar with the workflow/process that Debian
> Developers use.  For instance, I don't really understand what you men
> below:
> 
>> But you'll have to ensure that the kernel code matches the OFED user
>> space. The kernel stuff included in OFED doesn't support latest kernels
>> and is based on an older code base (e.g. OFED 1.5.4 kernel stuff is
>> based on 2.6.30).
> 
> Do you mean that the kernel-ib RPM in 1.5.4 is the code form the
> 2.6.30 kernel?  But then the list below doesn't seem to make sense.
> 
>> Here a simple list of matching code:
>> OFED-1.5.4  ---> kernel 3.2.x
>> OFED-1.5.4.1 ---> kernel 3.3.x

I've explained this above.

> (4) I think what you're saying here
> 
>> the trick is to check out the latest pkg-ofed source from debian SVN
>> (svn://svn.debian.org/svn/pkg-ofed/) and to update the upstream source
>> by merging the stuff by extracting the source RPMs or even better by
>> importing the source directly from the git repos of the OFED user space.
>> In the "debian" directory there are some patches e.g. which change some
>> stuff in shell scripts for the dash. These need to be adopted.
> 
> is:
> 
>   (a) check out the stuff from svn.debian.org
> 
>   (b) pull source from the OFED repos user-space
> 
>   (c) -copy- that (latest) OFED source into the tree I checked-out
>   from debian
> 
>   (d) make sure that the patches in the debian directories apply
>   properly to the various shellscripts
> 
>   (e) build debian packages per usual
> 
> And per your instructions above, I believe you're saying I should be
> using a 3.3.x kernel?

Yes, this is exactly what I would suggest to you if you want to have a
really working solution without "rpm". You should at least have a look
at this or try it to see if this fixes your issues and if this gives you
advantages.

Cheers,
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
