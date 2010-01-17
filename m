From: Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Add huge page support to ibv_madvise_range()
Date: Sun, 17 Jan 2010 11:30:16 +0200
Message-ID: <4B52D8A8.7060804@gmail.com>
References: <4B12AA78.7090401@gmail.com> <ada8wbzi490.fsf@roland-alpha.cisco.com>
Reply-To: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada8wbzi490.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org, roland <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Seems unfortunate.  I wonder if there's a way the kernel madvise could
> help us here?

We've tried to find the best solution for this issue.
But we couldn't find another one without changing the API or changing
the kernel.

> This seems to duplicate but only partially a similar function from
> libhugetlbfs.  Is there any way we can just use that directly? 

I will check this.

Thanks,
AlexV

Roland Dreier Wrote:
>  > ibv_reg_mr() fails to register a memory region allocated on huge page and not
>  > the default page size. This happens because ibv_madvise_range() aligns memory
>  > region to the default system page size before calling to madvise() which fails
>  > with EINVAL error. madvise() fails because it expects that the start and end
>  > pointer of the memory range be huge page aligned.
> 
> Seems unfortunate.  I wonder if there's a way the kernel madvise could
> help us here?
> 
>  > +/*
>  > + * Get the kernel default huge page size.
>  > + */
>  > +static int get_huge_page_size()
>  > +{
>  > +	int fd;
>  > +	char buf[MEMINFO_SIZE];
>  > +	int mem_file_len;
>  > +	char *p_hpage_val = NULL;
>  > +	char *end_pointer = NULL;
>  > +	char file_name[] = "/proc/meminfo";
>  > +	const char label[] = "Hugepagesize:";
>  > +	int ret_val = 0;
>  > +
>  > +	fd = open(file_name, O_RDONLY);
>  > +	if (fd < 0)
>  > +		return fd;
>  > +
>  > +	mem_file_len = read(fd, buf, sizeof(buf) - 1);
>  > +
>  > +	close(fd);
>  > +	if (mem_file_len < 0)
>  > +		return mem_file_len;
>  > +
>  > +	buf[mem_file_len] = '\0';
>  > +
>  > +	p_hpage_val = strstr(buf, label);
>  > +	if (!p_hpage_val) {
>  > +		errno = EINVAL;
>  > +		return -1;
>  > +	}
>  > +	p_hpage_val += strlen(label);
>  > +
>  > +	errno = 0;
>  > +	ret_val = strtol(p_hpage_val, &end_pointer, 0);
>  > +
>  > +	if (errno != 0)
>  > +		return -1;
>  > +
>  > +	return ret_val * 1024;
>  > +}
> 
> This seems to duplicate but only partially a similar function from
> libhugetlbfs.  Is there any way we can just use that directly?  eg
> libhugetlbfs handles the case where there are multiple huge page sizes
> (and that exists even on mainstream x86 with 2MB and 1GB pages possible
> on the same system).
> 
>  - R.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
