From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: RFC: FMR support in SRP
Date: Sat, 20 Sep 2014 08:24:58 +0200
Message-ID: <541D1DBA.7010004@acm.org>
References: <CAMGffEkN4OmJVi6UV7PtRYq5q3XZfJVTEaJFqvypx0W8Aq8cRA@mail.gmail.com> <541C380B.1000803@acm.org> <CAMGffEmjzsYsOTnaPWPr4D7TDCbwcoxM8Lr2kDNWCnBOpP5k-A@mail.gmail.com> <541C485B.60302@acm.org> <CAMGffE=AobYJe_r=0He-U=bH6WLSsKi_Bx-S0YeH_68gE96o7A@mail.gmail.com> <CAMGffE=BG6JS7C3ZZ_pwUV3AyHDtG8i49RR2PmXZo+ZT18M5XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMGffE=BG6JS7C3ZZ_pwUV3AyHDtG8i49RR2PmXZo+ZT18M5XA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/19/14 18:04, Jinpu Wang wrote:
> Another question, in srp_map_finish_fmr, the desc va is set to 0,
> could you point me how SRP protect multiple rdma operation write to
> same addr?  or different fmr-rkey will protect this?

Hello Jack,

As you can see in srpt_map_sg_to_ib_sge() in the SRP target driver the 
virtual address (db->va) and rkey (db->key) are always used in 
combination - the virtual address is never used alone. Please note that 
this not only holds for FMR but also for FR. More information can be 
found in paragraph "10.6.2 MEMORY REGISTRATION" in the InfiniBand 
Architecture Specification.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
