From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: opensm/complib: redundant redeclaration of functions
Date: Tue, 02 Feb 2010 15:11:26 +0200
Message-ID: <4B68247E.6070405@dev.mellanox.co.il>
References: <4B66D189.2090500@dev.mellanox.co.il> <20100201184616.GC25902@obsidianresearch.com>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100201184616.GC25902-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/Feb/10 20:46, Jason Gunthorpe wrote:
> On Mon, Feb 01, 2010 at 03:05:13PM +0200, Yevgeny Kliteynik wrote:
>
>> In general, here's the problem:
>>
>> We have cl_file.h and cl_file_osd.h.
>> cl_file.h has include directive for cl_file_osd.h
>> cl_file.h has the following definition of function:
>> 	int foo();
>>
>> cl_file_osd.h has another function definition, but
>> this time it also has implementation:
>> 	static inline int foo() { ..... }
>>
>> Any preferable way to fix this?
>
> It looks to me like using 'extern inline' is appropriate here:
>
> extern inline int foo();
>
> [..]
>
> inline int foo()
> {
>     body
> }
>
> If no inline version is defined then the compiler just emits a normal
> function call, if an inline version is defined then the compiler might
> use it.

Thanks for the idea.
I read some documentation about it, and it does look that
your suggestion should fix the problem, but it didn't :(
Probably because they both are in .h files.

-- Yevgeny
  
> Jason
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
