From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: OpenSM: reporting traps 129, 130, 131
Date: Sun, 08 Nov 2009 16:37:02 +0200
Message-ID: <4AF6D78E.6080600@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

I noticed that OpenSM doesn't send InformInfo on traps 129/130/131.
This is what osm_trap_rcv.c is doing:

322: static void trap_rcv_process_request(IN osm_sm_t * sm,
323: 				     IN const osm_madw_t * p_madw)
... 

435: 		if (ib_notice_is_generic(p_ntci) &&
436: 		    (p_ntci->g_or_v.generic.trap_num == CL_HTON16(129) ||
437: 		     p_ntci->g_or_v.generic.trap_num == CL_HTON16(130) ||
438: 		     p_ntci->g_or_v.generic.trap_num == CL_HTON16(131))) {
439: 			/* If this is a trap 129, 130, or 131 - then this is a
440: 			 * trap signaling a change on a physical port.
441: 			 * Mark the physp_change_trap flag as TRUE.
442: 			 */
443: 			physp_change_trap = TRUE;
...

539:	/* If we reached here due to trap 129/130/131 - do not need to do
540:	   the notice report. Just goto exit. We know this is the case
541:	   if physp_change_trap is TRUE. */
542:	if (physp_change_trap == TRUE)
543:		goto Exit;


Any particular reason why there's no reporting of these traps?

-- Yevgeny


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
