From: Marcus Epperson <marcus.r.epperson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] infiniband-diags/src/ibqueryerrors.c: fix segv due to
 CA port 0 reference
Date: Tue, 27 Sep 2011 17:50:13 -0700
Message-ID: <CAJ4ALkje120ds7V7i=HMp4Qy_7KcDCpqEYVmfBmunsDy9cinRw@mail.gmail.com>
References: <1317163951-25948-1-git-send-email-marcus.r.epperson@gmail.com>
	<20110927172920.ad114c31.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110927172920.ad114c31.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 27, 2011 at 5:29 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> On Tue, 27 Sep 2011 15:52:30 -0700
> Marcus R Epperson <marcus.r.epperson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>>
>> Signed-off-by: Marcus R Epperson <marcus.r.epperson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> I am curious if you have actually hit this bug. =A0I have not run int=
o any non-switches which set AllPortSelect which would lead to this con=
dition.[*] =A0In this case was it your intention to suppress the errors=
 for "all" ports and allow the individual ports to print? =A0I believe =
this is the correct behaviour.

I did hit this bug unfortunately. It happened with a Voltaire 4036E IO
node. My first inclination was to print the NodeGUID instead, but it
looked like you didn't want NodeGUIDs showing up anymore (based on
12748135). So the only other thing I could think of was to suppress
the "all" line for non-switches.

>
> Also, I assume this patch and 2/2 must go together. =A0However, this =
patch should include the braces from patch 2 to disambiguate the else s=
tatement. =A0Could you redo the series for that?

Sure thing.

-Marcus

>
> Thanks,
> Ira
>
> [*] but apparently the spec does not limit AllPortSelect to switches.=
=2E.
>
>> ---
>> =A0src/ibqueryerrors.c | =A0 =A05 +++--
>> =A01 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
>> index fa116a9..230f6b2 100644
>> --- a/src/ibqueryerrors.c
>> +++ b/src/ibqueryerrors.c
>> @@ -427,8 +427,9 @@ static int print_results(ib_portid_t * portid, c=
har *node_name,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (portnum =3D=3D 0xFF)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(" =A0 GUID 0x%" PRI=
x64 " port ALL:%s\n",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0node->ports=
[0]->guid, str);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (node->type =3D=3D IB_N=
ODE_SWITCH)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(" =A0=
 GUID 0x%" PRIx64 " port ALL:%s\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0node->ports[0]->guid, str);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(" =A0 GUID 0x%" P=
RIx64 " port %d:%s\n",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0node->por=
ts[portnum]->guid, portnum, str);
>> --
>> 1.7.4.1
>>
>
>
> --
> Ira Weiny
> Math Programmer/Computer Scientist
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
