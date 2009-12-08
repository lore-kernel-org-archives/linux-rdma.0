From: Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Add huge page support to ibv_madvise_range()
Date: Tue, 08 Dec 2009 16:03:21 +0200
Message-ID: <4B1E5CA9.3090707@gmail.com>
References: <4B12AA78.7090401@gmail.com>
Reply-To: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B12AA78.7090401-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: roland <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Have you had a chance to look at this patch and at the patch 
I've sent with this email:
"Subject: [PATCH] libibverbs: Add huge page support to ibv_madvise_range()
Sent: Sun, 29 Nov 2009 19:08:08 +0200"?

Thanks,
Alexv


Alex Vainman wrote:
> ibv_reg_mr() fails to register a memory region allocated on huge page and not
> the default page size. This happens because ibv_madvise_range() aligns memory
> region to the default system page size before calling to madvise() which fails
> with EINVAL error. madvise() fails because it expects that the start and end
> pointer of the memory range be huge page aligned.
> Patch handles the issue by:
> 1. ibv_fork_init() gets kernel's default huge page size in addition
>    to the default page size.
> 2. ibv_madvise_range() first tries aligning users memory range to default
>    page size and if madvise() fails with EINVAL error then it tries to align
>    users memory range by huge page size and tries madvise() again.
> 
> Signed-off-by: Alex Vaynman <alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
>  src/memory.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 68 insertions(+), 1 deletions(-)
> 
> diff --git a/src/memory.c b/src/memory.c
> index 550015a..73db083 100644
> --- a/src/memory.c
> +++ b/src/memory.c
> @@ -40,6 +40,9 @@
>  #include <unistd.h>
>  #include <stdlib.h>
>  #include <stdint.h>
> +#include <ctype.h>
> +#include <fcntl.h>
> +#include <string.h>
>  
>  #include "ibverbs.h"
>  
> @@ -54,6 +57,8 @@
>  #define MADV_DOFORK	11
>  #endif
>  
> +#define MEMINFO_SIZE	2048
> +
>  struct ibv_mem_node {
>  	enum {
>  		IBV_RED,
> @@ -68,8 +73,51 @@ struct ibv_mem_node {
>  static struct ibv_mem_node *mm_root;
>  static pthread_mutex_t mm_mutex = PTHREAD_MUTEX_INITIALIZER;
>  static int page_size;
> +static int huge_page_size;
>  static int too_late;
>  
> +/*
> + * Get the kernel default huge page size.
> + */
> +static int get_huge_page_size()
> +{
> +	int fd;
> +	char buf[MEMINFO_SIZE];
> +	int mem_file_len;
> +	char *p_hpage_val = NULL;
> +	char *end_pointer = NULL;
> +	char file_name[] = "/proc/meminfo";
> +	const char label[] = "Hugepagesize:";
> +	int ret_val = 0;
> +
> +	fd = open(file_name, O_RDONLY);
> +	if (fd < 0)
> +		return fd;
> +
> +	mem_file_len = read(fd, buf, sizeof(buf) - 1);
> +
> +	close(fd);
> +	if (mem_file_len < 0)
> +		return mem_file_len;
> +
> +	buf[mem_file_len] = '\0';
> +
> +	p_hpage_val = strstr(buf, label);
> +	if (!p_hpage_val) {
> +		errno = EINVAL;
> +		return -1;
> +	}
> +	p_hpage_val += strlen(label);
> +
> +	errno = 0;
> +	ret_val = strtol(p_hpage_val, &end_pointer, 0);
> +
> +	if (errno != 0)
> +		return -1;
> +
> +	return ret_val * 1024;
> +}
> +
>  int ibv_fork_init(void)
>  {
>  	void *tmp;
> @@ -85,6 +133,8 @@ int ibv_fork_init(void)
>  	if (page_size < 0)
>  		return errno;
>  
> +	huge_page_size = get_huge_page_size();
> +
>  	if (posix_memalign(&tmp, page_size, page_size))
>  		return ENOMEM;
>  
> @@ -554,7 +604,8 @@ static struct ibv_mem_node *prepare_to_roll_back(struct ibv_mem_node *node,
>  	return node;
>  }
>  
> -static int ibv_madvise_range(void *base, size_t size, int advice)
> +static int ibv_madvise_range_helper(void *base, size_t size, int advice,
> +				    int page_size)
>  {
>  	uintptr_t start, end;
>  	struct ibv_mem_node *node, *tmp;
> @@ -646,6 +697,22 @@ out:
>  	return ret;
>  }
>  
> +static int ibv_madvise_range(void *base, size_t size, int advice)
> +{
> +	int ret_val = 0;
> +
> +	ret_val = ibv_madvise_range_helper(base, size, advice, page_size);
> +
> +	/*
> +	 * if memory is backed by huge pages we need to align it
> +	 * to huge page boundary in order madvise() will succeed.
> +	 */
> +	if (ret_val == -1 && errno == EINVAL && huge_page_size > 0)
> +		ret_val = ibv_madvise_range_helper(base, size, advice, huge_page_size);
> +
> +	return ret_val;
> +}
> +
>  int ibv_dontfork_range(void *base, size_t size)
>  {
>  	if (mm_root)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
