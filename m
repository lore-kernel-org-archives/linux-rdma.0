From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] Handling busy responses from the SA
Date: Mon, 7 Jun 2010 10:14:48 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DBEA@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAF3@MNEXMB1.qlogic.org>
 <adaocfqo9gu.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaocfqo9gu.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier said:

> I don't have a strong opinion on this but it seems a bit odd.  If we're just going to drop the response anyway, why did the SA send it in the first place?  On the other hand, if the SA told us it's busy, it does seem we could do something more sensible than retrying immediately.

The spec provides for the SA to return a BUSY response. When that happens, this patch causes us to wait for the original request to time out before retrying, not trying again immediately. In effect, we are pretending we never got the BUSY response and allowing the request to time out, instead.

Roland Dreier said:

> The indentation of values seems pretty crazy here.  Also I'm not sure what most of these defines are for?  They seem unused in this patch.

The indentation is probably from the conversion of tabs to spaces when the patch was pasted into the email - correcting it is no problem.  The value IB_MGMT_MAD_STATUS_BUSY is used in the patch, the others are defined because they are the other possible values for the same status field. We might as well define them all, for completeness.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
