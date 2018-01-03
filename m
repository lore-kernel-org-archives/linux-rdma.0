From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Linux kernel v4.15-rc4 and rdma_rxe
Date: Wed, 3 Jan 2018 07:13:52 +0200
Message-ID: <CAG9sBKPhnknQPYX=s-y9-tonxTRrE05gU5W75x0FhKmTdggFmQ@mail.gmail.com>
References: <1513732236.2535.25.camel@wdc.com> <CAG9sBKP=i9ukbkj7x11oW=yLAz8u2RYHTMbf_Z1h3=nQ3pjfLw@mail.gmail.com>
 <1513983674.2579.27.camel@wdc.com> <CAG9sBKOOvvwG6yaQfWG=c04-LQ-Yvw8QbD-jzTm-zJYOFJeEVQ@mail.gmail.com>
 <dd87887d-8641-c8fc-48f1-234e7cf67cb1@wdc.com> <CAG9sBKOtxoG-HLU5A=WEZqUuADzje74_AjZgtG21Ueeb2YCAEQ@mail.gmail.com>
 <1514940799.14857.20.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514940799.14857.20.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Does this perhaps mean that the rxe_qp structure can be freed while rxe_do_task()
> is in progress? Please note that the ib_srpt driver only destroys a QP
> (srpt_destroy_ch_ib() call in srpt_release_channel_work()) after all SCSI command
> processing has finished (transport_deregister_session()).
>
> Thanks,
>
> Bart.
Hi Bart
If I understand right you say that the system is hung when trying to
take a lock in rxe_do_taks() (line 89). Is that right?
Anyway, It's possible that you hit a bug related to destroying a QP.

thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
