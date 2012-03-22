From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 4/9] ocrdma: Driver for Emulex OneConnect RDMA adapter
Date: Thu, 22 Mar 2012 08:58:56 -0700
Message-ID: <CAL1RGDUn2b6h52uivWL5-QUMqhLDVbHqFpEEXhvq6g9xziVbYw@mail.gmail.com>
References: <1332283154-16369-1-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-2-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-3-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-4-git-send-email-parav.pandit@emulex.com>
 <a5e59a7c-d6ff-4c78-89a7-fad7492260b0@exht1.ad.emulex.com>
 <1828884A29C6694DAF28B7E6B8A8237345197AC0@ORSMSX101.amr.corp.intel.com> <88B766C272F2C64B944B21AD078333151C964A657F@EXMAIL.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <88B766C272F2C64B944B21AD078333151C964A657F-/SwythR3zqxVRK6PHKByhFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav.Pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>> Does OneConnect not support UC? =A0(I thought UC was required for
>> compliance.)

> As of now UC is unsupported. I need to check with other teams. I'll a=
dd the support in follow on checkin after this initial version, if its =
supported.
> Is it o.k. if UC is unsupported in this initial release?
> I read the IB spec.
> C17-11: HCAs shall be capable of supporting the Unreliable Datagram,
> Reliable Connection, and Unreliable Connection transport service on a=
ny
> QP supported by the HCA.

It's fine to merge the driver without UC support and add it later.  We'=
re
pretty pragmatic about things if your hardware doesn't do something
(or doesn't do something yet).

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
