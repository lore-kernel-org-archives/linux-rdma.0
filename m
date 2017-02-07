From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: OFED-4.8, rdma-core, and library paths
Date: Tue, 7 Feb 2017 09:07:28 -0600
Message-ID: <011b01d28153$e5f0adf0$b1d209d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Cc: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey,

I think we have an issue with the new rdma-core packaging and OFED-4.8.  I think
OFED-4.8 installs provider libraries in a different location than previous
releases of the provider libs.  The result of this, I think, is that OFED-4.8
installed over a destro with its own provider libs installed will result in two
versions of the libs installed, and further, the system might end up using the
distro provider libs with newer OFED drivers, which could be problematic.  I
believe the OFED installer uninstalls previous OFED rpms, but not distro rpms.
>From what I can tell, it uses the ofed_info  command, if it exists, to determine
which rpms to uninstall.  So if there is no previous OFED installed, then
ofed_info will not exist so the distro rdma rpms will not be uninstalled.  Prior
to OFED-4.8, I think this was somewhat benign, because OFED would install the
provider libs over the currently installed distro libs, and thus nobody noticed.
But now the rdma-core package puts the provider libs in a different location,
thus exposing this issue.

What do folks think about this?  Should OFED-4.8 try and uninstall rdma
cmds/libs regardless of where they came from?  Perhaps optionally.  Or should
this just be documented so the admin is required to deal with it?  I think if we
leave OFED as-is, we'll end up with lots of support issues where old libs are
being loaded causing problems.

Thoughts?  Am I missing something in the OFED-4.8 installer that avoids this
issue?


Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
