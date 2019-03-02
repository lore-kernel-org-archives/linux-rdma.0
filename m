From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 1/2] CIFS: Fix a bug with re-sending wdata when transport
 returning -EAGAIN
Date: Fri, 1 Mar 2019 23:43:22 -0600
Message-ID: <CAH2r5mt0=W54eWaH6JBEm9sfD8BWCqecV7SakC5U14QbYhChzA@mail.gmail.com>
References: <20190302025146.2935-1-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190302025146.2935-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Long Li <longli@microsoft.com>
Cc: Steve French <sfrench@samba.org>, CIFS <linux-cifs@vger.kernel.org>, samba-technical <samba-technical@lists.samba.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

I tested this vs. Samba a few minutes ago with test 208 - looks like
it works.   Thank you!

Now just need some additional reviews as this can be a complex area of code.

On Fri, Mar 1, 2019 at 9:04 PM Long Li <longli@linuxonhyperv.com> wrote:
>
> From: Long Li <longli@microsoft.com>
>
> When sending a wdata, transport may return -EAGAIN. In this case
> we should re-obtain credits because the session may have been
> reconnected.
>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/file.c | 61 +++++++++++++++++++++++++-------------------------
>  1 file changed, 31 insertions(+), 30 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 9b53f33137b3..08e73759d6ec 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2620,43 +2620,44 @@ cifs_resend_wdata(struct cifs_writedata *wdata, struct list_head *wdata_list,
>         struct TCP_Server_Info *server =
>                 tlink_tcon(wdata->cfile->tlink)->ses->server;
>
> -       /*
> -        * Wait for credits to resend this wdata.
> -        * Note: we are attempting to resend the whole wdata not in segments
> -        */
>         do {
> -               rc = server->ops->wait_mtu_credits(server, wdata->bytes, &wsize,
> -                                                  &credits);
> -
> -               if (rc)
> -                       goto out;
> -
> -               if (wsize < wdata->bytes) {
> -                       add_credits_and_wake_if(server, &credits, 0);
> -                       msleep(1000);
> -               }
> -       } while (wsize < wdata->bytes);
> +               /*
> +                * Wait for credits to resend this wdata.
> +                * Note: we are attempting to resend the whole wdata not in
> +                * segments
> +                */
> +               do {
> +                       rc = server->ops->wait_mtu_credits(server, wdata->bytes,
> +                                               &wsize, &credits);
> +                       if (rc)
> +                               goto fail;
> +
> +                       if (wsize < wdata->bytes) {
> +                               add_credits_and_wake_if(server, &credits, 0);
> +                               msleep(1000);
> +                       }
> +               } while (wsize < wdata->bytes);
>
> -       wdata->credits = credits;
> -       rc = -EAGAIN;
> -       while (rc == -EAGAIN) {
> +               wdata->credits = credits;
>                 rc = 0;
>                 if (wdata->cfile->invalidHandle)
>                         rc = cifs_reopen_file(wdata->cfile, false);
>                 if (!rc)
>                         rc = server->ops->async_writev(wdata,
> -                                       cifs_uncached_writedata_release);
> -       }
> +                               cifs_uncached_writedata_release);
>
> -       if (!rc) {
> -               list_add_tail(&wdata->list, wdata_list);
> -               return 0;
> -       }
> +               /* If the write was successfully sent, we are done */
> +               if (!rc) {
> +                       list_add_tail(&wdata->list, wdata_list);
> +                       return 0;
> +               }
>
> -       add_credits_and_wake_if(server, &wdata->credits, 0);
> -out:
> -       kref_put(&wdata->refcount, cifs_uncached_writedata_release);
> +               /* Roll back credits and retry if needed */
> +               add_credits_and_wake_if(server, &wdata->credits, 0);
> +       } while (rc == -EAGAIN);
>
> +fail:
> +       kref_put(&wdata->refcount, cifs_uncached_writedata_release);
>         return rc;
>  }
>
> @@ -2884,12 +2885,12 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
>                                                 wdata->bytes, &tmp_from,
>                                                 ctx->cfile, cifs_sb, &tmp_list,
>                                                 ctx);
> +
> +                                       kref_put(&wdata->refcount,
> +                                               cifs_uncached_writedata_release);
>                                 }
>
>                                 list_splice(&tmp_list, &ctx->list);
> -
> -                               kref_put(&wdata->refcount,
> -                                        cifs_uncached_writedata_release);
>                                 goto restart_loop;
>                         }
>                 }
> --
> 2.17.1
>


-- 
Thanks,

Steve
