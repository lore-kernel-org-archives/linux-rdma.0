From: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: get_maintainer.pl bug?
Date: Wed, 24 Jan 2018 07:33:37 -0500
Message-ID: <d59f884f-e15f-fb9c-3d0d-303eb20c24b4@redhat.com>
References: <20180124112323.GA8265@yuvallap>
 <20180124115445.GH1393@mtr-leonro.local>
Reply-To: jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180124115445.GH1393-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 01/24/2018 06:54 AM, Leon Romanovsky wrote:
> On Wed, Jan 24, 2018 at 01:23:24PM +0200, Yuval Shaia wrote:
>> Hi,
>> This is what i get when running scripts/get_maintainer.pl drivers/infiniband/:
>>
>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (supporter:INFINIBAND SUBSYSTEM)
>> Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> (supporter:INFINIBAND SUBSYSTEM)
>> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:INFINIBAND SUBSYSTEM)
>> linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list)
>>
>> However section "INFINIBAND SUBSYSTEM" pointed out a different address for
>> Jason:
>>
>> INFINIBAND SUBSYSTEM
>> M:      Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> M:      Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> L:      linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> W:      http://www.openfabrics.org/
>> Q:      http://patchwork.kernel.org/project/linux-rdma/list/
>> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
>> S:      Supported
>> F:      Documentation/devicetree/bindings/infiniband/
>> F:      Documentation/infiniband/
>> F:      drivers/infiniband/
>> F:      include/uapi/linux/if_infiniband.h
>> F:      include/uapi/rdma/
>> F:      include/rdma/
>>
>> So
>> - Which one is the correct one?
>> - What am i doing wrong when using scripts/get_maintainer.pl?
>>
> 
> Both are correct, and the jgg-uk2M96/98Pc@public.gmane.org email is taken from .mailmap
> file.

Hello Yuval Shaia,

Also providing --nomailmap to get_maintainer.pl will get what is
displayed in the MAINTAINERS file. From a linus tree, hash
1f07476ec143bbed7bf0b641749783b1094b4c4f:

$ ./scripts/get_maintainer.pl --nomailmap drivers/infiniband/
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (supporter:INFINIBAND SUBSYSTEM)
Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> (supporter:INFINIBAND SUBSYSTEM)
linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:INFINIBAND SUBSYSTEM)
linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list)


Hope this helps,
-Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
