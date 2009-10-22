From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_vendor_ibumad.c: Add environment variable to
	change max retries
Date: Thu, 22 Oct 2009 11:41:25 -0400
Message-ID: <f0e08f230910220841s220373fau2cd4e814ec77ca25@mail.gmail.com>
References: <20091019183342.GA28926@comcast.net> <20091022122443.GF20210@me>
	 <f0e08f230910220556h3d7352f4s4bd8e57c0a01a5d0@mail.gmail.com>
	 <20091022135004.GK20210@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091022135004.GK20210@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 22, 2009 at 9:50 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 08:56 Thu 22 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> >
>> > Why do you need this?
>>
>> It is useful in some clusters where the default behavior is
>> insufficient
>
> I would suppose that by itself this may indicate some external issues
> like bad connectivity (cabling) or similar and some investigation wou=
ld
> be helpful there (regardless to number of retries).
>
>> and control over the number of retries helps and there is
>> no vendor API support for this.
>>
>> > And why did you choose to use environment variable and not command
>> > line/config option? I think that it is less obvious.
>>
>> It was modeled after OSM_UMAD_MAX_PENDING.
>
> It was internal libvendor hack (which is also not 100% clean :))
> controlling ibumad implementation specific parameter. Unlike this a
> number of MAD retries (similar to MAD response timeout value) has mor=
e
> generic meaning.
>
>> It could be made a command
>> line/options file item. Is that your preference ?
>
> I think command line/config option is a way to do it.

Do you see a way to do this without changing the vendor API ? I was
trying to add this without doing that.

-- Hal

>
> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
