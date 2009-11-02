From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/perfquery.c: Fix extended counter reset
	mask
Date: Mon, 2 Nov 2009 12:15:46 -0400
Message-ID: <f0e08f230911020815l7527536epba426c6596f63d7e@mail.gmail.com>
References: <20091030011708.GQ20136@me>
	 <1361989047.4222321256937573066.JavaMail.root@sz0074a.westchester.pa.mail.comcast.net>
	 <f0e08f230910301516o33bddfa3lcab8e31c3eec096f@mail.gmail.com>
	 <20091102130305.GA8345@me>
	 <f0e08f230911020723g68586367g296d1991616d937@mail.gmail.com>
	 <20091102161324.GF21323@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091102161324.GF21323@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 2, 2009 at 12:13 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 11:23 Mon 02 Nov =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> On Mon, Nov 2, 2009 at 9:03 AM, Sasha Khapyorsky <sashak-smomgflXvObQFizaE/u3fw@public.gmane.org=
m> wrote:
>> > On 18:16 Fri 30 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> >>
>> >> Because a PMA implementation which follows the IBA recommendation=
 will
>> >> reject this
>> >
>> > Hmm, where did you find such recommendation where stated that if
>> > reserved bits are not '0' the request should be rejected (I would =
rather
>> > expect ignoring of those values at all)?
>>
>> I sent a subsequent email indicating there was an errata on this and
>> that these changes are needed.
>
> Let me understand correctly. Do you mean that proposed patch is not
> needed?

Yes, it's not strictly required and you typically nix those sorts of th=
ings.

-- Hal

>
> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
