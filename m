From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Tue, 27 Jul 2010 10:54:30 +0300
Message-ID: <4C4E90B6.5070002@Voltaire.com>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com>	<AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com> <adamxtejbes.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adamxtejbes.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > do {
>  >     while (ib_poll_cq(cq, 1, &wc) > 0)
>  >         /* process wc */
>  > } while (ib_req_notify_cq(cq, IB_CQ_NEXT_COMP |
>  > IB_CQ_REPORT_MISSED_EVENTS) > 0);

> This approach can be used to have race-free in-order processing of
> completions using a scheme such as the NAPI processing loop used by the
> IPoIB driver (with help from the core networking stack).

Roland, I'm wasn't sure if/howmuch the results are buggy, but the IPoIB poll loop doesn't check whether the return code of ib_req_notify_cq is negative (error) or positive (more completions to poll), any thoughts on the matter?

   444		if (done < budget) {
   445			if (dev->features & NETIF_F_LRO)
   446				lro_flush_all(&priv->lro.lro_mgr);
   447	
   448			napi_complete(napi);
   449			if (unlikely(ib_req_notify_cq(priv->recv_cq,
   450						      IB_CQ_NEXT_COMP |
   451						      IB_CQ_REPORT_MISSED_EVENTS)) &&
   452			    napi_reschedule(napi))
   453				goto poll_more;
   454		}
   455	
   456		return done;
   457	}

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
