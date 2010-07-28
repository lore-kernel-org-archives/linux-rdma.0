From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Wed, 28 Jul 2010 10:44:02 -0700
Message-ID: <ada1vanfqn1.fsf@roland-alpha.cisco.com>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com>
	<AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com>
	<adamxtejbes.fsf@roland-alpha.cisco.com>
	<4C4E90B6.5070002@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C4E90B6.5070002-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org> (Or Gerlitz's message of "Tue, 27
	Jul 2010 10:54:30 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Roland, I'm wasn't sure if/howmuch the results are buggy, but the
 > IPoIB poll loop doesn't check whether the return code of
 > ib_req_notify_cq is negative (error) or positive (more completions to
 > poll), any thoughts on the matter?

I think I had two things in mind here:

 - I don't know of any drivers that actually return any errors ever from
   req_notify_cq so it's not really a practical concern.

 - If we did get an error, there's not much we can do except keep
   polling and try to request notification again later -- exactly the
   same thing we would do if we got a positive return value.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
