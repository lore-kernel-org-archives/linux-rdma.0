From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: libmlx5 doesn't build on s390x
Date: Thu, 23 Mar 2017 14:12:18 -0400
Message-ID: <0f339881-645b-486d-8490-dd0b19c1b63e@redhat.com>
References: <afe64964-4f10-0a00-0891-b97bf2c60b50@redhat.com>
 <36a02b19-5b50-10f6-f3da-13d4a67f50c2@dev.mellanox.co.il>
 <22f0dfe4-bf35-02cf-df73-ef7b59295015@redhat.com>
 <20170323165800.GC29811@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170323165800.GC29811-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2017-03-23 12:58 PM, Jason Gunthorpe wrote:
> On Thu, Mar 23, 2017 at 12:50:14PM -0400, Jarod Wilson wrote:
>
>>> Any option that you saw below message in the log ?
>>> "Architecture NOT able to do coherent DMA (check libibverbs/arch.h) some
>>> providers disabled!")"
>>
>> Yep, it's there, lost it in all the verbosity. Okay, that explains that.
>
> FWIW, that section after 'Missing Optional Items:' reflects everything
> 'wrong' with the build environment. An ideal build will list nothing,
> eg on FC25.
>
> Everything else means something is broken and cmake is working around
> the breakage somehow. It is worth reviewing if the thing is really
> broken or not...

 From the s390x build log:

-- Missing Optional Items:
--  Architecture NOT able to do coherent DMA (check libibverbs/arch.h) 
some providers disabled!
--  C11 stdatomic.h NOT available (old compiler)
--  rdma/vmw_pvrdma-abi.h NOT found (old system kernel headers)
--  -Wmissing-field-initializers does NOT work

The old compiler part isn't going to change, and we don't have the 
vmware pvrdma driver backported at this time.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
