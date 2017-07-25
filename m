From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-core 16/21] srp_daemon: Do not use LOG_PERROR
Date: Tue, 25 Jul 2017 16:47:59 +0000
Message-ID: <1501001276.8931.1.camel@wdc.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
         <1500926429-31822-17-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-17-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <A517BC2C6C3F4F40802CD2C79635A23F-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org" <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-07-24 at 14:00 -0600, Jason Gunthorpe wrote:
> When running from systemd syslog will send messages to the log, but
> so will stderr. Thus using LOG_PERROR doubles every log message.
>=20
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  srp_daemon/srp_daemon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
> index c0e8d23d58faf5..f0dfe260945574 100644
> --- a/srp_daemon/srp_daemon.c
> +++ b/srp_daemon/srp_daemon.c
> @@ -2090,7 +2090,7 @@ int main(int argc, char *argv[])
>  		goto restore_sig;
>  	}
> =20
> -	openlog("srp_daemon", LOG_PID | LOG_PERROR, LOG_DAEMON);
> +	openlog("srp_daemon", LOG_PID, LOG_DAEMON);
> =20
>  	config =3D calloc(1, sizeof(*config));
>  	if (!config) {

Hello Jason,

LOG_PERROR is very convenient when debugging srp_daemon. How about using
the result of isatty(STDERR_FILENO) to decide whether or not to enable
LOG_PERROR?

All the other srp_daemon-related patches in this series look fine to me.
Thank you for having done this work!

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
