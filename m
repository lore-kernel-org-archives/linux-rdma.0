From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 0/2] Improved node descriptions
Date: Mon, 21 Feb 2011 13:26:26 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A20B28B17@MNEXMB1.qlogic.org>
References: <20110217213017.25708.95042.stgit@homer>
 <AANLkTim5MrHMVjaNFtHeWBy82dag4XNxdBcjBEW+d1yb@mail.gmail.com>
 <20110219192458.GB4506@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110219192458.GB4506-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The biggest problem with that is that patching existing boot scripts is always going to vary from distro to distro and is always going to have problems when dealing with files that were already edited for site-specific reasons.

Ipoib is a good example of this, I frequently see failures trying to install the ipoib rpm because it failed to successfully patch the ifup- scripts. I'd rather not add another such dependency.

For example, there are is /etc/dhcp/dhclient-enter-hooks.d in SLES11 or on Redhat 6 - redhat 6 uses different files for different hooks and uses a single file (which does not exist by default) called /etc/dhcp/dhclient-enter-hook, but SLES11 uses a single script for all dhcp hooks called /etc/dhcpcd.sh.

Trying to create a single RPM capable of hacking into a wide variety of different dhcp mechanisms could be a huge headache.  Using something that relies on the openibd script and a kernel-expansion of the hostname is much less prone to problems.

-----Original Message-----
From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
Sent: Saturday, February 19, 2011 2:25 PM
To: Roland Dreier
Cc: Mike Heinz; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH 0/2] Improved node descriptions

If the main concern is DHCP what is the problem with using
/etc/dhcp/dhclient-enter-hooks.d/ or alike?

Jason


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
