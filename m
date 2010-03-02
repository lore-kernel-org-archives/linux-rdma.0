From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: SRP initiator and iSER initiator performance
Date: Tue, 2 Mar 2010 07:59:14 +0100
Message-ID: <e2e108261003012259o7c9b217j5011006e3a772d6a@mail.gmail.com>
References: <e2e108261002271127x253faa84lf6eb8aa77d3cf51a@mail.gmail.com>
	 <4B8C1FBF.8060001@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B8C1FBF.8060001-d+Crzxg7Rs0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Cc: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 1, 2010 at 9:12 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wrote:
> [ ... ]
> It's good if my impression was wrong. But you've got suspiciously low IOPS
> numbers. On your hardware you should have much more. Seems you experienced a
> bottleneck on the initiator somewhere above the drivers level (fio? sg
> engine? IRQs or context switches count?), so your results could be not
> really related to the topic. Oprofile and lockstat output can shed more
> light on this.

You didn't understand the purpose of the test. My goal was not to
achieve record IOPS numbers but to stress the SRP and iSER initiators
as much as possible. I choose the sg I/O engine in order to bypass the
block layer.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
