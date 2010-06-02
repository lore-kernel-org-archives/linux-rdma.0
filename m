From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add a rate based mechanism for SMP transactions
Date: Wed, 2 Jun 2010 11:36:47 -0400
Message-ID: <AANLkTinNTrdjF2tfu0JHN09eYmzimLt2yfTBfaxSuZUV@mail.gmail.com>
References: <20091216151115.GA22639@comcast.net>
	<20100601153234.GR28549@me>
	<AANLkTimDPaT0m-2Qa-0dTpng5FmQRhzUhpiBWFdxwGsQ@mail.gmail.com>
	<20100602153106.GG28549@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100602153106.GG28549@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 2, 2010 at 11:31 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 06:58 Wed 02 Jun =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> I had started with an algorithm along these lines but evolved toward=
s
>> the proposed one based on CPU utilization. An algorithm along the
>> lines of the above wastes CPU (when "idling" and other times) which
>> significantly impacts any other apps running.
>
> So what are you saying? To skip this patch until better implementatio=
n?

I'm saying that I think the approach proposed in the original patch is
better as it doesn't waste CPU although it's more complex. Maybe
there's something in the middle (less than my patch but doesn't waste
CPU as the "simplest" approach does) but I'm not sure about this right
now.

-- Hal


> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
