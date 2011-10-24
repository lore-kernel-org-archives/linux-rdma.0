From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 5/9] ib_srpt: Fix sport->port_guid formatting code
Date: Mon, 24 Oct 2011 21:57:17 +0200
Message-ID: <CAO+b5-pcNWgt1uxT2gH6KvDhdkkP1hbBbYnt81f-gHVr_UhdBg@mail.gmail.com>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org> <1319434422-15354-6-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319434422-15354-6-git-send-email-nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 24, 2011 at 7:33 AM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 snprintf(sport->port_guid, sizeof(sport=
->port_guid),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "0x0000=
000000000000%016llx",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 be64_to=
_cpu(sport->gid.global.interface_id));

If I interpret Roland's e-mail correctly Roland asked to use GID table
entry 0 (http://www.spinics.net/lists/linux-rdma/msg09751.html) ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
