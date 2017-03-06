From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: WARNING on drivers/infiniband/core/verbs.c:1975
 __ib_drain_sq+0x182/0x1c0 [ib_core]
Date: Mon, 6 Mar 2017 17:30:59 +0530
Message-ID: <CANjDDBikGWGL7dpSP2c7A5WPtaLeoa=C+4xjdFNH_cmTJwWzDQ@mail.gmail.com>
References: <1457714996.31424605.1488696068958.JavaMail.zimbra@redhat.com> <3ce3cfdb-a452-ff0c-fa52-2ad0546c8b8f@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3ce3cfdb-a452-ff0c-fa52-2ad0546c8b8f-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sagi

On Mon, Mar 6, 2017 at 5:12 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>
>> 2. Initiator side:
>> #nvme connect-all -t rdma -a 172.31.40.4 -s 1023
>>
>> 3. check the kernel log on both target/initiator side.
>>
>> kernel log:
>> [  242.494533] ocrdma0:Using VLAN with PFC is recommended
>> [  242.520244] ocrdma0:Using VLAN 0 for this connection
>> [  242.652599] ocrdma0:Using VLAN with PFC is recommended
>> [  242.676365] ocrdma0:Using VLAN 0 for this connection
>> [  242.700476] ocrdma0:Using VLAN with PFC is recommended
>> [  242.723497] ocrdma0:Using VLAN 0 for this connection
>> [  242.812331] nvme nvme0: new ctrl: NQN
>> "nqn.2014-08.org.nvmexpress.discovery", addr 172.31.40.4:1023
>> [  242.854149] ocrdma0:Using VLAN with PFC is recommended
>> [  242.854149] ocrdma0:Using VLAN 0 for this connection
>> [  242.854662] ------------[ cut here ]------------
>> [  242.854671] WARNING: CPU: 2 PID: 158 at
>> drivers/infiniband/core/verbs.c:1975 __ib_drain_sq+0x182/0x1c0 [ib_core]
>
>
>
>
> I suspect that ib_drain_sq is not supported on ocrdma. From looking at
> the code it seems that ocrdma fails and send post when the qp is not
> in RTS. I think that if this is the case ocrdma needs to implement
> its own qp drain logic similar to cxgb4, ns, i40e etc.
>
> Devesh (CC'd), has anyone tested ib_drain_qp on ocrdma?
No, ib_drain_sq and ib_drain_rq are not implemented as of now in ocrdma.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
