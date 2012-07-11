From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH libibverbs] memory: use SCNxPTR format to read uintptr_t values
Date: Wed, 11 Jul 2012 08:47:05 -0700
Message-ID: <CAL1RGDUQiWdSYbCH8k7Bwu8y549wQtQ7=tPA1G=uJuGW76G4hA@mail.gmail.com>
References: <1342019435-10041-1-git-send-email-ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342019435-10041-1-git-send-email-ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 11, 2012 at 8:10 AM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
> @@ -116,7 +117,7 @@ static unsigned long get_page_size(void *base)
>                 int n;
>                 uintptr_t range_start, range_end;
>
> -               n = sscanf(buf, "%lx-%lx", &range_start, &range_end);
> +               n = sscanf(buf, "%" SCNxPTR "-%" SCNxPTR, &range_start, &range_end);
>
>                 if (n < 2)
>                         continue;

Looks fine in itself, and I don't necessarily expect you to be the one
to answer, but:

 - what does /proc/<pid>/maps show when running a 32-bit process on a 64-bit
   kernel?  Should we be using uint64_t / SCNx64?  (but surely 32-bit processes
   are guaranteed to have all their mappings fit into 32 bits)

 - earlier in this function, why do we do /proc/%d/maps, getpid()?  Why doesn't
   /proc/self/maps always work?

Thanks,
  Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
