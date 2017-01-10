From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat/spec: can't build ibumad on 32-bit arm
Date: Mon, 9 Jan 2017 22:27:52 -0500
Message-ID: <0e01bfc8-333d-99dd-f7d1-024422923021@redhat.com>
References: <20170109213944.31970-1-jarod@redhat.com>
 <20170109223108.GA10850@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170109223108.GA10850-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2017-01-09 5:31 PM, Jason Gunthorpe wrote:
> On Mon, Jan 09, 2017 at 04:39:44PM -0500, Jarod Wilson wrote:
>> Building for 32-bit arm, things fall down, due to lack of arch-specific
>> memory barriers.
>
> Since we now have rxe that should work on ARM I think we need to fix
> this upstream..
>
> Do you have time to test some patches on ARM?

Afraid I don't have hardware. To the best of my knowledge, the only ARM 
systems my group has (and/or are getting soon) with RDMA hardware is all 
ARM64.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
