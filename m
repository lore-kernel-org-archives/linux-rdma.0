From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2 libibverbs 2/7] Add member functions to poll an
 extended CQ
Date: Mon, 23 May 2016 18:31:52 +0300
Message-ID: <c2a28acc-811a-84da-0793-88032de99b23@dev.mellanox.co.il>
References: <1463658702-9975-1-git-send-email-yishaih@mellanox.com>
 <1463658702-9975-3-git-send-email-yishaih@mellanox.com>
 <20160519181933.GB26130@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160519181933.GB26130-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/19/2016 9:19 PM, Jason Gunthorpe wrote:
> On Thu, May 19, 2016 at 02:51:37PM +0300, Yishai Hadas wrote:
>> +	int (*start_poll_ex)(struct ibv_cq_ex *current,
>> +			     struct ibv_poll_cq_ex_attr *attr);
>> +	int (*next_poll_ex)(struct ibv_cq_ex *current);
>> +	void (*end_poll_ex)(struct ibv_cq_ex *current);
>
> Probably don't need the _ex here..

The '_ex' points that those functions support extension. 
(ibv_poll_cq_ex* attr, ibv_cq_ex). Their matching ibv_xxx wrappers also 
have _ex (e.g. ibv_start_poll_ex).
Makes sense ?

>
>> +	uint64_t (*read_wr_id)(struct ibv_cq_ex *current);
>> +	enum ibv_wc_status (*read_status)(struct ibv_cq_ex *current);
>> +	enum ibv_wc_opcode (*read_opcode)(struct ibv_cq_ex *current);
>
> opcode, status and wr_id are always available in every WR, so I think
> a faster way to return them should be devised. Perahps have the driver
> write them to ibv_cq_ex and have the inline functions read the struct
> directly?

Specifically talking on 'opcode', the fact that it always exists doesn't 
mean that application will read it. Furthermore, in many cases 
application doesn't need it at all (e.g. only SEND is done, there is CQ 
per operation, etc.) In addition, in some cases it can be achieved based 
on the wr_id that is returned.

Re 'status' and 'wr_id':
 From our benchmark testing we found that coping the the data as part of 
the read_xxx is the major cost and not the function call, so not sure 
that coping the status/wr_id to ibv_cq_ex directly will really give a 
boost here.

However, as it makes sense will run some benchmark testing on that 
suggestion and see if it has some improvement.

> How does this work multi-threaded? Is the locking done in
> start_poll.end_poll?

Yes, however as a vendor controls on the start/end calls it can hook 
less-lock functions in case the CQ is created with a single threaded 
access. (see down stream patch "Create a single threaded CQ" in this 
series).

>
>> +	uint32_t (*read_vendor_err)(struct ibv_cq_ex *current);
>> +	uint32_t (*read_byte_len)(struct ibv_cq_ex *current);
>> +	uint32_t (*read_imm_data)(struct ibv_cq_ex *current);
>> +	uint32_t (*read_qp_num)(struct ibv_cq_ex *current);
>> +	uint32_t (*read_src_qp)(struct ibv_cq_ex *current);
>> +	int (*read_wc_flags)(struct ibv_cq_ex *current);
>> +	uint16_t (*read_pkey_index)(struct ibv_cq_ex *current);
>> +	uint16_t (*read_slid)(struct ibv_cq_ex *current);
>> +	uint8_t (*read_sl)(struct ibv_cq_ex *current);
>> +	uint8_t (*read_dlid_path_bits)(struct ibv_cq_ex *current);
>
> Maybe some of these should be grouped into a struct? What kind of
> performance hit did you measure on these calls? Reading all the ud
> parameters is not very expensive...
>
> read_ud_info ?

As part of our benchmark testing we grouped in one read call status & 
wr_id which are usually needed but didn't see a real impact. Even in UD 
flow, application may not need all fields so supplying a read_ud_info 
which will copy whole candidate fields might not be useful.
As the API is extensible we may do further extensions in the future if 
will be proved to be useful.

> What does the driver look like? I'm assuming it turned out as short
> and jump free as I outlined?
Yes, the read_xxx are short and are really jump free.

> Finally, these extended APIs really need to be always available - so
> the core code should always provide a compatability wrapper for
> providers that do not implement this API. The compat wrapper should
> use the existing provider wc interface.

The compat layer will work in a non optimal way as it can't support 
batching and there will 2 copies, one from the HW CQ to ibv_wc even for 
not required fields, second, from the ibv_wc to the read_xxx output.

However, if required it can be posted as some extra patches in another 
series.

> We should not have stuff like in your rc_pingpong example where
> totally different code paths are required on something like wc
> processing.

The example code shares the parsing and the logic between the 2 modes 
and demonstrates the usage of the new APIs. I agree that having a compat 
layer can prevent the need for 2 code paths.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
