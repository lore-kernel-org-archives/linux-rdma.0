From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: SQ overflow seen running isert traffic with high block sizes
Date: Mon, 29 Jan 2018 21:36:04 +0200
Message-ID: <62470be0-c6e0-cee6-867f-5231da99fdc6@grimberg.me>
References: <BN3PR07MB25784033E7FCD062FA0A7855F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <210f538f-8c98-f480-64fc-f2124ed6d01b@grimberg.me>
 <BN3PR07MB25786338EADC77A369A6D493F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <1499970579.7987.8.camel@haakon3.daterainc.com>
 <BN3PR07MB2578E6561CC669922A322245F8A00@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171006224025.GA23364@ssaleem-MOBL4.amr.corp.intel.com>
 <1515992195.24576.156.camel@haakon3.daterainc.com>
 <CY1PR0701MB2012E53C69D1CE3E16BA320B88EB0@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20180115152236.GA15484@ssaleem-MOBL4.amr.corp.intel.com>
 <1516269522.24576.274.camel@haakon3.daterainc.com>
 <9DD61F30A802C4429A01CA4200E302A789EB485A@fmsmsx116.amr.corp.intel.com>
 <1516780918.24576.341.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1516780918.24576.341.camel@haakon3.daterainc.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc: "Kalderon, Michal" <Michal.Kalderon@cavium.com>, "Amrani, Ram" <Ram.Amrani@cavium.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Elior, Ariel" <Ariel.Elior@cavium.com>, target-devel <target-devel@vger.kernel.org>, Potnuri Bharat Teja <bharat@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

Hi,

>>> First, would it be helpful to limit maximum payload size per I/O for consumers
>>> based on number of iser-target sq hw sges..?
>>>
>> Assuming data is not able to be fast registered as if virtually contiguous;
>> artificially limiting the data size might not be the best solution.
>>
>> But max SGEs does need to be exposed higher. Somewhere in the stack,
>> there might need to be multiple WRs submitted or data copied.
>>
> 
> Sagi..?

I tend to agree that if the adapter support just a hand-full of sges its
counter-productive to expose infinite data transfer size. On the other
hand, I think we should be able to chunk more with memory registrations
(although rdma rw code never even allocates them for non-iwarp devices).

We have an API for check this in the RDMA core (thanks to chuck)
introduced in:
commit 0062818298662d0d05061949d12880146b5ebd65
Author: Chuck Lever <chuck.lever@oracle.com>
Date:   Mon Aug 28 15:06:14 2017 -0400

     rdma core: Add rdma_rw_mr_payload()

     The amount of payload per MR depends on device capabilities and
     the memory registration mode in use. The new rdma_rw API hides both,
     making it difficult for ULPs to determine how large their transport
     send queues need to be.

     Expose the MR payload information via a new API.

     Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
     Acked-by: Doug Ledford <dledford@redhat.com>
     Signed-off-by: J. Bruce Fields <bfields@redhat.com>


So the easy way out would be to use that and plug it to
max_sg_data_nents. Regardless, queue-full logic today yields a TX attack
on the transport.

>>> diff --git a/drivers/target/iscsi/iscsi_target_configfs.c
>>> b/drivers/target/iscsi/iscsi_target_configf
>>> index 0ebc481..d8a4cc5 100644
>>> --- a/drivers/target/iscsi/iscsi_target_configfs.c
>>> +++ b/drivers/target/iscsi/iscsi_target_configfs.c
>>> @@ -1553,6 +1553,7 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
>>>          .module                         = THIS_MODULE,
>>>          .name                           = "iscsi",
>>>          .node_acl_size                  = sizeof(struct iscsi_node_acl),
>>> +       .max_data_sg_nents              = 32, /* 32 * PAGE_SIZE = MAXIMUM
>>> TRANSFER LENGTH */
>>>          .get_fabric_name                = iscsi_get_fabric_name,
>>>          .tpg_get_wwn                    = lio_tpg_get_endpoint_wwn,
>>>          .tpg_get_tag                    = lio_tpg_get_tag,
>>>
>>
>> BTW, this is helping the SQ overflow issue.
> 
> Thanks for confirming as a possible work-around.
> 
> For reference, what is i40iw's max_send_sg reporting..?
> 
> Is max_data_sg_nents=32 + 4k pages = 128K the largest MAX TRANSFER
> LENGTH to avoid consistent SQ overflow as-is with i40iw..?

I vaguely recall that this is the maximum mr length for i40e (and cxgb4
if I'm not mistaken).
