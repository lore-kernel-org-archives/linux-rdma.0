From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V9 libibverbs 0/7] Add extension and XRC QP support
Date: Mon, 16 Dec 2013 22:25:42 +0200
Message-ID: <CAJZOPZLwuD0v9RosvVY8uVUiAzMveGnn9=e5POfWEfRn8o8e=Q@mail.gmail.com>
References: <1375369459-9231-1-git-send-email-yishaih@mellanox.com>
	<CAL1RGDXiyOCBjQAJP_XVeAJ-y6Kgz+MfuOOB2bFr+km6-q5T7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXiyOCBjQAJP_XVeAJ-y6Kgz+MfuOOB2bFr+km6-q5T7Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 16, 2013 at 9:16 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
> OK, I finally got to merge this to libibverbs.  Please take a look at
> my libibverbs git tree and let me know if there is any issue with the
> verbs extensions or XRC support.

Roland, your libibverbs tree which includes the verbs extensions and
xrc  patches can't really be tested for the new functionality before
you pick the two XRC patches to libmlx4

https://patchwork.kernel.org/patch/2837142/
https://patchwork.kernel.org/patch/2837141/

so please do.

>
> I will probably cut a new libibverbs release in about a week if this
> looks good to everyone.


Lets have the libmlx4 patches there too before cutting this release.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
