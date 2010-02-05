From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Fri, 05 Feb 2010 12:32:51 -0600
Message-ID: <4B6C6453.9090706@opengridcomputing.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com><4B6C4460.3050908@opengridcomputing.com> <ada4olvefl4.fsf@roland-alpha.cisco.com> <324EFA68-12F6-46E9-B876-7F4847B53224@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <324EFA68-12F6-46E9-B876-7F4847B53224-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Jeff Squyres wrote:
> On Feb 5, 2010, at 12:51 PM, Roland Dreier (rdreier) wrote:
>
>   
>>  > But Jeff, note that if someone uses the upstream kernel and OpenMPI,
>>  > its busted...
>>
>> Is the issue 6f8372b6 ("RDMA/cm: fix loopback address support")?  This
>> just went in for 2.6.33, which is still at -rc6, so if we can quickly
>> reach a consensus, there is still time to get a fix in for 2.6.33.
>>     
>
> Oh oh oh!  Yes, that would be fabulous...
>
> Thanks!
>
>   

I think we should remove the feature of allowing binds to 127.0.0.1 
altogether based on Jeff's arguments and my assertion that 127.0.0.1 is 
a sw-loopback mechanism anyway...

I'm not sure if that commit does more or not...

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
