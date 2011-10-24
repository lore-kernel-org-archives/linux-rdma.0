From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 7/9] ib_srpt: Convert srp_max_rdma_size into per port
 configfs attribute
Date: Mon, 24 Oct 2011 18:34:00 +0200
Message-ID: <CAO+b5-q+SPZNv-c8Qnho3pzj6xqjTEu9cMAJGeCEr6qquHLScw@mail.gmail.com>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org> <1319434422-15354-8-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319434422-15354-8-git-send-email-nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 24, 2011 at 7:33 AM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> This patch converts the srp_max_rdma_size module parameter into a per
> endpoint configfs attribute. =A0This includes adding the necessary bi=
ts
> for show + store attributes w/ min/max bounds checking, and updating
> srpt_get_ioc() to accept a struct srpt_port parameter.
>
> [ ... ]
>
> -static void srpt_get_ioc(struct srpt_device *sdev, u32 slot,
> +static void srpt_get_ioc(struct srpt_port *sport, u32 slot,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ib_dm_mad *mad=
)

The SRP spec says that there should be only one value for
iocp->rdma_size per I/O controller. This patch breaks that rule. I'm
not sure it's a good idea to introduce such behavior changes.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
