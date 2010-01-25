From: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/4] Current XRC queue
Date: Mon, 25 Jan 2010 11:01:30 -0800
Message-ID: <1264446094-4460-1-git-send-email-rolandd@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi everyone,

I finally found time to finish going over the base XRC patches.  I fixed
the "userspace can destroy an XRCD handle while still having QPs/SRQs
referring to it" problem with a reference count, rather than the more
complicated method used by the original patches.

I think the next step would be for someone (probably not me if we want
this to happen soon) to port the rest of the mlx4 XRC patch set on top
of this, ideally trying to factor out any reference-counting-ish code
away from the device-specific driver and into common code.  Then we
should finally be able to merge this and move on to the IBoE changes.

Thanks,
  Roland

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
