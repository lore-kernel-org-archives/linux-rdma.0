From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC 2/9] IB/core: Introduce Signature Verbs API
Date: Sun, 20 Oct 2013 15:55:58 +0300
Message-ID: <5263D2DE.8010500@mellanox.com>
References: <1381851510-17290-1-git-send-email-sagig@mellanox.com> <1381851510-17290-3-git-send-email-sagig@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237388CE2BFF@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CE2BFF-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/18/2013 1:51 AM, Hefty, Sean wrote:
>> @@ -885,6 +901,19 @@ struct ib_send_wr {
>>   			u32                      rkey;
>>   			struct ib_mw_bind_info   bind_info;
>>   		} bind_mw;
>> +		struct {
>> +			struct ib_sig_attrs    *sig_attrs;
>> +			struct ib_mr	       *sig_mr;
>> +			int			access_flags;
>> +			/* Registered data mr */
>> +			struct ib_mr	       *data_mr;
>> +			u32			data_size;
>> +			u64			data_va;
>> +			/* Registered protection mr */
>> +			struct ib_mr	       *prot_mr;
>> +			u32			prot_size;
>> +			u64			prot_va;
>> +		} sig_handover;
> At what point do we admit that this is a ridiculous structure?

If you are referring to ib_send_wr, I agree, shall we modify it to a 
union of typedefs so it becomes more readable?

> Help me understand what this WR is doing.  Is this telling the HCA to copy data between local MRs?  What is a 'data MR' versus a 'protected MR'?  (I'm not hip on T10-DIF.)

No data copy, god forbids... :)

Let me start by giving a short intro on signature (and T10-DIF).
In signature world, data may exist with protection information which is 
the guarding the data. In T10-DIF (Data Integrity Fields) for example, 
these are 8-byte guards which includes CRC for each 512 bytes of data 
(block).
An HCA which support signature offload, is expected to validate that the 
data is intact (each block matches its guard) and send it correctly over 
the wire (in T10-DIF case the data and protection should be interleaved 
i.e. 512B of data followed by 8B of protection guard) or alternatively, 
validate data (+ protection) coming from the wire and write it to the 
associated memory areas.
In the general case, the data and the protection guards may lie in 
different memory areas. SCSI mid-layer for instance, passes the 
transport driver 2 buffers using 2 scatterlists.
The transport driver (or application in the general case), is expected 
to register each buffer (as it normally would in order to use RDMA) 
using 2 MRs.

The signature handover operation is binding all the necessary 
information for the HCA together: where is the data (data_mr), where is 
the protection information (prot_mr), what are the signature properties 
(sig_attrs).
Once this step is taken (WR is posted), a single MR (sig_mr) describes 
the signature handover operation and can be used to perform RDMA under 
signature presence.
Once the HCA will perform RDMA over this MR, it will take into account 
the signature context of the transaction and will follow the signature 
attributes configured.

Hope this helps,

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
