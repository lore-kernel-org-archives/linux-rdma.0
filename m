From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: =?UTF-8?B?UmU6IOOAkGFzayBmb3IgaGVscOOAkQ==?=
Date: Sat, 4 Nov 2017 17:02:06 +0800
Message-ID: <94c8a13d-6959-9000-751b-a323330e5f19@huawei.com>
References: <757dcf37-4fb3-c6e9-c915-de10b4e2326f@huawei.com>
 <1509721149.2473.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509721149.2473.3.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

在 2017/11/3 22:59, Bart Van Assche 写道:
> On Fri, 2017-11-03 at 17:14 +0800, oulijun wrote:
>> unhandled level 2 translation fault (11) at 0x00000000, esr 0x92000006, in librdmacm.so.1.1.11
>> [ffff9a6e8000+11000]
> 
> Is this perhaps a user space fault reported by the kernel? From kernel source
> file arch/arm64/mm/fault.c:
> 
> 		pr_info("%s[%d]: unhandled %s (%d) at 0x%08lx, esr 0x%03x",
> 			tsk->comm, task_pid_nr(tsk), inf->name, sig,
> 			addr, esr);
> 
> You will need to identify what code in librdmacm caused this fault by using
> tools that report a stack trace for the fault. Had you already considered to
> run the application that uses librdmacm and that triggers this fault under gdb
> or valgrind?
> 
> Bart.
> 
Hi，Bart Van Assche
  Thank your help. I have identify the error code in librdmacm because cma device is not
get sucessfully. your advice with locating these question is fined to me.

Lijun Ou

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
