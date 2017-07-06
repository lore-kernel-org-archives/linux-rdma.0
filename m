From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: rdma-core make install is failing
Date: Thu, 6 Jul 2017 21:08:37 +0530
Message-ID: <CANjDDBiKLQJzVyHYTV+3AXdP=RjSZDu97oMWbGgFeJEUWxbxQg@mail.gmail.com>
References: <CAGxzWdAvjAgeiRsR0UvArC0L+n_PbiuNJfoDvkWzV0Y3hypSeg@mail.gmail.com>
 <CANjDDBibVGqa5xRwpwZcwOR-vtx-wf=5yW4Z4euD1uYk5Z79EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANjDDBibVGqa5xRwpwZcwOR-vtx-wf=5yW4Z4euD1uYk5Z79EA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suman Debnath <suman.14san-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

+Jason

On Thu, Jul 6, 2017 at 9:07 PM, Devesh Sharma
<devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org> wrote:
> +Jason,
>
> Could you try same steps with v13 tag and see if it still fails?
>
> Adding Jason, Seemingly a bug in the make-install path.
>
> -Regards
>
> On Thu, Jul 6, 2017 at 8:58 PM, Suman Debnath <suman.14san-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
>> Greetings Team:
>>
>>
>>
>> I was trying to install rdma-core, on CentOS 7.2(Kernel 4.9.28)
>>
>> I'm not sure what I'm doing wrong but make install is searching for
>> "/root/software/rdma-core-master/build/lib/libbnxt_re-rdmav2.so".
>>
>> After running build.sh I ran make install and get this error, I also
>> checked the build.sh didn=E2=80=99t create this library
>> (libbnxt_re-rdmav2.so):
>>
>>
>>
>>>> snippet <<
>>
>>
>>
>> -- Up-to-date: /usr/local/include/infiniband/cm.h
>>
>> -- Up-to-date: /usr/local/include/infiniband/cm_abi.h
>>
>> -- Up-to-date: /usr/local/lib64/libibcm.so.1.0.15
>>
>> -- Up-to-date: /usr/local/lib64/libibcm.so.1
>>
>> -- Up-to-date: /usr/local/lib64/libibcm.so
>>
>> -- Up-to-date: /root/software/rdma-core-master/build/etc/libibverbs.d/bn=
xt_re.driver
>>
>> CMake Error at providers/bnxt_re/cmake_install.cmake:62 (FILE):
>>
>>   file INSTALL cannot find
>>
>>   "/root/software/rdma-core-master/build/lib/libbnxt_re-rdmav2.so".
>>
>> Call Stack (most recent call first):
>>
>>   cmake_install.cmake:47 (INCLUDE)
>>
>>
>>
>>
>>
>> make: *** [install] Error 1
>>
>>
>>
>>
>>
>>>> snippet <<
>>
>>
>>
>> [root@target1 build]# ls lib/lib*
>>
>> lib/libcxgb3-rdmav2.so      lib/libibacmp.so       lib/libibumad.so.3
>>       lib/libipathverbs-rdmav2.so  lib/libmlx5-rdmav2.so
>> lib/libnes-rdmav2.so     lib/librdmacm.so.1.0.15
>>
>> lib/libcxgb4-rdmav2.so      lib/libibcm.so
>> lib/libibumad.so.3.0.15   lib/libmlx4-rdmav2.so        lib/libmlx5.so
>>         lib/libocrdma-rdmav2.so  lib/librspreload.so
>>
>> lib/libhfi1verbs-rdmav2.so  lib/libibcm.so.1       lib/libibverbs.so
>>       lib/libmlx4.so               lib/libmlx5.so.1
>> lib/libqedr-rdmav2.so    lib/librxe-rdmav2.so
>>
>> lib/libhns-rdmav2.so        lib/libibcm.so.1.0.15  lib/libibverbs.so.1
>>       lib/libmlx4.so.1             lib/libmlx5.so.1.1.15
>> lib/librdmacm.so         lib/libvmw_pvrdma-rdmav2.so
>>
>> lib/libi40iw-rdmav2.so      lib/libibumad.so
>> lib/libibverbs.so.1.1.15  lib/libmlx4.so.1.0.15
>> lib/libmthca-rdmav2.so  lib/librdmacm.so.1
>>
>> [root@target1 build]#
>>
>> [root@target1 build]#
>>
>>
>>
>> Am I missing something?
>>
>>
>>
>> Thank you.
>>
>> Regards,
>>
>> Suman++
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
