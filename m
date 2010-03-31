From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_dump.c: dump SL2VL tables
Date: Wed, 31 Mar 2010 11:55:10 +0300
Message-ID: <4BB30DEE.6000206@dev.mellanox.co.il>
References: <4BAB879E.30203@dev.mellanox.co.il>
	<1269535468.4618.159.camel@sale659.sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1269535468.4618.159.camel-mgfCWIlwujvg4c9jKm7R2O1ftBKYq+Ku@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jim,

On 25/Mar/10 18:44, Jim Schutt wrote:
>
> Hi Yevgey,
>
> On Thu, 2010-03-25 at 09:56 -0600, Yevgeny Kliteynik wrote:
>> Hi Sasha,
>>
>> Dumping SL2VL tables in ROUTING verbosity level when QoS is on.
>> This is needed for SL2VL tables analysis in general, and for
>> routing engines that are using IB VLs in particular, such as
>> torus-2QoS.
>>
>
> Very cool.  Thanks.

Sure, no problem.
The next dump file would be path resolution file,  which
will have SLs (and other parameters) for all the paths.

-- Yevgeny
  
> -- Jim
>
>> Signed-off-by: Yevgeny Kliteynik<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>> ---
>>   opensm/opensm/osm_dump.c |   61 +++++++++++++++++++++++++++++++++++++++++++++-
>>   1 files changed, 60 insertions(+), 1 deletions(-)
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
