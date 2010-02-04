From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: bug 1918 - openmpi broken due to rdma-cm changes
Date: Thu, 4 Feb 2010 14:33:04 -0800
Message-ID: <DE586AB7003E4FC4B3850004A0B3CAF6@amr.corp.intel.com>
References: <4B6B47D0.9030507@aoot.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B6B47D0.9030507-10udUCx4aRo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Steve Wise' <swise-10udUCx4aRo@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>OpenMPI uses rdma_bind_addr() to figure out which ip addresses are valid
>for which IB devices.   This logic is now broken.  Regardless of whether
>OpenMPI should use another method for determining which IP address
>belong to which interfaces, we should probably rethink whether we're
>breaking rdma-cm semantics in a bad way on a point release.

The changes to the rdma_cm have been merged upstream.  These were fixes
specifically to enable using the loopback address with RDMA devices.

At first thought, we can extend enum ib_device_cap_flags to indicate if a device
supports loopback capabilities or not.  The rdma_cm could then skip over such
devices when dealing with a loopback address. 

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
