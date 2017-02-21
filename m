From: Josh Beavers <josh.beavers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: librxe license file (and others) missing from repo
Date: Tue, 21 Feb 2017 15:47:34 -0500
Message-ID: <CAE=AiOPFhpe-VA-xkk8-5JK1RiepCndnSXv0ZD=xCaR9RXQieA@mail.gmail.com>
References: <CAE=AiOMmMGhcGSm2fh+y9EwQ+LMQ-CQhiMoCXtnb9gvEsQ-bjQ@mail.gmail.com>
 <CAE=AiONzova5SQ+L=OeqbUnWp7wpc6G10rR2xUYVSj_UcuNb1w@mail.gmail.com> <20170221204622.GA13616@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170221204622.GA13616-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Majd and Jason,

Thank you!  I was confused since the Linux kernel SoftROCE component
(http://lxr.free-electrons.com/source/drivers/infiniband/sw/rxe/Kconfig)
still references SoftRoCE/rxe-dev, which in turn references
librxe-dev.

I will switch over to the linux-rdma repo.

-Josh




On Tue, Feb 21, 2017 at 3:46 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Feb 21, 2017 at 03:29:04PM -0500, Josh Beavers wrote:
>> Greetings,
>>
>> I am looking at https://github.com/SoftRoCE/librxe-dev for the RXE user
>> space code.  However, several files such as COPYING and README appear to be
>> completely empty.  Is there an official source for the full files?
>
> The source has moved here:
>
> https://github.com/linux-rdma/rdma-core
>
> and is properly licensed in its new location.
>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
