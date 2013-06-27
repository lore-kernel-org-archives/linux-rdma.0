From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 02/14] IB/srp: Fix race between srp_queuecommand() and
 srp_claim_req()
Date: Thu, 27 Jun 2013 17:02:25 -0400
Message-ID: <1372366945.32164.32.camel@frustration.ornl.gov>
References: <51B87501.4070005@acm.org> <51B875EE.3030702@acm.org>
	 <51B88C7C.4030209@profitbricks.com> <51B8903E.3000609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B8903E.3000609-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2013-06-12 at 17:14 +0200, Bart Van Assche wrote:
> Not sure how I missed that ... I will drop this version and replace it 
> with the proper fix.

I expect the merge window will be opening soon; I should be able to make
time on Sunday to review anything you post by then -- do you think the
next version will be out then?

I'll keep pushing through the series in the meantime.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
