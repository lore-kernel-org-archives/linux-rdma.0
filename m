From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [ANNOUNCE] SRP: ProfitBricks publishes its SRP Initiator patches
Date: Fri, 12 Apr 2013 13:19:36 +0200
Message-ID: <5167EDC8.3030909@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello everyone,

I'm very proud to announce that we finally publish our SRP initiator
patches we've been working on for quite some time now.

In the first step we publish our way of failing IO fast as we've notice=
d
that the way Bart Van Assche does that in his GitHub repository doesn't
match our requirements completely.

His repo: https://github.com/bvanassche/ib_srp-backport
Our repo: https://github.com/sriemer/ib_srp

We want to fail IO fast in exactly the time we configure. With our
patches this works (or please tell us why not). We provide you with ful=
l
test descriptions and related shell scripts. Everything is done with as
little dependencies as possible.

The shell scripts can also be very useful to show how to configure and
use SRP with sysfs only. This is why I've added the scst-devel mailing
list here. We want to be as close as possible to the kernel.

We want to combine efforts here and to get valuable feedback from you
all. Evaluation, testing, criticism, comments, etc more than welcome!
Hopefully, we can get a really cool solution into the mainline together=
!
This would make my job as the maintainer for the ProfitBricks host
kernels a lot easier! ;-)

You'll notice: We've already adapted patches from Bart and parts of his
patches. So it is only fair to publish our patches as well. :-)

It is the same as with Bart's patches: This can't be used for
production, yet. Our patches don't have the reconnect for now. Ideas ho=
w
to implement that on top are welcome. Just send your patches directly t=
o
me! :-)

Please further notice: There is a major bug in the upstream
multipath-tools. These read sysfs files cached which leads to IO on
offline devices. We've fixed it for us and publish the fix for you as
well. :-)

Git repo:
https://github.com/sriemer/multipath-tools

Thank you so much for your help in the past and in the future as well!
Thanks for the patience and reading this!

We'll continue publishing our SRP patches relevant for the mainline.
If you want to meet me or ProfitBricks in person, we'll have a booth on
LinuxTag in Berlin/Germany. I'll have a technical talk there about SRP:

http://www.linuxtag.org/2013/en/program/thursday-may-23-2013.html?event=
id=3D208

Cheers,
Sebastian

--=20
Sebastian Riemer
Linux Kernel Developer - Storage

ProfitBricks GmbH =95 Greifswalder Str. 207 =95 10405 Berlin, Germany
www.profitbricks.com =95 sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=E4ftsf=FChrer: Andreas Gauger, Achim Weiss
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
