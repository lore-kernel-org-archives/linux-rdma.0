From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 2/3 v5] IB/srp: Implement SRP_CRED_REQ and SRP_AER_REQ
Date: Wed, 18 Aug 2010 20:48:52 -0400
Message-ID: <1282178932.25848.27.camel@obelisk.thedillows.org>
References: <201008162055.02750.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201008162055.02750.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-08-16 at 20:55 +0200, Bart Van Assche wrote:
> Implements SRP_CRED_REQ and SRP_AER_REQ, which are information units defined
> in the SRP (draft) standard.  Adds declarations for the SRP_CRED_REQ,
> SRP_CRED_RSP, SRP_AER_REQ and SRP_AER_RSP information units to
> include/scsi/srp.h. Changes function definition order in ib_srp in order to
> avoid having to add more forward declarations.

I still don't like the style of this patch -- too much code duplication
and the SRP_TX_IU_* constants are too ugly to live. I'd also prefer to
put the code movement in a separate patch, so in this case I'd accept
the forward declaration and we can do a separate patch later to move the
code around in one swoop. I think there's quite a bit that can
potentially be cleaned up there, and I don't expect you to do it as part
of this series.

In that light, do you have any technical comment on the version I
posted? It is my preference to go with that version.

Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
