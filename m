From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Quick mlx4 IB SR-IOV howto?
Date: Wed, 26 Sep 2012 23:30:31 +0200
Message-ID: <CAJZOPZJPZfO60ZbVeYVCPjqRZXtfuzt3PNcvKpUM+Mm6KQefaQ@mail.gmail.com>
References: <CAL1RGDU0XPCyS6fVeHHxnhLHpREjqi6kjKFCX8hBwrLuVD2HwA@mail.gmail.com>
	<CAJZOPZLZQVjFj0P3SrU8hmsz5XNM3QR7HEsxrn5C755hxkWszQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLZQVjFj0P3SrU8hmsz5XNM3QR7HEsxrn5C755hxkWszQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 26, 2012 at 10:22 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Wed, Sep 26, 2012 at 7:14 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
>> What do I need for the slave VF's port to become active?
>> I'm running opensm 3.3.13 on a different box, is that new enough?
>> (does SR-IOV require any SM support?)
>
> Yes, as Hal noted, at minimum you need opensm 3.3.14


Roland, did this help? do you have IB link for the VF? IPoIB working on it?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
