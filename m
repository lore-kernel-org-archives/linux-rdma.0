From: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RFC: FMR support in SRP
Date: Sat, 20 Sep 2014 10:41:21 +0200
Message-ID: <CAD+HZHWztW1pvXMuRawwL8_vS1FPmPsYbfdYQXpZAFU4aJHJ1w@mail.gmail.com>
References: <CAMGffEkN4OmJVi6UV7PtRYq5q3XZfJVTEaJFqvypx0W8Aq8cRA@mail.gmail.com>
	<541C380B.1000803@acm.org>
	<CAMGffEmjzsYsOTnaPWPr4D7TDCbwcoxM8Lr2kDNWCnBOpP5k-A@mail.gmail.com>
	<541C485B.60302@acm.org>
	<CAMGffE=AobYJe_r=0He-U=bH6WLSsKi_Bx-S0YeH_68gE96o7A@mail.gmail.com>
	<CAMGffE=BG6JS7C3ZZ_pwUV3AyHDtG8i49RR2PmXZo+ZT18M5XA@mail.gmail.com>
	<541D1DBA.7010004@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <541D1DBA.7010004-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2014-09-20 8:24 GMT+02:00 Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>:
>
> On 09/19/14 18:04, Jinpu Wang wrote:
>>
>> Another question, in srp_map_finish_fmr, the desc va is set to 0,
>> could you point me how SRP protect multiple rdma operation write to
>> same addr?  or different fmr-rkey will protect this?
>
>
> Hello Jack,
>
> As you can see in srpt_map_sg_to_ib_sge() in the SRP target driver the virtual address (db->va) and rkey (db->key) are always used in combination - the virtual address is never used alone. Please note that this not only holds for FMR but also for FR. More information can be found in paragraph "10.6.2 MEMORY REGISTRATION" in the InfiniBand Architecture Specification.
>
> Bart.
>

Hello Bart,

Thanks for your informative reply, I will go through InfiniBand
Architecture Spec to understand memory registration better.

Have a nice weekend!

Jack




>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
