From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Issues with starting srp_daemon userspace for a 4.13 kernel
Date: Tue, 18 Jul 2017 16:01:45 -0400
Message-ID: <ef6d29a5-9632-bd9b-1113-1de6671031cc@redhat.com>
References: <b74ff7c3-734b-71ae-6b67-9a8ccf255bf6@redhat.com>
 <20170718194846.GA6048@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170718194846.GA6048-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 07/18/2017 03:48 PM, Jason Gunthorpe wrote:
> On Tue, Jul 18, 2017 at 02:07:08PM -0400, Laurence Oberman wrote:
>> Hello
>>
>> What changed in 4.13 so SRP will no longer start because QP cannot modify
>> state.
>>
>> Same test bed as always (based on RHEL 7.3)
>>
>> Linux dhcp40-139.desklab.eng.bos.redhat.com 4.12.0
>>
>> Works and srp_daemon activates using:
>>
>> run_srp_daemon  -f /etc/ddn/srp_daemon.conf -R 30 -T 10 -t 7000 -ance -i
>> mlx5_0 -p 1 1>/root/srp1.log 2>&1 &
>> run_srp_daemon  -f /etc/ddn/srp_daemon.conf -R 30 -T 10 -t 7000 -ance -i
>> mlx5_1 -p 1 1>/root/srp2.log 2>&1 &
>>
>> [  158.020366] scsi host2: SRP.T10:7CFE900300726E4E
>> [  158.574651] scsi host1: SRP.T10:7CFE900300726E4E
>>
>> Now Testing 4.13, same back-end target that IS running 4.13
>>
>> Client now booted into 4.13
>>
>> Linux dhcp40-139.desklab.eng.bos.redhat.com 4.13.0-rc1+
>>
>> [root@dhcp40-139 ~]# run_srp_daemon  -f /etc/ddn/srp_daemon.conf -R 30 -T 10
>> -t 7000 -ance -i mlx5_0 -p 1
>> srp_daemon[4573]: failed to modify QP state to RTR
>> srp_daemon[4573]: failed to modify QP state from RESET to RTS
>> [root@dhcp40-139 ~]# run_srp_daemon  -f /etc/ddn/srp_daemon.conf -R 30 -T 10
>> -t 7000 -ance -i mlx5_1 -p 1
>> srp_daemon[4616]: failed to modify QP state to RTR
>> srp_daemon[4616]: failed to modify QP state from RESET to RTS
> 
> Do you have this patch?
> 
>> Subject: [PATCH v2 1/2] RDMA/uverbs: Fix the check for port number
>>
>> The port number is only valid if IB_QP_PORT is set in the mask.
>> So only check port number if it is valid to prevent modify_qp from
>> failing due to an invalid port number.
>>
>> Fixes: 5ecce4c9b17b("Check port number supplied by user verbs cmds")
>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v2.6.14+
>> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Jason,

Yep, That patch seems to be in 4.12 and in 4.13 RC1.
4.12 is working.
I am going to add some debug now as I really dont feel like a bisect 
build unless I first try figure out the differences.

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
