From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Force line-buffering in ibv_asyncwatch
Date: Thu, 21 Jan 2010 15:18:12 +0100
Message-ID: <e2e108261001210618p476ed03bofa2e46c223578e1a@mail.gmail.com>
References: <ED0695A5-CBE3-4CE2-A20C-BBC7BEF28C33@Sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ED0695A5-CBE3-4CE2-A20C-BBC7BEF28C33-U0mLk4xYmo8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-xsfywfwIY+M@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 21, 2010 at 2:40 PM, H=E5kon Bugge <Haakon.Bugge-xsfywfwIY+M@public.gmane.org> w=
rote:
> ibv_asyncwatch defaults to block-buffering when stdout is redirected =
to a file or pipe. This fix makes it more usable in scripted environmen=
ts.
>
> Signed-off-by: Hakon Bugge <Haakon.Bugge-xsfywfwIY+M@public.gmane.org>
> ---
> diff --git a/examples/asyncwatch.c b/examples/asyncwatch.c
> index e56b4dc..f9fe6ff 100644
> --- a/examples/asyncwatch.c
> +++ b/examples/asyncwatch.c
> @@ -98,6 +98,9 @@ int main(int argc, char *argv[])
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 /* Force line-buffering if stdout is redirected */
> + =A0 =A0 =A0 setlinebuf(stdout);
> +
> =A0 =A0 =A0 =A0printf("%s: async event FD %d\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ibv_get_device_name(*dev_list), context->=
async_fd);

It might be a good idea to replace setlinebuf() by setvbuf().
setlinebuf() is a BSD function while setvbuf is POSIX (see also
http://opengroup.org/onlinepubs/009695399/functions/setvbuf.html).

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
