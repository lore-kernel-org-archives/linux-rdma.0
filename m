From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: bug 1918 - openmpi broken due to rdma-cm changes
Date: Thu, 4 Feb 2010 14:54:40 -0800
Message-ID: <DB361897EE7C40C5AB494AAC2D8625AC@amr.corp.intel.com>
References: <4B6B47D0.9030507@aoot.com> <DE586AB7003E4FC4B3850004A0B3CAF6@amr.corp.intel.com> <4B6B4C9B.8070804@opengridcomputing.com> <EEF75E01C32544C688989E66FECDC422@amr.corp.intel.com> <4B6B4EFE.3010205@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B6B4EFE.3010205-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Steve Wise' <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Well then the rdma-cm needs to know which devices support hw loopback.
>Cuz on a T3-only system, no hwloop...

The problem sounds like it's more than just whether 127.0.0.1 is usable.  That
check may fix openmpi, but it sounds more like the app needs to know whether the
device can actually support loopback, regardless of what addresses are used.  Is
this correct?

What would openmpi do if there were two addresses assigned to the T3 device?
Does openmpi simply bypass RDMA for all connections on the local machine?

Basically, I'm not sure that this is *just* an rdma_cm issue.  Although it
definitely appears that some sort of change needs to be made to the rdma_cm.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
