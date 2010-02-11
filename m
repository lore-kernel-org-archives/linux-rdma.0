From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] Add support for enhanced atomic operations
Date: Thu, 11 Feb 2010 09:08:58 -0500
Message-ID: <f0e08f231002110608y3a70c132r813d3472f82382d2@mail.gmail.com>
References: <4B66FA54.6030408@dev.mellanox.co.il>
	 <52BD554704A742B18E3F2F8F2B00B9FE@amr.corp.intel.com>
	 <4B68020D.4080401@dev.mellanox.co.il>
	 <f0e08f231002020754h482ba0f7xe35a78a72cc165e8@mail.gmail.com>
	 <F1F846D4754246DC862643839C4CB216@amr.corp.intel.com>
	 <4B692D67.5040006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B692D67.5040006-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 3, 2010 at 3:01 AM, Vladimir Sokolovsky
<vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> Sean Hefty wrote:
>>>
>>> Will Mellanox be adding this option to the IB spec rather than keep=
 it
>>> as vendor proprietary ?
>>
>> Along with that question, what is the use case for this feature? =C2=
=A0The only
>> benefit mentioned was saving a few bytes of memory, at the cost of
>> carrying
>> extra network headers. =C2=A0Atomics are only 64-bits to begin with.=
=2E.
>>
>
>
> For some applications the memory savings are very significant. One
> example is fine grain lock implementations for huge data sets. In oth=
er
> cases, the benefit is the ability to update multiple fields with a
> single io operation.

What happens when the other end doesn't support this feature (new
opcodes) ? How can that be determined remotely ? Is some CM related
change also needed ?

-- Hal

>
> Regards,
> Vladimir
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
