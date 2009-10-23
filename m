From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_vendor_ibumad.c: Add environment variable to
	change max retries
Date: Fri, 23 Oct 2009 18:02:30 -0400
Message-ID: <f0e08f230910231502p1758a8ag6c3852802aca40a7@mail.gmail.com>
References: <20091019183342.GA28926@comcast.net> <20091022122443.GF20210@me>
	 <f0e08f230910220556h3d7352f4s4bd8e57c0a01a5d0@mail.gmail.com>
	 <20091022135004.GK20210@me>
	 <f0e08f230910220841s220373fau2cd4e814ec77ca25@mail.gmail.com>
	 <20091023213308.GE5764@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091023213308.GE5764@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 23, 2009 at 5:33 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 11:41 Thu 22 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> Do you see a way to do this without changing the vendor API ? I was
>> trying to add this without doing that.
>
> What is the problem exactly?

Somehow passing retries in to the vendor layer (either as an
additional API or parameter to existing API) would change the API and
I see no way to get to the subnet options where retries is held from
the vendor layer. That was the reason the environment variable hack
was used.

-- Hal

> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
