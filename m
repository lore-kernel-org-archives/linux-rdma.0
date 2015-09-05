From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH libibverbs] Add support for TX/RX checksum offload
Date: Sat, 5 Sep 2015 22:59:35 +0300
Message-ID: <CAJ3xEMheigQt29mmb50PKHsXfx8pXMex+3bgJeobF0JBAjHsNQ@mail.gmail.com>
References: <1439826618-3015-1-git-send-email-bodong@mellanox.com>
	<55EA2C3D.2080904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55EA2C3D.2080904-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Sep 5, 2015 at 2:41 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 08/17/2015 11:50 AM, Bodong Wang wrote:
>> Add a device capability flag IBV_DEVICE_IP_CSUM to denote IPv4 checksum
>> offload support. Devices should set this flag if they support
>> insertion/verification of IPv4, TCP and UDP checksums on
>> outgoing/incoming IPv4 packets sent over IB UD or ETH RAW PACKET QPs.
>
> Correct me if I'm wrong, but the only reason this is only supported on
> UD and RAW ETH QPs is a matter of current firmware.  There's no reason
> it couldn't be supported on RC, right?

Doug,

The context here is the ability of the user-space RDMA verbs
infrastructure to serve as the baseline for implementing user-space
TCP/IP offloads engines. Such engines would be production worthy in
open-systems environments mostly when they are inter-operable which
whatever stack runs on the other end --> they must not put any
additional bits on the wire --> RC isn't an option, so for IPoIB we
just need an IPoIB UD QP in user space, and for Ethernet RAW PACKET
QP. This device capability is there  ~10y for IB UD and we just
naturally extend it to Eth RAW. If/when a vendor comes up with
supporting csum for RC, we can add another dev cap and say the well
established API applies on them too, with just a slight modification
to man pages and such, makes sense?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
