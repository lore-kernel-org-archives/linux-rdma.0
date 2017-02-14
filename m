From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Is SRP over RoCE possible?
Date: Tue, 14 Feb 2017 13:52:23 -0700
Message-ID: <CAANLjFonC2UJpCSgkuRXXGdUVEa7sg0Lb9tzHpxp0zM0vit+hg@mail.gmail.com>
References: <CAANLjFoJEnRERRNm34u8yonJCDqAe1d68BYb_GBTmmxVpFxpZQ@mail.gmail.com>
 <1487097898.2466.8.camel@sandisk.com> <CAANLjFqEk8MJ9+BQrqq7VFfuzbhrL=X_ht4r=qnRHLt8MOTdXw@mail.gmail.com>
 <1487104602.2466.17.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487104602.2466.17.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 14, 2017 at 1:36 PM, Bart Van Assche
<Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> On Tue, 2017-02-14 at 13:34 -0700, Robert LeBlanc wrote:
>> Trying to add "options ib_srpt rdma_cm_port=5000" gives me this error.
>>
>> [   25.318411] ib_srpt: unknown parameter 'rdma_cm_port' ignored
>
> Does this mean that you are not familiar with SCST? I referred explicitly
> to the SCST ib_srpt kernel module in my e-mail.

I haven't used SCST in almost a decade, favoring LIO. Using SCST may
compromise the goal of running SRP which is if I can reproduce the
iSER hang that I've been experiencing with SRP. That would help
pinpoint if the bug is in iSER, ib_core, or the Mellanox drivers. With
compiling SCST modules, I'm not sure how much that will invalidate my
thought process. I'm still going to give it a try.

Thanks,
Robert

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
