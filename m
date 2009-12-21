From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] tests/subnet_discover: discover test utility
Date: Mon, 21 Dec 2009 09:02:56 -0500
Message-ID: <f0e08f230912210602i5e3f528h2b0630420346db82@mail.gmail.com>
References: <20090813204306.dffc3237.weiny2@llnl.gov>
	 <20090816110200.GS25501@me> <20090817083023.da17378b.weiny2@llnl.gov>
	 <20090823120609.GG9547@me> <20090826164026.8dcce4b2.weiny2@llnl.gov>
	 <20091023234349.GK5764@me> <20091220121406.GF5262@me>
	 <20091220182809.f7e17fae.weiny2@llnl.gov> <20091221073550.GB18524@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091221073550.GB18524@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 21, 2009 at 2:35 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> Hi Ira,
>
> On 18:28 Sun 20 Dec =C2=A0 =C2=A0 , Ira Weiny wrote:
>>
>> Yes, a similar mechanism would work in libibnetdisc. =C2=A0However, =
it looks like you are doing a depth first search
>
> I wouldn't call it so, it is rather "parallel" than "first" depth or
> breath - discovery continues at first responding node doesn't matter =
how
> was it queried in depth or in breath.

Does anything limit the amount of parallelism ?

>
>> which I fear might exceed the path count limit in a DR path?
>
> Right, hops count should be limited. I will add this.
>
>> Is this how OpenSM works?
>
> I think so. The difference is that OpenSM has a limit of outstanding
> MADs on the wire and subnet_discover doesn't (and there could be a lo=
t
> of MADs).

Isn't that dangerous in a real subnet ?

-- Hal

>
>> I was trying to do a breath first search like ibnetdiscover does.
>>
>> >
>> > Would you like to look at this?
>>
>> No problem, I have enclosed the output from a run on Hyperion.
>> There appears to be a lot of errors. =C2=A0I am not sure what the is=
sue is right off. =C2=A0I have included an ibnetdiscover output for com=
parision.
>
> Thanks.
>
> An errors are response timeouts. I guess that most of them are due
> to switches' VL15 overflow (could be verified by VL15Dropped counter
> evaluation). Will look at this deeply.
>
> Sasha
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
