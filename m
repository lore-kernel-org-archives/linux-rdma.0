From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: ib_srpt status
Date: Wed, 19 Oct 2011 20:09:24 +0200
Message-ID: <CAO+b5-pypAr6zEXY0eS8Fv06kt-FiYOLNp2PxqqTXnRTo7tfHQ@mail.gmail.com>
References: <20111012092318.GA9405@lst.de> <CAO+b5-rqc7Dq-7p1XRHrxVMP9JS5N26Ht1q8ee=KGRqpUintFQ@mail.gmail.com>
 <1318956075.2454.10.camel@haakon2.linux-iscsi.org> <CAO+b5-oxcWM+Sh4t00SxPqbaNGj7uCJK8xgsoRaOxp-6Ac5EmQ@mail.gmail.com>
 <1319045907.18132.15.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319045907.18132.15.camel-Y1+j5t8j3WgjMeEPmliV8E/sVC8ogwMJ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 19, 2011 at 7:38 PM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> Btw, Roland asked me to take a look at the current set of module
> parameters for ib_srpt, and see which could be removed and/or convert=
ed
> to per SPR target endpoint configfs attributes.. =A0So on that note, =
a few
> questions for you on a couple of the module parameters:
>
> *) use_port_guid_in_session_name: This appears to be a legacy compat
> =A0 item, can this be safetly removed for mainline..?

As far as I know some people are still using this parameter.

> *) srpt_service_guid: Should this really have global scope..?

I'm afraid that having different values of this parameter for
different HCAs would break failing over between HCAs.

> Aside from those, i'm currently having a look to see which of the mod=
ule
> parameters are not used in the initial srpt_add_one() setup path, and
> that using per SRP target endpoint configfs attributes would make sen=
se.

My opinion is that the parameters used in srpt_add_one() also should
be converted from module parameters into something that is
configurable dynamically. ib_srpt users have already been asking to
make e.g. srp_max_req_size configurable dynamically. It should be
doable to reallocate the receive ring when there are no active
sessions.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
