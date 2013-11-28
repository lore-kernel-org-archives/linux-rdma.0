From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH librdmacm] Add directives on binding to IPv6 any address
 to man pages
Date: Thu, 28 Nov 2013 20:03:24 +0200
Message-ID: <CAJZOPZ+2+h-DuyK3V_AcyfLXHP3dEqobPrUDkA+LaVzeFsTYmA@mail.gmail.com>
References: <1385653101-12452-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385653101-12452-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael R Hines <mrhines-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 28, 2013 at 5:38 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Explain how to bind to IPv6 any address in the man pages for the examples
>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  man/rping.1    |    1 +
>  man/ucmatose.1 |    1 +
>  man/udaddy.1   |    1 +
>  3 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/man/rping.1 b/man/rping.1
> index a2b7b6b..127d290 100644
> --- a/man/rping.1
> +++ b/man/rping.1
> @@ -23,6 +23,7 @@ Run as the client.
>  .TP
>  \-a address
>  On the server, specifies the network address to bind the connection to.
> +To bind to any address with IPv6 use -a ::0 .
>  On the client, specifies the server address to connect to.
>  .TP
>  \-p
> diff --git a/man/ucmatose.1 b/man/ucmatose.1
> index 95dc2d6..154b60a 100644
> --- a/man/ucmatose.1
> +++ b/man/ucmatose.1
> @@ -23,6 +23,7 @@ This option must be specified by the client.
>  .TP
>  \-b bind_address
>  The local network address to bind to.
> +To bind to any address with IPv6 use -a ::0 .

oops, cut & paste bug here and for udaddy too... it should be -b ::0,
will fix and send you V1...


>  .TP
>  \-f address_format
>  Specifies the format of the server and bind address.  Be default, the
> diff --git a/man/udaddy.1 b/man/udaddy.1
> index 2f56b46..dd01420 100644
> --- a/man/udaddy.1
> +++ b/man/udaddy.1
> @@ -22,6 +22,7 @@ This option must be specified by the client.
>  .TP
>  \-b bind_address
>  The local network address to bind to.
> +To bind to any address with IPv6 use -a ::0 .
>  .TP
>  \-c connections
>  The number of communication paths to establish between the client and server.
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
