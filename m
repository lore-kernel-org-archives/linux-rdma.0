From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] libhns: Fix endian format of payload and
 immediate
Date: Thu, 16 Nov 2017 13:52:17 +0800
Message-ID: <2ff6455b-0ac4-3ca7-b780-8224bf00bc35@huawei.com>
References: <1509530440-164400-1-git-send-email-oulijun@huawei.com>
 <1509530440-164400-4-git-send-email-oulijun@huawei.com>
 <20171101161328.GB7815@ziepe.ca>
 <8dbc8305-f154-3b8c-795a-b5f1a6b53c73@huawei.com>
 <20171102150655.GD18874@ziepe.ca>
 <b2e9430c-a801-bef1-a491-8f983a525cab@huawei.com>
 <20171110211818.GH17451@ziepe.ca>
 <ef20c38b-201c-a039-c7c4-c5878fd0ee1c@huawei.com>
 <20171115153436.GO25894@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115153436.GO25894-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ÔÚ 2017/11/15 23:34, Jason Gunthorpe Ð´µÀ:
> On Wed, Nov 15, 2017 at 06:02:23PM +0800, oulijun wrote:
>> As a result, I alos re-run the cmds:
>> mkdr build-sparse
>> cd build-sparse
>>  CC=cgcc cmake -GNinja ..
>>
>> The print log is:
>> ubuntu@a8d50a1f660b:~/rdma-v16/rdma-core/build-sparse$ CC=cgcc cmake -GNinja ..
>> Traceback (most recent call last):
>>   File "/home/ubuntu/rdma-v16/rdma-core/buildlib/gen-sparse.py", line 137, in <module>
>> Patch from '/home/ubuntu/rdma-v16/rdma-core/buildlib/sparse-include/23/sys-socket.h.diff' failed
>> Unable to apply any patch to 'sys/socket.h', tries 1
>> Patch from '/home/ubuntu/rdma-v16/rdma-core/buildlib/sparse-include/25/netinet-in.h.diff' failed
>> Patch from '/home/ubuntu/rdma-v16/rdma-core/buildlib/sparse-include/23/netinet-in.h.diff' failed
>>     raise ValueError("Patch applications failed");
>> ValueError: Patch applications failed
>> CMake Error at buildlib/RDMA_Sparse.cmake:27 (message):
>>   glibc header file patching for sparse failed.  Review include/*.rej and fix
>>   the rejects, then do /home/ubuntu/rdma-v16/rdma-core/buildlib/gen-sparse.py
>>   -out /home/ubuntu/rdma-v16/rdma-core/build-sparse/include/ --src
>>   /home/ubuntu/rdma-v16/rdma-core/ --save
>> Call Stack (most recent call first):
>>   CMakeLists.txt:148 (RDMA_CheckSparse)
> 
> Okay, this is a different error, which version of ubuntu are you
> using? I will fix it for you
> 
> Jason
> 
  My os is ubuntu 14.04
 the print info by uname -a is:
Linux a8d50a1f660b 4.2.0-27-generic #32~14.04.1-Ubuntu SMP Fri Jan 22 15:32:26 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

Lijun Ou
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
