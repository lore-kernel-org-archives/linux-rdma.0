From: brendan doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Fwd: Re: [PATCH] libibmad: To reserve upper 8 bits of tid used
 by solaris SRIOV driver
Date: Thu, 21 Mar 2013 01:23:36 +0000
Message-ID: <514A6118.1030100@oracle.com>
References: <20130320223322.GB30100@obsidianresearch.com> <514A3996.601@oracle.com> <514A525F.7030706@oracle.com> <2807E5FD2F6FDA4886F6618EAC48510EBB428F@CRSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510EBB428F-8k97q/ur5Z1cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Pramod Gunjikar <Pramod.Gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 21/03/2013 00:51, Weiny, Ira wrote:
>> -----Original Message-----
>> From: brendan doyle [mailto:brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
>>
>>
>> On 20/03/2013 22:35, Boris Chiu wrote:
>>> fyi,
>>>
>>> Boris
>>>
>>>
>>> -------- Original Message --------
>>> Subject: 	Re: [PATCH] libibmad: To reserve upper 8 bits of tid used by
>>> solaris SRIOV driver
>>>
>>>
>>>
>>> On Wed, Mar 20, 2013 at 03:11:51PM -0700, Ira Weiny wrote:
>>>> Why does this need to be done in user space?  This seems like
>>>> something which should be done in the kernel for all Transaction
>>>> ID's which might be sent to the umad layer.
>> So the reason we "reserved" not set the upper two bytes of TID
> You mean 1 byte?

yeah sorry typo..

>>   in the user
>> space is so that libs and/or applications that rely on TID matching won't break.
>> If we changed the TID in the kernel then the response TID returned to the
>> lib/application would not match the request TID.
> While this makes sense I can't believe that libibmad is the only place which TID's get generated.  Do you also do this in OpenSM?

I didn't personal check, butt I ask a colleague who was making the 
change to check this
specifically, and the answer was that all tids were set/generated via 
mad_trid().

>> Currently the only place I see TID check is in libibmad's _do_madrpc(), and
>> here it effectively does something similar where it truncates the TID to
>> 32bits.  We send a MAD with a full 64 bit TID, record the lower 32 bits of the
>> TID, on on receipt of the response check that the lower 32 bits of TID are the
>> same, the upper 32 could be completely different.
>>
> Right, it ignores the upper 32bits because it knows the umad layer reserves the upper 32bits.  So for libibmad your patch does not fix anything unless you are doing some 64bit compare of TID's above the libibmad layer?

we are not so, i agree you could say that patch is moot, but I do think 
that tids
can be handled better than they are, and that if we expect the kernel to use
some of the upper bytes, then they should be marked reserved in userland.


>>> Agreed, if Solaris is going to emulate the Linux umad dev FD it should
>>> be done properly. The kernel overrides some bits and returns the TRID
>>> it actually put on the wire after the MAD is sent.
>> I don't see where the TID sent is returned to the caller of umad_send(), I see
>> that we pass down a MAD over the fd to the kernel that has a full 64bit TID
>> and then I see that the kernel over writes the upper 32 bits, but I don't see
>> how that is communicated back to the sender of the MAD, so if the sender
>> were doing
>> 64 bit TID matching it would not find its MAD, the upper 32bits it set are lost.
> I believe you are correct.  It is just up to the user of umad to "know" that the upper 32bits are not valid.  While unfortunate, this can only really be fixed through a major change in the umad ABI and/or documentation of that library.

noted.

>> Note in what we propose, in the userland we just reserve the upper byte, it
>> is the kernel that then uses/sets and unsets this upper byte to include a VF id
>> so MADs send on a VF device can get tunneled to the PF and received on a
>> PF can be directed to the correct VF, the upper byte is cleared before
>> handing back to the userland so that it can do 64 bit TID matching and the TID
>> it specified in the request MAD is the same as the one it gets in the response
>> MAD.
> This makes sense but I worry about users who do not use libibmad.  Frankly, I think people should be moving away from using libibmad.  It is very complicated and undocumented.  Putting transaction ID processing like this should probably be in libibumad since it reserves and uses bits from the TID.

Humm, so may be getting beyond the scope of this patch, I think there 
are a lot of good
parts to libibmad, especially the packing and unpacking/parsing of the 
MAD pkt, and
if we were to drop libibmad these should be rolled into libibumd. 
Included in that should
be a function to get a tid, and that all users of the umad interface 
must get their tid using
that function, then we can enforce a consistent policy for tids.

>>> Linux is already doing this to add per-process uniqueness, per-guest
>>> SRIOV uniqueness should use the same mechanism.
>> The way it is done in Linux effectively makes the TID a 32bit entity from the
>> userland perspective.
>>
> Yep, and I wish it was better documented and/or done a different way.
>
>>> Thus, this masking is either redundant, or hiding a kernel bug..
>> I might say it is the other way around. In Linux from the userland the TID you
>> get in a response MAD is not the same as the one you specified in the
>> request MAD.
> And this is yet another unfortunate "gotcha" of the libibumad interface.
>
>> I'm not debating that the kernel should use upper bits of the TID to demux
>> per process, per guest, that is what we do in Solaris, what I'm saying is that
>> those bits used by the kernel should be "reserved"  in userland so that the
>> TID of its request and response are the same across all 64 bits.
> So in Solaris do you combine the reservation of umad and this SRIOV like this:
>
> 0xXX YYYYYY ZZZZZZZZ
>
> Where XX is the VF mask YYYYYY is the agent mask and ZZZZZZZZ is the "actual" TID?
Actually we just reserve the upper byte, we currently don't include an 
agent mask, but
that's something we could certainly add.

>
> It seems like we should standardize on some format and then put this functionality into libibumad where all software can consistently use it.

I'd agree.

>
> Or leave things the way they are and define the TID to be 32bits in userspace and leave the rest up to the kernel.  In that respect libibmad probably should not be generating 64bit TID's.

So I think that could be a short term thing, until we have an agreed 
standard as above.

>
> I think I would rather see a patch which generates a 32bit TID from mad_trid.  Would you be happy with that?

yeup, I'll ask Boris to rework the patch.

Thanks

>
> Ira
>
>> Brendan
>>
>>> Jason
>>>
>>>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
