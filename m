From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Thu, 04 Feb 2010 15:35:39 -0800
Message-ID: <aday6j8efqs.fsf@roland-alpha.cisco.com>
References: <4B6B47D0.9030507@aoot.com>
	<DE586AB7003E4FC4B3850004A0B3CAF6@amr.corp.intel.com>
	<4B6B4C9B.8070804@opengridcomputing.com>
	<EEF75E01C32544C688989E66FECDC422@amr.corp.intel.com>
	<4B6B4EFE.3010205@opengridcomputing.com>
	<DB361897EE7C40C5AB494AAC2D8625AC@amr.corp.intel.com>
	<4B6B5277.80307@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B6B5277.80307-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (Steve Wise's message of
	"Thu, 04 Feb 2010 17:04:23 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Hey Roland, are you ok with a device attribute to indicate hw-loopback
 > support?

Sigh, I guess so.  Can we have the rdma-cm handle this somewhat
automagically, eg only choose devices that do handle loopback when
binding/connecting to 127.0.0.1?  Or maybe can we put the handling of
this into the device-driver-specific iwcm methods, to fail
listen/connect requests that are loopback?

But if a device cap flag is what it takes, that's OK I guess.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cisco.com - http://www.cisco.com

For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
