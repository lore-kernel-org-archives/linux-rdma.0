From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2] libibumad: update umad_recv man page.
Date: Fri, 06 Jul 2012 15:32:51 -0400
Message-ID: <4FF73D63.9010704@dev.mellanox.co.il>
References: <20120703095522.1e89cd25.weiny2@llnl.gov> <4FF72FB0.6020202@dev.mellanox.co.il> <20120706122408.2540ea8dd74f94dcadd3fce1@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120706122408.2540ea8dd74f94dcadd3fce1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/6/2012 3:24 PM, Ira Weiny wrote:
> On Fri, 06 Jul 2012 14:34:24 -0400
> Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> 
>> On 7/3/2012 12:55 PM, Ira Weiny wrote:
>>>
>>> Document the umad_recv length parameter better.
>>>
>>> Changes since V1:
>>> 	add comments from Hal
>>>
>>> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
>>> ---
>>>  man/umad_recv.3 |   18 +++++++++++++++++-
>>>  1 files changed, 17 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/man/umad_recv.3 b/man/umad_recv.3
>>> index e1b2985..310d3d2 100644
>>> --- a/man/umad_recv.3
>>> +++ b/man/umad_recv.3
>>> @@ -27,10 +27,26 @@ A negative
>>>  makes the function block until a packet is received. A
>>>  .I timeout_ms\fR
>>>  parameter of zero indicates a non blocking read.
>>> +
>>> +.B Note
>>> +.I length
>>> +is a pointer to the length of the
>>> +.B data
>>> +portion of the umad buffer.  This means that
>>> +.I umad
>>> +should point to a buffer at least umad_size() +
>>> +.I *length
>>> +bytes long.
>>> +
>>> +.B Note also
>>> +that
>>> +.I *length\fR
>>> +must be >= 256 bytes.
>>
>> This seems somewhat redundant to me as just above it says "should point
>> to a bugger that's at least umad_size() + *length bytes long.
>>
>> Also, if this remains, should "must be" be "should be" ?
> 
> I _guess_ it _could_ be less than 256.  

My only point here is that if it's less than 256 + header, then the
error is returned (and nothing useful can be done). To me, that makes it
a should rather than a must but just make the two lines consistent.
Roland does have this as a must in user_mad.txt kernel doc:
"The buffer passed to read() must be at least one struct ib_user_mad +
256 bytes."

-- Hal

> However the specification states:
> 
> 	"C13-3: The data payload (as used in Chapter 9: Transport Layer on page 233) for all MADs shall be exactly 256 bytes."
> 
> Furthermore, the kernel checks to ensure that *length is > the first (or only) packet in the MAD transaction.  While some Class/Attributes may allow for less "valid" data I'm not sure the kernel distinguishes that.  Therefore, I think it is safer to just specify it.  Don't you think?

> Ira
> 
>>
>>> +
>>>  .SH "RETURN VALUE"
>>>  .B umad_recv()
>>>  returns non negative receiving agentid on success, and a negative value on error as follows:
>>> - -EINVAL      invalid port handle or agentid
>>> + -EINVAL      invalid port handle or agentid or *length is less than the minimum
>>
>> Rather than just minimum, minimum support length might be clearer.
>>
>> -- Hal
>>
>>>   -EIO         receive operation failed
>>>   -EWOULDBLOCK non blocking read can't be fulfilled
>>>  .SH "SEE ALSO"
>>
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
