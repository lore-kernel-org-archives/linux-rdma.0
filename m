From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RESEND] ib/iser: re-write SG handling for rdma logic
Date: Mon, 09 Nov 2009 15:07:54 +0200
Message-ID: <4AF8142A.3070506@voltaire.com>
References: <Pine.LNX.4.64.0911010824010.4388@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.0911010824010.4388-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Alexander Nezhinsky <alexandern-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> This patch re-writes the logic that does the above, to make it clearer and simpler. It also fixes a bug in the being aligned for rdma checks, where a "start" check wasn't done but rather only "end" check.
>   
Roland, I don't see this patch in your for-next branch, any reason not 
to merge this?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
