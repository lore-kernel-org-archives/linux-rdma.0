From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] Adding support for Debian packaging
Date: Fri, 22 Feb 2013 08:07:48 -0800
Message-ID: <CAL1RGDVaiOp84E3SfF6nUkNvjrAeUE=32EdmWusmWZSZqRJ_Qw@mail.gmail.com>
References: <1361441897-19486-1-git-send-email-ilyan@mellanox.com> <CABweQmK6zBZSeeLShS8MpcFu6oHVvNw6CF_3sWbqe1dGM-BeUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABweQmK6zBZSeeLShS8MpcFu6oHVvNw6CF_3sWbqe1dGM-BeUg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Narayan Desai <narayan.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 21, 2013 at 12:53 PM, Narayan Desai <narayan.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Also, are you planning to try getting these pushed upstream into debian?
> thanks.

libibumad is already packaged in Debian:
http://packages.debian.org/search?keywords=libibumad

I don't think having this (different) packaging in the upstream
libibumad package would be helpful.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
