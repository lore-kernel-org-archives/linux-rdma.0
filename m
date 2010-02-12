From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 02/02] RDMA/nes: listener destroyed during loopback setup crash
Date: Fri, 12 Feb 2010 12:01:53 -0800
Message-ID: <F76A888F6A4D47848B20E1F578081E61@amr.corp.intel.com>
References: <20100212195704.GA71688@flatif-MOBL>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100212195704.GA71688@flatif-MOBL>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, -c@vger.kernel.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>@@ -1011,9 +1011,10 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core
>*cm_core,
> 					event.cm_info.loc_port =
> 							 loopback->loc_port;
> 					event.cm_info.cm_id = loopback->cm_id;
>+					add_ref_cm_node(loopback);
>+					loopback->state = NES_CM_STATE_CLOSED;

It seems odd to increment a reference count in a function with the name
'dec_refcnt'.  Is there a better name for mini_cm_dec_refcnt_listen?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
