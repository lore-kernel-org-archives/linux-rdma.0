From: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: OFED 1.4.2 requires rebuild of kernel modules on each node
Date: Thu, 22 Oct 2009 15:38:58 -0700
Message-ID: <382A478CAD40FA4FB46605CF81FE39F43DB6BABA@orsmsx507.amr.corp.intel.com>
References: <aad292200910221121w3bf5480fyfc4b04a12290b150@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <aad292200910221121w3bf5480fyfc4b04a12290b150-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan <bryan.mreese-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sending this to the EWG openfabrics list,
since this seems to be an OFED build/installation issue
rather than a general code problem.

One thing that you might try is to instead of copying the
entire build directory and re-runing ./install.pl -c ofed.conf
on each system, instead, after building on one node,
just copy the binrary RPMS directory and 
the uninstall script to the other nodes,
Then just run the uninstall script and
install the RPMS manually... e.g, 

./uninstall.sh
cd ./RPMS/redhat-release-xxxx/x86_64
rpm -i *

This method has worked for me in the past. 

woody


-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Bryan
Sent: Thursday, October 22, 2009 11:22 AM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: OFED 1.4.2 requires rebuild of kernel modules on each node

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
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
