From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [infiniband-diags] [libibmad] Support new ibccquery congestion
 control tool
Date: Fri, 23 Sep 2011 08:53:10 -0400
Message-ID: <CAKzyTsz2ERitddGLqUPnjLO4NQz1M2_N3DVywBwUmFBhtXGPaQ@mail.gmail.com>
References: <1316469989.25283.728.camel@auk59.llnl.gov>
	<CAKzyTsxKD0r9194fd1haQ0u=1kXLDhrRXLL8q+=+inV5BM1mog@mail.gmail.com>
	<20110921084934.b300e682.weiny2@llnl.gov>
	<1316629549.25283.803.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1316629549.25283.803.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Al,

On Wed, Sep 21, 2011 at 2:25 PM, Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org> wrote:
> Hey Hal,
>
> Ira answered most of the important stuff already. =C2=A0But some extr=
a
> details ...
>
>> Second the current alignment breaks libibmad. =C2=A0So it would be a=
 lot
>> more code to support the miss-alignment and would probably have to b=
e
>> changed anyway.
>
> As far as I can tell, all the code in libibmad currently assumes 32 b=
it
> alignment. =C2=A0For example, "BITSOFFS(48, 32)" leads to an offset o=
f -16,
> which is not good. =C2=A0I played around with updating the code in li=
bibmad,
> but it was a nice chunk of changes for 1 measly field. =C2=A0We could=
 remove
> the problem field until the issue is resolved in IBTA? =C2=A0Or perha=
ps we
> need to really redo chunks of libibmad to deal with this.

OK; maybe this is a new case of misalignment than has been dealt with
in the past. Ideally/hopefully, we don't need to deal with this.

-- Hal

>> Also, would you comment on what testing has been done with this ?
>
> I've gotten ibccquery to talk to Mellanox CAs and Switches and output
> the current config. =C2=A0I've got a side tool that can do rudimentar=
y
> congestion control settings, so at the minimum I can twiddle some val=
ues
> and they show up in the output of ibccquery. =C2=A0I haven't done any=
 testing
> w/ real network traffic yet, so there could be lingering bugs. =C2=A0=
But this
> is just the initial first pass.
>
> Al
>
> On Wed, 2011-09-21 at 08:49 -0700, Ira Weiny wrote:
>> On Wed, 21 Sep 2011 07:17:38 -0700
>> Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> > Hi Al,
>> >
>> > On Mon, Sep 19, 2011 at 6:06 PM, Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org> wrote=
:
>> > > The following patches add a new tool ibccquery to infiniband-dia=
gs. =C2=A0It
>> > > supports the querying of various congestion control settings. =C2=
=A0Related
>> > > updates to libibmad are also included.
>> >
>> > Looks good to me :-) Just a few comments below:
>> >
>> > Attaching rather than inlining patches makes it harder to comment.
>> >
>> > On 0001-Add-support-for-congestion-control-mads.patch, is ib_rpc_c=
c_t
>> > really needed ? Couldn't mkey in existing rpc struct just be
>> > reused/overloaded for this (and change comment to indicate mkey or
>> > cckey) and then some code could be eliminated ?
>>
>> I am not sure I like overloading fields like this. =C2=A0I will take=
 a look at it
>> and see if it "looks" good but in general to keep ABI and clarity of=
 the code
>> I preferred the separate struct.
>>
>> >
>> > On 0001-Support-ibccquery-congestion-control-query-tool.patch, I'm
>> > worried about the following:
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* XXX: Q3/2010 errata lists =
first entry offset at 80, but we assume
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* will be updated to 96=
 once CurrentTimeStamp field is word aligned.
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* In addition, assume m=
ax 13 log events instead of 16. =C2=A0Due to
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* errata changes increa=
sing size of CA log event, 16 log events is
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* no longer possible to=
 fit in max MAD size.
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> >
>> > As far as the 13 v. 16 entries, this appears correct to me (MAD si=
ze)
>> > but I'm concerned about changing the offset from 80 to 96 for bett=
er
>> > alignment as this is putting the cart before the horse a little as
>> > since these changes have not been finalized AFAIK at the IBTA.
>>
>> Yes, it is a bit premature. =C2=A0I have submitted the above alignme=
nt as a comment
>> to the IBTA but as you say it is not published. =C2=A0Most important=
ly the
>> miss-alignment breaks the convention of the spec. =C2=A0So I don't t=
hink the IBTA
>> will reject the comment.
>>
>> Second the current alignment breaks libibmad. =C2=A0So it would be a=
 lot more code
>> to support the miss-alignment and would probably have to be changed =
anyway.
>>
>> >
>> > Also, would you comment on what testing has been done with this ?
>> >
>>
>> Right, the real question is what does current hardware do?
>>
>> We have been unable to determine if any of the vendors support the e=
rrata
>> fully or specifically the miss-aligned CurrentTimeStamp. =C2=A0When =
I asked the
>> vendors I got concrete answers back, so we proceeded with trying to =
reverse
>> engineer it. =C2=A0Right now the query succeeds, that is all we know=
=2E
>>
>> Perhaps someone on the list can help us find out? =C2=A0:-D
>>
>> In the meantime we wanted to get comments on the patches.
>>
>> Ira
>>
>> > -- Hal
>> >
>> > > Al
>> > >
>> > > --
>> > > Albert Chu
>> > > chu11-i2BcT+NCU+M@public.gmane.org
>> > > Computer Scientist
>> > > High Performance Systems Division
>> > > Lawrence Livermore National Laboratory
>> > >
>> > >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-rd=
ma" in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
>>
>>
> --
> Albert Chu
> chu11-i2BcT+NCU+M@public.gmane.org
> Computer Scientist
> High Performance Systems Division
> Lawrence Livermore National Laboratory
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
