From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Scst-devel] [ofa-general] WinOF_2_0_5/SRP initiator: slow reads
	and eventually hangs
Date: Wed, 16 Sep 2009 08:42:19 +0200
Message-ID: <e2e108260909152342l743b9717l6bd2be8b06b7b324@mail.gmail.com>
References: <f3177b9e0908091009x23813cbdq4fbd9ebe6d8e174f@mail.gmail.com>
	 <f3177b9e0909060641i296c7aefp322712f52de9786a@mail.gmail.com>
	 <4AA4F561.504@vlnb.net>
	 <f3177b9e0909081529i4dd74faq9a6c5a4783b5ded4@mail.gmail.com>
	 <e2e108260909090938x6b72c519teed7dfd280eac804@mail.gmail.com>
	 <f3177b9e0909111250w159def51h9b720366e27fa3a7@mail.gmail.com>
	 <4AAE909F.6030202@vlnb.net>
	 <f3177b9e0909141603j2dc61663j4c6bbcc0dda631d4@mail.gmail.com>
	 <e2e108260909142310vb353718uea99d50ab638a865@mail.gmail.com>
	 <f3177b9e0909150850r2d0f5e15id7f4e14b015f68ed@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3177b9e0909150850r2d0f5e15id7f4e14b015f68ed-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 15, 2009 at 5:50 PM, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Sep 15, 2009 at 12:10 AM, Bart Van Assche
> <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Which Linux distro was installed on the inititiator and on the target
>> ? And if applicable, which OFED version ? Which kernel messages were
>> logged by SRPT around the time the issue occurred (after having
>> enabled SRPT logging first) ?
>
> This was with Ubuntu 8.10, built-in IB on the 2.6.27-14-server kernel.

A 2.6.27-14-server kernel with or without SCST patches ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
