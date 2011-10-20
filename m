From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: ib_srpt status
Date: Thu, 20 Oct 2011 09:51:57 -0700
Message-ID: <CAL1RGDUfzRXfbc3hpF6s8v-Qo2_okXB8J-jDgQ79ELHe-x3yvg@mail.gmail.com>
References: <20111012092318.GA9405@lst.de> <CAO+b5-rqc7Dq-7p1XRHrxVMP9JS5N26Ht1q8ee=KGRqpUintFQ@mail.gmail.com>
 <1318956075.2454.10.camel@haakon2.linux-iscsi.org> <CAO+b5-oxcWM+Sh4t00SxPqbaNGj7uCJK8xgsoRaOxp-6Ac5EmQ@mail.gmail.com>
 <1319045907.18132.15.camel@haakon2.linux-iscsi.org> <CAO+b5-pypAr6zEXY0eS8Fv06kt-FiYOLNp2PxqqTXnRTo7tfHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-pypAr6zEXY0eS8Fv06kt-FiYOLNp2PxqqTXnRTo7tfHQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 19, 2011 at 11:09 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> =
wrote:
>> *) use_port_guid_in_session_name: This appears to be a legacy compat
>> =A0 item, can this be safetly removed for mainline..?
>
> As far as I know some people are still using this parameter.

So what exactly does this parameter do?  How do I as a user
know what to set this to?

=46or mainline can we just decide what the right value of this is
and get rid of the parameter?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
