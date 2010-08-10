From: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Re: [PATCH v2] rdma/ib_pack.h: add new bth opcodes
Date: Tue, 10 Aug 2010 10:16:08 -0500
Message-ID: <4C616D38.7090506@systemfabricworks.com>
References: <00a901cb3785$4a032810$de097830$@com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BCAF@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BCAF-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/09/2010 06:36 PM, Hefty, Sean wrote:
>> Several new opcodes have been added since the last time ib_pack.h was
>> updated.
>> These changes add them.
>>      
> Will anything make use of these?
>
>    
>> diff --git a/include/rdma/ib_pack.h b/include/rdma/ib_pack.h
>> index cbb50f4..df10acc 100644
>> --- a/include/rdma/ib_pack.h
>> +++ b/include/rdma/ib_pack.h
>> @@ -73,8 +73,11 @@ enum {
>>          IB_OPCODE_UC                                = 0x20,
>>          IB_OPCODE_RD                                = 0x40,
>>          IB_OPCODE_UD                                = 0x60,
>> +       IB_OPCODE_CN                                = 0x80,
>> +       IB_OPCODE_XRC                               = 0xA0,
>>      
> The XRC and RD values all look correct, but I must have fallen asleep and missed something.  What's CN
>    
> - Sean
>
>    

Or also asked this question. Thanks to both of you.

CN is (backwards) congestion notification. It has a single opcode and 
caries no payload. It is described in an annex in IBA Vol 1.
I started adding the opcodes for send_xxx_with_invalidate but figured we 
may as well capture all of them.
My interest is supporting the rxe driver, a software implementation of 
the IB transport over Ethernet, and we have
looked at supporting xrc as an option, and I spent a little time looking 
at trying to exploit congestion notification to see if it
would bu useful in this context.

Bob Pearson

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
