From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V2 00/11] Add RoCE v2 support
Date: Wed, 16 Dec 2015 08:56:01 +0200
Message-ID: <CAG9sBKNa4Hd0WVqhZCLeqXjc2zE2h+dBwF6zVgGT0R_Gt1FEwA@mail.gmail.com>
References: <1449150450-13679-1-git-send-email-matanb@mellanox.com>
	<CAG9sBKM7j6w+Gk4PXXO+0mHpFeVaBdeNmr-z9V9fPR562o+kmw@mail.gmail.com>
	<567089F1.30004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <567089F1.30004-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The part that bothers me about this is that this statement makes sense
> when just thinking about the spec, as you say.  However, once you
> consider namespaces, security implications make this statement spec
> compliant, but still unacceptable.  The spec itself is silent on
> namespaces.  But, you guys wanted, and you got, namespace support.
> Since that's beyond spec, and carries security requirements, I think
> it's fair to say that from now on, the Linux kernel RDMA stack can no
> longer *just* be spec compliant.  There are additional concerns that
> must always be addressed with new changes, and those are the namespace
> constraint preservation concerns.

I can't object to that but I really would like to get an example of a
security risk.
So far, besides hearing that the way we choose to handle completions
is wrong, I didn't get a convincing example of how where it doesn't
work. Moreover, regarding security, all we wanted is for HW to report
the L3 protocol (IB, IPv4, or IPv6) in the packet. This is data that
with some extra CPU cycles can be obtained from the 40 bytes that are
scattered to the receive bufs anyway. So, if there is a security hole
it exists from day one of the IB stack and this is not the time we
should insist on fixing it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
