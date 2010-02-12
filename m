From: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 02/02] RDMA/nes: listener destroyed during loopback
 setup crash
Date: Fri, 12 Feb 2010 13:15:06 -0700
Message-ID: <B6AF6A496EB3F84096209458E19C94EE791E9F1B@azsmsx501.amr.corp.intel.com>
References: <20100212195704.GA71688@flatif-MOBL>
 <F76A888F6A4D47848B20E1F578081E61@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F76A888F6A4D47848B20E1F578081E61-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "-c@vger.kernel.org" <-c@vger.kernel.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The add_ref_cm_node() is not for listener node but for the active side node of a loopback connection. For loopback's active node, its refcount gets decremented in cm_event_connect_error(). This is a error handling case.

Faisal


>-----Original Message-----
>From: Hefty, Sean
>Sent: Friday, February 12, 2010 2:02 PM
>To: Latif, Faisal; Roland Dreier; -c@vger.kernel.org; linux-
>rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: RE: [PATCH 02/02] RDMA/nes: listener destroyed during loopback
>setup crash
>
>>@@ -1011,9 +1011,10 @@ static int mini_cm_dec_refcnt_listen(struct
>nes_cm_core
>>*cm_core,
>> 					event.cm_info.loc_port =
>> 							 loopback->loc_port;
>> 					event.cm_info.cm_id = loopback->cm_id;
>>+					add_ref_cm_node(loopback);
>>+					loopback->state = NES_CM_STATE_CLOSED;
>
>It seems odd to increment a reference count in a function with the name
>'dec_refcnt'.  Is there a better name for mini_cm_dec_refcnt_listen?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
