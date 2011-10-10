From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] RDMA/nes: Print ip address for critcal errors
Date: Mon, 10 Oct 2011 12:14:31 -0700
Message-ID: <CAG4TOxO0nRZOy9RkuVBTeQbQKB32d+e2Z-yLp58x1bSUf-k=yg@mail.gmail.com>
References: <20110926013344.GA5260@FLATIF-MOBL4> <CAL1RGDU+xag8AtQ18yrZmqU24u9QM6cajhca4MmrCGtmPbxKLg@mail.gmail.com>
 <2EFBCAEF10980645BBCFB605689E08E904EC29E1CE@azsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2EFBCAEF10980645BBCFB605689E08E904EC29E1CE-uLM7Qlg6MbdZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Actually I fixed it up myself, please check my result :)

On Mon, Oct 10, 2011 at 12:00 PM, Latif, Faisal <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org=
> wrote:
> Hi Roland,
>
> Sorry for late reply. Yes %pI4 would be a lot cleaner. Do you want me=
 to resubmit this patch again?
>
> Thanks
> Faisal
>
>
>> -----Original Message-----
>> From: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org [mailto:roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org] On Beha=
lf
>> Of Roland Dreier
>> Sent: Thursday, October 06, 2011 2:54 PM
>> To: Latif, Faisal
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: [PATCH 2/3] RDMA/nes: Print ip address for critcal erro=
rs
>>
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR PFX "Remote ip addr =
=3D %u.%u.%u.%u\n",
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rem_addr[3], rem_add=
r[2], rem_addr[1],
>> rem_addr[0]);
>>
>> Any reason this couldn't use %pI4 and be a lot cleaner?
>>
>> =A0- R.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
