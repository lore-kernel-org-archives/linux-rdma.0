From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] libhns: Fix endian format of payload and
 immediate
Date: Wed, 8 Nov 2017 10:05:22 +0800
Message-ID: <b2e9430c-a801-bef1-a491-8f983a525cab@huawei.com>
References: <1509530440-164400-1-git-send-email-oulijun@huawei.com>
 <1509530440-164400-4-git-send-email-oulijun@huawei.com>
 <20171101161328.GB7815@ziepe.ca>
 <8dbc8305-f154-3b8c-795a-b5f1a6b53c73@huawei.com>
 <20171102150655.GD18874@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102150655.GD18874-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ÔÚ 2017/11/2 23:06, Jason Gunthorpe Ð´µÀ:
> On Thu, Nov 02, 2017 at 02:03:18PM +0800, oulijun wrote:
>>>  mkdr build-sparse
>>>  cd build-sparse
>>>  CC=cgcc cmake -GNinja ..
>>>  ninja
>>>
>> I have run the sparse successful and don't understand the result.
> 
> Something is wrong with your local environment:
> 
>> [10/190] Building C object util/CMakeFiles/rdma_util_pic.dir/mmio.c.o
>> /usr/include/linux/types.h:4:11: error: unable to open 'asm/types.h'
> 
> Those headers should exist, they usually come with glibc, eg on Debian
> it comes from here:
> 
> linux-libc-dev:amd64: /usr/include/x86_64-linux-gnu/asm/types.h
> 
> Jason
> 
> 
Hi, Jason
   I have trying to run sparse according to your way and it is always fail in
the last two days.
   the print log is
	/usr/include/linux/types.h:4:11: error: unable to open 'asm/types.h'

   I do some steps for attempt resolving it and it is fail.
   1). I am trying to change the files' limit
	chmod 757 /usr/include/x86_64-linux-gnu/asm/*
   2). I am also trying to run the cmd
	sudo CC=cgcc cmake -GNinja ..
 	sudo ninja
   3). And I am trying to do others for asking my colleague.

   Can you give some good advice for me?

  My OS environment:
  OS: ubuntu

thanks
Lijun Ou

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
