From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Handling busy responses from the SA
Date: Fri, 04 Jun 2010 12:59:13 -0700
Message-ID: <adaocfqo9gu.fsf@roland-alpha.cisco.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAF3@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAF3-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
	(Mike Heinz's message of "Fri, 4 Jun 2010 13:30:45 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg@openfabrics.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > The purpose of this patch is to cause the ib_mad driver to discard
 > busy responses from the SA, effectively causing busy responses to
 > become time outs.

I don't have a strong opinion on this but it seems a bit odd.  If we're
just going to drop the response anyway, why did the SA send it in the
first place?  On the other hand, if the SA told us it's busy, it does
seem we could do something more sensible than retrying immediately.

Any opinions from anyone who worked on fabric scalability?

 > +				printk(KERN_NOTICE PFX "Response returned with MAD_STATUS_BUSY\n");

Do we want to spam kernel logs with this?  Seems it could generate a lot
of messages.

 > +#define IB_MGMT_MAD_STATUS_SUCCESS						0x0000
 > +#define IB_MGMT_MAD_STATUS_BUSY							0x0001
 > +#define IB_MGMT_MAD_STATUS_REDIRECT_REQD				0x0002
 > +#define IB_MGMT_MAD_STATUS_BAD_VERERSION				0x0004	
 > +#define IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD			0x0008	
 > +#define IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD_ATTRIB	0x000c
 > +#define IB_MGMT_MAD_STATUS_INVALID_ATTRIB_VALUE			0x001c

The indentation of values seems pretty crazy here.  Also I'm not sure
what most of these defines are for?  They seem unused in this patch.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
