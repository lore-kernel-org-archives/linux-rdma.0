From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH for-next 1/9] IB/core: Introduce peer client interface
Date: Wed, 01 Oct 2014 18:34:43 +0200
Message-ID: <542C2D23.30508@acm.org>
References: <1412176717-11979-1-git-send-email-yishaih@mellanox.com> <1412176717-11979-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412176717-11979-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/01/14 17:18, Yishai Hadas wrote:
> +static int num_registered_peers;

Is the only purpose of this variable to check whether or not 
peer_memory_list is empty ? In that case please drop this variable and 
use list_empty() instead.

> +static int ib_invalidate_peer_memory(void *reg_handle, void *core_context)
> +
> +{
> +	return -ENOSYS;
> +}

Please follow the Linux kernel coding style which means no empty line 
above the function body.

> +#define PEER_MEM_MANDATORY_FUNC(x) {\
> +	offsetof(struct peer_memory_client, x), #x }

Shouldn't the opening brace have been placed on the same line as the 
offsetof() macro to improve readability ?

> +	if (invalidate_callback) {
> +		*invalidate_callback = ib_invalidate_peer_memory;
> +		ib_peer_client->invalidation_required = 1;
> +	}
> +	mutex_lock(&peer_memory_mutex);
> +	list_add_tail(&ib_peer_client->core_peer_list, &peer_memory_list);
> +	num_registered_peers++;
> +	mutex_unlock(&peer_memory_mutex);
> +	return ib_peer_client;

Please insert an empty line before mutex_lock() and after mutex_unlock().

