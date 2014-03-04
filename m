From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v1 10/13] IB/iser: Support T10-PI operations
Date: Tue, 04 Mar 2014 19:04:05 +0200
Message-ID: <53160785.4060507@dev.mellanox.co.il>
References: <1393499589-15633-1-git-send-email-sagig@mellanox.com> <1393499589-15633-11-git-send-email-sagig@mellanox.com> <531408C8.10107@cs.wisc.edu> <53159F09.6050802@mellanox.com> <5315A3E4.508@dev.mellanox.co.il> <5315B83D.6060503@mellanox.com> <5315E6DD.4060909@dev.mellanox.co.il> <5315FC64.2020207@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <5315FC64.2020207@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>, Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@mellanox.com>
Cc: roland@kernel.org, nab@linux-iscsi.org, oren@mellanox.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 3/4/2014 6:16 PM, Or Gerlitz wrote:
> On 04/03/2014 16:44, Sagi Grimberg wrote:
>>>> @@ -1707,10 +1707,17 @@ int iscsi_queuecommand(struct Scsi_Host 
>>>> *host, struct scsi_cmnd *sc)
>>>>                                 goto prepd_fault;
>>>>                         }
>>>>                 }
>>>> -               if (session->tt->xmit_task(task)) {
>>>> -                       session->cmdsn--;
>>>> -                       reason = FAILURE_SESSION_NOT_READY;
>>>> -                       goto prepd_reject;
>>>> +
>>>> +               reason = session->tt->xmit_task(task);
>>>> +               if (reason) {
>>>> +                       if (reason == -ENOMEM || reason == -EAGAIN) {
>>>> +                               session->cmdsn--;
>>>
>>> I am pretty sure this has to be done anyway, no matter why the 
>>> xmit_task callback failed
>>
>> Even if we abort? this just follows the same logic as 
>> iscsi_prep_scsi_cmd_pdu error flow.
>
> yes, take a 2nd look on iscsi_prep_scsi_cmd_pdu and you'll see that 
> all the possible error cases take place **before** session->cmdsn is 
> incremented

Ahhh, yes... So dec the cmdsn regardless.

Mike, are you on board with this?

Sagi.
