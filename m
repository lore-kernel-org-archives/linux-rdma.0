From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibmad: To reserve upper 8 bits of tid used by solaris
 SRIOV driver
Date: Wed, 20 Mar 2013 15:11:51 -0700
Message-ID: <CAMLCd9LOuajya0_s4NhuUD4hUtHnc_NLi8sELnsEprash6t5Eg@mail.gmail.com>
References: <513F8386.5070208@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <513F8386.5070208-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Why does this need to be done in user space?  This seems like
something which should be done in the kernel for all Transaction ID's
which might be sent to the umad layer.

Ira

On Tue, Mar 12, 2013 at 12:35 PM, Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> From: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>
> Signed-off-by: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> src/mad.c |    3 +++
> 1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/src/mad.c b/src/mad.c
> index 70a69dd..fb5f5eb 100644
> --- a/src/mad.c
> +++ b/src/mad.c
> @@ -62,6 +62,9 @@ uint64_t mad_trid(void)
>                 trid = random();
>         }
>         next = ++trid | (base << 32);
> +#if defined(__SVR4) && defined(__sun)
> +       next &= 0x00ffffffffffffff;
> +#endif
>         return next;
> }
>
> --
> 1.7.1
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
