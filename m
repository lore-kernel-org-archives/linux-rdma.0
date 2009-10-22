From: Bryan <bryan.mreese-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: OFED 1.4.2 requires rebuild of kernel modules on each node
Date: Thu, 22 Oct 2009 14:21:36 -0400
Message-ID: <aad292200910221121w3bf5480fyfc4b04a12290b150@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I was referred to this list by the general mailing list on OFED.
Emailing from my personal address since Lotus Notes insists that
anything it sends has to contain some portion of HTML.

This problem was observed on Red Hat Enterprise Linux 5 update 3.  I
searched the list but did not see anything immediately applicable.
We've seen issues similar in the past where we were able to modify the
script to solve an RPM that didn't match the expected naming scheme,
but did not see anything immediately when looking at the scripts for
this version.

Copied from an internal bug reporting tool:

On installing OFED 1.4.2, the tarball was extracted, in directory the code
was extracted to, ./install.pl was run and all components of OFED were
build/installed with the default settings.  Then this directory was
copied to another node, and ./install.pl -c ofed.conf was run.  Previously
this would just do the install of the already built components, but with
OFED 1.4.2, the kernel RPM gets re-built when this is done.

This means that the build tools have to be on each node, and that
deployment of OFED takes longer.

Bryan Reese -- breese-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
e1350 Linux Cluster Test Engineer
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
