From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Issues with starting srp_daemon userspace for a 4.13 kernel
Date: Tue, 18 Jul 2017 16:27:37 -0400
Message-ID: <5ca055dc-199f-ee29-fc99-126db132df10@redhat.com>
References: <b74ff7c3-734b-71ae-6b67-9a8ccf255bf6@redhat.com>
 <20170718194846.GA6048@obsidianresearch.com>
 <ef6d29a5-9632-bd9b-1113-1de6671031cc@redhat.com>
 <1500408333.2664.6.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500408333.2664.6.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 07/18/2017 04:05 PM, Bart Van Assche wrote:
> On Tue, 2017-07-18 at 16:01 -0400, Laurence Oberman wrote:
>> Yep, That patch seems to be in 4.12 and in 4.13 RC1.
>> 4.12 is working.
>> I am going to add some debug now as I really dont feel like a bisect
>> build unless I first try figure out the differences.
> 
> Hello Laurence,
> 
> Is SELinux enabled on your test setup? If so, can you repeat your test
> after having disabled it?
> 
> Bart.
> 

Hi Bart
Thanks for replying.

Its disabled (at least now it is.) although it should have also been 
disabled when I tested.

I will re-run the test in case.

[root@dhcp40-139 ~]# getenforce
Disabled

Just waiting on a kernel build as I decided to start the bisect as it is 
not that many kernels between v12.x and v13 RC1.

I will say there are lots of code changes in V4.13 showing stuff about 
the RTS in the QP states (Mostly in ROCE though)

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
