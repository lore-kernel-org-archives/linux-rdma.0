From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: RFC: FMR support in SRP
Date: Fri, 19 Sep 2014 18:04:07 +0200
Message-ID: <CAMGffE=BG6JS7C3ZZ_pwUV3AyHDtG8i49RR2PmXZo+ZT18M5XA@mail.gmail.com>
References: <CAMGffEkN4OmJVi6UV7PtRYq5q3XZfJVTEaJFqvypx0W8Aq8cRA@mail.gmail.com>
 <541C380B.1000803@acm.org> <CAMGffEmjzsYsOTnaPWPr4D7TDCbwcoxM8Lr2kDNWCnBOpP5k-A@mail.gmail.com>
 <541C485B.60302@acm.org> <CAMGffE=AobYJe_r=0He-U=bH6WLSsKi_Bx-S0YeH_68gE96o7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMGffE=AobYJe_r=0He-U=bH6WLSsKi_Bx-S0YeH_68gE96o7A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 19, 2014 at 5:35 PM, Jinpu Wang <jinpu.wang-EIkl63zCoXbZz8UjPX3odA@public.gmane.org=
m> wrote:
>>
>>
>> Hello Jack,
>>
>> Did you know that file descriptor 0 corresponds to stdin ? With comm=
and-line
>> option -w the test program reads data from stdin and sends that data=
 to a
>> SCSI device. I think the test program is waiting for you to provide =
input
>> data :-)
>>
>> Bart.
>>
> Thanks Bart,
>
> Now I know it:)
>
> This command works, generated 128 descriptors.
> ./discontiguous-io -l 512  -s /dev/sdb
>
>
>
> Thanks a lot.
>
>
> --
> Mit freundlichen Gr=C3=BC=C3=9Fen,
> Best Regards,
>
> Jack Wang

Another question, in srp_map_finish_fmr, the desc va is set to 0,
could you point me how SRP protect multiple rdma operation write to
same
addr?  or different fmr-rkey will protect this?

--=20

Best Regards,

Jack Wang
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
