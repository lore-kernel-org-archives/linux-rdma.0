From: Narayan Desai <narayan.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] Adding support for Debian packaging
Date: Fri, 22 Feb 2013 10:14:04 -0600
Message-ID: <CABweQmLHm8o0yTm3Jh_C6uXvhA1d1=HJJ_f25EkmQL_WyTqUEA@mail.gmail.com>
References: <1361441897-19486-1-git-send-email-ilyan@mellanox.com>
	<CABweQmK6zBZSeeLShS8MpcFu6oHVvNw6CF_3sWbqe1dGM-BeUg@mail.gmail.com>
	<CAL1RGDVaiOp84E3SfF6nUkNvjrAeUE=32EdmWusmWZSZqRJ_Qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVaiOp84E3SfF6nUkNvjrAeUE=32EdmWusmWZSZqRJ_Qw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ah, sorry. I was speaking imprecisely; while the a bunch of the ib
libraries are pretty well maintained in debian/ubuntu, the management
tools are ancient. (this is why i built my PPA for ubuntu)

I think there would be a lot of value in keeping those up to date in
the distributions (or at least with an apt source) as well.
 -nld

On Fri, Feb 22, 2013 at 10:07 AM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
> On Thu, Feb 21, 2013 at 12:53 PM, Narayan Desai <narayan.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Also, are you planning to try getting these pushed upstream into debian?
>> thanks.
>
> libibumad is already packaged in Debian:
> http://packages.debian.org/search?keywords=libibumad
>
> I don't think having this (different) packaging in the upstream
> libibumad package would be helpful.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
