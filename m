From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SRP Q's: 1) When is asynchronous I/O complete, 2) Is sequential
	I/O coalesced, and 3) why is iSCSI faster than SRP in some instances
Date: Sat, 9 Jan 2010 14:05:30 +0100
Message-ID: <e2e108261001090505w58a70e8ax5cfa522cbf2da9cf@mail.gmail.com>
References: <f3177b9e1001061616v4f0015d1h843ba19c8cdd83d@mail.gmail.com>
	 <1262829441.29991.10.camel@obelisk.thedillows.org>
	 <f3177b9e1001081340r323c53cela2fb22907212fc2b@mail.gmail.com>
	 <1262989053.14204.21.camel@obelisk.thedillows.org>
	 <f3177b9e1001081439j3730acefrbfcf523b0da06306@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3177b9e1001081439j3730acefrbfcf523b0da06306-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 8, 2010 at 11:39 PM, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
> On Fri, Jan 8, 2010 at 3:17 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wr=
ote:
>> On Fri, 2010-01-08 at 14:40 -0700, Chris Worley wrote:
>>> On Wed, Jan 6, 2010 at 6:57 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> =
wrote:
>>> > On Wed, 2010-01-06 at 17:16 -0700, Chris Worley wrote:
>>> >> 1) I'm seeing small block random writes (32KB and smaller) get b=
etter
>>> >> performance over SRP than they do as a local drive. =A0I'm guess=
ing this
>>> >> is async behavior: once the written data is on the wire, it's de=
emed
>>> >> complete, and setting a sync flag would disable this. =A0Is this
>>> >> correct?
>>
>>> >> If not, any ideas why SRP random writes would be faster than
>>> >> the same writes locally?
>>> >
>>> > I would guess deeper queue depths and more cache available on the
>>> > target, especially if you are using a Linux-based SRP target.
>>>
>>> I do set the ib_srp initiator "srp_sg_tablesize" to its maximum of =
58.
>>
>> The max is 255, which will guarantee you can send up to a 1020 KB I/=
O
>> without breaking it into two SCSI commands. In practice, you're like=
ly
>> to be able to send larger requests, as you will often have some
>> contiguous runs in the data pages.
>
> I've tried a larger max... 58 is all I can get. =A0Maybe getting more=
 is
> dependent on some other setting.

The SRP spec says that the target must specify the maximum message
size in the SRP_LOGIN_RSP information unit. The largest value one can
set the srp_sg_tablesize initiator parameter to is (max. SRP message
size defined by the target - 68) / 16. With older SCST-SRPT revisions
the maximum SRP message size was 996 bytes, hence a maximum of 58 for
srp_sg_tablesize. With newer SCST-SRPT revisions the maximum message
size defaults to 2116, which corresponds to a maximum of 128 for
srp_sg_tablesize. The maximum message size can even be increased
further via the module parameter srp_max_message_size of ib_srpt (see
also srpt/src/README in the SCST source tree).

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
