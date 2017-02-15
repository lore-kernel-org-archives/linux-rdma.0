From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Is SRP over RoCE possible?
Date: Tue, 14 Feb 2017 18:10:41 -0700
Message-ID: <CAANLjFp8ybkAwqHdoBXVtdCgnLXnqjxE-gewB4MMR-s3zj168g@mail.gmail.com>
References: <CAANLjFoJEnRERRNm34u8yonJCDqAe1d68BYb_GBTmmxVpFxpZQ@mail.gmail.com>
 <1487097898.2466.8.camel@sandisk.com> <CAANLjFqEk8MJ9+BQrqq7VFfuzbhrL=X_ht4r=qnRHLt8MOTdXw@mail.gmail.com>
 <1487104602.2466.17.camel@sandisk.com> <CAANLjFonC2UJpCSgkuRXXGdUVEa7sg0Lb9tzHpxp0zM0vit+hg@mail.gmail.com>
 <CAANLjFqrKYdAyj-c0avvnjFEmiMuQ5zc5wYzuPmNjAHgZOUo4w@mail.gmail.com> <1487116271.2466.29.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487116271.2466.29.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 14, 2017 at 4:51 PM, Bart Van Assche
<Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> On Tue, 2017-02-14 at 16:43 -0700, Robert LeBlanc wrote:
>> I got things running with SRP and SCST and I could not get the hang
>> with SRP. Thanks for your help.
>
> Hello Robert,
>
> Thank you for the testing and for the feedback to the linux-rdma mailing
> list. If switching to the NVMe-over-Fabrics protocol is not a valid
> alternative on your setup I think this means that it would be valuable
> to have SRP-over-RoCE support upstream ...

I certainly like to have as many options as possible, so I'd sure like
to see it.

I was under the impression that the backing device for
NVMe-over-Fabrics had to be an NVMe device. We are using ZFS for our
backing stores, if it could work with that I need to really
investigate that option. I'll have to do some more research on the
subject and get myself more familiar with it instead of just assuming
things based on the name.

Thank you,
Robert LeBlanc

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
