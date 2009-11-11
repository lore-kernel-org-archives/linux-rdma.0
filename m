From: Richard Frank <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: strong ordering for data registered memory
Date: Wed, 11 Nov 2009 17:44:59 -0500
Message-ID: <4AFB3E6B.3080606@oracle.com>
References: <4AF9CACE.8070700@Sun.COM> <adaskclvta4.fsf@roland-alpha.cisco.com> <4AFAFF7A.4090602@oracle.com> <4AFB3677.6050603@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AFB3677.6050603-UdXhSnd/wVw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Brean <David.Brean-UdXhSnd/wVw@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Would anyone like to through out the list of HCAs that do this... I can 
guess at a few...
and can ask the vendors directly.. if not.. .
 
It would be much nicer to not hardcode names of adapters.. but that won't
stop us.. :)

David Brean wrote:
> Yes, there are HCAs that provide strong ordering.  And an application 
> such as OpenMPI checks the HCA model and if appropriate enables a 
> mechanism called "eager RDMA" that depends on it.
>
> -David
>
> Richard Frank wrote:
>> Today apps are forced to assume that all transports can not provide 
>> strong ordering..
>> and hence must implement solutions to work around this.
>>
>> There are specific optimizations an app might make if it knows the 
>> underpinning
>> transport can make these guarantees..
>>
>> It would be useful if "strong ordering" were exposed as attribute 
>> from a transport..
>> and as well - have the ability to provide a hint to enable "strong 
>> ordering" on either
>> registration or per operation or at the qp level .
>>
>> Are there any HCAs that provide "strong ordering" today ?
>>
>> Roland Dreier wrote:
>>>  > Some time ago there was an email sent to this group with the subject
>>>  > "weak ordering for data registered memory".  I don't recall any 
>>> action
>>>  > resulting from this thread.  So, I have a question.  If a bit were
>>>  > defined to specify "strong ordering", perhaps as a "access" flag 
>>> (see
>>>  > ibv_access_flags) and used with ibv_reg_mr(), would that be 
>>> sufficient
>>>  > for (1) client applications that need a HW "guarantee" of writing 
>>> the
>>>  > last byte of an RDMA last and (2) platform implementations that need
>>>  > to deliver that feature?
>>>
>>> What would happen if an application asked for strong ordering and the
>>> adapter and/or platform is not capable of that?
>>>
>>> Weak ordering is a bit easier to handle -- the app is saying "if you 
>>> can
>>> make things go faster, don't worry about ordering here" and a platform
>>> where it doesn't matter can just ignore it.
>>>
>>>  - R.
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-rdma" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>   
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
