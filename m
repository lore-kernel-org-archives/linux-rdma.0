From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: ib_srpt status
Date: Thu, 20 Oct 2011 09:54:10 -0700
Message-ID: <CAL1RGDW56xGXSKkHEUK3CSR2fLFCuWb5k9hEdrqi3c8Fad3+jA@mail.gmail.com>
References: <20111012092318.GA9405@lst.de> <CAO+b5-rqc7Dq-7p1XRHrxVMP9JS5N26Ht1q8ee=KGRqpUintFQ@mail.gmail.com>
 <1318956075.2454.10.camel@haakon2.linux-iscsi.org> <CAO+b5-oxcWM+Sh4t00SxPqbaNGj7uCJK8xgsoRaOxp-6Ac5EmQ@mail.gmail.com>
 <1319045907.18132.15.camel@haakon2.linux-iscsi.org> <CAO+b5-pypAr6zEXY0eS8Fv06kt-FiYOLNp2PxqqTXnRTo7tfHQ@mail.gmail.com>
 <1319049743.18132.41.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319049743.18132.41.camel-Y1+j5t8j3WgjMeEPmliV8E/sVC8ogwMJ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 19, 2011 at 11:42 AM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
>> > *) srpt_service_guid: Should this really have global scope..?
>>
>> I'm afraid that having different values of this parameter for
>> different HCAs would break failing over between HCAs.

If I have the possibility to set this per-whatever, I can of course
still choose to set it to the same value everywhere, if I care about
failover (vs. maybe providing SRP service to two different contexts).

How do I choose what value to set this to anyway?

Can we at least put this in configfs with the rest of the target
config options?  It seems like a hassle fo rme as a user to have
to set a module parameter to control this type of config.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
