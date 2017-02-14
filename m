From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Is SRP over RoCE possible?
Date: Tue, 14 Feb 2017 20:36:57 +0000
Message-ID: <1487104602.2466.17.camel@sandisk.com>
References: <CAANLjFoJEnRERRNm34u8yonJCDqAe1d68BYb_GBTmmxVpFxpZQ@mail.gmail.com>
         <1487097898.2466.8.camel@sandisk.com>
         <CAANLjFqEk8MJ9+BQrqq7VFfuzbhrL=X_ht4r=qnRHLt8MOTdXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFqEk8MJ9+BQrqq7VFfuzbhrL=X_ht4r=qnRHLt8MOTdXw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <8D25E8433733C946A92742BFD3E0AB56-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org" <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-02-14 at 13:34 -0700, Robert LeBlanc wrote:
> Trying to add "options ib_srpt rdma_cm_port=5000" gives me this error.
> 
> [   25.318411] ib_srpt: unknown parameter 'rdma_cm_port' ignored

Does this mean that you are not familiar with SCST? I referred explicitly
to the SCST ib_srpt kernel module in my e-mail.

Bart.--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
