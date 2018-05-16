From: Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH for-next 5/5] IB/isert: Fix for lib/dma_debug check_sync
 warning
Date: Wed, 16 May 2018 17:03:12 -0400
Message-ID: <bbbd8cb3-1878-82f4-4650-0b8ab1822f4e@redhat.com>
References: <20180516012947.12474.2286.stgit@scvm10.sc.intel.com>
 <20180516013137.12474.10259.stgit@scvm10.sc.intel.com>
 <20180516200441.GN25661@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180516200441.GN25661@ziepe.ca>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 05/16/2018 04:04 PM, Jason Gunthorpe wrote:
> On Tue, May 15, 2018 at 06:31:39PM -0700, Dennis Dalessandro wrote:
>> From: Alex Estrin <alex.estrin@intel.com>
>>
>> The following error message occurs on a target host in a debug build
>> during session login:
>>
>> [ 3524.411874] WARNING: CPU: 5 PID: 12063 at lib/dma-debug.c:1207 check_sync+0x4ec/0x5b0
>> [ 3524.421057] infiniband hfi1_0: DMA-API: device driver tries to sync DMA memory it has not allocated [device address=0x0000000000000000] [size=76 bytes]
>> ......snip .....
>>
>> [ 3524.535846] CPU: 5 PID: 12063 Comm: iscsi_np Kdump: loaded Not tainted 3.10.0-862.el7.x86_64.debug #1
>> [ 3524.546764] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.2.6 06/08/2015
>> [ 3524.555740] Call Trace:
>> [ 3524.559102]  [<ffffffffa5fe915b>] dump_stack+0x19/0x1b
>> [ 3524.565477]  [<ffffffffa58a2f58>] __warn+0xd8/0x100
>> [ 3524.571557]  [<ffffffffa58a2fdf>] warn_slowpath_fmt+0x5f/0x80
>> [ 3524.578610]  [<ffffffffa5bf5b8c>] check_sync+0x4ec/0x5b0
>> [ 3524.585177]  [<ffffffffa58efc3f>] ? set_cpus_allowed_ptr+0x5f/0x1c0
>> [ 3524.592812]  [<ffffffffa5bf5cd0>] debug_dma_sync_single_for_cpu+0x80/0x90
>> [ 3524.601029]  [<ffffffffa586add3>] ? x2apic_send_IPI_mask+0x13/0x20
>> [ 3524.608574]  [<ffffffffa585ee1b>] ? native_smp_send_reschedule+0x5b/0x80
>> [ 3524.616699]  [<ffffffffa58e9b76>] ? resched_curr+0xf6/0x140
>> [ 3524.623567]  [<ffffffffc0879af0>] isert_create_send_desc.isra.26+0xe0/0x110 [ib_isert]
>> [ 3524.633060]  [<ffffffffc087af95>] isert_put_login_tx+0x55/0x8b0 [ib_isert]
>> [ 3524.641383]  [<ffffffffa58ef114>] ? try_to_wake_up+0x1a4/0x430
>> [ 3524.648561]  [<ffffffffc098cfed>] iscsi_target_do_tx_login_io+0xdd/0x230 [iscsi_target_mod]
>> [ 3524.658557]  [<ffffffffc098d827>] iscsi_target_do_login+0x1a7/0x600 [iscsi_target_mod]
>> [ 3524.668084]  [<ffffffffa59f9bc9>] ? kstrdup+0x49/0x60
>> [ 3524.674420]  [<ffffffffc098e976>] iscsi_target_start_negotiation+0x56/0xc0 [iscsi_target_mod]
>> [ 3524.684656]  [<ffffffffc098c2ee>] __iscsi_target_login_thread+0x90e/0x1070 [iscsi_target_mod]
>> [ 3524.694901]  [<ffffffffc098ca50>] ? __iscsi_target_login_thread+0x1070/0x1070 [iscsi_target_mod]
>> [ 3524.705446]  [<ffffffffc098ca50>] ? __iscsi_target_login_thread+0x1070/0x1070 [iscsi_target_mod]
>> [ 3524.715976]  [<ffffffffc098ca78>] iscsi_target_login_thread+0x28/0x60 [iscsi_target_mod]
>> [ 3524.725739]  [<ffffffffa58d60ff>] kthread+0xef/0x100
>> [ 3524.732007]  [<ffffffffa58d6010>] ? insert_kthread_work+0x80/0x80
>> [ 3524.739540]  [<ffffffffa5fff1b7>] ret_from_fork_nospec_begin+0x21/0x21
>> [ 3524.747558]  [<ffffffffa58d6010>] ? insert_kthread_work+0x80/0x80
>> [ 3524.755088] ---[ end trace 23f8bf9238bd1ed8 ]---
>> [ 3595.510822] iSCSI/iqn.1994-05.com.redhat:537fa56299: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
>>
>> The code calls dma_sync on login_tx_desc->dma_addr prior to initializing it
>> with dma-mapped address.
>> login_tx_desc is a part of iser_conn structure and is used only once
>> during login negotiation, so the issue is fixed by eliminating
>> dma_sync call for this buffer using a special case routine.
>>
>> Cc: <stable@vger.kernel.org>
>> Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
>> Reviewed-by: Don Dutile <ddutile@redhat.com>
>> Signed-off-by: Alex Estrin <alex.estrin@intel.com>
>> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
>> ---
>>   drivers/infiniband/ulp/isert/ib_isert.c |   26 +++++++++++++++++---------
>>   1 files changed, 17 insertions(+), 9 deletions(-)
> 
> This sounds like -rc material? Why is it for-next?
> 
>> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
>> index fff40b0..6a55b87 100644
>> --- a/drivers/infiniband/ulp/isert/ib_isert.c
>> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
>> @@ -886,15 +886,9 @@
>>   }
>>   
>>   static void
>> -isert_create_send_desc(struct isert_conn *isert_conn,
>> -		       struct isert_cmd *isert_cmd,
>> -		       struct iser_tx_desc *tx_desc)
>> +__isert_create_send_desc(struct isert_device *device,
>> +			 struct iser_tx_desc *tx_desc)
>>   {
>> -	struct isert_device *device = isert_conn->device;
>> -	struct ib_device *ib_dev = device->ib_device;
>> -
>> -	ib_dma_sync_single_for_cpu(ib_dev, tx_desc->dma_addr,
>> -				   ISER_HEADERS_LEN, DMA_TO_DEVICE);
>>   
>>   	memset(&tx_desc->iser_header, 0, sizeof(struct iser_ctrl));
>>   	tx_desc->iser_header.flags = ISCSI_CTRL;
>> @@ -907,6 +901,20 @@
>>   	}
>>   }
>>   
>> +static void
>> +isert_create_send_desc(struct isert_conn *isert_conn,
>> +		       struct isert_cmd *isert_cmd,
>> +		       struct iser_tx_desc *tx_desc)
>> +{
>> +	struct isert_device *device = isert_conn->device;
>> +	struct ib_device *ib_dev = device->ib_device;
>> +
>> +	ib_dma_sync_single_for_cpu(ib_dev, tx_desc->dma_addr,
>> +				   ISER_HEADERS_LEN, DMA_TO_DEVICE);
>> +
>> +	__isert_create_send_desc(device, tx_desc);
>> +}
>> +
>>   static int
>>   isert_init_tx_hdrs(struct isert_conn *isert_conn,
>>   		   struct iser_tx_desc *tx_desc)
>> @@ -994,7 +1002,7 @@
>>   	struct iser_tx_desc *tx_desc = &isert_conn->login_tx_desc;
>>   	int ret;
>>   
>> -	isert_create_send_desc(isert_conn, NULL, tx_desc);
>> +	__isert_create_send_desc(device, tx_desc);
>>   
>>   	memcpy(&tx_desc->iscsi_header, &login->rsp[0],
>>   	       sizeof(struct iscsi_hdr));
>>
It is an unnecessary synch at login, harmless if done, but causes the lib/dma-debug dma-synch checker to complain, which only occurs in the debug kernel.

e.g., RHEL is including it in it's next release, but not backporting to existing release (not doing a z-stream update to 7.5 release which took the multiple code chunks in to see this warning pop). Move along, nothing to see here... ;-)

-dd
