From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ewg] [PATCH v4] IB Core: RAW ETH support
Date: Wed, 16 Jun 2010 11:02:35 -0600
Message-ID: <20100616170234.GA2932@obsidianresearch.com>
References: <E113D394D7C5DB4F8FF691FA7EE9DB4439A76E8632@MTLMAIL.mtl.com> <1276513450.30132.51.camel@alst60.voltaire.com> <aday6eguhfn.fsf@roland-alpha.cisco.com> <4C18DB37.6050501@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C18DB37.6050501-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Alekseys Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 16, 2010 at 09:09:59AM -0500, Steve Wise wrote:

> Granted our dev process may not be documented, but I always assumed the 
> general idea was to get changes accepted upstream, then pull into ofed. 
> OFED is just a mechanism to make top-of-tree linux work on distro 
> kernels. There are some exceptions, but this stuff shouldn't be an 
> exception.

That is what many people wish for, me included, but it is not at all
what generally happens :(

In my observation the typical flow is:
 - A patch is written, it may or may not be sent to the list
 - 'business drivers' get it slammed into OFED right away
 - A patch is finally sent for proper review
 - It is not merged, there are comments..
 - Interest in doing anything is lost because it is already in
   OFED and that is all that matters, right?
 - People complain.

For instance, the iWarp thingy we were just discussing fits this
process rather well.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
