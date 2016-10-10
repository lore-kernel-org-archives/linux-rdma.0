From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: Patches for librxe-dev
Date: Mon, 10 Oct 2016 08:49:43 -0700
Message-ID: <65ee46ce-0cee-dcb4-21e4-e5aa74ca6c1f@acm.org>
References: <CAP_Z8c=zx-DL1yFTZSRy=myQ1n4pqkcfH+Zi1MLDeHPEwDGRQw@mail.gmail.com>
        <4c6c926d-d5a4-7149-c3dc-b0945b134da0@acm.org>
        <CAP_Z8ckRONhy5Fy6VEYbfk5KVa5mbES1wyfPfsEX3fY=LOn=hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAP_Z8ckRONhy5Fy6VEYbfk5KVa5mbES1wyfPfsEX3fY=LOn=hw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: diegocg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Henrique Almeida <hdante.lnls-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/10/16 07:12, Henrique Almeida wrote:
> 2016-10-10 11:00 GMT-03:00 Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>:
>> On 10/10/16 06:49, Henrique Almeida wrote:
>>>
>>> Hello, how can I send patches for SoftRoCE library ? Last week I
>>> tried sending a pull request on github, but it looks like no one is
>>> watching it.
>>
>>
>> Maybe the README of the librxe-dev project should be updated to indicate
>> that that project has been superseded by the rdma-core project and that new
>> contributions should be submitted to the latter project
>> (https://github.com/linux-rdma/rdma-core)?
 >
 > Ok, but I think the SoftRoCE repository is mentioned in
 > kernelnewbies.
 >
 > 
https://kernelnewbies.org/Linux_4.8#head-d5eeeba16221162ce670139e945ab118b2aa772a

Hello Diego,

Do you perhaps have edit rights for that kernel newbies page? If so, can 
you correct the information about the SoftRoCE driver? The SoftRoCE 
driver went upstream in kernel v4.8 so I think the reference to the 
out-of-tree https://github.com/SoftRoCE/rxe-dev kernel driver should be 
removed. And since the https://github.com/SoftRoCE/librxe-dev repository 
has been superseded by the https://github.com/linux-rdma/rdma-core 
repository, please change the reference to https://github.com/SoftRoCE/ 
into https://github.com/linux-rdma/rdma-core.

PS: the linux-rdma mailing list is the mailing list on which the 
SoftRoCE driver was discussed before it was accepted upstream.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
