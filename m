From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [Intel-wired-lan] [PATCH V2] mm: Replace all open encodings for
	NUMA_NO_NODE
Date: Mon, 26 Nov 2018 11:04:24 -0700
Message-ID: <4d0840f2-bd96-e671-8120-56ef33a37816@kernel.dk>
References: <1543235202-9075-1-git-send-email-anshuman.khandual@arm.com>
	<c1b8de1a8e9d4d215b56498e2d5b83a02083483a.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <c1b8de1a8e9d4d215b56498e2d5b83a02083483a.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Anshuman Khandual <anshuman.khandual-5wv7dgnIgG8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vkoul-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, intel-wired-lan-qjLDD68F18P21nG7glBr7A@public.gmane.org, linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jiangqi903-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/26/18 10:56 AM, Jeff Kirsher wrote:
> On Mon, 2018-11-26 at 17:56 +0530, Anshuman Khandual wrote:
>> At present there are multiple places where invalid node number is
>> encoded
>> as -1. Even though implicitly understood it is always better to have
>> macros
>> in there. Replace these open encodings for an invalid node number
>> with the
>> global macro NUMA_NO_NODE. This helps remove NUMA related assumptions
>> like
>> 'invalid node' from various places redirecting them to a common
>> definition.
>>
>> Signed-off-by: Anshuman Khandual <anshuman.khandual-5wv7dgnIgG8@public.gmane.org>
> 
> For the 'ixgbe' driver changes.
> 
> Acked-by: Jeff Kirsher <jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Lost the original, but for mtip32xx:

Acked-by: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

-- 
Jens Axboe
