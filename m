From: Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Bug#881731: rdma-core: FTBFS on armhf and mips*: missing providers that need coherent DMA
Date: Tue, 14 Nov 2017 15:41:13 -0500
Message-ID: <7f295a93-e27e-6661-7e57-743818e12ef5@redhat.com>
References: <151067381730.19157.7563136692092597267.reportbug@ghostwheel.internal.ucko.debian.net> <20171114190805.GF4263@ziepe.ca> <151067381730.19157.7563136692092597267.reportbug@ghostwheel.internal.ucko.debian.net>
Reply-To: Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 881731-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114190805.GF4263-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, 881731-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/14/2017 02:08 PM, Jason Gunthorpe wrote:
>> However, it would of course be better to teach udma_barrier.h about
>> these architectures.
>
> The issue is that some architectures just can't do cache coherent DMA
> on any implementation. eg m68k
>
> There is no correct udma_barrier.h at all in those cases.
>
> We need to teach debian to follow cmake and exclude the missing
> installables in these cases..
>
> Or do not build at all on these arch's..
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Jason:
Why am I being cc'd on this debian bug?
I also received a notice about a bug fix in debian, and I had zip to do with it.

Is my name tagged in Debian wrt rdma for some reason? by someone? other?

-dd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
