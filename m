From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V2 00/11] Add RoCE v2 support
Date: Wed, 16 Dec 2015 11:13:12 -0700
Message-ID: <20151216181312.GE32594@obsidianresearch.com>
References: <1449150450-13679-1-git-send-email-matanb@mellanox.com>
 <CAG9sBKM7j6w+Gk4PXXO+0mHpFeVaBdeNmr-z9V9fPR562o+kmw@mail.gmail.com>
 <567089F1.30004@redhat.com>
 <CAG9sBKNa4Hd0WVqhZCLeqXjc2zE2h+dBwF6zVgGT0R_Gt1FEwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKNa4Hd0WVqhZCLeqXjc2zE2h+dBwF6zVgGT0R_Gt1FEwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 16, 2015 at 08:56:01AM +0200, Moni Shoua wrote:

> I can't object to that but I really would like to get an example of a
> security risk.

How can anyone give you an example when nobody knows exactly how mlx
hardware works in this area?

>From an kapi prespective, the security design is very simple.

Every single UD packet the kapi side has to process must be
unambiguously associated with a gid_index or dropped. Period full
stop. I would think that is an obvious conclusion based on the design
of the gid cache.

This is why we need a clear API to get this critical information. It
should not be open coded in init_ah_from_wc, it should not be done
some other way in the CMA code.

This is a simple matter of sane kapi design, nothing more.

I have no idea why this is so objectionable.

> scattered to the receive bufs anyway. So, if there is a security hole
> it exists from day one of the IB stack and this is not the time we
> should insist on fixing it.

IB isn't interacting with the net stack in the same way rocev2 is, so
this is not a pre-existing problem.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
