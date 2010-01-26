From: "Tziporet Koren" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: [PATCH 0/4] Current XRC queue
Date: Tue, 26 Jan 2010 13:16:25 +0200
Message-ID: <2ED289D4E09FBD4D92D911E869B97FDD0288C943@mtlexch01.mtl.com>
References: <1264446094-4460-1-git-send-email-rolandd@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <1264446094-4460-1-git-send-email-rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> I finally found time to finish going over the base XRC patches.  I
fixed
> the "userspace can destroy an XRCD handle while still having QPs/SRQs
> referring to it" problem with a reference count, rather than the more
> complicated method used by the original patches.
> 
> I think the next step would be for someone (probably not me if we want
> this to happen soon) to port the rest of the mlx4 XRC patch set on top
> of this, ideally trying to factor out any reference-counting-ish code
> away from the device-specific driver and into common code.  Then we
> should finally be able to merge this and move on to the IBoE changes.

Thanks Roland
Jack from Mellanox will take it from here

Tziporet

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
