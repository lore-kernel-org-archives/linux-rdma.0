From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs] XRC - Sample application issues
Date: Mon, 19 Aug 2013 13:12:16 -0600
Message-ID: <20130819191216.GA29493@obsidianresearch.com>
References: <1375974336-26314-1-git-send-email-yishaih@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237388CA64F6@ORSMSX109.amr.corp.intel.com>
 <63247C4015478741AE4981C62DF608835683DDC8@MTLDAG01.mtl.com>
 <52108E6C.9070908@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52108E6C.9070908-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, jay.e.sternberg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 18, 2013 at 12:05:48PM +0300, Yishai Hadas wrote:
> On 8/16/2013 06:11 PM, Sean Hefty wrote:
> >>@@ -884,6 +884,13 @@ int main(int argc, char *argv[])
> >>  	if (ctx.use_event)
> >>  		ibv_ack_cq_events(ctx.recv_cq, num_cq_events);
> >>
> >>+	/* Process should wait before closing its resources to make sure
> >>+	  * latest daemon's response sent via its target QP destined to an XSRQ
> >>+	  * created by another client won't be lost.
> >>+	  * Failure to do so will cause the client to wait for that sent message
> >>forever.
> >>+	  * See comment on pp_post_send.
> >>+	*/
> >>+	sleep(1);
> >I dislike adding sleep calls into code.  Isn't there a more robust way to handle this?
> 
> In general I agree this sleep is a workaround that comes to solve a
> synchronization hole in this sample application.  For that reason I
> put 5 lines comment to describe the problem and the reason for that
> sleep statement.  Long term you could think of synchronizing all the
> processes through the sockets mechanism to assure they terminate
> when all packets are received.

This example is very close to the only code that people will have
access to when trying to work with XRC.

It should be complete and correct under all cases. So no sleeps, IMHO.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
