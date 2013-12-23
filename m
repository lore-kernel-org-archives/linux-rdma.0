From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH V9 libmlx4 1/2] Infra-structure changes to support verbs extensions
Date: Mon, 23 Dec 2013 09:35:46 -0800
Message-ID: <CAL1RGDXmbkeyxwsxduJEq9K6x_S4-q-txiR2pziS3tX-BKV76g@mail.gmail.com>
References: <1375369555-11416-1-git-send-email-yishaih@mellanox.com> <1375369555-11416-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375369555-11416-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 1, 2013 at 8:05 AM, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> #ifdef HAVE_IBV_REGISTER_DRIVER
>  static __attribute__((constructor)) void mlx4_register_driver(void)
>  {
> -       ibv_register_driver("mlx4", mlx4_driver_init);
> +       verbs_register_driver("mlx4", mlx4_driver_init);
>  }
>  #else

So just to be clear, after this change libmlx4 will no longer build or
work with libibverbs <= 1.1.7 (1.1.8 is unreleased but is the one with
the verbs extension changes)?

If so does it make sense to have this autoconf stuff
(HAVE_IBV_REGISTER_DRIVER) for compatibility with libibverbs 1.0.x?
How hard would it be to add an autoconf check for
verbs_register_driver() and keep compatibility with libibverbs 1.1.7?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
