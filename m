From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core] Support writing man pages in MarkDown
Date: Sun, 24 Dec 2017 14:03:23 +0200
Message-ID: <455f0faf-516b-fa8d-c0d2-d2cee9194e5b@dev.mellanox.co.il>
References: <20171212225936.GA29558@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171212225936.GA29558-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/13/2017 12:59 AM, Jason Gunthorpe wrote:
> The pages are converted during the build into *roff mdoc using
> the pandoc tool.
> 
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   .travis.yml                   |  1 +
>   CMakeLists.txt                |  4 +++
>   buildlib/Findpandoc.cmake     | 21 +++++++++++++
>   buildlib/cbuild               |  3 ++
>   buildlib/rdma_functions.cmake | 33 --------------------
>   buildlib/rdma_man.cmake       | 70 +++++++++++++++++++++++++++++++++++++++++++
>   debian/control                |  1 +
>   7 files changed, 100 insertions(+), 33 deletions(-)
>   create mode 100644 buildlib/Findpandoc.cmake
>   create mode 100644 buildlib/rdma_man.cmake
> 
> This is a very big series, I am only sending the first patch to the
> mailing list. The whole series is on github here:
> 
> https://github.com/linux-rdma/rdma-core/pull/274
> 
> Overall, I'd like to see the man pages be more editable and viewable
> when in patch format. Longer term I'd like to see them all rendered to
> HTML and hosted on the web as libfabric and systemd are doing
> successfully. While some of this can be done with the classic roff
> format, it feels very painful.
> 

This makes sense to me.

> Markdown was selected because we are already using it successfully for
> other documentation, and libfabric has already demonstrated using it
> for man pages. github will natively render the markdown documentation
> internally for instance:
>

Makes sense as well.

> https://github.com/jgunthorpe/rdma-plumbing/blob/ea581c2d3d99d69083a8f4eaa9e55ae7ae233246/libibverbs/man/ibv_alloc_mw.3.md
> 
> Although some places are using features specific to the 'pandoc'
> flavour of markdown, github still renders them in a readable format.
> 
> The next most popular choice is docbook XML, which I suspect would not
> be well liked (and it is very baroque as well, just in a more modern
> way)
> 
> The actual conversion of the man pages was done largely by script,
> with some manual fixes and post-inspection. There doesn't seem to be a
> useful mdoc to markdown conversion script, so I built a quick and
> dirty one that works on our .3 man page style.
> 
> The converter is here:
> 
> https://github.com/jgunthorpe/rdma-plumbing/blob/migration-tooling/buildlib/man2md.py
> 
> I'm no mdoc expert, but it sure looks to me like there are many markup
> problems in our man pages, even if they happen to render mostly properly.
>  > Overall the conversion to markdown is very good in terms of resulting
> 'man ibv_foo' display with a few notable variances:
>   - The 'synopsis' is shifted right by 8 spaces and isn't bolded in
>     quite the same way
>   - I ran all the C code through clang-format and asked it fit it to
>     the standard 80 col terminal. Some of the results are 'interesting'
>     to say the least. Others are much better than before.
>   - Some of the hypenation choices are a little different
> 

Looked at few generated man pages, there are places that it looks *ugly* 
comparing to the original ones. Especially talking on the 'C' structures 
that were wrapped around the 80 column. (see ibv_query_device). There 
are cases that even in the same man page there are lines larger than 80 
while others are not. We can't just drop the 'C' structures as in many 
places few fields may include some meaningful information, need to go 
per man page and consider how we would really like to see it once moving 
to the new format.

> pandoc is fairly widely available in the distros with the notable
> problem that centos 6 and 7 can only get it from EPEL.
> 

There might be even a worse case scenario where pandoc may not exist as 
a package to be installed, for example how about SLES OS ?

> Since this may be a problem, I am thinking about following the
> libfabric approach and either including the precompiled man pages in
> the source tree, or just providing a framework for downstream to
> add-on precompiled files (with a cbuild command to make them)
> Looking for feedback on what path is best..
> 

An approach to have an option via the cbuild to generate them on demand 
makes sense to me. It should use the docker/containers mechanism to 
enable that. Upon regular compile/build the already generated man pages 
will be taken from the tree, upon a man page change the cbuild 
environment should be used and both the man and the .md files will be 
pushed into the tree.

However, need to consider below notes:
1) Need to have a clear documentation to describe the required steps to 
do that. Man pages may be changed by many people and as such, the 
process to generate them must be fully clear and easy to use.

2) As the tree will hold both the 'md' files and the man pages, someone 
might forget to use the pandoc and upload only a change in a man page, 
this should be prevented by Travis or other checker script.

3) How about cases that the a man page will be generated by pandoc but 
someone will do manual changes to have it nicer/cleaner ?
This might end-up having man page which doesn't fit to its source that 
may bring an issue on the next generation by someone else.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
