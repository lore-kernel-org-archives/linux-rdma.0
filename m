From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 for-next 0/7] Add support for multicast loopback
 prevention to mlx4
Date: Wed, 7 Oct 2015 18:36:37 +0300
Message-ID: <56153C05.1020001@mellanox.com>
References: <1440081275-15864-1-git-send-email-eranbe@mellanox.com>
 <CAKHjkjnQNqeLu+irEg97a1hcKp_ziXsDOFaTRwcaPpZAX_fMng@mail.gmail.com>
 <560AD75A.7080700@redhat.com>
 <CAJ3xEMiuPEJZ5EQueC=8wQyok2QbEaywQ3gRYVpqOwSaFQcj0A@mail.gmail.com>
 <5613F145.3040204@redhat.com>
 <CAJ3xEMhsr5uRLZ=Ur56TOpZy5XT3UbK=M1kcgjt=zx_x3HNcSQ@mail.gmail.com>
 <56143C8E.9090407@redhat.com>
 <CAJ3xEMiNk2ZXgg_Ji5dg+ahL_D5_RAvEzEEhMsPDjC-PJYDu7Q@mail.gmail.com>
 <56153A0C.4040006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56153A0C.4040006-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/7/2015 6:28 PM, Doug Ledford wrote:
> However, the machine is still crashing the iDRAC on reboot.  I can't be
> certain if it's the SRP target or iSER target causing this as they both
> were brought up live at the same time and reboot cycles without either
> of these work fine.  So I have more investigation to go before I know
> exactly what's going on.  And as I pointed out, each iteration is slow :-/

You may want to move to run with the lightweight user-space iSER target 
(TGT) it's provided with Fedora
and also with RHEL7 using the unsupported addons (forgot how you call that)

And anyway, Sagi suggested to help, so, please make use of his brainpower

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
