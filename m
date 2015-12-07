From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V2 05/11] IB/core: Add rdma_network_type to wc
Date: Mon, 7 Dec 2015 20:39:33 +0200
Message-ID: <CAG9sBKP32pW+22w5Sr_6ybzK9GHOAPzSTV8_E5e-UOFcJKqUnQ@mail.gmail.com>
References: <20151207111945.48b52fb35c6f209c51bccbb9807b6df0.d873ff1393.wbe@email24.secureserver.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207111945.48b52fb35c6f209c51bccbb9807b6df0.d873ff1393.wbe-wCzC33v8tqnShzhksYgB+AejPw4fNl8p@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 7, 2015 at 8:19 PM,  <cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org> wrote:
> Moni Shoua asked:
>
>
>
>> but how? all you have in hand is the sgid which can appear several
>
>> times in the GID table in different indices.
>
>
> Step back and review the context.
>
> Adding an extra field to the WC is *not* going to redesign the hardware.

This is where you have a mistake. Hardware is already designed that
way. Mellanox NICs completion info have network_type indication of the
packet for which the completion refers to.
BTW, hardware that doesn't support network_type will still work. In
that case it is the SW indeed that finds the network_type but the
method for doing this should be avoided as much as possible.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
