From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 03/14] ib_srp: Disallow duplicate logins
Date: Mon, 19 Dec 2011 10:31:50 +0000
Message-ID: <CAO+b5-oDSYWHC5Wkhfia4SDvqYjXvXMQLJW-iaefGBb0tRUDMw@mail.gmail.com>
References: <201112011954.25811.bvanassche@acm.org>
	<201112011958.17339.bvanassche@acm.org>
	<1323976101.16703.42.camel@lap75545.ornl.gov>
	<CAO+b5-r6dHt-vmbNjeD4zvcAaRVqhiEm5eZF7hgF6ei35kqjdQ@mail.gmail.com>
	<1324244446.17849.39.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1324244446.17849.39.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 18, 2011 at 9:40 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> A SRP target port (for the purposes of an I_T nexus) is defined by the
> IOC GUID and extension; if you want to have redundant connections to a
> port, multi-channel logins must be supported. The way most targets avoid
> this issue is to present a different IOC on each IB port, though you
> should be also able to export multiple ServiceEntries in the
> IOControllerProfile response to allow different service extensions to be
> selected.

I'm considering to leave out this patch since deleting an SRP target
port already provides a way to avoid that the initiator creates
duplicate LUNs.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
