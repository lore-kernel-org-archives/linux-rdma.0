From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv2] infiniband-diags/ibqueryerrors: Add support for
	PortXmitDiscardDetails
Date: Fri, 13 Nov 2009 10:11:52 -0500
Message-ID: <f0e08f230911130711i6890548x6a84c0c764f7edd7@mail.gmail.com>
References: <20091104144219.GA7923@comcast.net> <20091106165933.GG7192@me>
	 <20091112203844.GT7192@me>
	 <f0e08f230911130643l788ef2e5n538c123912300d42@mail.gmail.com>
	 <20091113145928.GO7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091113145928.GO7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 13, 2009 at 9:59 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 09:43 Fri 13 Nov =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> On Thu, Nov 12, 2009 at 3:38 PM, Sasha Khapyorsky <sashak@voltaire.c=
om> wrote:
>> > On 18:59 Fri 06 Nov =C2=A0 =C2=A0 , Sasha Khapyorsky wrote:
>> >> On 09:42 Wed 04 Nov =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> >> >
>> >> > When --details selected, if PortCounters has transmit discards,=
 then
>> >> > query PortXmitDiscardDetails. On reset, if --details is selecte=
d, then
>> >> > PortXmitDiscardDetails will also be reset.
>> >> >
>> >> > Unfortunately, PortSamplesControl:OptionMask can't be trusted t=
o determine
>> >> > which PortXmitDiscardDetails counters are supported so an optio=
n was added
>> >> > for this.
>> >>
>> >> Interesting... Why so? Is it any bug in existing hw? Which one?
>> >
>> > Could you elaborate?
>>
>> I don't think this is the forum to discuss vendor bugs.
>
> Really? If so why did you post patch here which workarounds something
> that you don't want to describe?

I wanted to answer why it wasn't done differently (without the vendor
specifics).

> I think that it is important for developers to be aware about existin=
g
> bugs which may require workarounds. Guess that this is also important
> for vendors since they likely want to have working products.
>
> Anyway don't expect that next time I will apply things blindly.

Didn't seem to me that anything has been applied blindly.

-- Hal

> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
