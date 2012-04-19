From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: kernel: rejected SRP_LOGIN_REQ because creating a new RDMA channel
 failed.
Date: Thu, 19 Apr 2012 06:41:26 +0000
Message-ID: <4F8FB396.6010200@acm.org>
References: <105692b8ae6e4f11fae2848be32f88d7@omrb.pnpi.spb.ru> <CAL1RGDXCtfK8L_Gt2BWwYWKySMjMY6sS8eOzUJXe9S6UW9Qkkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXCtfK8L_Gt2BWwYWKySMjMY6sS8eOzUJXe9S6UW9Qkkw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 04/18/12 20:21, Roland Dreier wrote:

> On Wed, Apr 18, 2012 at 2:07 AM, Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org> wrote:
>> Apr 18 13:04:01 store kernel: mlx4_core 0000:4b:00.0: command 0x19 failed: fw status = 0x9
> 
> status 0x9 is:
> 
>         /* Resource is not in the appropriate state or ownership: */
>         CMD_STAT_BAD_RES_STATE  = 0x09,
> 
> Bart, I seem to remember you had tracked this down to a bug in the SRPT code?


ib_destroy_cm_id() must be invoked before srpt_destroy_ch_ib() otherwise
srpt_ch_qp_err() can get invoked after a QP has already been freed and
reused. The patch that fixes this issue for the SCST version of ib_srpt
can be found here:
http://scst.svn.sourceforge.net/viewvc/scst?view=revision&revision=4139.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
