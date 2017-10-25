From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 rdma-core 0/5] Userspace library matching for hip08
 RoCE
Date: Wed, 25 Oct 2017 17:28:14 +0800
Message-ID: <40aa3621-b26b-8afc-7ce0-236659d9155c@huawei.com>
References: <1508851309-183263-1-git-send-email-oulijun@huawei.com>
 <20171024152836.GJ16127@mtr-leonro.local>
 <20171025053833.GN16127@mtr-leonro.local>
 <7689f70b-746a-44b8-91b3-81294d83b2a6@huawei.com>
 <20171025073430.GO16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171025073430.GO16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2017/10/25 15:34, Leon Romanovsky 写道:
> On Wed, Oct 25, 2017 at 02:29:26PM +0800, oulijun wrote:
>> 在 2017/10/25 13:38, Leon Romanovsky 写道:
>>> On Tue, Oct 24, 2017 at 06:28:36PM +0300, Leon Romanovsky wrote:
>>>> On Tue, Oct 24, 2017 at 09:21:44PM +0800, Lijun Ou wrote:
>>>>> This patch series add userspace library for hip08 RoCE driver. It will
>>>>> work with the kernel driver of hip08 RoCE(hns-roce-hw-v2.ko).
>>>>>
>>>>> Change from V2:
>>>>> - Fix the spelling with referred
>>>>> - Eliminate the warning by travis-CI
>>>>>
>>>>> Change from V1:
>>>>> - Fix build warning due to the strange placement of fprintf
>>>>>
>>>>
>>>> I created pull request, but Travis CI doesn't seem like working.
>>>> https://github.com/linux-rdma/rdma-core/pull/230
>>>>
>>>> I'll try to restart it a little bit later.
>>>
>>> OK, I gave up and rerun it locally and it fails to compile.
>>>
>>> Did you run cbuild travis?
>>>
>> Sorry, I have tried to run cbuild travis before send PATCH V2 and it is ok.
>> I also run it according to you provide way. it is print as follows:
>> oulijun@Turing-Arch-b:~/rdma/rdma-core/buildlib$ python2 cbuild pkg travis
> 
> I don't know if it matters, but I run the cbuild from top-directory,
> e.g. python2 buildlib/cbuild ...
> 
> Can i assume that you run "cbuild build-image travis" and "cbuild make travis" before?
> Did it finish successfully?
> 
> From the error below seems like you had an issue with your internet
> connection.
> 
> Thanks
> 
Hi, leon
  Thank your advice again.
  I have made an effort to install the all tools in order to run cbuild scripts according to you help.
  I also read the README.md with submit patch. I have run cbuild build-images travis and cbuild pkg travis for
  check PATCHV4 before send it.
  I also run it by forking rdma-core to my local github and build it.

Thanks
Lijun Ou
> 
>> HEAD is now at d0a1424 libhns: Update consolidate repo for userspace library of hip08 RoCE
>> fatal: unable to access 'https://github.com/linux-rdma/rdma-core.git/': Failed to connect to github.com port 443: Connection timed out
>> Traceback (most recent call last):
>>   File "cbuild", line 789, in <module>
>>     args.func(args);
>>   File "cbuild", line 618, in cmd_pkg
>>     run_travis_build(args,env);
>>   File "cbuild", line 565, in run_travis_build
>>     "master"]);
>>   File "/usr/lib/python2.7/subprocess.py", line 540, in check_call
>>     raise CalledProcessError(retcode, cmd)
>> subprocess.CalledProcessError: Command '['git', '--git-dir', '/home/oulijun/rdma/rdma-core/.git', 'fetch', '--no-tags', 'https://github.com/linux-rdma/rdma-core.git', 'HEAD', 'master']' returned non-zero exit status 128
>>
>>
>>> ➜  rdma-core git:(2017-10-24-2) python2 ./buildlib/cbuild pkg travis
>>> <....>
>>> [70/183] Building C object providers/i40iw/CMakeFiles/i40iw-rdmav16.dir/i40iw_umain.c.o
>>> FAILED: /usr/bin/gcc-7  -Dhns_rdmav16_EXPORTS -Werror -m32  -std=gnu11 -Wall -Wextra -Wno-sign-compare -Wno-unused-parameter -Wmissing-prototypes -Wmissing-declarations -Wwrite-strings -Wformat=2 -Wshadow -Wstrict-prototypes -Wold-style-definition -Wredundant-decls -O2 -g  -fPIC -Iinclude -MMD -MT providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o -MF "providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o.d" -o providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o   -c ../providers/hns/hns_roce_u_hw_v2.c
>>> ../providers/hns/hns_roce_u_hw_v2.c: In function 'get_send_wqe':
>>> ../providers/hns/hns_roce_u_hw_v2.c:131:18: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
>>>   return (void *)((uint64_t)(qp->buf.buf) + qp->sq.offset +
>>>                   ^
>>> ../providers/hns/hns_roce_u_hw_v2.c:131:9: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>>>   return (void *)((uint64_t)(qp->buf.buf) + qp->sq.offset +
>>>          ^
>>> ../providers/hns/hns_roce_u_hw_v2.c: In function 'get_send_sge_ex':
>>> ../providers/hns/hns_roce_u_hw_v2.c:137:18: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
>>>   return (void *)((uint64_t)(qp->buf.buf) + qp->sge.offset +
>>>                   ^
>>> ../providers/hns/hns_roce_u_hw_v2.c:137:9: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>>>   return (void *)((uint64_t)(qp->buf.buf) + qp->sge.offset +
>>>          ^
>>> cc1: all warnings being treated as errors
>>> ninja: build stopped: subcommand failed.
>>>
>>> Thanks
>>>
>>>>
>>>> Thanks
>>>
>>>
>>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