> +void ib_unregister_peer_memory_client(void *reg_handle)
> +{
> +	struct ib_peer_memory_client *ib_peer_client =
> +		(struct ib_peer_memory_client *)reg_handle;

No cast is needed when assigning a void pointer to a non-void pointer.

> +struct peer_memory_client {
> +	char	name[IB_PEER_MEMORY_NAME_MAX];
> +	char	version[IB_PEER_MEMORY_VER_MAX];
> +	/* The peer-direct controller (IB CORE) uses this callback to detect if a virtual address is under
> +	 * the responsibility of a specific peer direct client. If the answer is positive further calls
> +	 * for memory management will be directed to the callback of this peer driver.
> +	 * Any peer internal error should resulted in a zero answer, in case address range
> +	 * really belongs to the peer, no owner will be found and application will get an error
> +	 * from IB CORE as expected.
> +	 * Parameters:
> +		addr                  [IN]  - virtual address to be checked whether belongs to.
> +		size                  [IN]  - size of memory area starting at addr.
> +		peer_mem_private_data [IN]  - The contents of ib_ucontext-> peer_mem_private_data.
> +					      This parameter allows usage of the peer-direct
> +					      API in implementations where it is impossible
> +					      to detect if the memory belongs to the device
> +					      based upon the virtual address alone. In such
> +					      cases, the peer device can create a special
> +					      ib_ucontext, which will be associated with the
> +					      relevant peer memory.
> +		peer_mem_name         [IN]  - The contents of ib_ucontext-> peer_mem_name.
> +					      Used to identify the peer memory client that
> +					      initialized the ib_ucontext.
> +					      This parameter is normally used along with
> +					      peer_mem_private_data.
> +		client_context        [OUT] - peer opaque data which holds a peer context for
> +					      the acquired address range, will be provided
> +					      back to the peer memory in subsequent
> +					      calls for that given memory.
> +
> +	* Return value:
> +	*	1 - virtual address belongs to the peer device, otherwise 0
> +	*/
> +	int (*acquire)(unsigned long addr, size_t size, void *peer_mem_private_data,
> +		       char *peer_mem_name, void **client_context);
> +	/* The peer memory client is expected to pin the physical pages of the given address range
> +	 * and to fill sg_table with the information of the
> +	 * physical pages associated with the given address range. This function is
> +	 * equivalent to the kernel API of get_user_pages(), but targets peer memory.
> +	 * Parameters:
> +		addr           [IN] - start virtual address of that given allocation.
> +		size           [IN] - size of memory area starting at addr.
> +		write          [IN] - indicates whether the pages will be written to by the caller.
> +				      Same meaning as of kernel API get_user_pages, can be
> +				      ignored if not relevant.
> +		force          [IN] - indicates whether to force write access even if user
> +				      mapping is readonly. Same meaning as of kernel API
> +				      get_user_pages, can be ignored if not relevant.
> +		sg_head        [IN/OUT] - pointer to head of struct sg_table.
> +					  The peer client should allocate a table big
> +					  enough to store all of the required entries. This
> +					  function should fill the table with physical addresses
> +					  and sizes of the memory segments composing this
> +					  memory mapping.
> +					  The table allocation can be done using sg_alloc_table.
> +					  Filling in the physical memory addresses and size can
> +					  be done using sg_set_page.
> +		client_context [IN] - peer context for the given allocation, as received from
> +				      the acquire call.
> +		core_context   [IN] - opaque IB core context. If the peer client wishes to
> +				      invalidate any of the pages pinned through this API,
> +				      it must provide this context as an argument to the
> +				      invalidate callback.
> +
> +	* Return value:
> +	*	0 success, otherwise errno error code.
> +	*/
> +	int (*get_pages)(unsigned long addr,
> +			 size_t size, int write, int force,
> +			 struct sg_table *sg_head,
> +			 void *client_context, void *core_context);
> +	/* The peer-direct controller (IB CORE) calls this function to request from the
> +	 * peer driver to fill the sg_table with dma address mapping for the peer memory exposed.
> +	 * The parameters provided have the parameters for calling dma_map_sg.
> +	 * Parameters:
> +		sg_head        [IN/OUT] - pointer to head of struct sg_table. The peer memory
> +					  should fill the dma_address & dma_length for
> +					  each scatter gather entry in the table.
> +		client_context [IN] - peer context for the allocation mapped.
> +		dma_device     [IN] - the RDMA capable device which requires access to the
> +				      peer memory.
> +		dmasync        [IN] - flush in-flight DMA when the memory region is written.
> +				      Same meaning as with host memory mapping, can be ignored if not relevant.
> +		nmap           [OUT] - number of mapped/set entries.
> +
> +	* Return value:
> +	*		0 success, otherwise errno error code.
> +	*/
> +	int (*dma_map)(struct sg_table *sg_head, void *client_context,
> +		       struct device *dma_device, int dmasync, int *nmap);
> +	/* This callback is the opposite of the dma map API, it should take relevant actions
> +	 * to unmap the memory.
> +	* Parameters:
> +		sg_head        [IN/OUT] - pointer to head of struct sg_table. The peer memory
> +					  should fill the dma_address & dma_length for
> +					  each scatter gather entry in the table.
> +		client_context [IN] - peer context for the allocation mapped.
> +		dma_device     [IN] - the RDMA capable device which requires access to the
> +				      peer memory.
> +		dmasync        [IN] - flush in-flight DMA when the memory region is written.
> +				      Same meaning as with host memory mapping, can be ignored if not relevant.
> +		nmap           [OUT] - number of mapped/set entries.
> +
> +	* Return value:
> +	*	0 success, otherwise errno error code.
> +	*/
> +	int (*dma_unmap)(struct sg_table *sg_head, void *client_context,
> +			 struct device  *dma_device);
> +	/* This callback is the opposite of the get_pages API, it should remove the pinning
> +	 * from the pages, it's the peer-direct equivalent of the kernel API put_page.
> +	 * Parameters:
> +		sg_head        [IN] - pointer to head of struct sg_table.
> +		client_context [IN] - peer context for that given allocation.
> +	*/
> +	void (*put_pages)(struct sg_table *sg_head, void *client_context);
> +	/* This callback returns page size for the given allocation
> +	 * Parameters:
> +		sg_head        [IN] - pointer to head of struct sg_table.
> +		client_context [IN] - peer context for that given allocation.
> +	* Return value:
> +	*	Page size in bytes
> +	*/
> +	unsigned long (*get_page_size)(void *client_context);
> +	/* This callback is the opposite of the acquire call, let peer release all resources associated
> +	 * with the acquired context. The call will be performed only for contexts that have been
> +	 * successfully acquired (i.e. acquire returned a non-zero value).
> +	 * Parameters:
> +	 *	client_context [IN] - peer context for the given allocation.
> +	*/
> +	void (*release)(void *client_context);
> +
> +};

All these comments inside a struct make a struct definition hard to 
read. Please use kernel-doc style instead. See also 
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/kernel-doc-nano-HOWTO.txt.

Thanks,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
