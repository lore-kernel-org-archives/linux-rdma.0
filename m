From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/7] Add mlx5 direct verbs
Date: Thu, 26 Jan 2017 23:54:53 +0200
Message-ID: <ac21fe37-d617-e5a8-cd67-e8fdfbd69d55@dev.mellanox.co.il>
References: <1485446182-5109-1-git-send-email-yishaih@mellanox.com>
 <20170126172511.GB16562@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170126172511.GB16562-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/26/2017 7:25 PM, Jason Gunthorpe wrote:
> On Thu, Jan 26, 2017 at 05:56:15PM +0200, Yishai Hadas wrote:
>> This patchset from Leon adds direct access to mlx5 devices.
>>
>> The libibverbs API is an abstract API. It is agnostic to any underlying
>> provider specific implementation. While this abstraction has the advantage of
>> user applications portability it has a performance penalty. For some
>> applications optimizing performance is more important than portability.
>>
>> The mlx5 direct verbs API introduced in this patchset is intended for such
>> applications. It exposes mlx5 specific low level data path
>> (send/receive/completion) operations, allowing the application to bypass the
>> libibverbs data path API.
>
> Applications need to link directly to the libraries that provide the
> symbols they use - this approach you have where linking happens
> implicitly at runtime is not OK.

Correct, the link will be explicitly by the application at compile time 
so that the exported symbols will be resolved.

The below note from the cover letter planned to point on that:
"The direct include of dv.h together with linkage to mlx5 library will 
allow usage of this new interface"

> Somehow libmlx needs to be in the standard ld.so search path, and
> available for linking via gcc, as well as continuing to be a plugin..
> The best choice might be to put it in /usr/lib/../libmlx5.so.1 and
> symlink that file to /usr/lib/../libibverbs/libmlx5-rdmav2.so

You are pointing on same usage as done for libibverbs which has the 
symlink, correct ? Alternatively, application can use the linker flags 
as part of its Makefile to find the shared library location, isn't it ?

> This series also needs patches to the included packaging files to
> bundle the new files. (buildlib/cbuild exists for a reason, be sure to
> test the packaging)

Thanks for pointing on, we'll add and test the packaging.

> These probably need a man page as well. It wasn't instantly obvious to
> me how these were supposed to work.

Sure, we can add some man page here.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
