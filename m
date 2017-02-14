From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Is SRP over RoCE possible?
Date: Tue, 14 Feb 2017 23:51:23 +0000
Message-ID: <1487116271.2466.29.camel@sandisk.com>
References: <CAANLjFoJEnRERRNm34u8yonJCDqAe1d68BYb_GBTmmxVpFxpZQ@mail.gmail.com>
         <1487097898.2466.8.camel@sandisk.com>
         <CAANLjFqEk8MJ9+BQrqq7VFfuzbhrL=X_ht4r=qnRHLt8MOTdXw@mail.gmail.com>
         <1487104602.2466.17.camel@sandisk.com>
         <CAANLjFonC2UJpCSgkuRXXGdUVEa7sg0Lb9tzHpxp0zM0vit+hg@mail.gmail.com>
         <CAANLjFqrKYdAyj-c0avvnjFEmiMuQ5zc5wYzuPmNjAHgZOUo4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFqrKYdAyj-c0avvnjFEmiMuQ5zc5wYzuPmNjAHgZOUo4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <6B321F3181EBB24AA7F9295E2CF06EB1-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org" <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-02-14 at 16:43 -0700, Robert LeBlanc wrote:
> I got things running with SRP and SCST and I could not get the hang
> with SRP. Thanks for your help.

Hello Robert,

Thank you for the testing and for the feedback to the linux-rdma mailing
list. If switching to the NVMe-over-Fabrics protocol is not a valid
alternative on your setup I think this means that it would be valuable
to have SRP-over-RoCE support upstream ...

Bart.--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
