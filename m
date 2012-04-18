From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: kernel: rejected SRP_LOGIN_REQ because creating a new RDMA
 channel failed.
Date: Wed, 18 Apr 2012 13:21:43 -0700
Message-ID: <CAL1RGDXCtfK8L_Gt2BWwYWKySMjMY6sS8eOzUJXe9S6UW9Qkkw@mail.gmail.com>
References: <105692b8ae6e4f11fae2848be32f88d7@omrb.pnpi.spb.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <105692b8ae6e4f11fae2848be32f88d7-heEE5zn7HfaV8fSEjHp0FA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 18, 2012 at 2:07 AM, Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org> wrote:
> Apr 18 13:04:01 store kernel: mlx4_core 0000:4b:00.0: command 0x19 failed: fw status = 0x9

status 0x9 is:

        /* Resource is not in the appropriate state or ownership: */
        CMD_STAT_BAD_RES_STATE  = 0x09,

Bart, I seem to remember you had tracked this down to a bug in the SRPT code?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
