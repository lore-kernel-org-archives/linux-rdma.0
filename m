From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CQ and RDMA READ/WRITE APIs
Date: Wed, 18 May 2016 21:24:39 +0530
Message-ID: <CAG53R5X=u4M8xgn_9Z9rSuhaBhci-qWNBZo6Nfz5Rovp1bzGVA@mail.gmail.com>
References: <743399f9-10b7-6e62-2bf4-6a8656df8a55@redhat.com>
	<20160516114926.GA681@lst.de>
	<f6fdfc59-8193-18ed-0449-a16bba4601e0@redhat.com>
	<CA+55aFzq+4DJL46B8PXQQG-DpNpzZNzk=O6j+8U_NC6H6BwTdQ@mail.gmail.com>
	<6633ce02-7983-ad09-f95d-03cea6f54e31@redhat.com>
	<573B550D.5020008@sandisk.com>
	<732fb772-2f21-3ac9-a35a-aa4383734df5@redhat.com>
	<CAG53R5VSjz_G1adajcoUdgh3Sf1yyKf7UREFoNF9x_V+N6oR6A@mail.gmail.com>
	<43b558b1-8400-612c-9b27-6539be080871@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <43b558b1-8400-612c-9b27-6539be080871-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 18, 2016 at 7:37 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 05/17/2016 10:48 PM, Parav Pandit wrote:
>> Hi Doug,
>>
>> On Tue, May 17, 2016 at 11:02 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> Nice catch there Bart.  That was well before my role as maintainer and
>>> so settles things well enough for me.  IOW, I don't feel I need to worry
>>> about trying to maintain the dual license nature of the RDMA stack as it
>>> was broken long before I took over.  Thanks for pointing that out.
>>>
>>
>> Does it mean we can submit new code files under GPL only license?
>
> You always could.
>
>> I submitted RDMA cgroup related code in ib_core under GPLv2 only license.
>
> You did and you didn't.  For instance, in patch 1/3, the new
> cgroup_rdma.c file has a notice of GPLv2, but no notice of copyright, so
> it's incomplete.  You need to put a copyright notice in the file too.
> And in the file cgroup_rdma.h you have neither a copyright notice or a
> license statement.  It's a plain file.
>
> In patch 2/3, the file infiniband/core/cgroup.c has a copied dual
> license (not necessary, it can be GPL only), but again, it is missing
> the copyright notice.
>
ok. I will fix this part too in v11.

> You need to finish the conversation you and Christoph were having in
> that thread, but you also need a v11 of the patchset that fixes the
> copyright issues.
>
Yes. I will ping Christoph and Tejun as I am waiting for their responses.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
