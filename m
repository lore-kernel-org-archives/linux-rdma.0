From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx5: External memory binding for HW resources
Date: Tue, 5 Sep 2017 15:01:13 +0300
Message-ID: <7d029fd9-8437-3784-5ba1-6718cfa6a45b@dev.mellanox.co.il>
References: <1504533302-11998-1-git-send-email-yishaih@mellanox.com>
 <20170905014656.GA24178@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170905014656.GA24178-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuemingl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/5/2017 4:46 AM, Jason Gunthorpe wrote:
> On Mon, Sep 04, 2017 at 04:55:02PM +0300, Yishai Hadas wrote:
>> From: Xueming Li <xuemingl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Add a new DV API mlx5dv_set_context_attr() to enable setting an external
>> memory allocator. This API will allow the application to use specific
>> decisions about the memory allocation of HW resources (e.g. DV objects).
>> Some examples are managing numa pinning per object, managing a
>> hugepages resource pool, shared memory regions.
>>
>> Also extend mlx5dv_get_qp() to return UAR mapping info. This can allow a
>> process to share its doorbell access with secondary process by re-mmap
>> the UAR address on the device and make it accessible as a user space
>> address.
>
> Why two unrelated changes in one patch?
>
> Everything else looks fine to me
>

Thanks for reviewing that, just separated to two patches as you 
suggested, no code change.

PR:
https://github.com/linux-rdma/rdma-core/pull/209


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
