From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH/RFC] RDMA/iwpm: Fix uninitialized error code in iwpm_send_mapinfo()
Date: Thu, 16 Nov 2017 11:50:48 +0100
Message-ID: <CAK8P3a2D6dnQELKww5V-=mNAzrD-XQoWtNTXCmgMtsnFnujq5A@mail.gmail.com>
References: <1510827964-11100-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510827964-11100-1-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 16, 2017 at 11:26 AM, Geert Uytterhoeven
<geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org> wrote:
> With gcc-4.1.2:
>
>     drivers/infiniband/core/iwpm_util.c: In function =E2=80=98iwpm_send_m=
apinfo=E2=80=99:
>     drivers/infiniband/core/iwpm_util.c:647: warning: =E2=80=98ret=E2=80=
=99 may be used uninitialized in this function
>
> Indeed, if nl_client is not found in any of the scanned has buckets, ret
> will be used uninitialized.
>
> Preinitialize ret to zero to fix this.
>
> Fixes: 30dc5e63d6a5ad24 ("RDMA/core: Add support for iWARP Port Mapper us=
er space service")
> Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
> ---
> RFC as I have no idea if this can ever happen, and if yes, what's the
> correct behavior to handle it:
>   - return 0,
>   - return an error code,
>   - don't send anything,
>   - anything else?

This looks like a reasonable warning. I don't see on my box with any compil=
er
version. Do you have a configuration I can use to reproduce it, I'd just li=
ke
to see out of curiosity which other compilers report it.

Looking at one caller (iwpm_mapping_info_cb), it seems that we try to make
sure that nl_client is valid first by calling iwpm_valid_client(), and retu=
rning
-EINVAL otherwise, so that seems like an appropriate return code if any
caller forgets to test for iwpm_valid_client() first.

      Arnd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
