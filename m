From: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_mesh.c: fixing a bug in compare_switches()
Date: Thu, 09 Sep 2010 14:11:45 -0500
Message-ID: <4C893171.2020804@systemfabricworks.com>
References: <4C86538E.3080206@mellanox.co.il> <20100909143036.GB11502@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100909143036.GB11502@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks Sasha,

I'm not sure where that came from. This was a little optimization that 
improved the results in some cases. But wouldn't break the rest of the code.
Seems to have gotten broken somewhere along the way.

Bob Pearson

On 09/09/2010 09:30 AM, Sasha Khapyorsky wrote:
> On 18:00 Tue 07 Sep     , Yevgeny Kliteynik wrote:
>    
>> I'm pretty sure that ";" at the end of "if" statement
>> is not supposed to be there (not sure how it worked till
>> now though).
>> Also, making this condition a bit more readable.
>>
>> Signed-off-by: Yevgeny Kliteynik<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>>      
> Applied. Thanks.
>
> Sasha
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>    

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
