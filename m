From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 1/7] IB/hfi1: Fix serdes loopback set-up
Date: Mon, 9 Oct 2017 16:00:47 -0400
Message-ID: <6db0385f-187d-8a61-ee98-f3fb3bd05782@intel.com>
References: <20171009161736.6965.75352.stgit@scvm10.sc.intel.com>
 <20171009193744.6965.76584.stgit@scvm10.sc.intel.com>
 <20171009195846.GH1252@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171009195846.GH1252-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/9/2017 3:58 PM, Leon Romanovsky wrote:
> On Mon, Oct 09, 2017 at 12:37:48PM -0700, Dennis Dalessandro wrote:
>> From: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> Change serdes mode setting to use MISC_CONFIG_BITS in
>> VERIFY_CAP_LOCAL_LINK_WIDTH register. This method of
>> setting up serdes loopback is universally compatible
>> across all firmware versions.
>>
>> Change-Id: I3ccd935c4b33e843c83c36a2caee77d62249cdc8
> 
> It doesn't belong here.
> We don't love Gerrit here :)

I was literally about to hit send on a reply having just noticed that 
too. I forgot to remove the stupid gerrit commit hook when I edited 
Jan's patch. Doh!

v2 of this one coming up...

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
