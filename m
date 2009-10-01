From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] osm_helper.c match func to proto
Date: Thu, 1 Oct 2009 15:11:39 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912C86E8B02@orsmsx501.amr.corp.intel.com>
References: <3F6F638B8D880340AB536D29CD4C1E1912C86E895E@orsmsx501.amr.corp.intel.com>
 <20091001203544.GA17846@me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091001203544.GA17846@me>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha Khapyorsky wrote:
> On 13:16 Thu 01 Oct     , Smith, Stan wrote:
>>
>> Removed inet_ntop() (void*) cast per discussions; only prototype
>> updates.
>>
>> Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Just pushed out "'const' removing" patch few minutes before. Maybe it
> will just work for you.
>
> Sasha

Yes it did just work/compile for the changes in osm_helper.c & osm_helper.h.

Please advise when other .h files & friends are adjusted.

Stan.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
