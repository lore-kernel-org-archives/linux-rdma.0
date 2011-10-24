From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 6/9] ib_srpt: Remove legacy use_port_guid_in_session_name
 module parameter
Date: Mon, 24 Oct 2011 20:24:04 +0200
Message-ID: <CAO+b5-oe9H7g9=fbfGSTbRZreA=hDKgtBAG3xFjvsgedCNv0rw@mail.gmail.com>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org> <1319434422-15354-7-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319434422-15354-7-git-send-email-nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 24, 2011 at 7:33 AM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> This patch removes the legacy use_port_guid_in_session_name module parameter
> that is no longer required in modern ib_srpt code.

The patch looks fine to me but the description could be improved: the
"use_port_guid_in_session_name" had been introduced in the past to
work around a limitation of the Windows SRP initiator in multipath
setups. Apparently with recent Windows SRP initiator versions setting
that parameter is no longer necessary.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
