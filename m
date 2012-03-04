From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 15/18] ib_srp: Maintain a single connection per I_T nexus
Date: Sun, 04 Mar 2012 15:50:36 -0500
Message-ID: <1330894237.1243.30.camel@obelisk.thedillows.org>
References: <3109536.qySrY1Ts3e@asus> <6527223.rH6NsR1Dga@asus>
	 <1330238040.1026.89.camel@obelisk.thedillows.org>
	 <4F5238FC.1040703@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F5238FC.1040703-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, 2012-03-03 at 15:30 +0000, Bart Van Assche wrote:
> On 02/26/12 06:34, David Dillow wrote:
> > I was OK before with preventing the addition of a duplicate connection,
> > but the initiator shouldn't be enforcing the removal of previous
> > connections -- that should happen via the target issuing a DREQ.
> >
> > If you're going to disallow duplicate requests, then just disallow
> > adding the new one, don't tear down the old one -- let the admin
> > manually do that if desired.
> 
> But why to wait with disconnecting stale connections until the target
> sends a DREQ if we know the target is going to send it anyway ? Such an
> approach would make it necessary to introduce an extra state ("stale
> connection but not yet cleaned up by target"). Does that approach have
> any advantage over the approach followed in the patch I posted ?

Only code cleanliness. I'm not happy with the need to keep track of
whether or not this host has been added to the SCSI midlayer. I don't
think you need an extra state -- just leave it live; it will die on the
next command if the DREQ doesn't happen before the login is accepted
(which the spec says should be the case). Of course that's a bit ugly
from a behavioral viewpoint.

> Please note that this behavior was introduced because one of your
> comments on the v1 series was that you considered allowing an
> administrator to issue a duplicate login request as useful functionality
> (http://www.spinics.net/lists/linux-rdma/msg10451.html).

Yes, I recall. I also said that I was OK with disallowing a duplicate
login, as the re-login case is enabled by the admin's ability to
disconnect a single target.

I figured you would go that route, as it was the easier path. Let no one
say you back down from a challenge!

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
