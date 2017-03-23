From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: libmlx5 doesn't build on s390x
Date: Thu, 23 Mar 2017 14:08:33 -0400
Message-ID: <5264980a-10fa-5c18-ff3a-2f2774c60eb6@redhat.com>
References: <afe64964-4f10-0a00-0891-b97bf2c60b50@redhat.com>
 <20170323161017.GB29811@obsidianresearch.com>
 <100aafc9-21a6-8aed-47c3-220f0feb82b1@redhat.com>
 <20170323170228.GG29811@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170323170228.GG29811-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2017-03-23 1:02 PM, Jason Gunthorpe wrote:
> On Thu, Mar 23, 2017 at 12:57:37PM -0400, Jarod Wilson wrote:
>> Not sure. From rpm's perspective, I'm trying arch s390x, but maybe gcc is
>> actually calling it s390.
>
> The output from build/CMakeFiles/CMakeError.log might help
>
> As well as this output:
>
> $ gcc -dM -E - < /dev/null

Unfortunately, this is sort of a black box situation for me at the 
moment. I'm submitting the builds to our build system, which hands the 
build job off to all relevant architectures. I can probably get a 
reservation on an s390x system and poke manually though.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
