From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] DAPL v2.0: cma: disconnect can block for excessive
 times waiting for rdma_cm DREP timeout
Date: Fri, 3 Dec 2010 16:16:06 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8A96F27@orsmsx501.amr.corp.intel.com>
References: <E3280858FA94444CA49D2BA02341C983011C4D94F6@orsmsx506.amr.corp.intel.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8A96ECB@orsmsx501.amr.corp.intel.com>
 <E3280858FA94444CA49D2BA02341C983011C4D9564@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E3280858FA94444CA49D2BA02341C983011C4D9564-osO9UTpF0URZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >> @@ -636,13 +637,29 @@ dapls_ib_disconnect(IN DAPL_EP * ep_ptr, IN
> >> DAT_CLOSE_FLAGS close_flags)
> >>
> >>  	/* ABRUPT close, wait for callback and DISCONNECTED state */
> >>  	if (close_flags == DAT_CLOSE_ABRUPT_FLAG) {
> >> +		DAPL_EVD *evd = NULL;
> >> +		DAT_EVENT_NUMBER num = DAT_CONNECTION_EVENT_DISCONNECTED;
> >> +
> >>  		dapl_os_lock(&ep_ptr->header.lock);
> >> -		while (ep_ptr->param.ep_state != DAT_EP_STATE_DISCONNECTED) {
> >> +		/* limit DREP waiting, other side could be down */
> >> +		while (--drep_time && ep_ptr->param.ep_state !=
> >> DAT_EP_STATE_DISCONNECTED) {
> >>  			dapl_os_unlock(&ep_ptr->header.lock);
> >>  			dapl_os_sleep_usec(10000);
> >
> >gak - can't you wait on an event using some timeout interval?
> >
> 
> if rdma_cm would give me separate timeout interval choices
> for connect requests and disconnect requests than by all
> means I would use it for this abrupt disconnect timeout/retry
> interval.

That's a separate issue.  I'm suggesting to replace

while (not in the right state)
	retries--;
	sleep(timeout);

with

wait_for_event(disconnected_event, total timeout);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
