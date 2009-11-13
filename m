From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv2] infiniband-diags/ibqueryerrors: Add support for
	PortXmitDiscardDetails
Date: Fri, 13 Nov 2009 09:43:02 -0500
Message-ID: <f0e08f230911130643l788ef2e5n538c123912300d42@mail.gmail.com>
References: <20091104144219.GA7923@comcast.net> <20091106165933.GG7192@me>
	 <20091112203844.GT7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091112203844.GT7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 12, 2009 at 3:38 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 18:59 Fri 06 Nov =C2=A0 =C2=A0 , Sasha Khapyorsky wrote:
>> On 09:42 Wed 04 Nov =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> >
>> > When --details selected, if PortCounters has transmit discards, th=
en
>> > query PortXmitDiscardDetails. On reset, if --details is selected, =
then
>> > PortXmitDiscardDetails will also be reset.
>> >
>> > Unfortunately, PortSamplesControl:OptionMask can't be trusted to d=
etermine
>> > which PortXmitDiscardDetails counters are supported so an option w=
as added
>> > for this.
>>
>> Interesting... Why so? Is it any bug in existing hw? Which one?
>
> Could you elaborate?

I don't think this is the forum to discuss vendor bugs.

-- Hal

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
